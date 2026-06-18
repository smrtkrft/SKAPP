import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';

/// Shared text-prompt dialog for [NetworkIdentity] field edits.
///
/// Two callers: the desktop-only [NetworkIdentityCard] (name + port edit),
/// and the mobile-and-desktop GF-3 nav card on the main Settings screen.
/// Keeps a single source of truth for input style + validation hint.
Future<String?> promptNetworkIdentityText({
  required BuildContext context,
  required String title,
  required String help,
  required String initial,
  int? maxLength,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: maxLength,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onSubmitted: (_) => Navigator.of(ctx).pop(controller.text),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              help,
              style: Theme.of(ctx).textTheme.labelSmall,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(AppLocalizations.of(ctx).commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(controller.text),
          child: Text(AppLocalizations.of(ctx).commonConfirm),
        ),
      ],
    ),
  );
}

/// Convenience wrapper for the mDNS instance-name editor (32 char max,
/// dialog labels pulled from the localization bundle).
Future<String?> promptNetworkIdentityName(
  BuildContext context,
  AppLocalizations l,
  String currentName,
) {
  return promptNetworkIdentityText(
    context: context,
    title: l.settingsNetworkIdentityNameDialogTitle,
    help: l.settingsNetworkIdentityNameDialogHelp,
    initial: currentName,
    maxLength: 32,
  );
}
