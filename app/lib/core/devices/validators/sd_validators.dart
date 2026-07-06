// SynDimm saf doğrulayıcılar — ekran state'lerinden AYRIŞTIRILDI ki birim
// testlenebilsinler (test/features/sd/sd_validators_test.dart; bundled
// katalog/şablon JSON'ları da aynı testte bu kurallardan geçer). Kurallar
// firmware aynasıdır: son söz her zaman cihazındır.
//
// Faz B'de features/devices/sd/ altından core/devices/validators/ altına
// taşındı: SKAPI şablon dağıtım servisi de aynı kuralları kullanır ve
// feature'lar core'a bağımlı olur (skapi → devices/sd yan bağımlılığı
// oluşmaz).

import 'dart:convert';

/// Profil v2 JSON kuralları (firmware sd_profiles_validate.c aynası):
/// boş değil, ≤2048 B, geçerli JSON nesnesi, id [A-Za-z0-9_-] ≤15, v == 2.
enum SdProfileJsonError { empty, tooBig, invalidJson, notObject, idRequired, idFormat, version }

/// Hata + serbest detay (yalnız [SdProfileJsonError.invalidJson] doldurur).
typedef SdProfileJsonIssue = ({SdProfileJsonError kind, String detail});

SdProfileJsonIssue? validateProfileJson(String raw) {
  if (raw.trim().isEmpty) {
    return (kind: SdProfileJsonError.empty, detail: '');
  }
  if (utf8.encode(raw).length > 2048) {
    return (kind: SdProfileJsonError.tooBig, detail: '');
  }
  dynamic parsed;
  try {
    parsed = jsonDecode(raw);
  } catch (e) {
    return (kind: SdProfileJsonError.invalidJson, detail: e.toString());
  }
  if (parsed is! Map) {
    return (kind: SdProfileJsonError.notObject, detail: '');
  }
  final id = parsed['id']?.toString() ?? '';
  if (id.isEmpty) {
    return (kind: SdProfileJsonError.idRequired, detail: '');
  }
  if (id.length > 15 || !RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(id)) {
    return (kind: SdProfileJsonError.idFormat, detail: '');
  }
  if (parsed['v'] != 2) {
    return (kind: SdProfileJsonError.version, detail: '');
  }
  return null;
}

/// Kasa dizisi kuralları (firmware sd_sequence aynası, ürün kararı
/// 2026-07-03): L/R + 1-50 tık, "-" ayraç, kuyrukta isteğe bağlı B (segment
/// SAYILMAZ — firmware parse'ı da yutar); 3-6 segment.
enum SdSafeSequenceError { required, format, tooShort, tooLong }

SdSafeSequenceError? validateSafeSequence(String input) {
  final seq = input.trim().toUpperCase();
  if (seq.isEmpty) return SdSafeSequenceError.required;
  final re = RegExp(r'^([LR][1-9][0-9]?)(-([LR][1-9][0-9]?))*(-B)?$');
  if (!re.hasMatch(seq)) return SdSafeSequenceError.format;
  final parts = seq.split('-').where((p) => p != 'B').toList(growable: false);
  if (parts.length < 3) return SdSafeSequenceError.tooShort;
  if (parts.length > 6) return SdSafeSequenceError.tooLong;
  for (final p in parts) {
    final ticks = int.tryParse(p.substring(1)) ?? 0;
    if (ticks < 1 || ticks > 50) return SdSafeSequenceError.format;
  }
  return null;
}

/// Binding v2 (mode.set gövdesi) kuralları — SD_CLI_KOMUTLARI.md aynası:
/// geçerli JSON nesnesi, v == 2, behavior ∈ {dimmer, shutter, safe,
/// mqtt_remote}. mqtt_remote dışındaki davranışlarda en az bir hedef
/// (targets[].host) beklenir; mqtt_remote broker'ı params'tan alır.
enum SdModeJsonError {
  empty,
  invalidJson,
  notObject,
  version,
  behaviorRequired,
  behaviorUnknown,
  targetRequired,
}

typedef SdModeJsonIssue = ({SdModeJsonError kind, String detail});

const _kSdBehaviors = {'dimmer', 'shutter', 'safe', 'mqtt_remote'};

SdModeJsonIssue? validateModeBindingJson(String raw) {
  if (raw.trim().isEmpty) {
    return (kind: SdModeJsonError.empty, detail: '');
  }
  dynamic parsed;
  try {
    parsed = jsonDecode(raw);
  } catch (e) {
    return (kind: SdModeJsonError.invalidJson, detail: e.toString());
  }
  if (parsed is! Map) {
    return (kind: SdModeJsonError.notObject, detail: '');
  }
  if (parsed['v'] != 2) {
    return (kind: SdModeJsonError.version, detail: '');
  }
  final behavior = parsed['behavior']?.toString() ?? '';
  if (behavior.isEmpty) {
    return (kind: SdModeJsonError.behaviorRequired, detail: '');
  }
  if (!_kSdBehaviors.contains(behavior)) {
    return (kind: SdModeJsonError.behaviorUnknown, detail: behavior);
  }
  if (behavior != 'mqtt_remote' && behavior != 'safe') {
    final targets = parsed['targets'];
    final hasHost = targets is List &&
        targets.any((t) =>
            t is Map && (t['host']?.toString().isNotEmpty ?? false));
    if (!hasHost) {
      return (kind: SdModeJsonError.targetRequired, detail: '');
    }
  }
  return null;
}

/// Safe v2 (safe.set gövdesi) kuralları: geçerli JSON nesnesi, v == 2,
/// sequence [validateSafeSequence]'ten geçer, endpoint adı boş değil.
enum SdSafeJsonError {
  empty,
  invalidJson,
  notObject,
  version,
  sequence,
  endpointRequired,
}

typedef SdSafeJsonIssue = ({SdSafeJsonError kind, String detail});

SdSafeJsonIssue? validateSafeEntryJson(String raw) {
  if (raw.trim().isEmpty) {
    return (kind: SdSafeJsonError.empty, detail: '');
  }
  dynamic parsed;
  try {
    parsed = jsonDecode(raw);
  } catch (e) {
    return (kind: SdSafeJsonError.invalidJson, detail: e.toString());
  }
  if (parsed is! Map) {
    return (kind: SdSafeJsonError.notObject, detail: '');
  }
  if (parsed['v'] != 2) {
    return (kind: SdSafeJsonError.version, detail: '');
  }
  final seqErr = validateSafeSequence(parsed['sequence']?.toString() ?? '');
  if (seqErr != null) {
    return (kind: SdSafeJsonError.sequence, detail: seqErr.name);
  }
  if ((parsed['endpoint']?.toString() ?? '').isEmpty) {
    return (kind: SdSafeJsonError.endpointRequired, detail: '');
  }
  return null;
}
