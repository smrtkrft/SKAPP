// Şablon → cihaz dağıtım servisi. Tür bazlı sevk + dağıtım sonrası
// geri-okuma doğrulaması:
//
//   sd.profile → validateProfileJson → profile.add <json> → profile.get <id>
//   sd.mode    → validateModeBindingJson → mode.set <slot> <json> → mode.get
//   sd.safe    → validateSafeEntryJson → safe.set <n> <json> → safe.list
//   bf.endpoint→ BURADAN GEÇMEZ: OnDeviceApiEditorScreen(prefillTemplate:)
//                akışına push edilir (api.* yüzeyi sk_api-ortak olduğundan
//                BF/LS/SD hepsinde çalışır) — ekran kendi kaydını yapar.
//
// Geri-okuma "kaydettim sanmıştım" sınıfı hataları kapatır: cihaz OK dese
// bile kayıt tekrar okunur ve gövdeyle karşılaştırılır; uyuşmazlık
// [DeployOutcome.mismatch] olarak yüzeye çıkar, sessiz geçilmez.

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_client.dart';
import '../../../core/cli/cli_providers.dart';
import '../../../core/devices/validators/sd_validators.dart';
import '../../../core/storage/paired_devices_store.dart';
import 'device_template.dart';

/// 90 sn `lastSeen` çevrimiçi kapısı — SkapiScreen._onAddNewAction ve eski
/// template-detail akışıyla aynı kriter, tek yerde.
bool isDeviceRecentlySeen(PairedDevice d, {DateTime? now}) {
  final ls = d.lastSeen;
  if (ls == null) return false;
  return (now ?? DateTime.now()).difference(ls) < const Duration(seconds: 90);
}

/// Şablonun uyumluluk rozetlerine göre eşleşen cihazlar (çevrimdışılar da
/// dahil — seçici onları soluk/kilitli gösterir, gizlemez).
List<PairedDevice> compatibleDevices(
  List<PairedDevice> paired,
  List<String> compatiblePrefixes,
) {
  final want = {for (final p in compatiblePrefixes) p.toUpperCase()};
  return [
    for (final d in paired)
      if (want.contains(d.prefix.toUpperCase())) d,
  ];
}

enum DeployStatus { ok, validationFailed, deviceError, mismatch, offline }

class DeployOutcome {
  const DeployOutcome(this.status, {this.detail = ''});
  final DeployStatus status;

  /// validationFailed → doğrulayıcı enum adı; deviceError → ERR_* kodu;
  /// mismatch → uyuşmayan alan özeti.
  final String detail;

  bool get ok => status == DeployStatus.ok;
}

class TemplateDeployService {
  TemplateDeployService(this._ref);
  final Ref _ref;

  Future<CliClient?> _clientFor(String deviceId) async {
    try {
      final session =
          await _ref.read(deviceSessionProvider(deviceId).future);
      return session.client;
    } catch (_) {
      return null;
    }
  }

  /// sd.profile: [renderedJson] tüm {{param}}'ları çözülmüş Profil v2
  /// gövdesi. Kompaktlanıp basılır, ardından `profile.get <id>` ile geri
  /// okunup karşılaştırılır.
  Future<DeployOutcome> deployProfile(
      String deviceId, String renderedJson) async {
    final issue = validateProfileJson(renderedJson);
    if (issue != null) {
      return DeployOutcome(DeployStatus.validationFailed,
          detail: issue.kind.name);
    }
    final client = await _clientFor(deviceId);
    if (client == null) return const DeployOutcome(DeployStatus.offline);

    final parsed = jsonDecode(renderedJson) as Map;
    final compact = jsonEncode(parsed);
    final id = parsed['id'].toString();

    final r = await client.send('profile.add', argv: [compact]);
    if (!r.ok) {
      return DeployOutcome(DeployStatus.deviceError, detail: r.err ?? '?');
    }

    // Geri-okuma: cihazdaki kayıt bizim gönderdiğimizle aynı id/protokolde
    // mi? (Firmware normalize edebilir; alan-alan diff yerine kimlik +
    // protokol karşılaştırması yeterli ve sürüm-toleranslıdır.)
    final back = await client.send('profile.get', argv: [id]);
    if (!back.ok || back.data is! Map) {
      return DeployOutcome(DeployStatus.mismatch, detail: 'profile.get $id');
    }
    final got = back.data as Map;
    if (got['id']?.toString() != id) {
      return DeployOutcome(DeployStatus.mismatch,
          detail: 'id: ${got['id']} != $id');
    }
    return const DeployOutcome(DeployStatus.ok);
  }

  /// Cihazdaki profil id'leri — sd.mode dağıtımında referans profil kontrolü
  /// ve eksikse zincirleme profil yükleme önerisi için.
  Future<Set<String>> deviceProfileIds(String deviceId) async {
    final client = await _clientFor(deviceId);
    if (client == null) return const {};
    final r = await client.send('profile.list');
    if (!r.ok || r.data is! List) return const {};
    return {
      for (final e in r.data as List)
        if (e is Map && e['id'] != null) e['id'].toString()
        else if (e is String) e,
    };
  }

