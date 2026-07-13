import 'dart:convert';

import 'script_manifest.dart';

// ---------------------------------------------------------------------------
// Cihaz Şablonları — kategori bazlı, cihaz-rozetli şablon modeli.
//
// Eski cihaz-bazlı "Other" kategorilerinin (other-syndimm, other-bf, ...)
// yerine geçen tek kütüphanenin veri modeli. Bir şablon dört hedef türünden
// birine yüklenir:
//
//   bf.endpoint → api.endpoint.add   (sk_api ortak — BF/LS/SD hepsi kabul
//                                      eder; ApiTemplateManifest gömülüdür,
//                                      OnDeviceApiEditorScreen prefill
//                                      sözleşmesi değişmeden çalışır)
//   sd.profile  → profile.add        (Profile v2 hedef-cihaz sürücüsü)
//   sd.mode     → mode.set <slot>    (Binding v2 slot bağlama)
//   sd.safe     → safe.set <1-5>     (kombinasyon kilidi kaydı)
//
// İki yer tutucu katmanı (template_render.dart ile aynı sözleşme):
//   {{param}}  — çift süslü, yüklemeden ÖNCE app'te form değerleriyle çözülür
//   {token}    — tek süslü, cihazda ateşleme anında çözülür; dokunulmaz
// ---------------------------------------------------------------------------

/// Hangi CLI yüzeyine yüklendiğini belirler. Wire string'leri asset
/// JSON'larında ve UserTemplate kayıtlarında kullanılır.
enum TemplateTargetKind { bfEndpoint, sdProfile, sdMode, sdSafe }

String targetKindWire(TemplateTargetKind k) => switch (k) {
      TemplateTargetKind.bfEndpoint => 'bf.endpoint',
      TemplateTargetKind.sdProfile => 'sd.profile',
      TemplateTargetKind.sdMode => 'sd.mode',
      TemplateTargetKind.sdSafe => 'sd.safe',
    };

TemplateTargetKind? targetKindFromWire(String? s) => switch (s) {
      'bf.endpoint' => TemplateTargetKind.bfEndpoint,
      'sd.profile' => TemplateTargetKind.sdProfile,
      'sd.mode' => TemplateTargetKind.sdMode,
      'sd.safe' => TemplateTargetKind.sdSafe,
      _ => null,
    };

/// Kütüphanenin üst düzey gezinme bölümleri. Sıra ekrandaki bölüm sırasıdır;
/// firmware Profile v2 `behaviors` değerleriyle (dimmer/shutter) hizalıdır.
const List<String> kTemplateCategories = [
  'dimmer',
  'shutter',
  'webhook',
  'mqtt',
];

/// Şablonun kullanıcıdan istediği tek değer. [ApiTemplateParam]'ın üst
/// kümesi: tip/enum/aralık bilgisi form alanının nasıl çizileceğini söyler.
class TemplateParam {
  const TemplateParam({
    required this.name,
    required this.placeholder,
    required this.i18nLabel,
    this.i18nHint,
    this.type = 'string',
    this.allowedValues,
    this.min,
    this.max,
    this.defaultValue,
    this.secret = false,
    this.required = true,
  });

  /// Param anahtarı, kebab-case (örn `host`, `ifttt-key`).
  final String name;

  /// jsonBody / url şablonlarında geçen tam yer tutucu (örn `{{host}}`).
  final String placeholder;

  final String i18nLabel;
  final String? i18nHint;

  /// `string` | `int` | `enum` | `bool` | `host` | `secret`.
  /// `enum` → dropdown ([allowedValues]), `int` → sayısal klavye + min/max,
  /// `host` → IP/hostname klavyesi, `secret` → gizli giriş.
  final String type;

  final List<String>? allowedValues;
  final double? min;
  final double? max;

  /// Boş olmayan varsayılan form alanını önceden doldurur; secret'lar
  /// varsayılansız gelir ki alan boş başlasın.
  final String? defaultValue;

  final bool secret;

  /// Zorunlu paramlar dolmadan dağıtım kapalıdır; opsiyoneller boş
  /// bırakılırsa yer tutucu satırı şablondan olduğu gibi geçer ve
  /// doğrulayıcı karar verir.
  final bool required;

