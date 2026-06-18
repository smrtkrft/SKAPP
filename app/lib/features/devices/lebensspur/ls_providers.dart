// LebensSpur-specific Riverpod providers. Reads live timer/relay/wifi state
// from the device via CliClient and exposes it as typed models.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_providers.dart';

class LsTimerState {
  LsTimerState({
    required this.running,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.alarmCount,
    required this.vacationOn,
  });

  final bool running;
  final int remainingSeconds;
  final int totalSeconds;
  final int alarmCount;
  final bool vacationOn;

  factory LsTimerState.fromData(Map<String, dynamic> d) => LsTimerState(
        running: d['state'] == 'running',
        remainingSeconds: (d['remaining'] as num?)?.toInt() ?? 0,
        totalSeconds: (d['total'] as num?)?.toInt() ?? 0,
        alarmCount: (d['alarms_total'] as num?)?.toInt() ?? 0,
        vacationOn:
            ((d['vacation'] as Map?)?['enabled'] as bool?) ?? false,
      );
}

class LsRelayState {
  LsRelayState({required this.on, required this.mode});
  final bool on;
  final String mode;
  factory LsRelayState.fromData(Map<String, dynamic> d) =>
      LsRelayState(on: d['state'] == 'on', mode: (d['mode'] ?? 'NO') as String);
}

/// Live timer state for a device: seeds via `timer.status`, then updates
/// on `timer.tick` / `timer.set` / `timer.restart` / `timer.cancel` events.
final lsTimerProvider = StreamProvider.family<LsTimerState, String>((ref, id) async* {
  final session = await ref.watch(deviceSessionProvider(id).future);
  final resp = await session.client.send('timer.status');
  if (resp.ok && resp.data is Map) {
    yield LsTimerState.fromData((resp.data as Map).cast<String, dynamic>());
  }
  await for (final evt in session.client.events) {
    final name = evt['evt'] as String?;
    if (name == null) continue;
    if (name == 'timer.tick' || name == 'timer.set' ||
        name == 'timer.restart' || name == 'timer.cancel' ||
        name.startsWith('timer.vacation.')) {
      // On tick we get only {remaining,state}; merge into last snapshot via refetch
      // (cheap, device responds immediately). Real impl caches and patches.
      final fresh = await session.client.send('timer.status');
      if (fresh.ok && fresh.data is Map) {
        yield LsTimerState.fromData((fresh.data as Map).cast<String, dynamic>());
      }
    }
  }
});

final lsRelayProvider = StreamProvider.family<LsRelayState, String>((ref, id) async* {
  final session = await ref.watch(deviceSessionProvider(id).future);
  final resp = await session.client.send('relay.status');
  if (resp.ok && resp.data is Map) {
    yield LsRelayState.fromData((resp.data as Map).cast<String, dynamic>());
  }
  await for (final evt in session.client.events) {
    if (evt['evt'] == 'relay.state' && evt['data'] is Map) {
      yield LsRelayState.fromData((evt['data'] as Map).cast<String, dynamic>());
    }
  }
});
