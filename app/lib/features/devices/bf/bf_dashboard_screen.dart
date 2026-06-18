// BF Dashboard, bf.html mockup'unun Flutter karşılığı.
//
// Cihazla CLI üzerinden konuşur: Status pill'leri (WiFi/BLE/pil), 3
// toggle (titreşim / düz koyma uyarısı / düşük pil uyarısı), API
// zinciri özeti ve "Cihaz bilgisi / Ayarlar" giriş kartları.
//
// Buzzer 2026-05-08 itibarıyla donanımdan ve firmware'den kaldırıldı;
// burada da toggle / komut yok. Geçmiş `buzzer.on/off/status` çağrıları
// silindi çünkü cihaz artık bu komutları tanımıyor.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/cli/cli_transport.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import '../../skapi/on_device_api_editor_screen.dart';
import 'bf_device_info_screen.dart';
import 'bf_notebook_screen.dart';
import 'bf_session.dart';
import 'bf_settings_screen.dart';

// Toggle command contract, three switches kalır (vibration + warn'lar):
//   vibration.on/off/status         vibration master switch (drives PIN_VIBRATION)
//   tilt.warn.on/off/status         gate the `face.changed → Z+` alert
//   low_batt.warn.on/off/status     gate the `battery.low` alert
//
// All NVS-persisted; survives reboot. Warning gates are read by their
// own event subscribers; off → publisher hâlâ fire eder ama alert
// pattern bastırılır.

class BfDashboardScreen extends StatefulWidget {
  const BfDashboardScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<BfDashboardScreen> createState() => _BfDashboardScreenState();
}

class _BfDashboardScreenState extends State<BfDashboardScreen> {
  // Cihazda kayıtlı değerler yüklenene kadar varsayılan: açık. İlk
  // didChangeDependencies çağrısında secureGet ile gerçek değerler
  // alınır; build sırasında secureSet ile cihazda güncellenir.
  bool _vibration = true;
  bool _tiltWarning = true;
  bool _lowBatteryWarning = true;
  bool _loaded = false;

  // Status pill'leri için canlı veriler. WiFi durumu polling ile (3 sn),
  // pil seviyesi battery.threshold event'i + ilk açılışta cliSend ile.
  String? _wifiSsid;        // null = bağlı değil
  int? _batteryPercent;     // null = bilinmiyor
  Timer? _statusTimer;
  StreamSubscription<Map<String, dynamic>>? _eventSub;

  // Live data driving the rest of the dashboard. All start null/0 and
  // populate as the bootstrap and polling cycles return, never seeded
  // with placeholder values.
  String? _deviceModel;     // device.info → model (AppBar title)
  int _endpointCount = 0;   // api.status / api.endpoint.list → master_enabled?
  bool _apiMasterEnabled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final session = BfSession.of(context);

    // Read three toggles via their dedicated status commands. Each
    // returns `{enabled: bool}`; default to true on transport failure
    // so the UI shows something coherent while we retry.
    Future<bool> readDedicated(String cmd, bool fallback) async {
      try {
        final r = await session.client.send(cmd);
        if (r.ok && r.data is Map) {
          final m = r.data as Map;
          if (m['enabled'] is bool) return m['enabled'] as bool;
        }
        return fallback;
      } catch (_) {
        return fallback;
      }
    }

    final results = await Future.wait([
      readDedicated('vibration.status', true),
      readDedicated('tilt.warn.status', true),
      readDedicated('low_batt.warn.status', true),
    ]);
    if (!mounted) return;
    setState(() {
      _vibration         = results[0];
      _tiltWarning       = results[1];
      _lowBatteryWarning = results[2];
    });

    // device.info → model name (AppBar title) + anything else the device
    // info screen would also fetch. One-shot; the dashboard doesn't poll
    // identity since it doesn't change at runtime.
    try {
      final r = await session.client.send('device.info');
      if (mounted && r.ok && r.data is Map) {
        final m = r.data as Map;
        setState(() {
          _deviceModel = m['model']?.toString();
        });
      }
    } catch (_) {/* silent, title falls back to "Cihaz" */}

    // api.status → endpoint count + master enable flag for the summary card
    await _refreshApiSummary();