  factory TemplateParam.fromJson(Map<String, dynamic> j) => TemplateParam(
        name: j['name'] as String,
        placeholder: j['placeholder'] as String? ?? '{{${j['name']}}}',
        i18nLabel: j['i18nLabel'] as String? ?? j['name'] as String,
        i18nHint: j['i18nHint'] as String?,
        type: j['type'] as String? ?? 'string',
        allowedValues: (j['allowedValues'] as List?)?.cast<String>(),
        min: (j['min'] as num?)?.toDouble(),
        max: (j['max'] as num?)?.toDouble(),
        defaultValue: j['default']?.toString(),
        secret: j['secret'] as bool? ?? false,
        required: j['required'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'placeholder': placeholder,
        'i18nLabel': i18nLabel,
        if (i18nHint != null) 'i18nHint': i18nHint,
        'type': type,
        if (allowedValues != null) 'allowedValues': allowedValues,
        if (min != null) 'min': min,
        if (max != null) 'max': max,
        if (defaultValue != null) 'default': defaultValue,
        'secret': secret,
        'required': required,
      };
}

/// Bir cihaz şablonu: bundled asset (`assets/skapi/templates/<id>.json`)
/// veya kullanıcı kopyası (UserTemplate). Bundled şablonlarda i18n alanları
/// çeviri anahtarıdır; kullanıcı kopyalarında düz metindir —
/// `resolveSkapiI18nKey` bilinmeyen anahtarı olduğu gibi döndürdüğü için
/// iki tür de aynı ekranlarda render edilir.
class DeviceTemplate {
  const DeviceTemplate({
    required this.id,
    required this.schemaVersion,
    required this.category,
    required this.targetKind,
    required this.compatiblePrefixes,
    required this.i18nTitle,
    required this.i18nSummary,
    this.i18nNote,
    this.params = const [],
    this.endpoint,
    this.jsonBody,
    this.manufacturer,
    this.source,
  });

  /// Kebab-case, katalog genelinde benzersiz; asset dosya adıyla eşleşir.
  final String id;

  final int schemaVersion;

  /// [kTemplateCategories] üyelerinden biri. Bilinmeyen kategori kütüphanede
  /// "diğer" bölümüne düşer (asset bozulmasında sessiz kaybolma olmasın).
  final String category;

  final TemplateTargetKind targetKind;

  /// Yüklenebilir cihaz aileleri (`SD`, `BF`, `LS`). Rozetleri ve cihaz
  /// seçicinin filtresini besler.
  final List<String> compatiblePrefixes;

  final String i18nTitle;
  final String i18nSummary;
  final String? i18nNote;

  final List<TemplateParam> params;

  /// targetKind == bfEndpoint: mevcut Madde-24 yapılandırması aynen gömülü.
  final ApiTemplateManifest? endpoint;

  /// targetKind == sd.*: cihaza gidecek ham JSON gövdesi ({{param}} yer
  /// tutucularıyla). Firmware `{token}`ları dokunulmadan geçer.
  final String? jsonBody;

  /// sd.profile sürücülerinde `jsonBody.manufacturer` (örn `Shelly`,
  /// `Tasmota`, `Generic`); kütüphanede Dimmer/Panjur'u üreticiye göre
  /// gruplamak için kullanılır. Modlarda (jsonBody string + {{param}}) yok →
  /// null (Genel kovasına düşer). Yalnızca gömülü obje biçiminden okunur;
  /// yer-tutuculu string asla jsonDecode edilmez.
  final String? manufacturer;

  /// Bundled sd.profile şablonlarında köken işareti
  /// (`SynDimm/Code/neue/profiles/<dosya>`); firmware deposu doğruluk
  /// kaynağıdır, senkron kopyanın nereden geldiğini belgeler.
  final String? source;

  factory DeviceTemplate.fromJson(Map<String, dynamic> j) {
    final kind = targetKindFromWire(j['targetKind'] as String?);
    if (kind == null) {
      throw FormatException('unknown targetKind: ${j['targetKind']}');
    }
    final i18n = (j['i18n'] as Map?)?.cast<String, dynamic>() ?? const {};
    final rawBody = j['jsonBody'];
    return DeviceTemplate(
      id: j['id'] as String,
      schemaVersion: (j['schemaVersion'] as num?)?.toInt() ?? 1,
      category: j['category'] as String? ?? 'webhook',
      targetKind: kind,
      compatiblePrefixes:
          (j['compatiblePrefixes'] as List?)?.cast<String>() ?? const ['SD'],
      i18nTitle: i18n['title'] as String? ?? j['id'] as String,
      i18nSummary: i18n['summary'] as String? ?? '',
      i18nNote: i18n['note'] as String?,
      params: [
        for (final p in (j['params'] as List?) ?? const [])
          TemplateParam.fromJson((p as Map).cast<String, dynamic>()),
      ],
      endpoint: kind == TemplateTargetKind.bfEndpoint
          ? ApiTemplateManifest.fromJson(j)
          : null,
      // jsonBody asset'te ya gömülü obje ya string olabilir — obje halinde
      // yazmak (özellikle profil sarmalarında) diff'lenebilirlik sağlar.
      jsonBody: rawBody == null
          ? null
          : (rawBody is String ? rawBody : jsonEncode(rawBody)),
      // manufacturer yalnızca gömülü obje (sürücü) biçiminden okunur; mod
      // gövdeleri {{param}} yer-tutuculu string olduğundan (geçersiz JSON)
      // decode edilmez, alan null kalır.
      manufacturer: rawBody is Map
          ? ((rawBody['manufacturer'] as String?)?.trim().isNotEmpty ?? false
              ? (rawBody['manufacturer'] as String).trim()
              : null)
          : null,
      source: j['source'] as String?,
    );
  }

  static DeviceTemplate decode(String s) =>
      DeviceTemplate.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
