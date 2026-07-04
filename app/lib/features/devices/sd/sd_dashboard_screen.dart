// SD Dashboard — design2.html "Orbital Tactile" prototipinin Flutter
// karşılığı (Faz A: veri katmanı + slot tepsisi; kadran Faz B'de
// SdOrbitalDial ile değişecek).
//
// Cihazla CLI üzerinden konuşur: `mode.list` panonun tek durum kaynağı,
// canlılık `mode.*` / `target.*` olaylarından gelir (≤10 Hz coalesced).

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/cli/cli_transport.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'sd_settings_screen.dart';
import 'sd_session.dart';
import 'widgets/sd_orbital_dial.dart';
import 'widgets/sd_safe_center.dart';

/// One row of `mode.list`'s `slots[]` array, as the firmware reports it.
class SdSlot {
  SdSlot({
    required this.slot,
    required this.assigned,
    required this.behavior,
    required this.name,
    required this.enabled,
    required this.error,
    required this.value,
    required this.state,
  });

  final int slot; // 1..3
  final bool assigned;
  final String behavior; // dimmer | shutter | safe | mqtt_remote | ''
  final String name;
  final bool enabled;
  bool error; // mode.error olayı yerinde işaretler
  int value; // 0..100 — event'lerle canlı güncellenir
  bool state;

  static SdSlot? fromJson(dynamic j) {
    if (j is! Map) return null;
    final slot = (j['slot'] as num?)?.toInt();
    if (slot == null) return null;
    return SdSlot(
      slot: slot,
      assigned: j['assigned'] == true,
      behavior: j['behavior']?.toString() ?? '',
      name: j['name']?.toString() ?? '',
      enabled: j['enabled'] == true,
      error: j['error'] == true,
      value: (j['value'] as num?)?.toInt() ?? 0,
      state: j['state'] == true,
    );
  }
}

class SdDashboardScreen extends StatefulWidget {
  const SdDashboardScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<SdDashboardScreen> createState() => _SdDashboardScreenState();
}

class _SdDashboardScreenState extends State<SdDashboardScreen> {
  bool _loaded = false;

  // mode.list snapshot'ı; olaylar üstüne yazar.
  List<SdSlot> _slots = [];
  int _active = 1;
  bool _recovery = false;

  // Slot bazında hedef erişilebilirliği (target.offline/online).
  final Set<int> _offlineSlots = {};

  // Safe durum merkezi (V5): cihaz olayları sürer, kısa süre sonra
  // "nöbette" tabanına döner. Uygulamadan dizi girişi YOKTUR.
  SdSafeStatus _safeStatus = SdSafeStatus.idle;
  int? _safeLockSeconds;
  Timer? _safeResetTimer;

  // mode.value trailing throttle (≈120 ms): sürükleme sırasında yerel
  // değer anında güncellenir, cihaza en son değer gönderilir (firmware
  // zaten 100 ms coalescing yapar; burada BLE'yi boğmamak için).
  int? _pendingValue;
  Timer? _valueTimer;

  // Status pill verileri (BF deseniyle aynı: 3 sn polling + device.info
  // one-shot).
  String? _wifiSsid;
  String? _deviceModel;
  Timer? _statusTimer;
  StreamSubscription<Map<String, dynamic>>? _eventSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final session = SdSession.of(context);

    await _refreshModes();

    try {
      final r = await session.client.send('device.info');
      if (mounted && r.ok && r.data is Map) {
        final m = r.data as Map;
        setState(() => _deviceModel = m['model']?.toString());
      }
    } catch (_) {/* sessiz, başlık fallback'e düşer */}

