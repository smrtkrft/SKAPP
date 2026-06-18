// BF Olay geçmişi, cihazdan gelen `evt` mesajlarının canlı listesi.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'bf_session.dart';

class BfEventsScreen extends StatefulWidget {
  const BfEventsScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<BfEventsScreen> createState() => _BfEventsScreenState();
}

class _BfEventsScreenState extends State<BfEventsScreen> {
  final List<_LogEntry> _entries = [];
  StreamSubscription<Map<String, dynamic>>? _sub;
  bool _attached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_attached) return;
    _attached = true;
    final client = BfSession.of(context).client;
    _sub = client.events.listen(_onEvent);
  }

  void _onEvent(Map<String, dynamic> evt) {
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    final entry = _LogEntry.fromEvent(evt, l);
    if (entry == null) return;
    setState(() {
      _entries.insert(0, entry);
      // Ring sınırı: en eski olayları kırp.
      if (_entries.length > 200) _entries.removeLast();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.bfEventsTitle),
        actions: [
          IconButton(
            tooltip: l.bfEventsClearTooltip,
            icon: const Icon(Icons.clear_all),
            onPressed: _entries.isEmpty
                ? null
                : () => setState(() => _entries.clear()),
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: _entries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l.bfEventsEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              itemCount: _entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final e = _entries[i];
                return SkNeuCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: Icon(e.icon, color: cs.onSurfaceVariant),
                    title: Text(e.title),
                    subtitle: Text(e.subtitle),
                  ),
                );
              },
            ),
      ),
    );
  }
}

class _LogEntry {
  _LogEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  static _LogEntry? fromEvent(Map<String, dynamic> evt, AppLocalizations l) {
    final name = evt['evt']?.toString();
    if (name == null) return null;
    final ts = DateTime.now();
    final tsStr =
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}:${ts.second.toString().padLeft(2, '0')}';
    final data = evt['data'];

    IconData icon;
    String title;
    if (name.startsWith('timer.')) {
      icon = Icons.timer_outlined;
      // Names match firmware exactly (bf_timer_engine.c publishes
      // `timer.state` / `timer.expired` / `timer.tick`). Earlier code
      // matched `timer.started` / `timer.ended` which never arrive, so
      // every countdown row rendered as the raw event string.
      if (name == 'timer.state' && data is Map) {
        final s = data['state']?.toString();
        title = switch (s) {
          'RUNNING' => l.bfEventsTimerRunning,
          'PAUSED' => l.bfEventsTimerPaused,
          'IDLE' => l.bfEventsTimerIdle,
          'COOLDOWN' => l.bfEventsTimerCooldown,
          _ => name,
        };
      } else if (name == 'timer.expired') {
        title = l.bfEventsTimerExpired;
      } else if (name == 'timer.tick') {
        // Tick'leri olay listesine basmıyoruz; başlık kullanılmazsa da
        // değeri olduğu gibi bırak ki ileride bir filtre eklenirse
        // tutarsız davranmasın.
        title = name;
      } else {
        title = name;
      }
    } else if (name.startsWith('face.')) {
      icon = Icons.change_circle_outlined;
      title = name == 'face.changed' && data is Map
          ? l.bfEventsFaceChanged(
              (data['from'] ?? '?').toString(),
              (data['to'] ?? '?').toString(),
            )
          : name;
    } else if (name == 'api.sent') {
      icon = Icons.send;
      // Firmware api.sent payload is {name, ok, status, err} — there is no
      // `type` key, so the old read always fell back to "API".
      title = data is Map
          ? l.bfEventsApiTriggered((data['name'] ?? data['type'] ?? 'API').toString())
          : l.bfEventsApiTriggeredFallback;
    } else if (name.startsWith('battery.')) {
      icon = Icons.battery_alert;
      // Firmware battery payload key is `pct` (not `percent`); read both so the
      // friendly "Battery level: N" title actually renders.
      final pct = data is Map ? (data['pct'] ?? data['percent']) : null;
      title = pct is num ? l.bfEventsBatteryLevel(pct.toInt()) : name;
    } else if (name.contains('restart')) {
      icon = Icons.restart_alt;
      title = l.bfEventsDeviceRestarted;
    } else {
      icon = Icons.bolt;
      title = name;
    }

    final subtitle = data != null && data is Map && data.isNotEmpty
        ? '$tsStr · $data'
        : tsStr;
    return _LogEntry(icon: icon, title: title, subtitle: subtitle);
  }
}
