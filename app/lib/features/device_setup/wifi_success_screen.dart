import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_model.dart';
import '../../core/cli/cli_providers.dart';
import '../../core/cli/transport_selector.dart';
import '../../core/logging/app_logger.dart';
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
  bool _advanced = false;

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
    // The post-frame callback can fire after a fast unmount (an error on the
    // previous screen pops us, the 6 s safety timer already advanced, …).
    // Touching `ref` after unmount throws "Using ref when a widget is … been
    // unmounted is unsafe", which — uncaught in this fire-and-forget call —
    // took down the whole SynDimm UI. Bail before we touch any provider.
    if (!mounted) return;

    // ref.read'i unmount ÖNCESİ senkron yap; devamı widget'a bağımlı değil.
    final sessionFuture =
        ref.read(deviceSessionProvider(widget.device.id).future);
    unawaited(_followUpDetached(sessionFuture));
  }

  /// Widget yaşam döngüsünden BAĞIMSIZ: 6 s güvenlik zamanlayıcısı ekranı
  /// ilerletse bile time.set/device.info tamamlanır. Eski kod işi widget'a
  /// bağlıyordu; oturum açılışı (BLE zincirinde 15-40 s) 6 s'lik zamanlayıcıyı
  /// hep kaybediyor, time.set HİÇ çalışmıyor ve cihaz saati sessizce yanlış
  /// kalıyordu (audit C20).
  Future<void> _followUpDetached(Future<DeviceSession> sessionFuture) async {
    // Opening a session here is inherently racy: the device tears down and
    // resumes its BLE link the instant it joins WiFi (event
    // `ble.resume.after-wifi`), so this read can throw "CLI transport closed"
    // / DeviceUnreachable. The WiFi save already succeeded (we only reach this
    // screen on reply.ok); the follow-ups are best-effort, so on ANY failure
    // we simply advance to the home shell, which opens its own fresh session.
    final DeviceSession session;
    try {
      session =
          await sessionFuture.timeout(TransportSelector.chainWorstCase);
    } catch (e) {
      AppLogger.instance
          .warn('wifi-success', 'follow-up session unavailable: $e');
      if (mounted) _advance();
      return;
    }

    // 1. time.set — cihaz saatinin doğruluğu log/event timestamp'lerinin
    // temelidir; başarısızlık kullanıcıyı bloklamaz ama loglanır.
    final unixNow = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    try {
      await session.client.send('time.set', args: {'unix': '$unixNow'});
    } catch (e) {
      AppLogger.instance.warn('wifi-success', 'time.set failed: $e');
    }

    if (mounted) {
      setState(
          () => _status = AppLocalizations.of(context).wifiSuccessFetchingInfo);
    }

    // 2. device.info, gives the home strip its identity row.
    try {
      await session.client.send('device.info');
    } catch (e) {
      AppLogger.instance.warn('wifi-success', 'device.info failed: $e');
    }

    if (mounted) {
      setState(
          () => _status = AppLocalizations.of(context).wifiSuccessPreparingUi);
    }

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
    } catch (e) {
      AppLogger.instance.warn('wifi-success', 'device.manifest failed: $e');
    }

    if (mounted) _advance();
  }

  void _advance() {
    // Tek seferlik: güvenlik zamanlayıcısı, kopuk follow-up ve kullanıcı
    // dokunuşu aynı hedefe koşuyor. Route kaldırıldıktan sonra State ~300 ms
    // daha `mounted` kalır; bu pencerede ikinci push DeviceHomeScreen'i iki
    // kez kurar (ikinci oturum açılışı + çift geçiş animasyonu).
    if (_advanced) return;
    _advanced = true;
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