    // İlk status snapshot'ı + 3sn polling. Pil seviyesi event'le güncellenir
    // ama ilk açılışta da bir kere çekilir.
    _refreshStatus();
    _statusTimer ??=
        Timer.periodic(const Duration(seconds: 3), (_) => _refreshStatus());

    // Event stream, battery.* gibi event'leri dinle. face/timer/api da
    // gelebilir; şimdilik sadece pil seviyesini çekiyoruz.
    _eventSub ??= session.client.events.listen(_onEvent);
  }

  /// Reads `api.status` and stores the endpoint count + master switch
  /// state. Called from bootstrap and from the API chain card's tap-back
  /// path so any change made there reflects on the dashboard summary.
  Future<void> _refreshApiSummary() async {
    if (!mounted) return;
    final session = BfSession.of(context);
    try {
      final r = await session.client.send('api.status');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = r.data as Map;
        final count = (m['endpoints'] as num?)?.toInt() ?? 0;
        final enabled = m['master_enabled'] == true;
        setState(() {
          _endpointCount = count;
          _apiMasterEnabled = enabled;
        });
      }
    } catch (_) {/* silent, summary stays at last known values */}
  }

  Future<void> _refreshStatus() async {
    if (!mounted) return;
    final session = BfSession.of(context);
    try {
      final w = await session.client.send('wifi.status');
      if (!mounted) return;
      if (w.ok && w.data is Map) {
        final m = w.data as Map;
        final connected = m['connected'] == true;
        setState(() => _wifiSsid = connected ? (m['ssid']?.toString()) : null);
      }
    } catch (_) {/* sessiz */}
    try {
      final b = await session.client.send('battery.status');
      if (!mounted) return;
      if (b.ok && b.data is Map) {
        final m = b.data as Map;
        final p = m['pct'] ?? m['percent'];
        if (p is num) setState(() => _batteryPercent = p.toInt());
      }
    } catch (_) {/* sessiz */}
  }

  void _onEvent(Map<String, dynamic> evt) {
    // Cihazdan gelen event şeması: {"evt": "battery.sample", "data": {...}}
    // bf_battery alan adı olarak `pct` kullanır; eski `percent`'i de tolere et.
    final name = evt['evt']?.toString();
    if (name == null) return;
    if (name.startsWith('battery.')) {
      final data = evt['data'];
      if (data is Map) {
        final p = data['pct'] ?? data['percent'];
        if (p is num) {
          setState(() => _batteryPercent = p.toInt());
        }
      }
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _eventSub?.cancel();
    super.dispose();
  }

  /// Writes one toggle's value into local state. Used both for the
  /// optimistic update and to roll back when the device rejects the write.
  void _setToggleState(_Toggle toggle, bool value) {
    setState(() {
      switch (toggle) {
        case _Toggle.vibration:
          _vibration = value;
        case _Toggle.tilt:
          _tiltWarning = value;
        case _Toggle.lowBattery:
          _lowBatteryWarning = value;
      }
    });
  }

  /// Pushes a single toggle change to the device using a dedicated CLI
  /// command. Three switches are NVS-persisted on device + matching
  /// `*.on/off/status` commands; no secure store keys, no silent no-ops.
  /// The matching gate on the device fires the alert pattern or stays
  /// silent based on this state.
  ///
  /// The UI is updated optimistically by the caller. If the write fails,
  /// either as a thrown transport error or a protocol-level `ok:false`
  /// response (e.g. NVS save failure on device), we roll the toggle back
  /// to [previous] and surface the reason; never leave a flipped switch
  /// that the device did not actually persist.
  Future<void> _writeToggle(_Toggle toggle, bool value, bool previous) async {
    final session = BfSession.of(context);
    String? errText;
    try {
      final cmd = switch (toggle) {
        _Toggle.vibration  => value ? 'vibration.on'     : 'vibration.off',
        _Toggle.tilt       => value ? 'tilt.warn.on'     : 'tilt.warn.off',
        _Toggle.lowBattery => value ? 'low_batt.warn.on' : 'low_batt.warn.off',
      };
      final r = await session.client.send(cmd);
      if (!r.ok) errText = r.err ?? '?';
    } catch (e) {
      errText = e.toString();
    }
    if (errText == null || !mounted) return;
    // Device did not persist the change, undo the optimistic flip.
    _setToggleState(toggle, previous);
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.bfDashboardWriteFailed(errText))),
    );
  }


  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final session = BfSession.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(_deviceModel ?? l.bfDashboardTitleFallback),
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: [
          _IdentityHeader(
            deviceId: widget.deviceId,
            wifiSsid: _wifiSsid,
            batteryPercent: _batteryPercent,
            transportKind: session.transportKind,
          ),
          const SizedBox(height: 8),
          _QuickControlsCard(
            vibration: _vibration,
            tiltWarning: _tiltWarning,
            lowBatteryWarning: _lowBatteryWarning,
            onChanged: (k, v) {
              // Optimistic local update + cihaza yaz; cihaz reddederse
              // (transport hatası VEYA protokol ok:false) _writeToggle
              // toggle'ı eski değerine döndürür ve hata snackbar'ı gösterir.
              final previous = switch (k) {
                _Toggle.vibration  => _vibration,
                _Toggle.tilt       => _tiltWarning,
                _Toggle.lowBattery => _lowBatteryWarning,
              };
              _setToggleState(k, v);
              _writeToggle(k, v, previous);
            },
          ),
          const SizedBox(height: 24),
          _ApiChainSummaryCard(
            endpointCount: _endpointCount,
            masterEnabled: _apiMasterEnabled,
            onTap: () async {
              await BfSession.push(
                  context, OnDeviceApiEditorScreen(deviceId: widget.deviceId));
              await _refreshApiSummary();
            },
          ),
          const SizedBox(height: 24),
          _NotebookCard(
            onTap: () => BfSession.push(
                context, BfNotebookScreen(deviceId: widget.deviceId)),
          ),
          const SizedBox(height: 24),
          _MoreCard(
            onDeviceInfo: () => BfSession.push(
                context, BfDeviceInfoScreen(deviceId: widget.deviceId)),
            onSettings: () => BfSession.push(
                context, BfSettingsScreen(deviceId: widget.deviceId)),
          ),
        ],
        ),
      ),
    );
  }

}

