// LS API webhook section body for LebensSpur dashboard.
//
// LebensSpur reuses the generic sk_api outbound layer for the
// "trigger webhook" behaviour: when the countdown reaches zero, every
// USER endpoint fires. This section configures a single conventional
// USER slot named "ls_api" so the user has one obvious place to point
// their personal webhook URL, without exposing the full sk_api editor.
//
// CLI contract (sk_api uses `--key value` style — encoded as named
// args in NDJSON mode):
//   LIST   : api.endpoint.list → [{slot, kind, name, type, url, method,
//                                  auth, header, content_type, ...}]
//   ADD    : api.endpoint.add  (critical, two-step confirm)
//              --name ls_api --type webhook_post --url <URL>
//              --method POST|GET|PUT
//              [--auth bearer --token <BEARER>]
//              [--header-name X --content-type application/json]
//   REMOVE : api.endpoint.remove --name ls_api (critical)
//   TEST   : api.send --name ls_api [--payload <json>]
//
// UI:
//   * URL · method · headers (advanced JSON) · body template
//     (placeholder text, info-only) · bearer token (obscured).
//   * Save · Send test · Remove buttons.
//   * Status pushed to parent: "Configured · https://example.com/..."
//     or "Not configured".

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/cli/cli_client.dart';
import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

