// BfPassphraseScreen, content-access passphrase configuration.
//
// Three operations on top of `auth.passphrase.*` CLI commands:
//   1. Set    , when no passphrase exists. Asks for the new value, length
//                check 6-32, sends `auth.passphrase.set` (critical, auto
//                confirm-token).
//   2. Change , verifies old + sets new in one transaction.
//   3. Clear  , verifies old, then wipes hash + mode bits.
//
// Plus the two enforcement-mode toggles (`pairing_required`,
// `always_required`) pushed via `auth.passphrase.mode.set`.

import 'package:flutter/material.dart';

import '../../../core/cli/cli_client.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'bf_session.dart';

class BfPassphraseScreen extends StatefulWidget {
  const BfPassphraseScreen({super.key});

  @override
  State<BfPassphraseScreen> createState() => _BfPassphraseScreenState();
}

class _BfPassphraseScreenState extends State<BfPassphraseScreen> {
  bool _loading = true;
  String? _err;
  bool _set = false;
  bool _pairing = false;
  bool _always = false;
  int _attemptsLeft = 10;
  int _minLen = 6;
  int _maxLen = 32;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loading) _refresh();
  }

  CliClient get _client => BfSession.of(context).client;

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _err = null;
    });
    final l = AppLocalizations.of(context);
    try {
      final r = await _client.send('auth.passphrase.status');
      if (!mounted) return;
      if (!r.ok || r.data is! Map) {
        setState(() {
          _err = l.bfPassphraseStatusReadError(r.err ?? '?');
          _loading = false;
        });
        return;
      }
      final m = Map<String, dynamic>.from(r.data as Map);
      final mode = (m['mode'] as Map?)?.cast<String, dynamic>();
      setState(() {
        _set = m['set'] == true;
        _pairing = mode?['pairing'] == true;
        _always = mode?['always'] == true;
        _attemptsLeft = (m['attempts_left'] as num?)?.toInt() ?? 10;
        _minLen = (m['min_len'] as num?)?.toInt() ?? 6;
        _maxLen = (m['max_len'] as num?)?.toInt() ?? 32;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _err = l.bfPassphraseStatusReadError(e.toString());
        _loading = false;
      });
    }
  }

  Future<bool> _confirmCritical(CliConfirmRequest req) async => true;

  Future<void> _doSet() async {
    final l = AppLocalizations.of(context);
    final plain = await _promptValue(
      title: l.bfPassphraseSetTitle,
      hint: l.bfPassphraseNewLabel,
      validator: _validateLength,
    );
    if (plain == null) return;
    final r = await _client.sendCritical(
      'auth.passphrase.set',
      args: {'plain': plain},
      confirmRequest: _confirmCritical,
    );
    _toastResult(r, l.bfPassphraseSetDone);
    await _refresh();
  }

  Future<void> _doChange() async {
    final l = AppLocalizations.of(context);
    final oldp = await _promptValue(
      title: l.bfPassphraseChangeTitle,
      hint: l.bfPassphraseCurrentLabel,
      validator: (s) => s.isEmpty ? l.bfPassphraseEmpty : null,
    );
    if (oldp == null) return;
    if (!mounted) return;
    final newp = await _promptValue(
      title: l.bfPassphraseChangeTitle,
      hint: l.bfPassphraseNewLabel,
      validator: _validateLength,
    );
    if (newp == null) return;
    final r = await _client.sendCritical(
      'auth.passphrase.change',
      args: {'old': oldp, 'new': newp},
      confirmRequest: _confirmCritical,
    );
    _toastResult(r, l.bfPassphraseChangeDone);
    await _refresh();
  }

  Future<void> _doClear() async {
    final l = AppLocalizations.of(context);
    final oldp = await _promptValue(
      title: l.bfPassphraseClearTitle,
      hint: l.bfPassphraseCurrentLabel,
      validator: (s) => s.isEmpty ? l.bfPassphraseEmpty : null,
    );
    if (oldp == null) return;
    final r = await _client.sendCritical(
      'auth.passphrase.clear',
      args: {'old': oldp},
      confirmRequest: _confirmCritical,
    );
    _toastResult(r, l.bfPassphraseClearDone);
    await _refresh();
  }

  Future<void> _setMode({bool? pairing, bool? always}) async {
    final p = pairing ?? _pairing;
    final a = always ?? _always;
    final r = await _client.sendCritical(
      'auth.passphrase.mode.set',
      args: {'pairing': p ? 1 : 0, 'always': a ? 1 : 0},
      confirmRequest: _confirmCritical,
    );
    if (!r.ok) _toastResult(r, '');
    await _refresh();
  }

  String? _validateLength(String s) {
    final l = AppLocalizations.of(context);
    if (s.length < _minLen) return l.bfPassphraseTooShort(_minLen);
    if (s.length > _maxLen) return l.bfPassphraseTooLong(_maxLen);
    return null;
  }

  void _toastResult(CliResponse r, String okMessage) {
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (r.ok) {
      if (okMessage.isNotEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(okMessage, textAlign: TextAlign.center)));
      }
      return;
    }
    final reason = r.params?['reason']?.toString();
    final attempts = r.params?['attempts_left'];
    final detail = [
      if (r.err != null) r.err!,
      ?reason,
      if (attempts != null) l.passphraseAttemptsLeft(attempts as int),
    ].join(' · ');
    messenger.showSnackBar(SnackBar(content: Text(l.logsErrorPrefix(detail), textAlign: TextAlign.center)));
  }

  Future<String?> _promptValue({
    required String title,
    required String hint,
    required String? Function(String) validator,
  }) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    bool obscured = true;
    String? error;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dctx) => StatefulBuilder(
        builder: (dctx, setLocal) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                obscureText: obscured,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: hint,
                  errorText: error,
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscured ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setLocal(() => obscured = !obscured),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.bfPassphraseLengthHint(_minLen, _maxLen),
                style: Theme.of(dctx).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dctx).pop(null),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () {
                final v = controller.text;
                final e = validator(v);
                if (e != null) {
                  setLocal(() => error = e);
                  return;
                }
                Navigator.of(dctx).pop(v);
              },
              child: Text(l.commonOk),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.bfPassphraseTitle),
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _err != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_err!),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _refresh,
                          icon: const Icon(Icons.refresh),
                          label: Text(l.commonRetry),
                        ),
                      ],
                    ),
                  ),
                )
              : _content(),
      ),
    );
  }

  Widget _content() {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
      children: [
        _statusCard(),
        const SizedBox(height: 16),
        if (_set) ...[
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(l.bfPassphraseChangeTitle),
            subtitle: Text(l.bfPassphraseChangeSubtitle),
            onTap: _doChange,
          ),
          ListTile(
            leading: Icon(Icons.lock_open,
                color: Theme.of(context).colorScheme.error),
            title: Text(l.bfPassphraseClearTitle),
            subtitle: Text(l.bfPassphraseClearSubtitle),
            onTap: _doClear,
          ),
          const Divider(height: 32),
          ListTile(
            title: Text(l.bfPassphraseModePairing),
            subtitle: Text(l.bfPassphraseModePairingSubtitle),
            trailing: SkNeuSwitch(
              value: _pairing,
              onChanged: (v) => _setMode(pairing: v),
            ),
            onTap: () => _setMode(pairing: !_pairing),
          ),
          ListTile(
            title: Text(l.bfPassphraseModeAlways),
            subtitle: Text(l.bfPassphraseModeAlwaysSubtitle),
            trailing: SkNeuSwitch(
              value: _always,
              onChanged: (v) => _setMode(always: v),
            ),
            onTap: () => _setMode(always: !_always),
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: Text(l.bfPassphraseSetTitle),
            subtitle: Text(l.bfPassphraseLengthSubtitle(_minLen, _maxLen)),
            onTap: _doSet,
          ),
        ],
        const SizedBox(height: 16),
        _explainCard(),
      ],
    );
  }

  Widget _statusCard() {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final modeText = !_set
        ? l.bfPassphraseStatusNone
        : (!_pairing && !_always)
            ? l.bfPassphraseStatusActiveOff
            : [
                if (_pairing) l.bfPassphraseStatusActivePairing,
                if (_always) l.bfPassphraseStatusActiveAlways,
              ].join(' · ');
    return SkNeuCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SkNeuIconSlot(
            icon: _set ? Icons.lock : Icons.lock_open,
            size: 44,
            iconSize: 22,
            tone: _set
                ? SkNeuIconSlotTone.mustard
                : SkNeuIconSlotTone.neutral,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _set ? l.bfPassphraseBadgeActive : l.bfPassphraseBadgeNone,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(modeText,
                    style: Theme.of(context).textTheme.bodySmall),
                if (_set && _attemptsLeft < 10) ...[
                  const SizedBox(height: 4),
                  Text(
                    l.bfPassphraseAttemptsRatio(_attemptsLeft, 10),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _attemptsLeft <= 3 ? cs.error : null,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _explainCard() {
    final l = AppLocalizations.of(context);
    return SkNeuCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 8),
              Text(l.bfPassphraseNotesTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.bfPassphraseNotesBody,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
