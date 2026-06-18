// Telegram early-warning section body for LebensSpur dashboard.
//
// User pastes a Telegram bot token + chat id; we register a USER slot on
// sk_api (`api.endpoint.add --type generic --url https://api.telegram.org/
// bot<TOKEN>/sendMessage`). Once the firmware grows a `timer.alarm` →
// `sk_api_chain_run` subscriber this slot will fire automatically; until
// then the disclaimer at the bottom makes the deferred status explicit.
//
// CLI contract:
//   READ   : api.endpoint.list  → look up slot named `early_telegram`
//   WRITE  : api.endpoint.add  --name early_telegram --type generic
//                              --url <built from token>
//                              --method POST
//                              --content-type application/json
//            (critical → confirm-token round trip via sendCritical)
//   TEST   : api.send  --name early_telegram
//   REMOVE : api.endpoint.remove --name early_telegram   (also critical)
//
// Chat id + message template are kept in SharedPreferences as a sidecar
// (the firmware's --body flag doesn't exist and the URL alone can't
// encode the payload). When the firmware-side timer.alarm hook lands it
// will read these locally-stored fields and POST the JSON itself.

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

const String _kEndpointName = 'early_telegram';
String _prefsKey(String deviceId) => 'ls_${deviceId}_telegram_v1';

class LsSectionTelegram extends ConsumerStatefulWidget {
  const LsSectionTelegram({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionTelegram> createState() =>
      _LsSectionTelegramState();
}

class _LsSectionTelegramState extends ConsumerState<LsSectionTelegram> {
  // Local form state.
  final _tokenCtl = TextEditingController();
  final _chatCtl = TextEditingController();
  final _messageCtl = TextEditingController(
    text: 'LebensSpur: Alarm triggered, check timer status.',
  );
  bool _active = true;

  // Remote state — does the USER slot currently exist on the device?
  bool _hasEndpoint = false;

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
    _tokenCtl.dispose();
    _chatCtl.dispose();
    _messageCtl.dispose();
    super.dispose();
  }

  // -- Persistence helpers ----------------------------------------------

  Future<void> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey(widget.deviceId));
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      _tokenCtl.text = (m['token'] as String?) ?? '';
      _chatCtl.text = (m['chat'] as String?) ?? '';
      final msg = (m['message'] as String?);
      if (msg != null && msg.isNotEmpty) _messageCtl.text = msg;
      _active = (m['active'] as bool?) ?? true;
    } catch (_) {/* ignore corrupt prefs */}
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey(widget.deviceId),
      jsonEncode({
        'token': _tokenCtl.text.trim(),
        'chat': _chatCtl.text.trim(),
        'message': _messageCtl.text,
        'active': _active,
      }),
    );
  }

  Future<void> _clearLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey(widget.deviceId));
  }

  // -- Device round trips -----------------------------------------------

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
      if (r.ok && r.data is List) {
        for (final e in r.data as List) {
          if (e is Map && e['name'] == _kEndpointName) {
            exists = true;
            break;
          }
        }
      }
      setState(() {
        _hasEndpoint = exists;
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

  String _buildUrl(String token) {
    // Telegram sendMessage path. Token format is `<bot_id>:<secret>`. We
    // intentionally keep the raw token in the URL because sk_api's --auth
    // flag has no Telegram preset; this matches every Telegram bot HTTP
    // recipe in the wild and is what users will paste from BotFather.
    return 'https://api.telegram.org/bot$token/sendMessage';
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final token = _tokenCtl.text.trim();
    final chat = _chatCtl.text.trim();
    if (token.isEmpty) {
      _snack(l.lsTelegramTokenRequired);
      return;
    }
    if (chat.isEmpty) {
      _snack(l.lsTelegramChatRequired);
      return;
    }
    setState(() => _saving = true);
    await _saveLocal();
    try {
      final session =
          await ref.read(deviceSessionProvider(widget.deviceId).future);
      if (_active) {
        final r = await session.client.sendCritical(
          'api.endpoint.add',
          args: {
            'name': _kEndpointName,
            'type': 'generic',
            'url': _buildUrl(token),
            'method': 'POST',
            'content-type': 'application/json',
          },
          confirmRequest: _confirmDialog(
            title: l.lsTelegramSaveDialogTitle,
            body: l.lsTelegramSaveDialogBody(_kEndpointName),
            confirmLabel: l.lsCommonSaveButton,
          ),
        );
        if (!mounted) return;
        if (r.ok) {
          setState(() {
            _hasEndpoint = true;
            _saving = false;
          });
          _pushStatus();
          _snack(l.lsTelegramSavedSnack);
        } else if (r.err == 'ERR_CONFIRM_TOKEN_REQUIRED') {
          setState(() => _saving = false); // user cancelled the dialog
        } else {
          setState(() => _saving = false);
          _snack(l.lsCommonSaveFailedWith(r.err ?? '?'));
        }
      } else {
        // Active toggle off → tear the slot down so nothing fires later.
        await _removeRemote();
        if (!mounted) return;
        setState(() => _saving = false);
        _snack(l.lsTelegramDisabledSnack);
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
      // Telegram needs a JSON body with chat_id + text; sk_api doesn't
      // template this for us, so we ship a literal payload that the
      // device's generic POST handler forwards verbatim.
      final payload = jsonEncode({
        'chat_id': _chatCtl.text.trim(),
        'text': _messageCtl.text,
      });
      final r = await session.client.send(
        'api.send',
        args: {'name': _kEndpointName, 'payload': payload},
      );
      if (!mounted) return;
      setState(() => _testing = false);
      _snack(r.ok
          ? l.lsTelegramTestQueuedSnack
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
        title: l.lsTelegramRemoveDialogTitle,
        body: l.lsAlarmApiRemoveDialogBody(_kEndpointName),
        confirmLabel: l.lsAlarmApiRemoveButton,
        danger: true,
      ),
    );
    if (!mounted) return;
    if (r.ok) {
      setState(() => _hasEndpoint = false);
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

  void _pushStatus() {
    final l = AppLocalizations.of(context);
    if (_hasEndpoint && _tokenCtl.text.trim().isNotEmpty) {
      widget.onStatusChanged(l.lsTelegramBotConfiguredStatus);
    } else {
      widget.onStatusChanged(l.lsSmtpStatusNotConfigured);
    }
  }

  // -- Dialog helper -----------------------------------------------------

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

  // -- Build -------------------------------------------------------------

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
          label: l.lsTelegramBotTokenLabel,
          hint: l.lsTelegramBotTokenHint,
          child: LsNeuTextField(
            controller: _tokenCtl,
            obscure: true,
            enabled: !_saving,
            hint: '123456:ABC-DEF...',
          ),
        ),
        LsField(
          label: l.lsTelegramChatIdLabel,
          hint: l.lsTelegramChatIdHint,
          child: LsNeuTextField(
            controller: _chatCtl,
            enabled: !_saving,
            hint: '-100123456789',
          ),
        ),
        LsField(
          label: l.lsTelegramMessageTemplateLabel,
          child: TextField(
            controller: _messageCtl,
            enabled: !_saving,
            maxLines: 3,
            minLines: 2,
            style: TextStyle(fontSize: 14, color: fg),
            decoration: InputDecoration(
              isDense: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              hintText: l.lsTelegramMessageHint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: fg.withValues(alpha: 0.35),
              ),
            ),
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