class LsSectionLsApi extends ConsumerStatefulWidget {
  const LsSectionLsApi({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionLsApi> createState() => _LsSectionLsApiState();
}

class _LsSectionLsApiState extends ConsumerState<LsSectionLsApi> {
  // Conventional reserved name. The user-facing terminology is just
  // "the LS webhook", but inside sk_api this lives as a USER slot
  // whose name is `ls_api`. Documented in this section's file header.
  static const String _slotName = 'ls_api';

  bool _loading = true;
  String? _loadError;
  bool _saving = false;
  bool _testing = false;

  // Existing slot snapshot (null if not yet configured).
  bool _exists = false;
  String? _existingUrl;
  String? _existingMethod;
  String? _existingMaskedToken;

  // Form state.
  final _urlCtl = TextEditingController();
  String _method = 'POST';
  final _headersCtl = TextEditingController(text: '{}');
  final _bodyCtl = TextEditingController(
    text:
        '{"event":"ls.triggered","device":"{device}","value1":"ls.triggered"}',
  );
  final _tokenCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlCtl.addListener(_rebuild);
    _tokenCtl.addListener(_rebuild);
    _fetch();
  }

  @override
  void dispose() {
    _urlCtl.dispose();
    _headersCtl.dispose();
    _bodyCtl.dispose();
    _tokenCtl.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('api.endpoint.list');
      if (!mounted) return;
      if (r.ok && r.data is List) {
        final list = r.data as List;
        Map<String, dynamic>? found;
        for (final e in list) {
          if (e is Map &&
              e['name']?.toString() == _slotName &&
              e['kind']?.toString() == 'user') {
            found = e.cast<String, dynamic>();
            break;
          }
        }
        setState(() {
          if (found != null) {
            _exists = true;
            _existingUrl = found['url']?.toString();
            _existingMethod = found['method']?.toString().toUpperCase();
            _existingMaskedToken = found['masked_token']?.toString();
            _urlCtl.text = _existingUrl ?? '';
            _method = _existingMethod ?? 'POST';
          } else {
            _exists = false;
            _existingUrl = null;
            _existingMethod = null;
            _existingMaskedToken = null;
          }
          _loading = false;
        });
        _pushStatus();
      } else {
        final l = AppLocalizations.of(context);
        setState(() {
          _loading = false;
          _loadError = r.err ?? l.lsCommonReadFailed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  void _pushStatus() {
    final l = AppLocalizations.of(context);
    if (!_exists || (_existingUrl == null || _existingUrl!.isEmpty)) {
      widget.onStatusChanged(l.lsSmtpStatusNotConfigured);
      return;
    }
    final truncated = _existingUrl!.length > 38
        ? '${_existingUrl!.substring(0, 38)}…'
        : _existingUrl!;
    widget.onStatusChanged(l.lsAlarmApiConfiguredHost(truncated));
  }

  bool get _canSave {
    final url = _urlCtl.text.trim();
    if (url.isEmpty) return false;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return false;
    }
    return !_saving;
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final url = _urlCtl.text.trim();
    if (url.isEmpty) {
      _snack(l.lsLsApiUrlRequired);
      return;
    }
    setState(() => _saving = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);

      final args = <String, dynamic>{
        'name': _slotName,
        'type': 'webhook_post',
        'url': url,
        'method': _method,
        'content-type': 'application/json',
      };
      final token = _tokenCtl.text.trim();
      if (token.isNotEmpty) {
        args['auth'] = 'bearer';
        args['token'] = token;
      }

      final r = await session.client.sendCritical(
        'api.endpoint.add',
        args: args,
        confirmRequest: _confirmRequest,
      );
      if (!mounted) return;
      if (r.ok) {
        _snack(_exists ? l.lsLsApiUpdatedSnack : l.lsLsApiSavedSnack);
        await _fetch();
      } else {
        _snack(l.lsCommonSaveFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      _snack(l.lsCommonSaveFailedWith(e.toString()));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _sendTest() async {
    final l = AppLocalizations.of(context);
    if (!_exists) {
      _snack(l.lsLsApiSaveFirstSnack);
      return;
    }
    setState(() => _testing = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      // api.send is not critical, so a direct send is fine. payload is
      // optional — the device fills in a default manual_test JSON.
      final args = <String, dynamic>{'name': _slotName};
      final body = _bodyCtl.text.trim();
      if (body.isNotEmpty) args['payload'] = body;
      final r = await session.client.send('api.send', args: args);
      if (!mounted) return;
      if (r.ok) {
        _snack(l.lsLsApiTestQueuedSnack);
      } else {
        _snack(l.lsAlarmApiTestFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      _snack(l.lsAlarmApiTestFailedWith(e.toString()));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _remove() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.lsAlarmApiRemoveDialogTitle),
        content: Text(l.lsLsApiRemoveDialogBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l.lsAlarmApiRemoveButton)),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _saving = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.sendCritical(
        'api.endpoint.remove',
        args: {'name': _slotName},
        confirmRequest: _confirmRequest,
      );
      if (!mounted) return;
      if (r.ok) {
        _snack(l.lsLsApiRemovedSnack);
        setState(() {
          _urlCtl.clear();
          _tokenCtl.clear();
          _method = 'POST';
        });
        await _fetch();
      } else {
        _snack(l.lsAlarmApiRemoveFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      _snack(l.lsAlarmApiRemoveFailedWith(e.toString()));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Dialog for the device's two-step confirm. The user is told what
  /// the device is about to do and given a short TTL window.
  Future<bool> _confirmRequest(CliConfirmRequest req) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.lsLsApiConfirmCriticalTitle),
        content: Text(l.lsLsApiConfirmCriticalBody(req.cmd, req.ttlSec)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l.lsLsApiConfirmButton)),
        ],
      ),
    );
    return ok == true;
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

    final hasToken =
        _existingMaskedToken != null && _existingMaskedToken!.isNotEmpty;

    return LsSectionBody(
      children: [
        if (_exists)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: SkColors.attentionMustard.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: SkColors.attentionMustard.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline,
                    size: 14, color: SkColors.attentionMustard),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    hasToken
                        ? l.lsLsApiActiveWithToken(_slotName, _existingMaskedToken!)
                        : l.lsLsApiActiveSlot(_slotName),
                    style: TextStyle(
                      fontSize: 11,
                      color: fg.withValues(alpha: 0.70),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        LsField(
          label: l.lsAlarmApiUrlLabel,
          hint: l.lsLsApiUrlHint,
          child: LsNeuTextField(
            controller: _urlCtl,
            enabled: !_saving,
            hint: 'https://example.com/triggered',
            keyboardType: TextInputType.url,
          ),
        ),
        LsField(
          label: l.lsAlarmApiMethodLabel,
          child: LsNeuDropdown<String>(
            value: _method,
            items: const [
              DropdownMenuItem(value: 'POST', child: Text('POST')),
              DropdownMenuItem(value: 'GET', child: Text('GET')),
              DropdownMenuItem(value: 'PUT', child: Text('PUT')),
            ],
            onChanged: _saving
                ? null
                : (v) {
                    if (v != null) setState(() => _method = v);
                  },
          ),
        ),
        LsField(
          label: l.lsLsApiHeadersLabel,
          hint: l.lsLsApiHeadersHint,
          child: LsNeuTextField(
            controller: _headersCtl,
            enabled: false,
          ),
        ),
        LsField(
          label: l.lsAlarmApiBodyTemplateLabel,
          hint: l.lsLsApiBodyTemplateHint,
          child: LsNeuTextField(
            controller: _bodyCtl,
            enabled: !_saving,
          ),
        ),
        LsField(
          label: l.lsAlarmApiBearerLabel,
          hint: hasToken
              ? l.lsLsApiBearerHintExisting(_existingMaskedToken!)
              : l.lsLsApiBearerHintEmpty,
          child: LsNeuTextField(
            controller: _tokenCtl,
            enabled: !_saving,
            obscure: true,
            hint: '••••••••••••',
          ),
        ),
        LsActionsRow(
          children: [
            if (_exists)
              LsPillButton(
                label: _testing ? l.lsSmtpSendingButton : l.lsSmtpSendTestButton,
                onPressed: (_saving || _testing) ? null : _sendTest,
                outlined: true,
                icon: Icons.send,
              ),
            if (_exists)
              LsPillButton(
                label: l.lsAlarmApiRemoveButton,
                onPressed: _saving ? null : _remove,
                danger: true,
                outlined: true,
                icon: Icons.delete_outline,
              ),
            LsPillButton(
              label: _saving
                  ? l.lsCommonSavingButton
                  : (_exists ? l.lsLsApiUpdateButton : l.lsCommonSaveButton),
              onPressed: _canSave ? _save : null,
              accent: _canSave,
            ),
          ],
        ),
        if (_saving)
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
