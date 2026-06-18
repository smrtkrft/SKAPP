import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/preferences_provider.dart';
import 'skapp_peer_target.dart';

/// SharedPreferences-backed list of paired Desktop SKAPP peers. Mirrors
/// the `paired_devices_store` shape: single JSON key, sync read, async
/// write on every mutation.
class SkappPeerStore {
  SkappPeerStore(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'skapp_peers_v1';

  List<SkappPeerTarget> read() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) =>
            SkappPeerTarget.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);
  }

  Future<void> _write(List<SkappPeerTarget> peers) async {
    await _prefs.setString(
      _key,
      jsonEncode(peers.map((p) => p.toJson()).toList()),
    );
  }

  Future<List<SkappPeerTarget>> upsert(SkappPeerTarget peer) async {
    final list = [...read()];
    final idx = list.indexWhere((p) => p.uuid == peer.uuid);
    if (idx == -1) {
      list.add(peer);
    } else {
      list[idx] = peer;
    }
    await _write(list);
    return list;
  }

  Future<List<SkappPeerTarget>> remove(String uuid) async {
    final list = read().where((p) => p.uuid != uuid).toList();
    await _write(list);
    return list;
  }

  Future<List<SkappPeerTarget>> markSeen(
    String uuid,
    String? ip,
    DateTime when,
  ) async {
    final list = [...read()];
    final idx = list.indexWhere((p) => p.uuid == uuid);
    if (idx == -1) return list;
    list[idx] = list[idx].copyWith(lastIp: ip, lastSeen: when);
    await _write(list);
    return list;
  }

  /// Refresh the `developerModeEnabled` flag from a `/api/health`
  /// response. Health prober calls this after every successful probe;
  /// the peer picker reads the flag to disable rows whose desktop has
  /// developer mode off. Independent of `markSeen` because the prober
  /// updates both at the same point but mDNS-driven `markSeen` does
  /// not carry health information.
  Future<List<SkappPeerTarget>> updateHealth(
    String uuid, {
    required bool developerModeEnabled,
  }) async {
    final list = [...read()];
    final idx = list.indexWhere((p) => p.uuid == uuid);
    if (idx == -1) return list;
    list[idx] =
        list[idx].copyWith(developerModeEnabled: developerModeEnabled);
    await _write(list);
    return list;
  }

  /// Reset Pairings / Factory Reset için: tüm peer kayıtlarını siler.
  Future<void> clearAll() async {
    await _write(const []);
  }
}

class SkappPeersNotifier extends Notifier<List<SkappPeerTarget>> {
  @override
  List<SkappPeerTarget> build() => ref.watch(skappPeerStoreProvider).read();

  Future<void> add(SkappPeerTarget peer) async {
    final next = await ref.read(skappPeerStoreProvider).upsert(peer);
    state = next;
  }

  Future<void> remove(String uuid) async {
    final next = await ref.read(skappPeerStoreProvider).remove(uuid);
    state = next;
  }

  Future<void> markSeen(String uuid, String? ip, DateTime when) async {
    final next =
        await ref.read(skappPeerStoreProvider).markSeen(uuid, ip, when);
    state = next;
  }

  Future<void> updateHealth(
    String uuid, {
    required bool developerModeEnabled,
  }) async {
    final next = await ref
        .read(skappPeerStoreProvider)
        .updateHealth(uuid, developerModeEnabled: developerModeEnabled);
    state = next;
  }

  /// Reset Pairings / Factory Reset için: tüm peer kayıtlarını siler.
  Future<void> clearAll() async {
    await ref.read(skappPeerStoreProvider).clearAll();
    state = const [];
  }
}

final skappPeerStoreProvider = Provider<SkappPeerStore>((ref) {
  return SkappPeerStore(ref.watch(sharedPreferencesProvider));
});

final skappPeersProvider =
    NotifierProvider<SkappPeersNotifier, List<SkappPeerTarget>>(
        SkappPeersNotifier.new);
