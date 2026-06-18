// Shared helpers for the BLE and WiFi pairing screens. Both flows talk to
// the same firmware-side `pairing.ecdh.exchange` + `pairing.passphrase.verify`
// dispatcher, so the user-facing UX (passphrase prompt, slot-full
// explanation) is identical and lives here once.

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Trim a device name to fit the firmware bond label slot (24 chars,
/// null-terminated). Empty input → empty string (device records "no
/// label").
String shortPairingLabel(String s) {
  final t = s.trim();
  if (t.isEmpty) return '';
  return t.length > 24 ? t.substring(0, 24) : t;
}

/// User-facing message for ERR_BOND_STORE_FULL. The device returns the
/// list of currently paired peers so the user can see what to free up
/// from another paired SKAPP / USB.
String bondStoreFullMessage(BuildContext context, List<dynamic> peers) {
  final l = AppLocalizations.of(context);
  final lines = StringBuffer('${l.bondStoreFullHeader}\n');
  for (final p in peers) {
    if (p is! Map) continue;
    final slot     = p['slot'];
    final lbl      = (p['label'] ?? '').toString();
    final pid      = (p['peer_id'] ?? '').toString();
    final shortPid = pid.length > 8 ? pid.substring(0, 8) : pid;
    final name     = lbl.isNotEmpty ? lbl : l.bondPeerUnnamed;
    lines.writeln(l.bondStoreFullPeerLine(slot ?? '?', name, shortPid));
  }
  lines.write('\n${l.bondStoreFullFooter}');
  return lines.toString();
}

/// Modal passphrase prompt for the pairing-time gate. Returns the entered
/// passphrase, or null if the user cancels. The dialog re-builds with the
/// latest [attemptsLeft] each time the parent re-arms the loop.
Future<String?> promptPairingPassphrase(
  BuildContext context, {
  required int attemptsLeft,
}) {
  final l = AppLocalizations.of(context);
  final controller = TextEditingController();
  bool obscured = true;
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (dctx) {
      return StatefulBuilder(
        builder: (dctx, setLocal) => AlertDialog(
          title: Text(l.pairingPassphraseDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.pairingPassphraseDialogBody,
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
      );
    },
  );
}