enum _Toggle { vibration, tilt, lowBattery }

// ---------------------------------------------------------------------------
// Identity + status pills (BF-A06TMFSQT · WiFi · BLE · pil)
// ---------------------------------------------------------------------------

class _IdentityHeader extends StatelessWidget {
  const _IdentityHeader({
    required this.deviceId,
    required this.wifiSsid,
    required this.batteryPercent,
    required this.transportKind,
  });
  final String deviceId;
  final String? wifiSsid;                  // null → bağlı değil
  final int? batteryPercent;               // null → bilinmiyor
  final CliTransportKind transportKind;    // active SKAPP↔device link

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final (linkIcon, linkLabel) = switch (transportKind) {
      CliTransportKind.ble => (Icons.bluetooth_connected, l.bfDashboardLinkBle),
      CliTransportKind.tcp => (Icons.wifi_tethering, l.bfDashboardLinkWifi),
      CliTransportKind.usb => (Icons.usb, l.bfDashboardLinkUsb),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 28),
      child: Column(
        children: [
          Text(
            deviceId,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                  color: cs.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                icon: Icons.wifi,
                label: wifiSsid ?? l.bfDashboardWifiNone,
                tone: wifiSsid != null ? _PillTone.ok : _PillTone.neutral,
              ),
              _Pill(
                icon: linkIcon,
                label: linkLabel,
                tone: _PillTone.ok,
              ),
              _Pill(
                icon: Icons.bolt,
                label: batteryPercent != null ? '%$batteryPercent' : '%-',
                tone: _PillTone.neutral,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _PillTone { ok, neutral }

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.tone,
  });
  final IconData icon;
  final String label;
  final _PillTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = tone == _PillTone.ok
        ? cs.primary.withValues(alpha: 0.1)
        : cs.surfaceContainerHigh;
    final fg = tone == _PillTone.ok ? cs.primary : cs.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: fg)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick controls, 3 toggle (titreşim / düz koyma / düşük pil)
// ---------------------------------------------------------------------------

class _QuickControlsCard extends StatelessWidget {
  const _QuickControlsCard({
    required this.vibration,
    required this.tiltWarning,
    required this.lowBatteryWarning,
    required this.onChanged,
  });
  final bool vibration;
  final bool tiltWarning;
  final bool lowBatteryWarning;
  final void Function(_Toggle, bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _Card(
      children: [
        _ToggleRow(
          icon: Icons.vibration,
          title: l.bfDashboardToggleVibration,
          value: vibration,
          onChanged: (v) => onChanged(_Toggle.vibration, v),
        ),
        // Tilt: cube on a corner / edge → top face is ambiguous. Used to
        // be labelled "yukarı dönük" which mis-described the actual
        // firmware behaviour (Z+ beep). Now wired to bf_face_detector's
        // `face.tilted` event on the device side. Subtitle removed
        // the title carries the meaning, no extra explainer needed.
        _ToggleRow(
          icon: Icons.warning_amber,
          title: l.bfDashboardToggleTilt,
          value: tiltWarning,
          onChanged: (v) => onChanged(_Toggle.tilt, v),
        ),
        _ToggleRow(
          icon: Icons.battery_alert,
          title: l.bfDashboardToggleLowBatt,
          value: lowBatteryWarning,
          onChanged: (v) => onChanged(_Toggle.lowBattery, v),
          isLast: true,
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: cs.outlineVariant, width: 0.5),
              ),
      ),
      child: ListTile(
        leading: Icon(icon, color: cs.onSurfaceVariant),
        title: Text(title),
        trailing: SkNeuSwitch(value: value, onChanged: onChanged),
        onTap: () => onChanged(!value),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// API zinciri özet kartı, tıklanınca chain editor sayfası açılacak.
// ---------------------------------------------------------------------------

class _ApiChainSummaryCard extends StatelessWidget {
  const _ApiChainSummaryCard({
    required this.endpointCount,
    required this.masterEnabled,
    required this.onTap,
  });

  /// Endpoints stored on the device, fresh from `api.status`.
  final int endpointCount;

  /// `api on` master switch state.
  final bool masterEnabled;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final masterText =
        masterEnabled ? l.bfDashboardMasterOn : l.bfDashboardMasterOff;
    final subtitle = endpointCount == 0
        ? l.bfDashboardApiChainNone(masterText)
        : l.bfDashboardApiChainSummary(endpointCount, masterText);
    return _Card(
      children: [
        ListTile(
          leading: Icon(Icons.link, color: cs.onSurfaceVariant),
          title: Text(l.bfDashboardApiChainTitle),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Kullanıcı Defteri, userdata blob şifreli kişisel alana giriş
// ---------------------------------------------------------------------------

class _NotebookCard extends StatelessWidget {
  const _NotebookCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return _Card(
      children: [
        ListTile(
          leading: Icon(Icons.menu_book_outlined, color: cs.onSurfaceVariant),
          title: Text(l.bfDashboardNotebookTitle),
          subtitle: Text(l.bfDashboardNotebookSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Daha fazla, Cihaz bilgisi + Ayarlar
// ---------------------------------------------------------------------------

class _MoreCard extends StatelessWidget {
  const _MoreCard({required this.onDeviceInfo, required this.onSettings});
  final VoidCallback onDeviceInfo;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return _Card(
      children: [
        ListTile(
          leading: Icon(Icons.info_outline, color: cs.onSurfaceVariant),
          title: Text(l.bfDashboardMoreDeviceInfo),
          trailing: const Icon(Icons.chevron_right),
          onTap: onDeviceInfo,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: cs.outlineVariant, width: 0.5),
            ),
          ),
          child: ListTile(
            leading: Icon(Icons.settings_outlined, color: cs.onSurfaceVariant),
            title: Text(l.bfDashboardMoreSettings),
            trailing: const Icon(Icons.chevron_right),
            onTap: onSettings,
          ),
        ),
      ],
    );
  }
}

// Genel kart wrapper'ı, bf.html'deki list-card karşılığı.
class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SkNeuCard(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}