    _refreshStatus();
    _statusTimer ??=
        Timer.periodic(const Duration(seconds: 3), (_) => _refreshStatus());
    _eventSub ??= session.client.events.listen(_onEvent);
  }

  /// `mode.list` → slots + active + recovery. Panonun tek durum kaynağı;
  /// slot düzenleme ekranlarından dönüşte de çağrılır.
  Future<void> _refreshModes() async {
    if (!mounted) return;
    final session = SdSession.of(context);
    try {
      final r = await session.client.send('mode.list');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = r.data as Map;
        final slots = <SdSlot>[];
        if (m['slots'] is List) {
          for (final j in m['slots'] as List) {
            final s = SdSlot.fromJson(j);
            if (s != null) slots.add(s);
          }
        }
        setState(() {
          _slots = slots;
          _active = (m['active'] as num?)?.toInt() ?? 1;
          _recovery = m['recovery'] == true;
        });
      }
    } catch (_) {/* sessiz, son bilinen durum kalır */}
  }

  Future<void> _refreshStatus() async {
    if (!mounted) return;
    final session = SdSession.of(context);
    try {
      final w = await session.client.send('wifi.status');
      if (!mounted) return;
      if (w.ok && w.data is Map) {
        final m = w.data as Map;
        final connected = m['connected'] == true;
        setState(() => _wifiSsid = connected ? (m['ssid']?.toString()) : null);
      }
    } catch (_) {/* sessiz */}
  }

  void _onEvent(Map<String, dynamic> evt) {
    final name = evt['evt']?.toString();
    if (name == null || !mounted) return;
    final data = evt['data'];

    switch (name) {
      case 'mode.value':
        // {slot,value,state} — fiziksel düğme çevrildiğinde pano canlı
        // kalsın diye listeyi yeniden çekmeden yerinde günceller.
        if (data is Map) {
          final slot = (data['slot'] as num?)?.toInt();
          final s = _slotOrNull(slot);
          if (s != null) {
            setState(() {
              s.value = (data['value'] as num?)?.toInt() ?? s.value;
              s.state = data['state'] == true;
            });
          }
        }
      case 'mode.changed':
        // Aktif slot cihazdan değişti (hold+rotate) → snapshot tazele.
        _refreshModes();
      case 'mode.error':
        if (data is Map) {
          final s = _slotOrNull((data['slot'] as num?)?.toInt());
          if (s != null) setState(() => s.error = true);
        }
      case 'target.offline':
        if (data is Map) {
          final slot = (data['slot'] as num?)?.toInt();
          if (slot != null) setState(() => _offlineSlots.add(slot));
        }
      case 'target.online':
        if (data is Map) {
          final slot = (data['slot'] as num?)?.toInt();
          if (slot != null) setState(() => _offlineSlots.remove(slot));
        }
      case 'safe.triggered':
        // {n, ok} — ok=false (yanlış dizi) tabanı bozmaz; yalnız
        // başarılı tetikleme açılış dönüşünü oynatır.
        if (data is Map && data['ok'] != false) {
          _setSafeStatus(SdSafeStatus.fired);
        }
      case 'safe.lockout':
        if (data is Map) {
          _safeLockSeconds = (data['seconds'] as num?)?.toInt();
          _setSafeStatus(SdSafeStatus.locked);
        }
      case 'device.recovery':
        setState(() => _recovery = true);
    }
  }

  /// Safe merkez durumunu olaydan sürer, kısa süre sonra "nöbette"
  /// tabanına döndürür (V5 karakteri — design2.html ile aynı süreler).
  void _setSafeStatus(SdSafeStatus status) {
    _safeResetTimer?.cancel();
    setState(() => _safeStatus = status);
    if (status == SdSafeStatus.idle) return;
    _safeResetTimer = Timer(
      status == SdSafeStatus.fired
          ? const Duration(milliseconds: 3200)
          : const Duration(milliseconds: 4200),
      () {
        if (mounted) setState(() => _safeStatus = SdSafeStatus.idle);
      },
    );
  }

  /// Kadran sürüklemesi: yerel değer anında (iyimser), cihaza trailing
  /// throttle ile `mode.value <slot> <v>`. Cihaz reddederse snapshot
  /// tazelenir (gerçek değere geri döner).
  void _dialValue(int value) {
    final s = _slotOrNull(_active);
    if (s == null) return;
    setState(() {
      s.value = value;
      s.state = value > 0;
    });
    _pendingValue = value;
    _valueTimer ??= Timer(const Duration(milliseconds: 120), () {
      _valueTimer = null;
      final v = _pendingValue;
      _pendingValue = null;
      if (v != null) _writeValue('$v');
    });
  }

  /// Disk dokunuşu: dimmer aç/kapa, shutter STOP — firmware'de ikisi de
  /// `mode.value <slot> toggle` yoludur.
  void _dialTap() => _writeValue('toggle');

  Future<void> _writeValue(String arg) async {
    final session = SdSession.of(context);
    String? errText;
    try {
      final r =
          await session.client.send('mode.value', argv: ['$_active', arg]);
      if (!r.ok) errText = r.err ?? '?';
    } catch (e) {
      errText = e.toString();
    }
    if (!mounted || errText == null) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.sdDashboardWriteFailed(errText))),
    );
    await _refreshModes();
  }

  SdSlot? _slotOrNull(int? n) {
    if (n == null) return null;
    for (final s in _slots) {
      if (s.slot == n) return s;
    }
    return null;
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _eventSub?.cancel();
    _safeResetTimer?.cancel();
    _valueTimer?.cancel();
    super.dispose();
  }

  /// Aktif slotu cihazda değiştirir (`mode.select`). İyimser güncelleme
  /// yok: cevap gelene kadar eski slot vurgulu kalır, başarıda
  /// _refreshModes zaten yeni aktifle döner.
  Future<void> _selectSlot(int slot) async {
    final session = SdSession.of(context);
    String? errText;
    try {
      final r = await session.client.send('mode.select', argv: ['$slot']);
      if (!r.ok) errText = r.err ?? '?';
    } catch (e) {
      errText = e.toString();
    }
    if (!mounted) return;
    if (errText != null) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.sdDashboardWriteFailed(errText))),
      );
      return;
    }
    await _refreshModes();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final session = SdSession.of(context);
    final active = _slotOrNull(_active);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(_deviceModel ?? l.sdDashboardTitleFallback),
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
              transportKind: session.transportKind,
            ),
            if (_recovery) ...[
              _RecoveryBanner(text: l.sdDashboardRecovery),
              const SizedBox(height: 16),
            ],
            if (active?.behavior == 'safe')
              SdSafeCenter(
                status: _safeStatus,
                statusText: switch (_safeStatus) {
                  SdSafeStatus.idle => l.sdSafeStatusIdle,
                  SdSafeStatus.fired => l.sdSafeStatusFired,
                  SdSafeStatus.locked =>
                    l.sdSafeStatusLocked(_safeLockSeconds ?? 30),
                },
                note: l.sdSafeNote,
              )
            else
              SdOrbitalDial(
                value: active?.value ?? 0,
                state: active?.state ?? false,
                label: (active?.assigned ?? false)
                    ? (active!.name.isNotEmpty ? active.name : active.behavior)
                    : l.sdDashboardSlotEmpty,
                interactive: (active?.assigned ?? false) &&
                    active?.error != true &&
                    !_recovery,
                onValue: _dialValue,
                onTap: _dialTap,
              ),
            if (active != null && _offlineSlots.contains(active.slot)) ...[
              const SizedBox(height: 10),
              Center(
                child: Text(
                  l.sdDashboardOffline,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            _SlotTray(
              slots: _slots,
              active: _active,
              offlineSlots: _offlineSlots,
              enabled: !_recovery,
              onSelect: _selectSlot,
            ),
            const SizedBox(height: 24),
            // Ürün kararı (2026-07-03): en altta YALNIZ ayarlar girişi —
            // Webhooks vb. ikincil yüzeyler ayarlar hub'ına taşındı.
            SkNeuCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                title: Text(l.bfDashboardMoreSettings),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await SdSession.push(
                    context,
                    SdSettingsScreen(deviceId: widget.deviceId),
                  );
                  if (mounted) await _refreshModes();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Identity + status pills (SD-XXXXXX · WiFi · bağlantı türü)
// ---------------------------------------------------------------------------

class _IdentityHeader extends StatelessWidget {
  const _IdentityHeader({
    required this.deviceId,
    required this.wifiSsid,
    required this.transportKind,
  });
  final String deviceId;
  final String? wifiSsid; // null → bağlı değil
  final CliTransportKind transportKind;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final (linkIcon, linkLabel) = switch (transportKind) {
      CliTransportKind.ble => (Icons.bluetooth_connected, l.sdDashboardLinkBle),
      CliTransportKind.tcp => (Icons.wifi_tethering, l.sdDashboardLinkWifi),
      CliTransportKind.usb => (Icons.usb, l.sdDashboardLinkUsb),
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
                label: wifiSsid ?? l.sdDashboardWifiNone,
                tone: wifiSsid != null ? _PillTone.ok : _PillTone.neutral,
              ),
              _Pill(icon: linkIcon, label: linkLabel, tone: _PillTone.ok),
            ],
          ),
        ],
      ),
    );
  }
}

