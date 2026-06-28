import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../app_info/version_provider.dart';
import '../settings/settings_providers.dart';
import '../storage/preferences_provider.dart';
import 'update_provider.dart';
import 'update_service.dart';

/// Wraps the app home and, on startup, runs a cloud-free auto update check
/// (GitHub Releases) when [autoCheckUpdatesProvider] is on. Throttled to once
/// per [_throttle]. Surfaces a dismissible MaterialBanner via the root
/// ScaffoldMessenger. Offline / rate-limit / any error degrades silently —
/// it must never block the app.
class UpdateScope extends ConsumerStatefulWidget {
  const UpdateScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<UpdateScope> createState() => _UpdateScopeState();
}

class _UpdateScopeState extends ConsumerState<UpdateScope> {
  static const _throttle = Duration(hours: 6);
  static const _prefKey = 'update_last_check_ms';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeCheck());
  }

  Future<void> _maybeCheck() async {
    if (!ref.read(autoCheckUpdatesProvider)) return;
    final prefs = ref.read(sharedPreferencesProvider);
    final last = prefs.getInt(_prefKey) ?? 0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs - last < _throttle.inMilliseconds) return;

    // Let the splash → shell transition settle before surfacing any UI.
    await Future<void>.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    try {
      final info = await ref.read(packageInfoProvider.future);
      final channel = ref.read(updateChannelProvider);
      final result = await ref.read(updateServiceProvider).check(
            currentVersion: info.version,
            channel: channel,
          );
      await prefs.setInt(_prefKey, nowMs);
      if (!mounted || !result.updateAvailable) return;
      _showBanner(info.version, result);
    } catch (_) {
      // Offline / rate-limited / parse error: stay silent.
    }
  }

  void _showBanner(String current, UpdateCheckResult result) {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final latest = result.latestVersion ?? '';
    final url = result.latest?.downloadUrlForCurrentPlatform();
    messenger.clearMaterialBanners();
    messenger.showMaterialBanner(
      MaterialBanner(
        content: Text(l.updateAvailableBody(latest, current)),
        leading: const Icon(Icons.system_update_alt_rounded),
        actions: [
          TextButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            child: Text(l.updateLater),
          ),
          FilledButton(
            onPressed: () {
              messenger.hideCurrentMaterialBanner();
              if (url != null && url.isNotEmpty) {
                launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              }
            },
            child: Text(l.updateDownloadAction),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
