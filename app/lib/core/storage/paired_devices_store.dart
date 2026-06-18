// Persistent registry of paired devices.
//
// Companion to BondStore, BondStore keeps the *secret* (32-byte token,
// in flutter_secure_storage), this store keeps the *user-visible
// metadata* (name, prefix, pairedAt, last-known IP) so the home / devices
// list can render bonded devices without an active BLE/TCP session.
//
// Stored as a JSON array under a single SharedPreferences key.

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ble/device_type_visual.dart';
import '../cli/device_id.dart';
import 'preferences_provider.dart';

class PairedDevice {
  PairedDevice({
    required this.id,
    required this.name,
    required this.prefix,
    required this.pairedAt,
    this.customName,
    this.lastIp,
    this.lastPort,
    this.lastSeen,
  });

  final String id;
  final String name;
  final String prefix;
  final DateTime pairedAt;
  /// User-chosen alias, scoped to *this* SKAPP install only, never
  /// pushed to firmware. When set, takes the place of the product name
  /// in device cards. Null means "show product type as title".
  final String? customName;
  final String? lastIp;
  // Last TCP port the mDNS browser saw the device on. Persisted so a
  // cold-started SKAPP can skip the live mDNS resolve and try TCP first.
  final int? lastPort;
  final DateTime? lastSeen;

  PairedDevice copyWith({
    String? name,
    Object? customName = _sentinel,
    String? lastIp,
    int? lastPort,
    DateTime? lastSeen,
  }) =>
      PairedDevice(
        id: id,
        name: name ?? this.name,
        prefix: prefix,
        pairedAt: pairedAt,
        customName: identical(customName, _sentinel)
            ? this.customName
            : customName as String?,
        lastIp: lastIp ?? this.lastIp,
        lastPort: lastPort ?? this.lastPort,
        lastSeen: lastSeen ?? this.lastSeen,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'prefix': prefix,
        'pairedAt': pairedAt.toIso8601String(),
        if (customName != null) 'customName': customName,
        if (lastIp != null) 'lastIp': lastIp,
        if (lastPort != null) 'lastPort': lastPort,
        if (lastSeen != null) 'lastSeen': lastSeen!.toIso8601String(),
      };

  factory PairedDevice.fromJson(Map<String, dynamic> j) => PairedDevice(
        id: j['id'] as String,
        name: j['name'] as String,
        prefix: j['prefix'] as String,
        pairedAt: DateTime.parse(j['pairedAt'] as String),
        customName: j['customName'] as String?,
        lastIp: j['lastIp'] as String?,
        lastPort: (j['lastPort'] as num?)?.toInt(),
        lastSeen: j['lastSeen'] != null
            ? DateTime.parse(j['lastSeen'] as String)
            : null,
      );

  /// Human-readable product name from the two-letter [prefix]. Brand
  /// names are not translated (memory feedback_i18n_script_ids: device
  /// types are technical identifiers). Falls back to the raw prefix for
  /// future device families that don't yet have a friendly name. The
  /// table itself lives in DeviceTypeVisual so DiscoveredDevice (no
  /// PairedDevice wrapper yet) renders the same brand label.
  String get typeFullName => DeviceTypeVisual.friendlyName(prefix);

  /// `MS` (mobile SKAPP peer) is not a SmartKraft hardware device — it's
  /// a paired mobile phone running SKAPP. The Devices tab uses this to
  /// pick a different tile icon and to skip BF-specific actions
  /// (pairing wizard, OTA flash, etc.) for these entries.
  bool get isMobilePeer => prefix == 'MS';

  /// Primary label shown at the top of the device card. If the user has
  /// assigned a [customName] (e.g. "Calisma Odasi"), use it; otherwise
  /// fall back to the short form of the BLE name (`BF-A06` from
  /// `BF-A06TMFSQT`). Mobile peers keep their full pairing name (the
  /// phone's user-set node name) because there's no encoded short form
  /// to truncate. Full ID is rendered separately on the card so the
  /// user can still copy/recognize it.
  String get displayName {
    final custom = customName?.trim();
    if (custom != null && custom.isNotEmpty) return custom;
    if (isMobilePeer) return name;
    // Short form: prefix + first 4 chars of suffix → "BF-A06".
    final dash = name.indexOf('-');
    if (dash > 0 && name.length > dash + 5) {
      return name.substring(0, dash + 5);
    }
    return name;
  }

  /// [displayName] gibi ama SmartKraft kimliğini ASLA kısaltmaz: kullanıcı
  /// bir [customName] verdiyse onu, vermediyse tam advertised adı döner
  /// (örn. "BF-A06TMFSQT" — kısaltılmış "BF-A06" değil). Tam kimliğin
  /// önemli olduğu yerlerde kullanılır (çevrim dışı uyarı SnackBar'ı) ki
  /// kullanıcı mesajın tam olarak hangi cihaza ait olduğunu görebilsin.
  String get displayNameFull {
    final custom = customName?.trim();
    if (custom != null && custom.isNotEmpty) return custom;
    return name;
  }
}

const Object _sentinel = Object();

