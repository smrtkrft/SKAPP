// Alarm API webhook (early warning) section body for LebensSpur dashboard.
//
// Generic outbound HTTP for the timer.alarm event. Lays the user's URL,
// method, headers, body template, and optional bearer into a USER slot
// on sk_api via `api.endpoint.add --type webhook_post|generic`. The
// sidecar fields the firmware can't store today (headers JSON + body
// template) are persisted in SharedPreferences so they survive a reload
// of the form; the firmware will pick them up when the timer.alarm
// subscriber lands and starts driving this slot.
//
// CLI contract:
//   READ   : api.endpoint.list  → look up slot named `alarm_webhook`
//   WRITE  : api.endpoint.add  --name alarm_webhook --type webhook_post
//                              --url ... --method POST|GET|PUT
//                              [--auth bearer --token <bearer>]
//                              --content-type application/json
//   TEST   : api.send  --name alarm_webhook --payload <rendered template>
//   REMOVE : api.endpoint.remove --name alarm_webhook   (critical)

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/cli/cli_client.dart';
import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

const String _kEndpointName = 'alarm_webhook';
String _prefsKey(String deviceId) => 'ls_${deviceId}_alarm_webhook_v1';

const String _defaultBodyTemplate =
    '{"event":"ls.alarm","device":"{device}","remaining":{remaining_sec}}';

enum _HttpMethod { post, get, put }

extension on _HttpMethod {
  String get wire {
    switch (this) {
      case _HttpMethod.post:
        return 'POST';
      case _HttpMethod.get:
        return 'GET';
      case _HttpMethod.put:
        return 'PUT';
    }
  }
}

