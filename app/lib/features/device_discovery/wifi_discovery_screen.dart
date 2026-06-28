// "Hazır cihazı SKAPP'a ekle" akışı, sadece mDNS browse, BLE'ye hiç
// dokunmaz. Cihaz CLI/USB üzerinden zaten WiFi'a bağlanmış olmalı (yani
// `_skapp._tcp.local` yayını yapıyor olmalı). SKAPP burada sadece ağı
// dinler, eşleştirme TCP üzerinden ECDH ile yapılır.
//
// Eşleşmemiş cihazları da listeleriz; kullanıcı tile'a dokununca
// WifiPairingScreen'e geçiş olur. Eşleşmiş cihazlar (bond stored) ayrı
// işaretlenir, onlar için zaten cihaz ekranı açıkken bağlanılabilir,
// burada tekrar pairing'e gerek yok.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cli/mdns_discovery.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import '../device_pairing/wifi_pairing_screen.dart';

class WifiDiscoveryScreen extends ConsumerStatefulWidget {
  const WifiDiscoveryScreen({super.key});

  @override
  ConsumerState<WifiDiscoveryScreen> createState() =>
      _WifiDiscoveryScreenState();
}

class _WifiDiscoveryScreenState extends ConsumerState<WifiDiscoveryScreen> {
  bool _scanning = false;
  String? _error;
  List<MdnsDeviceEndpoint> _results = const [];
  Timer? _autoScan;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scan();
      // Periyodik tazeleme, kullanıcı bekliyorsa yeni gelen cihazlar
      // birkaç saniye içinde listede belirsin. Manuel refresh butonu
      // da AppBar'da var.
      _autoScan = Timer.periodic(const Duration(seconds: 8), (_) => _scan());
    });
  }

  @override
  void dispose() {
    _autoScan?.cancel();
    super.dispose();
  }

  Future<void> _scan() async {
    if (_scanning) return;
    setState(() {
      _scanning = true;
      _error = null;
    });
    try {
      final results = await MdnsDiscovery.scanAll(
        timeout: const Duration(seconds: 3),
      );
      if (!mounted) return;
      setState(() {
        _results = results;
        _scanning = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _scanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final paired = ref.watch(pairedDevicesProvider);
    final pairedNames = {for (final d in paired) d.name};

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.wifiDiscoveryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
            onPressed: _scanning ? null : _scan,
          ),
        ],
      ),
      body: SafeArea(
        child: SkContent(
          maxWidth: SkBreakpoints.maxWideContentWidth,
          horizontalPadding: 24,
          child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    l.wifiDiscoveryScanError(_error!),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              _ScanIndicator(scanning: _scanning, count: _results.length),
              const SizedBox(height: 12),
              Expanded(
                child: _results.isEmpty
                    ? _EmptyState(scanning: _scanning)
                    : ListView.separated(
                        itemCount: _results.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final ep = _results[i];
                          final isPaired = pairedNames.contains(ep.instance);
                          return _DeviceTile(
                            endpoint: ep,
                            alreadyPaired: isPaired,
                            onTap: isPaired
                                ? null
                                : () => _openPairing(ep),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SkNeuCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.wifiDiscoveryHint,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _openPairing(MdnsDeviceEndpoint ep) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WifiPairingScreen(endpoint: ep),
      ),
    );
  }
}

class _ScanIndicator extends StatelessWidget {
  const _ScanIndicator({required this.scanning, required this.count});
  final bool scanning;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final label = scanning
        ? l.wifiDiscoveryScanning
        : (count == 0
            ? l.wifiDiscoveryNotFound
            : l.wifiDiscoveryFoundCount(count));
    return Row(
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: scanning
              ? const CircularProgressIndicator(strokeWidth: 2)
              : Icon(Icons.wifi_find,
                  size: 14, color: cs.onSurfaceVariant),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                )),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.scanning});
  final bool scanning;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off,
                size: 56, color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 12),
            Text(
              scanning
                  ? l.wifiDiscoveryEmptyTitle
                  : l.wifiDiscoveryEmptyTitleIdle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            Text(
              l.wifiDiscoveryEmptyHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.endpoint,
    required this.alreadyPaired,
    required this.onTap,
  });

  final MdnsDeviceEndpoint endpoint;
  final bool alreadyPaired;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Identity'nin ilk iki harfi cihaz prefix'i (BF / LS / ...).
    final prefix = endpoint.instance.length >= 2
        ? endpoint.instance.substring(0, 2)
        : '??';

    return SkNeuCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                prefix,
                style: TextStyle(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  endpoint.instance,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${endpoint.host}:${endpoint.port}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                ),
              ],
            ),
          ),
          if (alreadyPaired)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // tasarim.md: "eşleşti" pozitif durumu renkle değil
                // opaklık+nötr ton ile gösterilir.
                color: cs.onSurface.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                AppLocalizations.of(context).wifiDiscoveryPairedBadge,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            )
          else
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}
