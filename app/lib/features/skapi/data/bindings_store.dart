import 'package:shared_preferences/shared_preferences.dart';

import 'action_binding.dart';

/// SharedPreferences-backed binding table. Mirrors `paired_devices_store`:
/// single JSON key, sync `read`, async `write` on every mutation.
///
/// Cascade delete (2026-05-13): Unpairing a device removes ALL its
/// bindings (no orphans). The cascade is wired explicitly from the
/// unpair UI handler, not from a Riverpod listener — Riverpod would
/// re-fire on every paired-list mutation and risk wiping bindings
/// during transient list shrink/grow cycles (e.g. an in-progress
/// re-pair). Storage key `skapi_bindings_v1` stays independent of
/// `paired_devices_v1` for migration safety.
class BindingsStore {
  BindingsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'skapi_bindings_v1';

  List<ActionBinding> read() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    return ActionBinding.decodeList(raw);
  }

  Future<void> _write(List<ActionBinding> bindings) =>
      _prefs.setString(_key, ActionBinding.encodeList(bindings));

  Future<List<ActionBinding>> upsert(ActionBinding binding) async {
    final list = [...read()];
    final idx = list.indexWhere((b) => b.id == binding.id);
    if (idx == -1) {
      list.add(binding);
    } else {
      list[idx] = binding;
    }
    await _write(list);
    return list;
  }

  Future<List<ActionBinding>> remove(String id) async {
    final list = read().where((b) => b.id != id).toList();
    await _write(list);
    return list;
  }

  /// Cascade delete after unpair: removes every binding whose `deviceId`
  /// matches the unpaired device id. Match is case-insensitive to mirror
  /// `bindingsForDeviceProvider` (BF webhook headers can arrive uppercase
  /// while bindings were saved from a lowercase MAC, etc.). Returns the
  /// remaining bindings + the removed count so the UI handler can decide
  /// whether to surface a "N actions removed" toast.
  Future<({List<ActionBinding> remaining, int removed})> removeForDevice(
      String deviceId) async {
    final variants = <String>{
      deviceId,
      deviceId.toUpperCase(),
      deviceId.toLowerCase(),
    };
    final all = read();
    final remaining =
        all.where((b) => !variants.contains(b.deviceId)).toList();
    final removed = all.length - remaining.length;
    if (removed > 0) {
      await _write(remaining);
    }
    return (remaining: remaining, removed: removed);
  }

  Future<List<ActionBinding>> setEnabled(String id, bool enabled) async {
    final list = [...read()];
    final idx = list.indexWhere((b) => b.id == id);
    if (idx == -1) return list;
    list[idx] = list[idx].copyWith(enabled: enabled);
    await _write(list);
    return list;
  }

  /// Reset Pairings / Factory Reset için: tüm binding tablosunu siler.
  Future<void> clearAll() async {
    await _write(const []);
  }
}
