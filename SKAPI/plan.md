# SKAPI — Flutter UI Render Planı

Bu dosya, SKAPI klasöründeki `.md` şablonlarının **SKAPP Flutter uygulaması içinde nasıl gösterileceğini** tanımlar.

İlgili: [architecture.md](architecture.md) §13 (şablon formatı).

---

## 1. Amaç

SKAPI içindeki `.md` dosyaları SKAPP'te şu yetenekleri sağlamalıdır:

1. **Browse edilebilir katalog** — kullanıcı tüm aksiyonları görür
2. **Aranabilir ve filtrelenebilir** — OS / kategori / risk seviyesine göre
3. **Detay görüntüsü** — markdown body render edilir
4. **Form'a dönüştürülür** — frontmatter'daki `params` otomatik form alanlarına dönüşür
5. **Test edilebilir** — anlık fire (manuel tetikleme)
6. **ESP32'ye yüklenebilir** — action olarak ESP32 cihazına gönderilir

---

## 2. Asset Bundling

### Klasör yapısı (Flutter projesi içinde)

```
skapp/
├── pubspec.yaml
├── lib/
└── assets/
    └── skapi/                    ← SKAPI repo'su submodule veya kopya olarak
        ├── architecture.md
        ├── plan.md
        ├── WIN/
        │   ├── start.md
        │   ├── volume.md
        │   ├── brightness.md
        │   └── ...
        ├── MAC/
        ├── LX/
        └── Other/
            ├── wiz/
            ├── shelly/
            └── ...
```

### pubspec.yaml

```yaml
flutter:
  assets:
    - assets/skapi/
    - assets/skapi/WIN/
    - assets/skapi/MAC/
    - assets/skapi/LX/
    - assets/skapi/Other/
    - assets/skapi/Other/wiz/
    - assets/skapi/Other/shelly/
```

### Yükleme stratejisi
- **MVP:** Asset olarak app içinde bundle. Yeni şablonlar app güncellemesi ile gelir.
- **Faz 3:** SKAPI Github repo'sundan online çekme + cache (versioned).

---

## 3. Şablon Format Sözleşmesi

### Frontmatter şeması

```yaml
---
id: string                   # benzersiz, kebab-case, dosya adıyla eşleşir
name: string                 # gösterilecek isim
category: enum               # audio | display | power | notification | input |
                             # window | network | smarthome | sensor | misc
os: [enum]                   # [win, mac, lx, other]
icon: string                 # Material icon adı veya path
risk: enum                   # safe | caution | destructive
                             # safe: veri kaybı yok, geri alınabilir
                             # caution: dikkat (örn. monitor off)
                             # destructive: shutdown, kill-app gibi
description: string          # bir cümle özet
params:                      # 0..n parametre
  - key: string              # endpoint body'sinde kullanılan
    label: string            # form label
    type: enum               # int | string | bool | ip | port | secret |
                             # color | duration | enum | file
    required: bool
    default: any
    min: number              # int / duration için
    max: number
    options: [string]        # type=enum için
    placeholder: string
endpoint:                    # tek HTTP isteği için
  method: GET|POST|PUT|DELETE
  path: string               # SKAPP base URL'e eklenir
  headers: { ... }
  body: { ... }              # {{key}} placeholder'ları çözülür
endpoints:                   # birden fazla istek gerekiyorsa
  - method: ...
    path: ...
---
```

### Body (Markdown)
- Açıklama, OS implementasyon notları, güvenlik notları, örnek kullanım
- `flutter_markdown` ile render edilir
- Code block'larda syntax highlight

### Placeholder çözümlemesi
- `{{key}}` → `params[].key` değerinden gelir
- Eksik veya geçersiz parametre → form validation hatası
- Çözüm zamanı: ESP32'ye yüklemeden önce SKAPP'te

---

## 4. Parser

### Paketler
- `yaml: ^3.x` — frontmatter parse
- `flutter_markdown: ^0.7.x` — body render
- `markdown: ^7.x` — custom extension'lar gerekirse

### Parser fonksiyonu (sözde kod)

```dart
class SkapiTemplate {
  String id, name, category, description;
  List<String> os;
  String icon, risk;
  List<SkapiParam> params;
  SkapiEndpoint endpoint;
  String markdownBody;
}

Future<SkapiTemplate> parseSkapiMd(String assetPath) async {
  final raw = await rootBundle.loadString(assetPath);
  final parts = raw.split('---');
  final frontmatter = loadYaml(parts[1]);
  final body = parts.sublist(2).join('---').trim();
  return SkapiTemplate.fromYaml(frontmatter, body);
}
```

