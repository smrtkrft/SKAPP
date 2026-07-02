// SD Olay geçmişi, cihazdan gelen `evt` mesajlarının canlı listesi
// (bf_events_screen deseni; SD olay ailesi: mode/safe/target/input/prefs).

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'sd_session.dart';

class SdEventsScreen extends StatefulWidget {
  const SdEventsScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<SdEventsScreen> createState() => _SdEventsScreenState();
}

class _SdEventsScreenState extends State<SdEventsScreen> {
  final List<_LogEntry> _entries = [];
  StreamSubscription<Map<String, dynamic>>? _sub;
  bool _attached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_attached) return;
    _attached = true;
    final client = SdSession.of(context).client;
    _sub = client.events.listen(_onEvent);
  }

  void _onEvent(Map<String, dynamic> evt) {
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    final entry = _LogEntry.fromEvent(evt, l);
    if (entry == null) return;
    setState(() {
      _entries.insert(0, entry);
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
        title: Text(l.sdEventsTitle),
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
                      leading: Icon(e.icon, color: e.warn ? cs.error : cs.onSurfaceVariant),
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
    this.warn = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool warn;

  /// SD firmware olayları (SKAPP_CONTRACT.md): mode.changed/value/error,
  /// target.offline/online, safe.triggered/lockout, input.gesture,
  /// prefs.changed, profile.added/removed + sk katmanı api.sent/wifi./ota.
  /// `mode.value` seli listeye BASILMAZ (≤10 Hz sürükleme trafiği).
  static _LogEntry? fromEvent(Map<String, dynamic> evt, AppLocalizations l) {
    final name = evt['evt']?.toString();
    if (name == null || name == 'mode.value') return null;
    final ts = DateTime.now();
    final tsStr =
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}:${ts.second.toString().padLeft(2, '0')}';
    final data = evt['data'];

    IconData icon;
    String title;
    var warn = false;
    switch (name) {
      case 'mode.changed':
        icon = Icons.tune;
        title = data is Map
            ? l.sdEventsModeChanged(
                (data['slot'] ?? '?').toString(),
                (data['name'] ?? '').toString(),
              )
            : name;
      case 'mode.error':
        icon = Icons.error_outline;
        warn = true;
        title = data is Map
            ? l.sdEventsModeError((data['slot'] ?? '?').toString())
            : name;
      case 'target.offline':
        icon = Icons.cloud_off_outlined;
        warn = true;
        title = data is Map
            ? l.sdEventsTargetOffline((data['slot'] ?? '?').toString())
            : name;
      case 'target.online':
        icon = Icons.cloud_done_outlined;
        title = data is Map
            ? l.sdEventsTargetOnline((data['slot'] ?? '?').toString())
            : name;
      case 'safe.triggered':
        // İçerik değil sonuç loglanır (dizi sır — n + ok dışında veri yok).
        final ok = data is Map ? data['ok'] != false : true;
        icon = ok ? Icons.lock_open_outlined : Icons.lock_outline;
        warn = !ok;
        title = ok ? l.sdEventsSafeTriggered : l.sdEventsSafeWrong;
      case 'safe.lockout':
        icon = Icons.lock_clock_outlined;
        warn = true;
        final secs = data is Map ? (data['seconds'] as num?)?.toInt() : null;
        title = l.sdEventsSafeLockout(secs ?? 30);
      case 'input.gesture':
        icon = Icons.touch_app_outlined;
        title = data is Map
            ? l.sdEventsGesture((data['type'] ?? '?').toString())
            : name;
      case 'prefs.changed':
        icon = Icons.toggle_on_outlined;
        title = data is Map
            ? l.sdEventsPrefChanged((data['key'] ?? '?').toString())
            : name;
      case 'api.sent':
        icon = Icons.send;
        title = data is Map
            ? l.bfEventsApiTriggered(
                (data['name'] ?? data['type'] ?? 'API').toString())
            : l.bfEventsApiTriggeredFallback;
      default:
        icon = Icons.bolt;
        title = name;
    }

    final subtitle = data != null && data is Map && data.isNotEmpty
        ? '$tsStr · $data'
        : tsStr;
    return _LogEntry(icon: icon, title: title, subtitle: subtitle, warn: warn);
  }
}
