// Mail Setup (SMTP) section body for LebensSpur dashboard.
//
// Four fields (host, port, sender, api_key) backed by four separate
// CLI commands. We fetch via `smtp.get` (api_key comes back masked as
// "(set, N chars)"), and on Save we issue any commands whose field is
// dirty. The api_key field is special: only sent if the user typed
// something new (its placeholder shows the masked length, blank input
// means "keep current key").
//
// CLI contract:
//   READ : smtp.get  → {host, port, sender, api_key}
//   WRITE: smtp.host {host}
//          smtp.port {port}
//          smtp.sender {sender}
//          smtp.key {api_key}
//   TEST : smtp.test
//
// SAVE caveat (also noted to the parent agent): the four writes are not
// atomic. If one fails midway, the device is left in a half-applied
// state and the user has to retry. We surface which field failed in
// the snackbar so the user can fix it without losing the others.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

class LsSectionSmtp extends ConsumerStatefulWidget {
  const LsSectionSmtp({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionSmtp> createState() => _LsSectionSmtpState();
}

class _LsSectionSmtpState extends ConsumerState<LsSectionSmtp> {
  static const _appPasswordUrl =
      'https://support.google.com/accounts/answer/185833';

  bool _loading = true;
  bool _saving = false;
  bool _testing = false;
  String? _loadError;

  // Device snapshot (for dirty diff).
  String _deviceHost = '';
  int _devicePort = 465;
  String _deviceSender = '';
  String _deviceKeyMask = ''; // "(set, N chars)" or ""

  final _hostCtl = TextEditingController();
  final _portCtl = TextEditingController(text: '465');
  final _senderCtl = TextEditingController();
  final _keyCtl = TextEditingController();
  bool _showKey = false;

  @override
  void initState() {
    super.initState();
    _hostCtl.addListener(_rebuild);
    _portCtl.addListener(_rebuild);
    _senderCtl.addListener(_rebuild);
    _keyCtl.addListener(_rebuild);
    _fetch();
  }

  @override
  void dispose() {
    _hostCtl.dispose();
    _portCtl.dispose();
    _senderCtl.dispose();
    _keyCtl.dispose();
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
      final r = await session.client.send('smtp.get');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = (r.data as Map).cast<String, dynamic>();
        final h = m['host']?.toString() ?? '';
        final p = (m['port'] as num?)?.toInt() ?? 465;
        final s = m['sender']?.toString() ?? '';
        final k = m['api_key']?.toString() ?? '';
        setState(() {
          _deviceHost = h;
          _devicePort = p;
          _deviceSender = s;
          _deviceKeyMask = k;
          _hostCtl.text = h;
          _portCtl.text = p.toString();
          _senderCtl.text = s;
          _keyCtl.text = '';
          _loading = false;
        });
        widget.onStatusChanged(_summary(h));
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

  String _summary(String host) {
    if (host.isEmpty) return AppLocalizations.of(context).lsSmtpStatusNotConfigured;
    return host;
  }

  bool get _dirty {
    if (_hostCtl.text.trim() != _deviceHost) return true;
    final port = int.tryParse(_portCtl.text.trim());
    if (port != null && port != _devicePort) return true;
    if (_senderCtl.text.trim() != _deviceSender) return true;
    if (_keyCtl.text.isNotEmpty) return true;
    return false;
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final host = _hostCtl.text.trim();
    final portStr = _portCtl.text.trim();
    final port = int.tryParse(portStr);
    final sender = _senderCtl.text.trim();
    final newKey = _keyCtl.text;

    if (host.isEmpty) {
      _snack(l.lsSmtpHostRequired);
      return;
    }
    if (port == null || port < 1 || port > 65535) {
      _snack(l.lsSmtpPortValidationError);
      return;
    }
    if (sender.isEmpty) {
      _snack(l.lsSmtpSenderRequired);
      return;
    }

    setState(() => _saving = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);

      // Issue per-field commands sequentially so a failure is
      // attributable. Stop at the first error so the user fixes one
      // thing at a time (cleaner than blasting all 4 and surfacing a
      // grab-bag of failures).
      Future<String?> step(String fieldLabel, String cmd,
          Map<String, dynamic> args) async {
        final r = await session.client.send(cmd, args: args);
        if (!r.ok) return '$fieldLabel: ${r.err ?? "?"}';
        return null;
      }

      String? err;
      if (host != _deviceHost) {
        err = await step(l.lsSmtpFieldHost, 'smtp.host', {'host': host});
      }
      if (err == null && port != _devicePort) {
        err = await step(l.lsSmtpFieldPort, 'smtp.port', {'port': port});
      }
      if (err == null && sender != _deviceSender) {
        err = await step(l.lsSmtpFieldSender, 'smtp.sender', {'sender': sender});
      }
      if (err == null && newKey.isNotEmpty) {
        err = await step(l.lsSmtpFieldKey, 'smtp.key', {'api_key': newKey});
      }
      if (!mounted) return;
      if (err != null) {
        setState(() => _saving = false);
        _snack(l.lsSmtpSaveHaltedOn(err));
        return;
      }
      _snack(l.lsSmtpSavedSnack);
      await _fetch();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(l.lsCommonSaveFailedWith(e.toString()));
    }
  }

  Future<void> _sendTest() async {
    final l = AppLocalizations.of(context);
    setState(() => _testing = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(
        'smtp.test',
        timeout: const Duration(seconds: 30),
      );
      if (!mounted) return;
      setState(() => _testing = false);
      if (r.ok) {
        _snack(l.lsSmtpTestSentSnack);
      } else {
        _snack(l.lsSmtpTestFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _testing = false);
      _snack(l.lsSmtpTestFailedWith(e.toString()));
    }
  }

  Future<void> _openAppPasswordHelp() async {
    final l = AppLocalizations.of(context);
    final uri = Uri.parse(_appPasswordUrl);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        await Clipboard.setData(const ClipboardData(text: _appPasswordUrl));
        _snack(l.lsSmtpUrlCopiedSnack);
      }
    } catch (_) {
      await Clipboard.setData(const ClipboardData(text: _appPasswordUrl));
      if (mounted) _snack(l.lsSmtpUrlCopiedSnack);
    }
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
    final keyPlaceholder = _deviceKeyMask.isNotEmpty
        ? _deviceKeyMask
        : l.lsSmtpApiKeyPlaceholder;

    return LsSectionBody(
      children: [
        LsField2Col(
          left: LsField(
            label: l.lsSmtpServerLabel,
            child: LsNeuTextField(
              controller: _hostCtl,
              enabled: !_saving,
              hint: 'smtp.gmail.com',
            ),
          ),
          right: LsField(
            label: l.lsSmtpFieldPort,
            child: LsNeuTextField(
              controller: _portCtl,
              enabled: !_saving,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              hint: '465',
            ),
          ),
        ),
        LsField(
          label: l.lsSmtpFieldSender,
          child: LsNeuTextField(
            controller: _senderCtl,
            enabled: !_saving,
            keyboardType: TextInputType.emailAddress,
            hint: 'you@gmail.com',
          ),
        ),
        LsField(
          label: l.lsSmtpApiKeyLabel,
          hint: l.lsSmtpApiKeyHint,
          child: LsNeuTextField(
            controller: _keyCtl,
            obscure: !_showKey,
            enabled: !_saving,
            hint: keyPlaceholder,
            suffix: IconButton(
              icon: Icon(
                _showKey ? Icons.visibility_off : Icons.visibility,
                size: 16,
              ),
              color: fg.withValues(alpha: 0.50),
              onPressed: () => setState(() => _showKey = !_showKey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        GestureDetector(
          onTap: _openAppPasswordHelp,
          child: Text(
            l.lsSmtpAppPasswordHelpLink,
            style: TextStyle(
              fontSize: 11,
              color: SkColors.attentionMustard,
              decoration: TextDecoration.underline,
              decorationColor:
                  SkColors.attentionMustard.withValues(alpha: 0.50),
            ),
          ),
        ),
        LsActionsRow(
          children: [
            LsPillButton(
              label: _testing ? l.lsSmtpSendingButton : l.lsSmtpSendTestButton,
              icon: Icons.outgoing_mail,
              outlined: true,
              onPressed: (_saving || _testing) ? null : _sendTest,
            ),
            LsPillButton(
              label: _saving ? l.lsCommonSavingButton : l.lsCommonSaveButton,
              onPressed: (_dirty && !_saving && !_testing) ? _save : null,
              accent: _dirty,
            ),
          ],
        ),
      ],
    );
  }
}
