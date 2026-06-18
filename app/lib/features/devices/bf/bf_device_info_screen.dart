// BF Cihaz bilgisi, bf.html bf-device-info ekranının Flutter karşılığı.
//
// Reads everything from `device.info` (sk_baseline.c). Real response shape:
//   {
//     "model": "<prefix>",        // "BF"
//     "prefix": "<prefix>",
//     "serial": "<full identity>", // "BF-A06TMFSQT"
//     "fw_version": "<semver>",
//     "hw_version": "<char>",
//     "protocol_version": "<str>",
//     "build_info": "<commit>" | null,
//     "uptime_sec": <num>,
//     "wifi":   { "connected": bool, "ssid": str, "rssi": num, "ip": str },
//     "ble":    { "advertising": bool, "paired_clients": num },
//     "battery": { "present": bool },
//     "last_error": null,
//     "time":   { "valid": bool, "unix": num, "source": str }
//   }
//
// MAC isn't currently exposed in device.info. We surface what the
// firmware actually sends and "-" the rest, never a fake value.

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'bf_events_screen.dart';
import 'bf_logs_screen.dart';
import 'bf_session.dart';
import 'widgets/bootstrap_banner.dart';

class BfDeviceInfoScreen extends StatefulWidget {
  const BfDeviceInfoScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<BfDeviceInfoScreen> createState() => _BfDeviceInfoScreenState();
}