/// Resolves a raw identifier (BLE MAC or SmartKraft id, in any case) against
/// a list of paired devices. Replaces the case-insensitive + name fallback
/// chain the device-session resolver previously inlined, so every lookup
/// uses the same precedence: exact id, exact name, then case-insensitive id,
/// then case-insensitive name. Returns null when nothing matches.
extension PairedDeviceLookup on Iterable<PairedDevice> {
  PairedDevice? matchDeviceId(String rawId) {
    final lower = canonicalizeDeviceId(rawId);
    PairedDevice? ciMatch;
    for (final d in this) {
      if (d.id == rawId || d.name == rawId) return d;
      if (ciMatch == null &&
          (canonicalizeDeviceId(d.id) == lower ||
              canonicalizeDeviceId(d.name) == lower)) {
        ciMatch = d;
      }
    }
    return ciMatch;
  }
}

const _prefsKey = 'paired_devices_v1';

class PairedDevicesStore {
  PairedDevicesStore(this._prefs);
  final SharedPreferences _prefs;

  // Serializes read-modify-write mutations. SharedPreferences offers no
  // atomicity, so two concurrent touch()/upsert() calls could each read the
  // same list and the later write would clobber the earlier one; a freshly
  // upserted device could even vanish under a racing touch(). Chaining every
  // mutation through this future keeps the read-modify-write critical section
  // atomic without pulling in a mutex package.
  Future<void> _mutationLock = Future<void>.value();

  Future<T> _locked<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _mutationLock = _mutationLock.then((_) async {
      try {
        completer.complete(await action());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }

  List<PairedDevice> read() {
    final raw = _prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map(PairedDevice.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _write(List<PairedDevice> list) async {
    final encoded = jsonEncode(list.map((d) => d.toJson()).toList());
    await _prefs.setString(_prefsKey, encoded);
  }

  Future<void> upsert(PairedDevice device) => _locked(() async {
        final list = [...read()];
        final i = list.indexWhere((d) => d.id == device.id);
        if (i >= 0) {
          list[i] = device;
        } else {
          list.add(device);
        }
        await _write(list);
      });

  Future<void> touch(String id, {String? lastIp, int? lastPort}) =>
      _locked(() async {
        final list = [...read()];
        final i = list.indexWhere((d) => d.id == id);
        if (i < 0) return;
        list[i] = list[i].copyWith(
          lastIp: lastIp ?? list[i].lastIp,
          lastPort: lastPort ?? list[i].lastPort,
          lastSeen: DateTime.now(),
        );
        await _write(list);
      });

  Future<void> setCustomName(String id, String? customName) =>
      _locked(() async {
        final list = [...read()];
        final i = list.indexWhere((d) => d.id == id);
        if (i < 0) return;
        final trimmed = customName?.trim();
        list[i] = list[i].copyWith(
          customName: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
        );
        await _write(list);
      });

  /// Drops the cached `lastIp`/`lastPort` for [id]. Called by the session
  /// provider after a TCP cache attempt fails so the next connect skips
  /// the dead endpoint and goes straight to mDNS resolve. The mDNS
  /// browser repopulates these on its next sweep.
  Future<void> clearLastEndpoint(String id) => _locked(() async {
        final list = [...read()];
        final i = list.indexWhere((d) => d.id == id);
        if (i < 0) return;
        final d = list[i];
        if (d.lastIp == null && d.lastPort == null) return;
        list[i] = PairedDevice(
          id: d.id,
          name: d.name,
          prefix: d.prefix,
          pairedAt: d.pairedAt,
          customName: d.customName,
          lastSeen: d.lastSeen,
          // lastIp/lastPort omitted → cleared
        );
        await _write(list);
      });

  Future<void> remove(String id) => _locked(() async {
        final list = read().where((d) => d.id != id).toList();
        await _write(list);
      });

  /// Reset Pairings / Factory Reset için: tüm paired device kayıtlarını
  /// siler. Bond store / bindings cascade'i çağıran tarafa (ResetService)
  /// aittir; bu metod sadece kendi store'unu temizler.
  Future<void> clearAll() => _locked(() async {
        await _write(const []);
      });

  PairedDevice? findById(String id) {
    for (final d in read()) {
      if (d.id == id) return d;
    }
    return null;
  }
}

class PairedDevicesNotifier extends Notifier<List<PairedDevice>> {
  late final PairedDevicesStore _store;

  @override
  List<PairedDevice> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    _store = PairedDevicesStore(prefs);
    return _store.read();
  }

  Future<void> upsert(PairedDevice d) async {
    await _store.upsert(d);
    state = _store.read();
  }

  Future<void> touch(String id, {String? lastIp, int? lastPort}) async {
    await _store.touch(id, lastIp: lastIp, lastPort: lastPort);
    state = _store.read();
  }

  Future<void> setCustomName(String id, String? customName) async {
    await _store.setCustomName(id, customName);
    state = _store.read();
  }

  Future<void> clearLastEndpoint(String id) async {
    await _store.clearLastEndpoint(id);
    state = _store.read();
  }

  Future<void> remove(String id) async {
    await _store.remove(id);
    state = _store.read();
  }

  Future<void> clearAll() async {
    await _store.clearAll();
    state = const [];
  }
}

final pairedDevicesProvider =
    NotifierProvider<PairedDevicesNotifier, List<PairedDevice>>(
        PairedDevicesNotifier.new);
