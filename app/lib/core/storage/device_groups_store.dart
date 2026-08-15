// Kullanıcının tanımladığı YER GRUPLARI (Büro · Ev · Salon).
//
// Cihaz tipine göre gruplama DEĞİL — tip zaten kimlik ön ekinden
// (BF-/LS-/SD-) ve kart glifinden okunuyor. Buradaki gruplar kullanıcının
// fiziksel yerleşimini yansıtır.
//
// Cihaz → grup eşlemesi bu store'da DEĞİL, `PairedDevice.groupId`
// alanında durur (tek kaynak; cihaz silinince eşleme de gider). Burada
// yalnız grubun kendisi (kimlik + ad + sıra) saklanır.
//
// "Tüm cihazlar" bir grup DEĞİLDİR: sabit bir görünümdür, listede yer
// almaz, silinemez ve adı değiştirilemez.

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_provider.dart';

class DeviceGroup {
  const DeviceGroup({
    required this.id,
    required this.name,
    required this.order,
  });

  final String id;
  final String name;

  /// Kullanıcı sırası. Listede ve süzgeç şeridinde bu sırayla çizilir.
  final int order;

  DeviceGroup copyWith({String? name, int? order}) => DeviceGroup(
        id: id,
        name: name ?? this.name,
        order: order ?? this.order,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'order': order};

  factory DeviceGroup.fromJson(Map<String, dynamic> j) => DeviceGroup(
        id: j['id'] as String,
        name: j['name'] as String,
        order: (j['order'] as num?)?.toInt() ?? 0,
      );
}

/// Ad doğrulama sonucu — UI mesajı çağıran tarafta seçilir.
enum GroupNameCheck { ok, empty, duplicate }

class DeviceGroupsStore {
  DeviceGroupsStore(this._prefs);
  final SharedPreferences _prefs;

  static const _prefsKey = 'device_groups';

  Future<void> _lock = Future.value();
  Future<T> _locked<T>(Future<T> Function() body) {
    final completer = Completer<T>();
    _lock = _lock.then((_) async {
      try {
        completer.complete(await body());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }

  List<DeviceGroup> read() {
    final raw = _prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = (jsonDecode(raw) as List)
          .whereType<Map>()
          .map((m) => DeviceGroup.fromJson(m.cast<String, dynamic>()))
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    } catch (_) {
      // Bozuk kayıt tüm listeyi öldürmesin: gruplar kozmetik bir katman,
      // cihazlar `groupId`leriyle yerinde durur ve gruplanmamış görünür.
      return const [];
    }
  }

  Future<void> _write(List<DeviceGroup> list) async {
    // Sırayı yaz sırasında normalize et: 0..n-1, boşluksuz.
    final normalized = [
      for (var i = 0; i < list.length; i++) list[i].copyWith(order: i),
    ];
    await _prefs.setString(
        _prefsKey, jsonEncode(normalized.map((g) => g.toJson()).toList()));
  }

  /// Ad kontrolü. Yeniden adlandırmada [exceptId] kendini yinelenmiş
  /// saymamak için verilir.
  GroupNameCheck checkName(String name, {String? exceptId}) {
    final t = name.trim();
    if (t.isEmpty) return GroupNameCheck.empty;
    final lower = t.toLowerCase();
    for (final g in read()) {
      if (g.id == exceptId) continue;
      if (g.name.toLowerCase() == lower) return GroupNameCheck.duplicate;
    }
    return GroupNameCheck.ok;
  }

  /// Yeni grup ekler ve kimliğini döner; ad geçersizse null döner.
  Future<String?> add(String name) => _locked(() async {
        if (checkName(name) != GroupNameCheck.ok) return null;
        final list = [...read()];
        final id = 'g${DateTime.now().microsecondsSinceEpoch}';
        list.add(DeviceGroup(id: id, name: name.trim(), order: list.length));
        await _write(list);
        return id;
      });

  Future<bool> rename(String id, String name) => _locked(() async {
        if (checkName(name, exceptId: id) != GroupNameCheck.ok) return false;
        final list = [...read()];
        final i = list.indexWhere((g) => g.id == id);
        if (i < 0) return false;
        list[i] = list[i].copyWith(name: name.trim());
        await _write(list);
        return true;
      });

  Future<void> remove(String id) => _locked(() async {
        await _write(read().where((g) => g.id != id).toList());
      });

  /// [oldIndex] → [newIndex] taşıma (ReorderableListView sözleşmesi).
  Future<void> reorder(int oldIndex, int newIndex) => _locked(() async {
        final list = [...read()];
        if (oldIndex < 0 || oldIndex >= list.length) return;
        // ReorderableListView, aşağı taşımada hedefi bir fazla bildirir.
        var target = newIndex;
        if (target > oldIndex) target -= 1;
        if (target < 0) target = 0;
        if (target >= list.length) target = list.length - 1;
        if (target == oldIndex) return;
        final item = list.removeAt(oldIndex);
        list.insert(target, item);
        await _write(list);
      });

  Future<void> clearAll() => _locked(() async {
        await _prefs.remove(_prefsKey);
      });
}

class DeviceGroupsNotifier extends Notifier<List<DeviceGroup>> {
  late final DeviceGroupsStore _store;

  @override
  List<DeviceGroup> build() {
    _store = DeviceGroupsStore(ref.read(sharedPreferencesProvider));
    return _store.read();
  }

  GroupNameCheck checkName(String name, {String? exceptId}) =>
      _store.checkName(name, exceptId: exceptId);

  Future<String?> add(String name) async {
    final id = await _store.add(name);
    state = _store.read();
    return id;
  }

  Future<bool> rename(String id, String name) async {
    final ok = await _store.rename(id, name);
    state = _store.read();
    return ok;
  }

  Future<void> remove(String id) async {
    await _store.remove(id);
    state = _store.read();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    await _store.reorder(oldIndex, newIndex);
    state = _store.read();
  }

  Future<void> clearAll() async {
    await _store.clearAll();
    state = const [];
  }
}

final deviceGroupsProvider =
    NotifierProvider<DeviceGroupsNotifier, List<DeviceGroup>>(
        DeviceGroupsNotifier.new);