### Discovery
Bir manifest dosyası `assets/skapi/manifest.json` tüm şablonları listeler:

```json
{
  "version": "1.0.0",
  "templates": [
    "WIN/volume.md",
    "WIN/brightness.md",
    "MAC/volume.md",
    "Other/wiz/turn-off.md"
  ]
}
```

Manifest, SKAPI repo'sunda bir build script ile otomatik üretilir.

---

## 5. UI Akışı

### A) Catalog Screen (Aksiyon Kataloğu)

```
┌─────────────────────────────────────────────────────────┐
│ ← Aksiyon Seç                              [🔍 Search]  │
├─────────────────────────────────────────────────────────┤
│ [Win] [Mac] [Linux] [IoT]    Kategori: [Tümü ▼]        │
├─────────────────────────────────────────────────────────┤
│ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│ │ 🔊       │ │ ☀        │ │ 🔔       │ │ 💡       │   │
│ │ Ses Ayar │ │ Parlaklık│ │ Bildirim │ │ Wiz Aç   │   │
│ │ #audio   │ │ #display │ │ #notif   │ │ #iot     │   │
│ │ ✓ safe   │ │ ✓ safe   │ │ ✓ safe   │ │ ✓ safe   │   │
│ └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
│ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│ │ ⏻        │ │ 🔒       │ │ ⏸        │ │ ...      │   │
│ │ Kapat    │ │ Kilitle  │ │ Mola Ver │ │          │   │
│ │ ⚠ destr. │ │ ✓ safe   │ │ ✓ safe   │ │          │   │
│ └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
└─────────────────────────────────────────────────────────┘
```

**Davranış:**
- Üstteki chip'lerle OS filtresi (multi-select)
- Kategori dropdown'ı
- Search bar ile isim/açıklama içinde arama
- Risk badge'i renklendirilir: yeşil/sarı/kırmızı
- Karta tıklayınca detay ekranı

### B) Detail Screen (Şablon Detayı)

```
┌─────────────────────────────────────────────────────────┐
│ ← Ses Seviyesini Ayarla                          ⋮     │
├─────────────────────────────────────────────────────────┤
│ Kategori: Audio        OS: Win/Mac/Lx     Risk: Safe   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ # Ne yapar                                               │
│ Ana ses seviyesini 0-100 arasında ayarlar.              │
│                                                          │
│ # OS implementasyonu                                     │
│ - Win: IAudioEndpointVolume COM                          │
│ - Mac: osascript -e "..."                                │
│ - Linux: pactl set-sink-volume                           │
│                                                          │
│ # Güvenlik                                               │
│ Veri kaybı yok. Geri alınabilir.                         │
│                                                          │
├─────────────────────────────────────────────────────────┤
│      [   Bu Aksiyonu Kullan   ]  [ Test Et ]            │
└─────────────────────────────────────────────────────────┘
```

**Davranış:**
- Markdown body `flutter_markdown` ile render
- Code block'lar, link'ler, tablolar desteklenir
- "Bu aksiyonu kullan" → Form Builder ekranına geçer
- "Test Et" → Form Builder + manuel fire modu

### C) Form Builder Screen (Parametre Doldurma)

```
┌─────────────────────────────────────────────────────────┐
│ ← Ses Seviyesini Ayarla — Yapılandır                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ Hedef Cihaz                                              │
│ ┌─────────────────────────────────────────────────┐    │
│ │ Cem'in iş laptop'u (192.168.1.50)            ▼ │    │
│ └─────────────────────────────────────────────────┘    │
│                                                          │
│ Seviye (0-100) *                                         │
│ ┌─────────────────────────────────────────────────┐    │
│ │ ━━━━━━━━━━━━●━━━━━━━━━━━━━━━━━━  50            │    │
│ └─────────────────────────────────────────────────┘    │
│                                                          │
├─────────────────────────────────────────────────────────┤
│  [ Test Et Şimdi ]    [ Kaydet ve ESP32'ye Yükle ]     │
└─────────────────────────────────────────────────────────┘
```

**Davranış:**
- "Hedef cihaz" dropdown: mDNS ile keşfedilen SKAPP cihazları + IoT cihazları
- Frontmatter `params`'a göre form alanları otomatik üretilir:
  - `int` → slider veya numeric input
  - `string` → TextField
  - `bool` → Switch
  - `ip` → TextField + IP regex validation
  - `secret` → obscured TextField
  - `color` → color picker
  - `duration` → süre seçici
  - `enum` → dropdown
- Required validation
- "Test Et Şimdi" → seçilen hedefe anlık HTTP isteği (kullanıcı sonucu görür)
- "Kaydet" → action olarak persist + ESP32'ye yükle