class LsSectionAlarmApi extends ConsumerStatefulWidget {
  const LsSectionAlarmApi({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionAlarmApi> createState() =>
      _LsSectionAlarmApiState();
}

class _LsSectionAlarmApiState extends ConsumerState<LsSectionAlarmApi> {
  final _urlCtl = TextEditingController(text: 'https://');
  _HttpMethod _method = _HttpMethod.post;
  final _headersCtl = TextEditingController();
  final _bodyCtl = TextEditingController(text: _defaultBodyTemplate);
  final _bearerCtl = TextEditingController();
  bool _active = true;

  bool _hasEndpoint = false;
  String? _deviceUrl; // What the firmware reports for this slot, if any.

  bool _loading = true;
  bool _saving = false;
  bool _testing = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _urlCtl.dispose();
    _headersCtl.dispose();
    _bodyCtl.dispose();
    _bearerCtl.dispose();
    super.dispose();
  }

  Future<void> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey(widget.deviceId));
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      final url = m['url'] as String?;
      if (url != null && url.isNotEmpty) _urlCtl.text = url;
      _method = _HttpMethodExt.parse(m['method'] as String?);
      _headersCtl.text = (m['headers'] as String?) ?? '';
      final body = m['body'] as String?;
      if (body != null && body.isNotEmpty) _bodyCtl.text = body;
      _bearerCtl.text = (m['bearer'] as String?) ?? '';
      _active = (m['active'] as bool?) ?? true;
    } catch (_) {/* ignore corrupt prefs */}
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey(widget.deviceId),
      jsonEncode({
        'url': _urlCtl.text.trim(),
        'method': _method.wire,
        'headers': _headersCtl.text,
        'body': _bodyCtl.text,
        'bearer': _bearerCtl.text.trim(),
        'active': _active,
      }),
    );
  }

  Future<void> _clearLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey(widget.deviceId));
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    await _loadLocal();
    try {
      final session =
          await ref.read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('api.endpoint.list');
      if (!mounted) return;
      bool exists = false;
      String? url;
      if (r.ok && r.data is List) {
        for (final e in r.data as List) {
          if (e is Map && e['name'] == _kEndpointName) {
            exists = true;
            url = e['url']?.toString();
            break;
          }
        }
      }
      setState(() {
        _hasEndpoint = exists;
        _deviceUrl = url;
        _loading = false;
      });
      _pushStatus();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final url = _urlCtl.text.trim();
    if (!_looksLikeUrl(url)) {
      _snack(l.lsAlarmApiUrlValidation);
      return;
    }
    // Headers + body are validated to be JSON-parseable if non-empty so
    // the firmware doesn't reject silently later.
    if (_headersCtl.text.trim().isNotEmpty) {
      try {
        jsonDecode(_headersCtl.text);
      } catch (_) {
        _snack(l.lsAlarmApiHeadersValidation);
        return;
      }
    }
    setState(() => _saving = true);
    await _saveLocal();
    try {
      final session =
          await ref.read(deviceSessionProvider(widget.deviceId).future);
      if (_active) {
        final bearer = _bearerCtl.text.trim();
        final args = <String, dynamic>{
          'name': _kEndpointName,
          'type': 'webhook_post',
          'url': url,
          'method': _method.wire,
          'content-type': 'application/json',
        };
        if (bearer.isNotEmpty) {
          args['auth'] = 'bearer';
          args['token'] = bearer;
        }
        final r = await session.client.sendCritical(
          'api.endpoint.add',
          args: args,
          confirmRequest: _confirmDialog(
            title: l.lsAlarmApiSaveDialogTitle,
            body: l.lsAlarmApiSaveDialogBody(_kEndpointName, url),
            confirmLabel: l.lsCommonSaveButton,
          ),
        );
        if (!mounted) return;
        if (r.ok) {
          setState(() {
            _hasEndpoint = true;
            _deviceUrl = url;
            _saving = false;
          });
          _pushStatus();
          _snack(l.lsAlarmApiSavedSnack);
        } else if (r.err == 'ERR_CONFIRM_TOKEN_REQUIRED') {
          setState(() => _saving = false); // user cancelled
        } else {
          setState(() => _saving = false);
          _snack(l.lsCommonSaveFailedWith(r.err ?? '?'));
        }
      } else {
        await _removeRemote();
        if (!mounted) return;
        setState(() => _saving = false);
        _snack(l.lsAlarmApiDisabledSnack);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(l.lsCommonSaveFailedWith(e.toString()));
    }
  }

  Future<void> _test() async {
    final l = AppLocalizations.of(context);
    setState(() => _testing = true);
    try {
      final session =
          await ref.read(deviceSessionProvider(widget.deviceId).future);
      final payload = _renderTemplate(_bodyCtl.text);
      final r = await session.client.send(
        'api.send',
        args: {'name': _kEndpointName, 'payload': payload},
      );
      if (!mounted) return;
      setState(() => _testing = false);
      _snack(r.ok
          ? l.lsAlarmApiTestQueuedSnack
          : l.lsAlarmApiTestFailedWith(r.err ?? '?'));
    } catch (e) {
      if (!mounted) return;
      setState(() => _testing = false);
      _snack(l.lsAlarmApiTestFailedWith(e.toString()));
    }
  }

  Future<void> _removeRemote() async {
    final l = AppLocalizations.of(context);
    final session =
        await ref.read(deviceSessionProvider(widget.deviceId).future);
    final r = await session.client.sendCritical(
      'api.endpoint.remove',
      args: {'name': _kEndpointName},
      confirmRequest: _confirmDialog(
        title: l.lsAlarmApiRemoveDialogTitle,
        body: l.lsAlarmApiRemoveDialogBody(_kEndpointName),
        confirmLabel: l.lsAlarmApiRemoveButton,
        danger: true,
      ),
    );
    if (!mounted) return;
    if (r.ok) {
      setState(() {
        _hasEndpoint = false;
        _deviceUrl = null;
      });
      _pushStatus();
    } else if (r.err != 'ERR_CONFIRM_TOKEN_REQUIRED') {
      _snack(l.lsAlarmApiRemoveFailedWith(r.err ?? '?'));
    }
  }

  Future<void> _onRemove() async {
    setState(() => _saving = true);
    try {
      await _removeRemote();
      await _clearLocal();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  bool _looksLikeUrl(String s) =>
      s.startsWith('http://') || s.startsWith('https://');

  String _renderTemplate(String tpl) {
    // Cheap substitution so the manual test payload looks like what the
    // firmware will eventually emit. `{device}` → deviceId verbatim;
    // `{remaining_sec}` → 0 (no live access here, the device fills the
    // real number when it fires the chain itself).
    return tpl
        .replaceAll('{device}', widget.deviceId)
        .replaceAll('{remaining_sec}', '0');
  }

  void _pushStatus() {
    final l = AppLocalizations.of(context);
    if (!_hasEndpoint) {
      widget.onStatusChanged(l.lsSmtpStatusNotConfigured);
      return;
    }
    final url = _deviceUrl ?? _urlCtl.text.trim();
    final host = _hostFromUrl(url);
    widget.onStatusChanged(
      host.isEmpty
          ? l.lsAlarmApiConfiguredStatus
          : l.lsAlarmApiConfiguredHost(host),
    );
  }

  String _hostFromUrl(String url) {
    try {
      final u = Uri.parse(url);
      return u.host;
    } catch (_) {
      return '';
    }
  }

  Future<bool> Function(CliConfirmRequest) _confirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    bool danger = false,
  }) {
    return (req) async {
      if (!mounted) return false;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(AppLocalizations.of(ctx).commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: danger ? SkColors.warnRed : null,
              ),
              child: Text(confirmLabel),
            ),
          ],
        ),
      );
      return ok == true;
    };
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LsSectionBody(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      );
    }
    if (_loadError != null) {
      return LsSectionBody(
        children: [
          LsSectionErrorLine(message: _loadError!, onRetry: _fetch),
        ],
      );
    }

    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;

    return LsSectionBody(
      children: [
        LsField(
          label: l.lsAlarmApiUrlLabel,
          child: LsNeuTextField(
            controller: _urlCtl,
            enabled: !_saving,
            keyboardType: TextInputType.url,
            hint: 'https://example.com/alarm',
          ),
        ),
        LsField(
          label: l.lsAlarmApiMethodLabel,
          row: true,
          child: SizedBox(
            width: 140,
            child: LsNeuDropdown<_HttpMethod>(
              value: _method,
              items: const [
                DropdownMenuItem(
                    value: _HttpMethod.post, child: Text('POST')),
                DropdownMenuItem(
                    value: _HttpMethod.get, child: Text('GET')),
                DropdownMenuItem(
                    value: _HttpMethod.put, child: Text('PUT')),
              ],
              onChanged: _saving
                  ? null
                  : (v) {
                      if (v != null) setState(() => _method = v);
                    },
            ),
          ),
        ),
        LsField(
          label: l.lsAlarmApiHeadersLabel,
          hint: l.lsAlarmApiHeadersHint,
          child: TextField(
            controller: _headersCtl,
            enabled: !_saving,
            maxLines: 3,
            minLines: 1,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'monospace',
              color: fg,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              hintText: '{"X-Trace":"ls-alarm"}',
              hintStyle: TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: fg.withValues(alpha: 0.35),
              ),
            ),
          ),
        ),
        LsField(
          label: l.lsAlarmApiBodyTemplateLabel,
          hint: l.lsAlarmApiBodyTemplateHint,
          child: TextField(
            controller: _bodyCtl,
            enabled: !_saving,
            maxLines: 4,
            minLines: 2,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'monospace',
              color: fg,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              hintText: _defaultBodyTemplate,
              hintStyle: TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: fg.withValues(alpha: 0.35),
              ),
            ),
          ),
        ),
        LsField(
          label: l.lsAlarmApiBearerLabel,
          child: LsNeuTextField(
            controller: _bearerCtl,
            enabled: !_saving,
            obscure: true,
            hint: 'eyJhbGciOi...',
          ),
        ),
        LsField(
          label: l.lsReminderMailActiveLabel,
          row: true,
          child: Switch.adaptive(
            value: _active,
            onChanged: _saving
                ? null
                : (v) => setState(() => _active = v),
          ),
        ),
        LsActionsRow(
          children: [
            if (_hasEndpoint)
              LsPillButton(
                label: l.lsAlarmApiRemoveButton,
                onPressed: _saving ? null : _onRemove,
                danger: true,
                outlined: true,
              ),
            LsPillButton(
              label: l.lsSmtpSendTestButton,
              onPressed: (_hasEndpoint && !_testing && !_saving)
                  ? _test
                  : null,
              outlined: true,
            ),
            LsPillButton(
              label: _saving ? l.lsCommonSavingButton : l.lsCommonSaveButton,
              onPressed: _saving ? null : _save,
              accent: true,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            l.lsAlarmApiFootnote,
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: fg.withValues(alpha: 0.50),
              height: 1.4,
            ),
          ),
        ),
        if (_saving || _testing)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              minHeight: 2,
              color: SkColors.attentionMustard,
            ),
          ),
      ],
    );
  }
}

extension _HttpMethodExt on _HttpMethod {
  static _HttpMethod parse(String? s) {
    switch (s) {
      case 'GET':
        return _HttpMethod.get;
      case 'PUT':
        return _HttpMethod.put;
      case 'POST':
      default:
        return _HttpMethod.post;
    }
  }
}
