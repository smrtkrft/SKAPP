import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/preferences_provider.dart';
import 'device_template.dart';
import 'script_manifest.dart';

/// Kullanıcının kendi cihaz şablonu — bundled bir [DeviceTemplate]'ten
/// "Şablonlarıma kopyala" ile türetilir ya da sıfırdan yazılır. Başlık ve
/// özet düz metindir (çeviri boru hattı yok); `resolveSkapiI18nKey`
/// bilinmeyen anahtarı olduğu gibi döndürdüğü için bundled şablonlarla
/// aynı ekranlarda render edilir. [UserScript]/[UserScriptStore] deseninin
/// birebir aynasıdır.
class UserTemplate {
  const UserTemplate({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.targetKind,
    required this.compatiblePrefixes,
    required this.createdAtMs,
    required this.updatedAtMs,
    this.params = const [],
    this.endpointJson,
    this.jsonBody,
    this.sourceTemplateId,
  });

  /// Kararlı id, örn `usertpl-1716998400000`.
  final String id;

  final String title;
  final String summary;
  final String category;
  final TemplateTargetKind targetKind;
  final List<String> compatiblePrefixes;
  final int createdAtMs;
  final int updatedAtMs;

  final List<TemplateParam> params;

  /// bf.endpoint türü: gömülü ApiTemplateManifest'in ham JSON'u (kopyalanan
  /// bundled asset gövdesi). Model yerine ham JSON saklanır — manifest
  /// alanları büyüdüğünde eski kayıtlar veri kaybetmeden geçer.
  final String? endpointJson;

  /// sd.* türleri: cihaza gidecek JSON gövdesi.
  final String? jsonBody;

  /// Kopyalandığı bundled şablonun id'si (sıfırdan yazıldıysa null).
  final String? sourceTemplateId;

  UserTemplate copyWith({
    String? title,
    String? summary,
    String? category,
    List<TemplateParam>? params,
    String? endpointJson,
    String? jsonBody,
    int? updatedAtMs,
  }) =>
      UserTemplate(
        id: id,
        title: title ?? this.title,
        summary: summary ?? this.summary,
        category: category ?? this.category,
        targetKind: targetKind,
        compatiblePrefixes: compatiblePrefixes,
        createdAtMs: createdAtMs,
        updatedAtMs: updatedAtMs ?? this.updatedAtMs,
        params: params ?? this.params,
        endpointJson: endpointJson ?? this.endpointJson,
        jsonBody: jsonBody ?? this.jsonBody,
        sourceTemplateId: sourceTemplateId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'category': category,
        'targetKind': targetKindWire(targetKind),
        'compatiblePrefixes': compatiblePrefixes,
        'createdAtMs': createdAtMs,
        'updatedAtMs': updatedAtMs,
        'params': [for (final p in params) p.toJson()],
        if (endpointJson != null) 'endpointJson': endpointJson,
        if (jsonBody != null) 'jsonBody': jsonBody,
        if (sourceTemplateId != null) 'sourceTemplateId': sourceTemplateId,
      };

  factory UserTemplate.fromJson(Map<String, dynamic> j) => UserTemplate(
        id: j['id'] as String,
        title: (j['title'] ?? '') as String,
        summary: (j['summary'] ?? '') as String,
        category: (j['category'] ?? 'webhook') as String,
        targetKind: targetKindFromWire(j['targetKind'] as String?) ??
            TemplateTargetKind.bfEndpoint,
        compatiblePrefixes:
            (j['compatiblePrefixes'] as List?)?.cast<String>() ?? const ['SD'],
        createdAtMs: (j['createdAtMs'] as num?)?.toInt() ?? 0,
        updatedAtMs: (j['updatedAtMs'] as num?)?.toInt() ?? 0,
        params: [
          for (final p in (j['params'] as List?) ?? const [])
            TemplateParam.fromJson((p as Map).cast<String, dynamic>()),
        ],
        endpointJson: j['endpointJson'] as String?,
        jsonBody: j['jsonBody'] as String?,
        sourceTemplateId: j['sourceTemplateId'] as String?,
      );