### D) Saved Actions Screen (Kayıtlı Aksiyonlar)

```
┌─────────────────────────────────────────────────────────┐
│ Aksiyonlarım                              [+ Yeni]      │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────┐│
│ │ 🌅 Sabah Rutini       ESP32: Yatak Odası      ▶  ⋮ ││
│ │   • Wiz lambası aç                                   ││
│ │   • Müzik başlat (laptop)                            ││
│ │   • Perdeleri aç                                     ││
│ └─────────────────────────────────────────────────────┘│
│ ┌─────────────────────────────────────────────────────┐│
│ │ ⏸ Mola Zamanı         ESP32: Çalışma Masası   ▶  ⋮ ││
│ │   • Laptop'a 60sn mola overlay'i                     ││
│ │   • Spotify durdur                                   ││
│ │   • Salon ışığı maviye dön                           ││
│ └─────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
```

**Davranış:**
- Her action grup'u (timer + action listesi) bir kart
- ▶ butonu → manuel tetikle (test)
- ⋮ → düzenle / sil / dışa aktar
- Yeni → Catalog'a yönlendirir

---

## 6. Lokalizasyon

### Strateji A — Çoklu dosya
- `volume.tr.md`, `volume.en.md`, `volume.de.md`
- Manifest dile göre filtreleme yapar
- **Avantaj:** Tam kontrol, doğal okunaklı
- **Dezavantaj:** Birden çok dosya bakımı

### Strateji B — i18n key referansı
```yaml
name_key: "templates.volume.name"
description_key: "templates.volume.description"
```
- ARB dosyalarında çeviriler
- **Avantaj:** Tek `.md` dosyası
- **Dezavantaj:** Body kısmı çevirisi karmaşık

**Karar (MVP):** Strateji A. Türkçe varsayılan, İngilizce ikincil. Body kısa ve net tutulur.

---

## 7. State Management

### Önerilen yaklaşım: Riverpod

```dart
// Şablon kütüphanesi (immutable, app start'ta yüklenir)
final skapiTemplatesProvider = FutureProvider<List<SkapiTemplate>>((ref) async {
  final manifest = await loadManifest();
  return Future.wait(manifest.templates.map(parseSkapiMd));
});

// Filtre state
final templateFilterProvider = StateProvider<TemplateFilter>((ref) =>
    TemplateFilter(os: {OS.win}, category: null, search: ''));

// Filtrelenmiş liste
final filteredTemplatesProvider = Provider<List<SkapiTemplate>>((ref) {
  final templates = ref.watch(skapiTemplatesProvider).valueOrNull ?? [];
  final filter = ref.watch(templateFilterProvider);
  return templates.where(filter.matches).toList();
});

// Kullanıcının kayıtlı aksiyonları (persist)
final savedActionsProvider = StateNotifierProvider<...>(...);
```

### Persistence
- **Kayıtlı action'lar:** SQLite (`drift` paketi) veya `hive`
- **Ayarlar:** `shared_preferences`
- **Şablonlar:** Asset, persist gerekmez

---

## 8. Kategori → İkon Eşleşmesi

| Kategori | Material Icon | Renk |
|---|---|---|
| audio | `volume_up` | mavi |
| display | `brightness_6` | sarı |
| power | `power_settings_new` | kırmızı |
| notification | `notifications` | mor |
| input | `keyboard` | gri |
| window | `web_asset` | indigo |
| network | `wifi` | yeşil |
| smarthome | `home` | turkuaz |
| sensor | `sensors` | turuncu |
| break | `self_improvement` | yeşil-soft |
| misc | `extension` | gri |

Risk badge renkleri:
- `safe` → yeşil
- `caution` → sarı
- `destructive` → kırmızı

---

## 9. Test ve Doğrulama

### Şablon validasyonu
SKAPP açılışta tüm `.md` dosyalarını parse eder. Hata olursa:
- Konsolda warning
- Settings → Diagnostics ekranında listelenir
- Bozuk şablon catalog'da gösterilmez

### Endpoint test
"Test Et" butonu:
1. Form parametrelerini al
2. Placeholder'ları çöz
3. HTTP isteği at
4. Response'u kullanıcıya göster (success/error + body)

### Mock mode
Geliştirme için mock SKAPP listener — Catalog'daki tüm endpoint'lere `200 OK` döner. Test'lerde kullanılır.

---

## 10. İmplementasyon Yol Haritası (2026-05-07 güncellendi)