enum _PillTone { ok, neutral }

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.tone});
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
// Kurtarma bandı (recovery boot — slotlar yüklenmedi)
// ---------------------------------------------------------------------------

class _RecoveryBanner extends StatelessWidget {
  const _RecoveryBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.healing_outlined, size: 18, color: cs.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12.5, color: cs.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Slot tepsisi — 3 mod hapı (design2 mode-tray karşılığı)
// ---------------------------------------------------------------------------

class _SlotTray extends StatelessWidget {
  const _SlotTray({
    required this.slots,
    required this.active,
    required this.offlineSlots,
    required this.enabled,
    required this.onSelect,
  });
  final List<SdSlot> slots;
  final int active;
  final Set<int> offlineSlots;
  final bool enabled;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SkNeuCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          for (var n = 1; n <= 3; n++) ...[
            if (n > 1) const SizedBox(width: 8),
            Expanded(
              child: _SlotPill(
                slot: _find(n),
                number: n,
                selected: n == active,
                offline: offlineSlots.contains(n),
                emptyLabel: l.sdDashboardSlotEmpty,
                errorLabel: l.sdDashboardSlotError,
                onTap: enabled && n != active ? () => onSelect(n) : null,
              ),
            ),
          ],
        ],
      ),
    );
  }

  SdSlot? _find(int n) {
    for (final s in slots) {
      if (s.slot == n) return s;
    }
    return null;
  }
}

class _SlotPill extends StatelessWidget {
  const _SlotPill({
    required this.slot,
    required this.number,
    required this.selected,
    required this.offline,
    required this.emptyLabel,
    required this.errorLabel,
    required this.onTap,
  });
  final SdSlot? slot;
  final int number;
  final bool selected;
  final bool offline;
  final String emptyLabel;
  final String errorLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final assigned = slot != null && slot!.assigned;
    final error = slot?.error == true;
    final label = assigned
        ? (slot!.name.isNotEmpty ? slot!.name : slot!.behavior)
        : emptyLabel;
    // Durum noktası: hata=kırmızı, offline=soluk, aktif+atanmış=hardal.
    final dotColor = error
        ? cs.error
        : offline
            ? cs.outline
            : selected && assigned
                ? cs.tertiary
                : cs.outlineVariant;
    return Material(
      color: selected ? cs.surfaceContainerHigh : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? cs.outline : cs.outlineVariant,
              width: selected ? 1 : 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration:
                        BoxDecoration(color: dotColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                error ? errorLabel : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: error
                      ? cs.error
                      : selected
                          ? cs.onSurface
                          : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
