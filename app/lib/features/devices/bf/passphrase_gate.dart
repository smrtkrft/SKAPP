// PassphraseGate, sits between an authenticated CliClient and the BF UI
// to honour the firmware's `always_required` passphrase mode.
//
// Behaviour:
//   1. On mount, send a cheap `device.info` probe.
//   2. If the device replies normally → unlock the gate and render `child`.
//   3. If the device replies `ERR_SESSION_LOCKED` → prompt the user for
//      the passphrase, send `auth.passphrase.verify` as a signed envelope,
//      retry. Re-prompt on wrong passphrase until success or user cancels.

import 'package:flutter/material.dart';

import '../../../core/cli/cli_client.dart';
import '../../../l10n/app_localizations.dart';

class PassphraseGate extends StatefulWidget {
  const PassphraseGate({
    super.key,
    required this.client,
    required this.child,
  });

  final CliClient client;
  final Widget child;

  @override
  State<PassphraseGate> createState() => _PassphraseGateState();
}

enum _GateState { probing, locked, unlocked, failed }

class _PassphraseGateState extends State<PassphraseGate> {
  _GateState _state = _GateState.probing;
  int _attemptsLeft = 10;
  String? _failMsg;

  @override
  void initState() {
    super.initState();
    _probe();
  }

  Future<void> _probe() async {
    if (!mounted) return;
    setState(() => _state = _GateState.probing);
    final l = AppLocalizations.of(context);
    try {
      final r = await widget.client
          .send('device.info', timeout: const Duration(seconds: 6));
      if (r.ok) {
        if (mounted) setState(() => _state = _GateState.unlocked);
        return;
      }
      if (r.err == 'ERR_SESSION_LOCKED') {
        final left =
            (r.params?['attempts_left'] as num?)?.toInt() ?? _attemptsLeft;
        if (mounted) {
          setState(() {
            _state = _GateState.locked;
            _attemptsLeft = left;
          });
        }
        await _promptAndVerify();
        return;
      }
      // Unexpected error, surface but treat as unlocked so user sees
      // device home with whatever the screen can render.
      if (mounted) setState(() => _state = _GateState.unlocked);
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = _GateState.failed;
          _failMsg = l.passphraseGateCommError(e.toString());
        });
      }
    }
  }

  Future<void> _promptAndVerify() async {
    if (!mounted) return;
    // Hoist l10n out of the loop: reading context after an `await` triggers
    // use_build_context_synchronously. The locale is unlikely to change
    // mid-verify; if it does, the next prompt cycle (after gate state
    // change) will re-read it.
    final l = AppLocalizations.of(context);
    while (mounted && _state == _GateState.locked) {
      final plain = await _showPrompt(_attemptsLeft);
      if (plain == null) {
        if (mounted) {
          setState(() {
            _state = _GateState.failed;
            _failMsg = l.passphraseGateCancelled;
          });
        }
        return;
      }
      try {
        final r = await widget.client.send(
          'auth.passphrase.verify',
          args: {'plain': plain},
          timeout: const Duration(seconds: 10),
        );
        if (r.ok) {
          if (mounted) setState(() => _state = _GateState.unlocked);
          return;
        }
        if (r.err == 'ERR_PASSPHRASE_INCORRECT') {
          final left =
              (r.params?['attempts_left'] as num?)?.toInt() ?? 0;
          if (left <= 0) {
            if (mounted) {
              setState(() {
                _state = _GateState.failed;
                _failMsg = l.passphraseLockoutTriggered;
              });
            }
            return;
          }
          if (mounted) setState(() => _attemptsLeft = left);
          // loop and re-prompt
        } else {
          if (mounted) {
            setState(() {
              _state = _GateState.failed;
              _failMsg = l.passphraseGateVerifyError(
                  r.err ?? l.passphraseGateUnknownError);
            });
          }
          return;
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _state = _GateState.failed;
            _failMsg = l.passphraseGateCommError(e.toString());
          });
        }
        return;
      }
    }
  }

  Future<String?> _showPrompt(int attemptsLeft) async {
    if (!mounted) return null;
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    bool obscured = true;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dctx) => StatefulBuilder(
        builder: (dctx, setLocal) => AlertDialog(
          title: Text(l.pairingPassphraseDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.passphraseGateDialogBody,
                style: Theme.of(dctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                obscureText: obscured,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l.passphraseFieldLabel,
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscured ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setLocal(() => obscured = !obscured),
                  ),
                ),
                onSubmitted: (v) => Navigator.of(dctx).pop(v),
              ),
              const SizedBox(height: 8),
              Text(
                l.passphraseAttemptsLeft(attemptsLeft),
                style: Theme.of(dctx).textTheme.bodySmall?.copyWith(
                      color: attemptsLeft <= 3
                          ? Theme.of(dctx).colorScheme.error
                          : null,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dctx).pop(null),
              child: Text(l.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dctx).pop(controller.text),
              child: Text(l.passphraseVerifyButton),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    switch (_state) {
      case _GateState.probing:
      case _GateState.locked:
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: SizedBox(
              width: 36, height: 36,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      case _GateState.failed:
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.lock_outline,
                    size: 40,
                    color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 12),
                Text(_failMsg ?? l.passphraseGateUnknownError,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: _probe,
                  label: Text(l.commonRetry),
                ),
              ],
            ),
          ),
        );
      case _GateState.unlocked:
        return widget.child;
    }
  }
}