> **Not:** MVP'de format kararı `.md` frontmatter yerine **ayrı `.json` manifest + ham `.ps1`** kuruldu (daha sıkı şema, kolay parse, yerinde editlenebilir). Aşağı tablodaki "şablon parser" rolü `script_repository.dart` + `script_manifest.dart`'a karşılık geliyor.

| Sıra | İş | Çıktı | Durum |
|---|---|---|---|
| 1 | ~~Şablon parser yaz~~ | `ScriptManifest.fromJson()` + `ScriptRepository.loadScript()` | ✅ |
| 2 | ~~Manifest sistemi + asset yükleme~~ | `_platform.json` → `<group>.group.json` → `<script>.json` zinciri | ✅ |
| 3 | ~~Catalog Screen (sadece liste)~~ | [skapi_screen.dart](../app/lib/features/skapi/skapi_screen.dart) (4 platform tile) → [skapi_platform_screen.dart](../app/lib/features/skapi/skapi_platform_screen.dart) → [skapi_group_screen.dart](../app/lib/features/skapi/skapi_group_screen.dart) | ✅ |
| 4 | Filtreleme + search | (henüz yok; arama bar ileride) | ❌ |
| 5 | ~~Detail Screen + markdown render~~ | [skapi_script_detail_screen.dart](../app/lib/features/skapi/skapi_script_detail_screen.dart) — i18n title/summaryWhat/summaryHow/note rendererıyla | ✅ |
| 6 | ~~Form Builder — temel tipler (int/string/bool)~~ | [skapi_basic_param_form.dart](../app/lib/features/skapi/widgets/skapi_basic_param_form.dart) | ✅ |
| 7 | Form Builder — özel tipler (ip/secret/color/enum/duration) | (kısmen — int/string/bool/enum var; ip/secret/color/duration özel renderer yok) | ⚠ |
| 8 | ~~Hedef cihaz dropdown — mDNS keşif entegrasyonu~~ | [mdns_skapp_peer.dart](../app/lib/core/network/mdns_skapp_peer.dart) + [skapi_run_remote_sheet.dart](../app/lib/features/skapi/widgets/) | ✅ |
| 9 | ~~Test Et — anlık HTTP fire~~ | [script_runner.dart](../app/lib/features/skapi/data/script_runner.dart) PowerShell + run sheet stream | ✅ |
| 10 | ~~Saved Actions — persist~~ | [bindings_store.dart](../app/lib/features/skapi/data/bindings_store.dart) ile SharedPreferences | ✅ |
| 11 | ESP32'ye yükleme | (cihaz-ici action listesi henüz cihaza push edilmiyor; mevcut: cihaz event → SKAPP script çalıştırır) | ❌ |
| 12 | Lokalizasyon | TR/EN tam, 6 dil bekliyor (yapilacaklar.md #19) | ⚠ |
| 13 | Online template güncelleme (Faz 3) | (asset-only şu an, online çekme yok) | ❌ |
| **14** | **Bind sistemi (cihaz event → script tetik)** | [bindings_trigger_service.dart](../app/lib/features/skapi/data/bindings_trigger_service.dart) | ✅ |
| **15** | **Peer-to-peer remote run (telefon → desktop)** | [skapp_http_server.dart](../app/lib/core/network/skapp_http_server.dart) + [skapp_http_client.dart](../app/lib/core/network/skapp_http_client.dart) + [güvenlik.md](../güvenlik.md) | ✅ |
| **16** | **Yıldızlı scriptler (favourites)** | [skapi_providers.dart](../app/lib/features/skapi/data/skapi_providers.dart) + composite-key persist | ✅ |

---

## 11. Açık Sorular (sonra karara bağlanacak)

- [ ] Şablon parser hata toleransı: bozuk şablon → silently skip mi, kullanıcıya bildirim mi?
- [ ] Şablonların tema (dark/light) duyarlı renderlanması — markdown CSS
- [ ] Aynı endpoint birden fazla OS'te farklı body kullanırsa — tek `.md` mi 3 ayrı mı?
  (Şu an: tek `.md`, body kısmında OS notları, çalıştırma kararı SKAPP listener'ında)
- [ ] Şablon versiyonlama — `id` aynı ama içerik değiştiyse migrasyon nasıl?
- [ ] Action chain (birden çok şablonu sırayla yürütme) için ayrı UI mi gerekli?

---

## 12. Sonuç

SKAPI klasöründeki `.md` dosyaları **iki rolü birden** üstlenir:
1. İnsan-okunaklı dokümantasyon (Github'da, IDE'de, CLI'da)
2. Makine-okunaklı şablon (SKAPP'in parse ettiği)

Bu sayede dokümantasyon ve uygulama her zaman senkron kalır — tek kaynak doğruluğu.
