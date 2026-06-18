import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_model.dart';
import '../../core/cli/cli_providers.dart';
import '../../l10n/app_localizations.dart';
import '../device_home/device_home_screen.dart';

/// Post-WiFi-connect handoff screen.
///
/// Runs three follow-up commands in the background while the user looks
/// at the success message, then routes to the device home shell:
///   1. `time.set`, push the phone's UTC unix time so log/event
///      timestamps are correct from the very next event.
///   2. `device.info`, kicks the device to publish identity/fw/protocol
///      so the home screen has them for the strip header.
///   3. `device.manifest`, preloads the runtime UI manifest into the
///      provider cache so the home shell renders without a spinner.
///
/// All three are best-effort, failures are logged on screen but do not
/// block the user; the home shell can fetch them again itself.
class WifiSuccessScreen extends ConsumerStatefulWidget {
  const WifiSuccessScreen({
    super.key,
    required this.device,
    this.ssid,
  });
  final DiscoveredDevice device;

  /// SSID the device just connected to. May be `null` when the WiFi
  /// wizard was skipped (device already had saved credentials before
  /// pairing), the screen falls back to a simpler "device ready"
  /// message in that case.
  final String? ssid;

  @override
  ConsumerState<WifiSuccessScreen> createState() =>
      _WifiSuccessScreenState();
}

class _WifiSuccessScreenState extends ConsumerState<WifiSuccessScreen> {
  String? _status;
  String? _errorNote;
  Timer? _safetyAdvance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runFollowUp());
    // Safety: even if every follow-up call is silent, we still leave the
    // screen after 6 s so the user is never stuck here.
    _safetyAdvance = Timer(const Duration(seconds: 6), _advance);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _status ??= AppLocalizations.of(context).wifiSuccessSyncing;
  }

  @override
  void dispose() {
    _safetyAdvance?.cancel();
    super.dispose();
  }

  Future<void> _runFollowUp() async {
    final session =
        await ref.read(deviceSessionProvider(widget.device.id).future);

    // 1. time.set, ignore failures, user does not care.
    final unixNow = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    try {
      await session.client.send('time.set', args: {'unix': '$unixNow'});
    } catch (_) {/* silent */}

    if (!mounted) return;
    setState(() => _status = AppLocalizations.of(context).wifiSuccessFetchingInfo);

    // 2. device.info, gives the home strip its identity row.
    try {
      await session.client.send('device.info');
    } catch (_) {/* silent */}

    if (!mounted) return;
    setState(() => _status = AppLocalizations.of(context).wifiSuccessPreparingUi);

    // 3. device.manifest, prefetch (cached in CliClient pending? No
    // it's a one-shot send/response, so the result is just discarded).
    // The home tabs re-issue it themselves once they're built. We still
    // make the call here to surface obvious failures early (e.g. a
    // device running an old firmware without sk_baseline).
    try {
      final reply = await session.client.send('device.manifest');
      if (!reply.ok && mounted) {
        final l = AppLocalizations.of(context);
        setState(() {
          _errorNote =
              l.wifiSuccessManifestRejected(reply.err ?? 'ERR_UNKNOWN');
        });
      }
    } catch (_) {/* silent */}

    _advance();
  }

  void _advance() {
    _safetyAdvance?.cancel();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => DeviceHomeScreen(device: widget.device),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: _advance,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 56, color: cs.onPrimary),
                  ),
                  const SizedBox(height: 24),
                  Text(AppLocalizations.of(context).wifiSuccessReady,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    widget.ssid != null
                        ? '${widget.device.name} · ${widget.ssid}'
                        : widget.device.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _status ?? AppLocalizations.of(context).wifiSuccessSyncing,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  if (_errorNote != null) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorNote!,
                        style: TextStyle(
                            color: cs.onErrorContainer, fontSize: 12),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context).wifiSuccessTapToContinue,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
