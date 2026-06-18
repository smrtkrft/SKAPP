import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Top-of-screen banner shown when a sub-screen's bootstrap CLI calls
/// (`wifi.list`, `device.info`, `api.endpoint.list`, ...) fail. Surfaces
/// the actual error string so the user can see WHY data is missing
/// instead of a silent "-".
///
/// Shared between OnDeviceApiEditorScreen + BF settings + device-info so
/// the look and retry-button wiring stays uniform across sub-screens.
class BootstrapBanner extends StatelessWidget {
  const BootstrapBanner({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 20, color: cs.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l.bootstrapBannerError(error),
              style: TextStyle(color: cs.onErrorContainer),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: cs.onErrorContainer,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: Text(l.bootstrapBannerRetry),
          ),
        ],
      ),
    );
  }
}