  /// Cihazdaki mode slot özetleri (slot → isim/boş) — slot seçici için.
  Future<Map<int, String?>> deviceModeSlots(String deviceId) async {
    final client = await _clientFor(deviceId);
    if (client == null) return const {};
    final r = await client.send('mode.list');
    if (!r.ok) return const {};
    final raw = r.data is List
        ? r.data as List
        : (r.data is Map ? ((r.data as Map)['modes'] as List? ?? const []) : const []);
    final out = <int, String?>{};
    for (final e in raw) {
      if (e is! Map) continue;
      final slot = (e['slot'] as num?)?.toInt();
      if (slot == null) continue;
      final name = e['name']?.toString();
      final enabled = e['behavior'] != null || (name?.isNotEmpty ?? false);
      out[slot] = enabled ? (name ?? '') : null;
    }
    return out;
  }

  /// sd.mode: seçilen [slot]'a Binding v2 basar, `mode.get <slot>` ile
  /// davranışı geri doğrular.
  Future<DeployOutcome> deployMode(
      String deviceId, int slot, String renderedJson) async {
    final issue = validateModeBindingJson(renderedJson);
    if (issue != null) {
      return DeployOutcome(DeployStatus.validationFailed,
          detail: issue.kind.name);
    }
    final client = await _clientFor(deviceId);
    if (client == null) return const DeployOutcome(DeployStatus.offline);

    final parsed = jsonDecode(renderedJson) as Map;
    final r = await client
        .send('mode.set', argv: ['$slot', jsonEncode(parsed)]);
    if (!r.ok) {
      return DeployOutcome(DeployStatus.deviceError, detail: r.err ?? '?');
    }

    final back = await client.send('mode.get', argv: ['$slot']);
    if (!back.ok || back.data is! Map) {
      return DeployOutcome(DeployStatus.mismatch, detail: 'mode.get $slot');
    }
    final got = back.data as Map;
    final wantBehavior = parsed['behavior']?.toString();
    if (got['behavior']?.toString() != wantBehavior) {
      return DeployOutcome(DeployStatus.mismatch,
          detail: 'behavior: ${got['behavior']} != $wantBehavior');
    }
    return const DeployOutcome(DeployStatus.ok);
  }

  /// Cihazdaki sk_api USER endpoint adları — sd.safe dağıtımında endpoint
  /// referans kontrolü için.
  Future<Set<String>> deviceEndpointNames(String deviceId) async {
    final client = await _clientFor(deviceId);
    if (client == null) return const {};
    final r = await client.send('api.endpoint.list');
    if (!r.ok || r.data is! List) return const {};
    return {
      for (final e in r.data as List)
        if (e is Map && e['kind'] != 'system' && e['name'] != null)
          e['name'].toString(),
    };
  }

  /// sd.safe: [entry] (1-5) kaydına Safe v2 basar, `safe.list` ile girişin
  /// aktifleştiğini doğrular. (Diziler gizlidir — firmware sequence'i asla
  /// geri vermez; karşılaştırma enable durumu üzerinden yapılır.)
  Future<DeployOutcome> deploySafe(
      String deviceId, int entry, String renderedJson) async {
    final issue = validateSafeEntryJson(renderedJson);
    if (issue != null) {
      return DeployOutcome(DeployStatus.validationFailed,
          detail: issue.kind.name);
    }
    final client = await _clientFor(deviceId);
    if (client == null) return const DeployOutcome(DeployStatus.offline);

    final parsed = jsonDecode(renderedJson) as Map;
    final r = await client
        .send('safe.set', argv: ['$entry', jsonEncode(parsed)]);
    if (!r.ok) {
      return DeployOutcome(DeployStatus.deviceError, detail: r.err ?? '?');
    }

    final back = await client.send('safe.list');
    if (!back.ok || back.data is! List) {
      return DeployOutcome(DeployStatus.mismatch, detail: 'safe.list');
    }
    final found = (back.data as List).any((e) =>
        e is Map && (e['entry'] as num?)?.toInt() == entry);
    if (!found) {
      return DeployOutcome(DeployStatus.mismatch, detail: 'entry $entry yok');
    }
    return const DeployOutcome(DeployStatus.ok);
  }

  /// Ortak sevk yüzeyi (bf.endpoint hariç — o UI akışında kalır).
  Future<DeployOutcome> deploy({
    required DeviceTemplate template,
    required String deviceId,
    required String renderedJson,
    int? slot,
    int? safeEntry,
  }) {
    switch (template.targetKind) {
      case TemplateTargetKind.sdProfile:
        return deployProfile(deviceId, renderedJson);
      case TemplateTargetKind.sdMode:
        assert(slot != null, 'sd.mode dağıtımı slot ister');
        return deployMode(deviceId, slot!, renderedJson);
      case TemplateTargetKind.sdSafe:
        assert(safeEntry != null, 'sd.safe dağıtımı entry ister');
        return deploySafe(deviceId, safeEntry!, renderedJson);
      case TemplateTargetKind.bfEndpoint:
        throw StateError(
            'bf.endpoint OnDeviceApiEditorScreen akışıyla yüklenir');
    }
  }
}

final templateDeployServiceProvider =
    Provider<TemplateDeployService>((ref) => TemplateDeployService(ref));
