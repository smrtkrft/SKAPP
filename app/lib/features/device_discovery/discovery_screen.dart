import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/ble/ble_service.dart';
import '../../core/ble/device_model.dart';
import '../../core/ble/device_type_visual.dart';
import '../../core/cli/mdns_discovery.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import '../device_pairing/pairing_screen.dart';
import '../device_pairing/wifi_pairing_screen.dart';

enum _Stage {
  checking,
  permissionsDenied,
  adapterOff,
  unsupported,
  scanning,
}

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  _Stage _stage = _Stage.checking;
  // Default: show everything. The SmartKraft name filter is helpful in
  // production but actively hides debugging information when a real
  // device is missing, turning it off lets the user see whether BLE
  // is reaching us at all.
  bool _onlySmartKraft = false;

  // mDNS results accumulate here in parallel with the BLE scan stream.
  // A SmartKraft device that's bonded to its WiFi appears via mDNS even
  // when it's out of BLE range, and a fresh device on the LAN that
  // SKAPP hasn't paired with yet shows up here too, both surfaces feed
  // the merged list shown in the UI.
  List<MdnsDeviceEndpoint> _mdnsResults = const [];
  Timer? _mdnsTimer;
  bool _mdnsBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _mdnsTimer?.cancel();
    ref.read(bleServiceProvider).stopScan();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final svc = ref.read(bleServiceProvider);

    // 1) Permissions FIRST. On Android, calling FlutterBluePlus before the
    //    runtime permissions are granted can return adapterState=unknown
    //    forever, which would push us down the adapterOff branch even
    //    when Bluetooth is on. Asking permissions first avoids that.
    final granted = await _requestPermissions();
    if (!granted) {
      _set(_Stage.permissionsDenied);
      return;
    }

    // 2) Now we can safely probe the adapter.
    final readiness = await svc.checkReadiness();
    switch (readiness) {
      case BleReadiness.unsupported:
        _set(_Stage.unsupported);
        return;
      case BleReadiness.adapterOff:
        _set(_Stage.adapterOff);
        return;
      case BleReadiness.permissionsDenied:
        _set(_Stage.permissionsDenied);
        return;
      case BleReadiness.ready:
        break;
    }

    // 3) Scan. Failures here are usually transient (radio busy, just
    //    toggled off), surface them as adapterOff so the user sees a
    //    "Try again / open settings" affordance rather than a silent UI.
    _set(_Stage.scanning);
    try {
      await svc.startScan();
    } catch (_) {
      _set(_Stage.adapterOff);
    }

    // 4) mDNS sweep alongside BLE. Independent of BLE permissions/state
    //   , a paired device that's only reachable over WiFi still surfaces
    //    here (e.g. BLE out of range, or device deliberately not
    //    advertising right now).
    _startMdnsSweeps();
  }

  void _startMdnsSweeps() {
    // Run one sweep right away, then a periodic refresh every 8 s. The
    // first sweep populates the list quickly; the timer keeps it fresh
    // as devices appear or drop off the LAN.
    _runMdnsSweep();
    _mdnsTimer ??= Timer.periodic(
      const Duration(seconds: 8),
      (_) => _runMdnsSweep(),
    );
  }

  Future<void> _runMdnsSweep() async {
    if (_mdnsBusy) return;
    _mdnsBusy = true;
    try {
      final results = await MdnsDiscovery.scanAll(
        timeout: const Duration(seconds: 3),
      );
      if (!mounted) return;
      setState(() => _mdnsResults = results);
    } catch (_) {
      // Silent, multicast permission, network change, etc.
      // Next tick will retry.
    } finally {
      _mdnsBusy = false;
    }
  }

  /// True iff we have *enough* permission to scan on this OS.
  ///
  /// Platform matrix:
  ///   * iOS:           auto-prompt on first BLE op (Info.plist usage)
  ///   * Windows/macOS/Linux: OS-level BLE access, no app-level grant
  ///   * Android 12+ (API 31+): BLUETOOTH_SCAN + BLUETOOTH_CONNECT runtime
  ///   * Android 6-11: ACCESS_FINE_LOCATION runtime
  ///
  /// `permission_handler` returns `denied` for permissions that don't apply
  /// on the current OS, so calling it on Windows/macOS/Linux would falsely
  /// reject all three permissions and lock the screen at "permissionsDenied"
  /// even though the desktop OS handles BLE access at its own setting layer
  /// (Privacy → Bluetooth on Win/Mac). We short-circuit those platforms
  /// to "ready" and let FlutterBluePlus do the actual probing.
  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) return true;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Desktop: BLE is OS-managed. If the user disabled Bluetooth or
      // denied app-level access in system Settings, FlutterBluePlus's
      // adapterState will surface as off / unsupported and the discovery
      // flow falls through to the appropriate hint screen.
      return true;
    }
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    final modernOk = scan.isGranted && connect.isGranted;
    final legacyOk = location.isGranted;
    return modernOk || legacyOk;
  }

  void _set(_Stage s) {
    if (!mounted) return;
    setState(() => _stage = s);
  }

  Future<void> _enableBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
      _set(_Stage.checking);
      await _bootstrap();
    } catch (_) {
      // iOS rejects programmatic toggle; user must do it from Settings.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Text(l.discoveryTitle),
        actions: [
          if (_stage == _Stage.scanning) ...[
            IconButton(
              icon: Icon(_onlySmartKraft
                  ? Icons.filter_alt
                  : Icons.filter_alt_off),
              tooltip: _onlySmartKraft
                  ? l.discoveryFilterShowAll
                  : l.discoveryFilterOnlySmartKraft,
              onPressed: () =>
                  setState(() => _onlySmartKraft = !_onlySmartKraft),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l.discoveryRescan,
              onPressed: () => ref.read(bleServiceProvider).startScan(),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: SkContent(
          maxWidth: SkBreakpoints.maxWideContentWidth,
          horizontalPadding: 24,
          child: _buildBody(l),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l) {
    switch (_stage) {
      case _Stage.checking:
        return _statusView(
          icon: Icons.search,
          title: l.discoveryPreparing,
          body: l.discoveryStatusChecking,
          spinner: true,
        );
      case _Stage.permissionsDenied:
        return _statusView(
          icon: Icons.shield_outlined,
          title: l.discoveryPermissionsTitle,
          body: l.discoveryPermissionsBody,
          actionLabel: l.discoveryPermissionsRetry,
          onAction: () async {
            _set(_Stage.checking);
            await _bootstrap();
          },
          secondaryLabel: l.discoveryPermissionsOpenSettings,
          onSecondary: openAppSettings,
        );
      case _Stage.adapterOff:
        return _statusView(
          icon: Icons.bluetooth_disabled,
          title: l.discoveryBluetoothOff,
          body: l.discoveryAdapterOffBody,
          actionLabel: l.discoveryAdapterOffEnable,
          onAction: _enableBluetooth,
        );
      case _Stage.unsupported:
        return _statusView(
          icon: Icons.error_outline,
          title: l.discoveryUnsupportedTitle,
          body: l.discoveryUnsupportedBody,
        );
      case _Stage.scanning:
        return _scanningView(l);
    }
  }

  Widget _scanningView(AppLocalizations l) {
    final results = ref.watch(scanResultsProvider);
    return results.when(
      loading: () => _searchingPlaceholder(l),
      error: (e, st) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('$e', textAlign: TextAlign.center),
        ),
      ),
      data: (bleDevices) {
        final entries = _mergeEntries(bleDevices, _mdnsResults);
        final visible = _onlySmartKraft
            ? entries.where((e) => e.isSmartKraft).toList()
            : entries;
        final smartKraftCount = entries.where((e) => e.isSmartKraft).length;
        if (visible.isEmpty) {
          return _searchingPlaceholder(l);
        }
        return Column(
          children: [
            _scanBanner(smartKraftCount, visible.length),
            Expanded(
              child: ListView.separated(
                itemCount: visible.length,
                separatorBuilder: (_, i) => const Divider(height: 1),
                itemBuilder: (ctx, i) => _DiscoveryTile(entry: visible[i]),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Merge BLE scan results and mDNS sweep results into one list keyed by
  /// device name (e.g. `BF-A06TMFSQT`). A device may show up via either
  /// transport, both, or neither, the merged entry carries whichever
  /// surfaces are live so the row can advertise its capabilities.
  ///
  /// Non-SmartKraft BLE entries (random nearby Bluetooth devices) keep
  /// their BLE id as the merge key since they have no identity prefix.
  /// mDNS entries always have a SmartKraft-shaped instance name so they
  /// land under the canonical name.
  List<_DiscoveryEntry> _mergeEntries(
    List<DiscoveredDevice> ble,
    List<MdnsDeviceEndpoint> mdns,
  ) {
    final byKey = <String, _DiscoveryEntry>{};
    for (final d in ble) {
      final key = d.isSmartKraft ? d.name : d.id;
      byKey[key] = _DiscoveryEntry(ble: d);
    }
    for (final m in mdns) {
      final existing = byKey[m.instance];
      byKey[m.instance] = _DiscoveryEntry(
        ble: existing?.ble,
        mdns: m,
      );
    }
    return byKey.values.toList();
  }

  /// Sticky status strip below the app bar. Reflects both transports
  /// honestly: BLE scanning still controls the spinner, mDNS is described
  /// as an additional channel ("+ ağda N cihaz") so the user knows where
  /// each row came from when both are live.
  Widget _scanBanner(int smartKraftCount, int visibleCount) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final scanning = FlutterBluePlus.isScanningNow;
    final mdnsCount = _mdnsResults.length;
    final mdnsTail = mdnsCount > 0 ? l.discoveryMdnsTail(mdnsCount) : '';
    final label = _onlySmartKraft
        ? (scanning
            ? l.discoveryScanningWithCount(smartKraftCount, mdnsTail)
            : l.discoveryFoundCountWithTail(smartKraftCount, mdnsTail))
        : l.discoveryFilterOff(visibleCount, smartKraftCount, mdnsTail);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          if (scanning) ...[
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchingPlaceholder(AppLocalizations l) {
    final cs = Theme.of(context).colorScheme;
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: cs.primary,
                backgroundColor: cs.primary.withValues(alpha: 0.18),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l.discoverySearching,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
  }

  Widget _statusView({
    required IconData icon,
    required String title,
    required String body,
    bool spinner = false,
    String? actionLabel,
    VoidCallback? onAction,
    String? secondaryLabel,
    VoidCallback? onSecondary,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (spinner) ...[
              const SizedBox(height: 24),
              SizedBox.square(
                dimension: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.18),
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel),
              ),
            ],
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onSecondary,
                child: Text(secondaryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// One row in the merged discovery list, wraps the BLE shape
/// ([DiscoveredDevice]) and/or the mDNS shape ([MdnsDeviceEndpoint])
/// for the same physical device. A row may carry either or both.
class _DiscoveryEntry {
  const _DiscoveryEntry({this.ble, this.mdns});

  final DiscoveredDevice? ble;
  final MdnsDeviceEndpoint? mdns;

  /// User-visible name. Both transports carry it; we prefer the BLE
  /// scan name because it survived recent advertising and the mDNS
  /// instance name as a fallback.
  String get name => ble?.name ?? mdns!.instance;

  /// Two-letter SmartKraft type prefix (BF, LS, ...). Computed from
  /// whichever side is present.
  String? get typePrefix {
    if (ble != null) return ble!.typePrefix;
    final m = RegExp(r'^([A-Z]{2})-([A-Z0-9]{6,12})$').firstMatch(name);
    return m?.group(1);
  }

  bool get isSmartKraft => typePrefix != null;
  bool get hasBle => ble != null;
  bool get hasWifi => mdns != null;
}

class _DiscoveryTile extends StatelessWidget {
  const _DiscoveryTile({required this.entry});
  final _DiscoveryEntry entry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final isSk = entry.isSmartKraft;
    final ble = entry.ble;
    final mdns = entry.mdns;

    // Subtitle composition: prefix (or BLE id for randoms) + transport
    // surfaces. RSSI when BLE is present, IP when mDNS is.
    final parts = <String>[];
    if (isSk) {
      // "BF · Blocking Focus" so users see brand name during discovery
      // without having to recall the two-letter prefix. Brand name
      // intentionally untranslated per memory feedback_i18n_script_ids.
      parts.add('${entry.typePrefix!} · '
          '${DeviceTypeVisual.friendlyName(entry.typePrefix)}');
    } else if (ble != null) {
      parts.add(ble.id);
    }
    if (ble != null) parts.add('${ble.rssi} dBm');
    if (mdns != null) parts.add('${mdns.host}:${mdns.port}');

    final badge = _pairableBadge(context, l, ble);

    return ListTile(
      leading: _TransportIcon(
        hasBle: entry.hasBle,
        hasWifi: entry.hasWifi,
        active: isSk,
      ),
      title: badge == null
          ? Text(entry.name)
          : Row(
              children: [
                Flexible(
                  child: Text(
                    entry.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                badge,
              ],
            ),
      subtitle: Text(parts.join('  •  ')),
      trailing: _trailing(cs, ble),
      onTap: isSk ? () => _onTap(context) : null,
    );
  }

  /// Returns a compact chip reflecting the device's advertised pairing
  /// posture, or null when the scan result didn't carry a SmartKraft
  /// manufacturer-data tag (non-SmartKraft entry, mDNS-only row, older
  /// firmware). Pairable = mustard chip ("come pair me"), bonded = muted
  /// outlined chip ("already linked to someone else"), unknown = nothing.
  Widget? _pairableBadge(
    BuildContext context,
    AppLocalizations l,
    DiscoveredDevice? ble,
  ) {
    if (ble == null) return null;
    switch (ble.pairable) {
      case SkPairableState.pairable:
        return _Chip(
          label: l.discoveryBadgePairable,
          background: SkColors.attentionMustard.withValues(alpha: 0.18),
          foreground: SkColors.attentionMustard,
          border: SkColors.attentionMustard,
        );
      case SkPairableState.bonded:
        final cs = Theme.of(context).colorScheme;
        return _Chip(
          label: l.discoveryBadgeBonded,
          background: cs.surfaceContainerHighest,
          foreground: cs.onSurfaceVariant,
          border: cs.outlineVariant,
        );
      case SkPairableState.unknown:
        return null;
    }
  }

  Widget _trailing(ColorScheme cs, DiscoveredDevice? ble) {
    if (!entry.isSmartKraft) {
      return Icon(Icons.block, color: cs.onSurfaceVariant, size: 18);
    }
    return const Icon(Icons.chevron_right);
  }

  void _onTap(BuildContext context) {
    final ble = entry.ble;
    if (ble != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PairingScreen(device: ble)),
      );
      return;
    }
    final mdns = entry.mdns;
    if (mdns != null) {
      // BF was already brought onto Wi-Fi (via its own CLI / earlier
      // BLE pair) and is announcing on `_skapp._tcp.local`. Pair over
      // TCP directly: WifiPairingScreen connects to the mDNS endpoint,
      // runs the ECDH exchange, and stores the bond — no BLE needed.
      // Pairing window must be open on BF (button short-press) for the
      // first-time pair; the screen surfaces a clear hint if the
      // device refuses with ERR_PAIRING_NOT_OPEN.
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => WifiPairingScreen(endpoint: mdns)),
      );
      return;
    }
  }
}

/// Compact transport indicator: a Bluetooth glyph, a WiFi glyph, or both
/// stacked. Mirrors the truth of the merged entry so the user can see
/// which channel is feeding the row.
class _TransportIcon extends StatelessWidget {
  const _TransportIcon({
    required this.hasBle,
    required this.hasWifi,
    required this.active,
  });

  final bool hasBle;
  final bool hasWifi;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = active ? cs.primary : cs.onSurfaceVariant;
    if (hasBle && hasWifi) {
      return SizedBox(
        width: 28,
        height: 28,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Icon(Icons.bluetooth, size: 16, color: color),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(Icons.wifi, size: 14, color: color),
            ),
          ],
        ),
      );
    }
    return Icon(
      hasWifi ? Icons.wifi : Icons.bluetooth,
      color: color,
    );
  }
}

/// Compact pill-shaped chip used by [_DiscoveryTile] to surface a
/// device's advertised pairing posture next to its name. Three tone
/// channels (background / foreground / border) so the same shape can
/// signal "pairable" (mustard fill) and "bonded" (muted outline)
/// without spinning up the heavier Material Chip widget.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
    required this.border,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
