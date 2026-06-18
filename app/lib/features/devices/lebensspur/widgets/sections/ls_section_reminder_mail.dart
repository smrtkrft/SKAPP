// Reminder Mail early-warning section body for LebensSpur dashboard.
//
// Unlike Telegram / generic webhook, there is currently no firmware-side
// "reminder mail" concept distinct from the regular trigger-time alert
// chain. Until the firmware grows a dedicated `mail.reminder.set` (and
// the matching `timer.alarm` subscriber that calls it), the config lives
// purely in SharedPreferences on this device. The Send-test button
// piggybacks on the existing `smtp.test` command so the user can at
// least verify their SMTP credentials work — that proves the eventual
// reminder will be deliverable once the firmware glue lands.
//
// CLI contract (today):
//   READ  : SharedPreferences  (key ls_<deviceId>_reminder_mail_v1)
//   WRITE : SharedPreferences  (same key, JSON map)
//   TEST  : smtp.test --to <recipient>  (firmware-side dry run)

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

String _prefsKey(String deviceId) => 'ls_${deviceId}_reminder_mail_v1';

class LsSectionReminderMail extends ConsumerStatefulWidget {
  const LsSectionReminderMail({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionReminderMail> createState() =>
      _LsSectionReminderMailState();
}

class _LsSectionReminderMailState
    extends ConsumerState<LsSectionReminderMail> {
  final _recipientCtl = TextEditingController();
  // Default subject + body seeded with English placeholders; user is
  // expected to edit. We don't re-translate on locale change because
  // they live in user-owned SharedPreferences after first save.
  final _subjectCtl = TextEditingController(text: 'LebensSpur reminder');
  final _bodyCtl = TextEditingController(
    text: 'Your countdown will trigger soon. Reset to avoid action.',
  );
  bool _active = true;

  bool _loading = true;
  bool _saving = false;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _recipientCtl.dispose();
    _subjectCtl.dispose();
    _bodyCtl.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey(widget.deviceId));
    if (raw != null) {
      try {
        final m = jsonDecode(raw) as Map<String, dynamic>;
        _recipientCtl.text = (m['recipient'] as String?) ?? '';
        final subj = m['subject'] as String?;
        if (subj != null && subj.isNotEmpty) _subjectCtl.text = subj;
        final body = m['body'] as String?;
        if (body != null && body.isNotEmpty) _bodyCtl.text = body;
        _active = (m['active'] as bool?) ?? true;
      } catch (_) {/* ignore corrupt prefs */}
    }
    if (!mounted) return;
    setState(() => _loading = false);
    _pushStatus();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final to = _recipientCtl.text.trim();
    if (!_looksLikeEmail(to)) {
      _snack(l.lsReminderMailRecipientValidation);
      return;
    }
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey(widget.deviceId),
      jsonEncode({
        'recipient': to,
        'subject': _subjectCtl.text,
        'body': _bodyCtl.text,
        'active': _active,
      }),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    _pushStatus();
    _snack(l.lsReminderMailSavedSnack);
  }

  Future<void> _test() async {
    final l = AppLocalizations.of(context);
    final to = _recipientCtl.text.trim();
    if (!_looksLikeEmail(to)) {
      _snack(l.lsReminderMailRecipientFirstSnack);
      return;
    }
    setState(() => _testing = true);
    try {
      final session =
          await ref.read(deviceSessionProvider(widget.deviceId).future);
      // We piggyback on the device's smtp.test, which only confirms the
      // SMTP credentials reach the server. The eventual auto-reminder
      // path is firmware-side and not yet wired.
      final r = await session.client.send(
        'smtp.test',
        args: {'to': to},
      );
      if (!mounted) return;
      setState(() => _testing = false);
      _snack(r.ok
          ? l.lsReminderMailTestOkSnack
          : l.lsReminderMailTestFailedWith(r.err ?? '?'));
    } catch (e) {
      if (!mounted) return;
      setState(() => _testing = false);
      _snack(l.lsReminderMailTestFailedWith(e.toString()));
    }
  }

  bool _looksLikeEmail(String s) {
    // Defensive validation; not RFC-perfect, but catches the obvious
    // typos before SharedPreferences ends up holding garbage.
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return r.hasMatch(s);
  }

  void _pushStatus() {
    final to = _recipientCtl.text.trim();
    widget.onStatusChanged(
      to.isEmpty
          ? AppLocalizations.of(context).lsSmtpStatusNotConfigured
          : to,
    );
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

    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;

    return LsSectionBody(
      children: [
        LsField(
          label: l.lsReminderMailRecipientLabel,
          child: LsNeuTextField(
            controller: _recipientCtl,
            enabled: !_saving,
            keyboardType: TextInputType.emailAddress,
            hint: 'you@example.com',
          ),
        ),
        LsField(
          label: l.lsReminderMailSubjectLabel,
          child: LsNeuTextField(
            controller: _subjectCtl,
            enabled: !_saving,
            hint: 'LebensSpur reminder',
          ),
        ),
        LsField(
          label: l.lsReminderMailBodyLabel,
          child: TextField(
            controller: _bodyCtl,
            enabled: !_saving,
            maxLines: 4,
            minLines: 2,
            style: TextStyle(fontSize: 14, color: fg),
            decoration: InputDecoration(
              isDense: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              hintText: l.lsReminderMailBodyHint,
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
            LsPillButton(
              label: l.lsSmtpSendTestButton,
              onPressed: (!_testing && !_saving) ? _test : null,
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
            l.lsReminderMailFootnote,
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