class _BfDeviceInfoScreenState extends State<BfDeviceInfoScreen> {
  Map<String, dynamic>? _info;
  bool _loaded = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    try {
      final r = await client.send('device.info');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        setState(() {
          _info = Map<String, dynamic>.from(r.data as Map);
          _error = null;
        });
      } else {
        setState(() => _error = r.err ?? l.commonReadFailed);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  /// Top-level field accessor with explicit fallback. We always pass "-"
  /// for unknown values; never substitute a marketing string.
  String _v(String k, [String fallback = '-']) {
    final v = _info?[k];
    if (v == null) return fallback;
    final s = v.toString();
    return s.isEmpty ? fallback : s;
  }

  /// Pulls a leaf out of a nested JSON object, e.g. wifi → ip. Used for
  /// the runtime snapshot fields the firmware groups under wifi/ble/battery.
  String _nested(String parent, String leaf, [String fallback = '-']) {
    final p = _info?[parent];
    if (p is! Map) return fallback;
    final v = p[leaf];
    if (v == null) return fallback;
    final s = v.toString();
    return s.isEmpty ? fallback : s;
  }

  bool? _nestedBool(String parent, String leaf) {
    final p = _info?[parent];
    if (p is! Map) return null;
    final v = p[leaf];
    return v is bool ? v : null;
  }

  num? _nestedNum(String parent, String leaf) {
    final p = _info?[parent];
    if (p is! Map) return null;
    final v = p[leaf];
    return v is num ? v : null;
  }

  String get deviceId => widget.deviceId;

  /// Maps the BF firmware's `prefix` ("BF") to a human-readable product
  /// name. New device families plug into the same switch.
  String _productName(AppLocalizations l) {
    final prefix = _info?['prefix']?.toString() ??
        (_info?['model']?.toString() ?? '');
    return switch (prefix) {
      'BF' => l.productBlockingFocus,
      'LS' => l.productLebensSpur,
      _ => '-',
    };
  }

  /// uptime_sec → "2 h 14 min" / "45 min" / "23 s".
  String _formatUptime(AppLocalizations l) {
    final v = _info?['uptime_sec'];
    if (v is! num) return '-';
    final s = v.toInt();
    if (s < 60) return l.bfDeviceInfoUptimeSecs(s);
    final m = s ~/ 60;
    if (m < 60) return l.bfDeviceInfoUptimeMins(m);
    final h = m ~/ 60;
    final remM = m % 60;
    if (h < 24) return l.bfDeviceInfoUptimeHours(h, remM);
    final d = h ~/ 24;
    final remH = h % 24;
    return l.bfDeviceInfoUptimeDays(d, remH);
  }

  String _yesNo(AppLocalizations l, bool? v) =>
      v == null ? '-' : (v ? l.bfDeviceInfoYes : l.bfDeviceInfoNo);

  /// time.unix → ISO benzeri okunabilir tarih. Geçerli değilse "-".
  String _formatTime() {
    final valid = _nestedBool('time', 'valid');
    if (valid != true) return '-';
    final unix = _nestedNum('time', 'unix');
    if (unix == null) return '-';
    final dt = DateTime.fromMillisecondsSinceEpoch(unix.toInt() * 1000,
        isUtc: false);
    final src = _nested('time', 'source');
    final iso = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
    return src == '-' ? iso : '$iso  ($src)';
  }

  /// wifi.rssi → dBm. -50 great, -90 marginal.
  String _formatRssi() {
    final r = _nestedNum('wifi', 'rssi');
    if (r == null) return '-';
    return '${r.toInt()} dBm';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final batteryPresent = _nestedBool('battery', 'present');
    final batteryLabel = batteryPresent == null
        ? '-'
        : (batteryPresent
            ? l.bfDeviceInfoBatteryPresent
            : l.bfDeviceInfoBatteryAbsent);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.bfDeviceInfoTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
            onPressed: _bootstrap,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: [
          if (_error != null)
            BootstrapBanner(error: _error!, onRetry: _bootstrap),
          _Section(title: l.bfDeviceInfoSectionGeneral, children: [
            _InfoRow(
              icon: Icons.devices_other,
              title: l.bfDeviceInfoProduct,
              subtitle: _productName(l),
            ),
            _InfoRow(
              icon: Icons.badge,
              title: l.bfDeviceInfoTypeCode,
              subtitle: _v('prefix', _v('model')),
              mono: true,
            ),
            _InfoRow(
              icon: Icons.fingerprint,
              title: l.bfDeviceInfoIdentity,
              subtitle: _v('serial', deviceId),
              mono: true,
            ),
            _InfoRow(
              icon: Icons.memory,
              title: l.bfDeviceInfoHardware,
              subtitle: _v('hw_version'),
              mono: true,
            ),
            _InfoRow(
              icon: Icons.system_update,
              title: l.bfDeviceInfoFirmware,
              subtitle: _v('fw_version'),
            ),
            _InfoRow(
              icon: Icons.code,
              title: l.bfDeviceInfoProtocol,
              subtitle: _v('protocol_version'),
              mono: true,
            ),
            _InfoRow(
              icon: Icons.tag,
              title: l.bfDeviceInfoBuild,
              subtitle: _v('build_info'),
              mono: true,
            ),
            _InfoRow(
              icon: Icons.timer_outlined,
              title: l.bfDeviceInfoUptime,
              subtitle: _formatUptime(l),
            ),
          ]),
          const SizedBox(height: 24),
          _Section(title: l.bfDeviceInfoSectionConnection, children: [
            _InfoRow(
              icon: Icons.wifi,
              title: l.bfDeviceInfoWifiState,
              subtitle: _yesNo(l, _nestedBool('wifi', 'connected')) +
                  (_nested('wifi', 'ssid') == '-'
                      ? ''
                      : ' · ${_nested('wifi', 'ssid')}'),
            ),
            _InfoRow(
              icon: Icons.lan,
              title: l.bfDeviceInfoIp,
              subtitle: _nested('wifi', 'ip'),
              mono: true,
            ),
            _InfoRow(
              icon: Icons.signal_cellular_alt,
              title: l.bfDeviceInfoSignal,
              subtitle: _formatRssi(),
              mono: true,
            ),
            _InfoRow(
              icon: Icons.bluetooth,
              title: l.bfDeviceInfoBleAdvertising,
              subtitle: _yesNo(l, _nestedBool('ble', 'advertising')),
            ),
            _InfoRow(
              icon: Icons.devices,
              title: l.bfDeviceInfoBlePaired,
              subtitle: () {
                final n = _nestedNum('ble', 'paired_clients');
                return n == null
                    ? '-'
                    : l.bfDeviceInfoPairedClients(n.toInt());
              }(),
            ),
          ]),
          const SizedBox(height: 24),
          _Section(title: l.bfDeviceInfoSectionBattery, children: [
            _InfoRow(
              icon: Icons.battery_full,
              title: l.bfDeviceInfoBattery,
              subtitle: batteryLabel,
            ),
          ]),
          const SizedBox(height: 24),
          _Section(title: l.bfDeviceInfoSectionTime, children: [
            _InfoRow(
              icon: Icons.schedule,
              title: l.bfDeviceInfoDeviceClock,
              subtitle: _formatTime(),
              mono: true,
            ),
          ]),
          const SizedBox(height: 24),
          if (_v('last_error') != '-')
            _Section(title: l.bfDeviceInfoSectionLastError, children: [
              _InfoRow(
                icon: Icons.error_outline,
                title: 'last_error',
                subtitle: _v('last_error'),
                mono: true,
              ),
            ]),
          if (_v('last_error') != '-') const SizedBox(height: 24),
          _Section(title: l.bfDeviceInfoSectionDiagnostics, children: [
            _ActionRow(
              icon: Icons.description,
              title: l.bfDeviceInfoLogs,
              subtitle: l.bfDeviceInfoLogsSubtitle,
              onTap: () => BfSession.push(
                  context, BfLogsScreen(deviceId: deviceId)),
            ),
            _ActionRow(
              icon: Icons.history,
              title: l.bfDeviceInfoEvents,
              subtitle: l.bfDeviceInfoEventsSubtitle,
              onTap: () => BfSession.push(
                  context, BfEventsScreen(deviceId: deviceId)),
            ),
          ]),
          const SizedBox(height: 24),
          _Section(title: l.bfDeviceInfoSectionDocs, children: [
            _ActionRow(
              icon: Icons.menu_book,
              title: l.bfDeviceInfoUserGuide,
              subtitle: l.bfDeviceInfoUserGuideSubtitle,
              onTap: () => _todo(context),
            ),
            _ActionRow(
              icon: Icons.terminal,
              title: l.bfDeviceInfoDevNotes,
              subtitle: l.bfDeviceInfoDevNotesSubtitle,
              onTap: () => _todo(context),
            ),
            _ActionRow(
              icon: Icons.policy,
              title: l.bfDeviceInfoLicense,
              subtitle: l.bfDeviceInfoLicenseSubtitle,
              onTap: () => _todo(context),
            ),
          ]),
        ],
        ),
      ),
    );
  }

  void _todo(BuildContext ctx) {
    final l = AppLocalizations.of(ctx);
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(l.bfDeviceInfoComingSoon)),
    );
  }
}

// ---------------------------------------------------------------------------
// Section + row primitives
// ---------------------------------------------------------------------------

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: cs.onSurfaceVariant,
                ),
          ),
        ),
        SkNeuCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                      height: 1, thickness: 0.5, color: cs.outlineVariant),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.mono = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.onSurfaceVariant),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: mono ? 'monospace' : null,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.onSurfaceVariant),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