  /// Bundled şablondan düzenlenebilir kopya üretir. Başlık/özet literal
  /// metin olarak ekranda çözülmüş halleriyle kopyalanır — çağıran
  /// `resolveSkapiI18nKey` sonucunu verir.
  factory UserTemplate.fromDeviceTemplate(
    DeviceTemplate tpl, {
    required String resolvedTitle,
    required String resolvedSummary,
    required int nowMs,
  }) =>
      UserTemplate(
        id: 'usertpl-$nowMs',
        title: resolvedTitle,
        summary: resolvedSummary,
        category: tpl.category,
        targetKind: tpl.targetKind,
        compatiblePrefixes: tpl.compatiblePrefixes,
        createdAtMs: nowMs,
        updatedAtMs: nowMs,
        params: tpl.params,
        endpointJson: null, // bf.endpoint kopyaları için aşağıya bak
        jsonBody: tpl.jsonBody,
        sourceTemplateId: tpl.id,
      );

  /// Ortak ekranlar [DeviceTemplate] tüketir; kullanıcı kaydı görüntüleme
  /// için o modele projekte edilir.
  DeviceTemplate toDeviceTemplate() => DeviceTemplate(
        id: id,
        schemaVersion: 1,
        category: category,
        targetKind: targetKind,
        compatiblePrefixes: compatiblePrefixes,
        i18nTitle: title,
        i18nSummary: summary,
        params: params,
        endpoint: endpointJson == null
            ? null
            : ApiTemplateManifest.decode(endpointJson!),
        jsonBody: jsonBody,
      );
}

/// Tek anahtar altında JSON dizisi — [UserScriptStore] ile aynı sözleşme.
class UserTemplateStore {
  UserTemplateStore(this._prefs);
  final SharedPreferences _prefs;

  static const _kKey = 'skapi.userTemplates.v1';

  List<UserTemplate> read() {
    final raw = _prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return [
        for (final e in list)
          if (e is Map) UserTemplate.fromJson(e.cast<String, dynamic>()),
      ];
    } catch (_) {
      // Bozuk kayıt: sekmeyi düşürmek yerine temiz başla.
      return const [];
    }
  }

  Future<List<UserTemplate>> _write(List<UserTemplate> next) async {
    await _prefs.setString(
      _kKey,
      jsonEncode([for (final t in next) t.toJson()]),
    );
    return next;
  }

  Future<List<UserTemplate>> upsert(UserTemplate tpl) {
    final current = read();
    final idx = current.indexWhere((t) => t.id == tpl.id);
    final next = [...current];
    if (idx >= 0) {
      next[idx] = tpl;
    } else {
      next.insert(0, tpl);
    }
    return _write(next);
  }

  Future<List<UserTemplate>> remove(String id) {
    final next = read().where((t) => t.id != id).toList(growable: false);
    return _write(next);
  }

  Future<void> clear() => _prefs.remove(_kKey);
}

final userTemplateStoreProvider = Provider<UserTemplateStore>((ref) {
  return UserTemplateStore(ref.watch(sharedPreferencesProvider));
});

class UserTemplatesNotifier extends Notifier<List<UserTemplate>> {
  @override
  List<UserTemplate> build() => ref.watch(userTemplateStoreProvider).read();

  Future<void> upsert(UserTemplate tpl) async {
    state = await ref.read(userTemplateStoreProvider).upsert(tpl);
  }

  Future<void> remove(String id) async {
    state = await ref.read(userTemplateStoreProvider).remove(id);
  }

  UserTemplate? byId(String id) {
    for (final t in state) {
      if (t.id == id) return t;
    }
    return null;
  }
}

final userTemplatesProvider =
    NotifierProvider<UserTemplatesNotifier, List<UserTemplate>>(
        UserTemplatesNotifier.new);
