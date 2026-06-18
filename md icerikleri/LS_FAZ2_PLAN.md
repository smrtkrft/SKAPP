# LebensSpur Faz 2 — SKAPP CLI/GUI Entegrasyonu

**Önkoşul:** Faz 1 (firmware) tam çalışır durumda, `esp32/ls/protocol/v1/` kontratı stabil.

## Genel Durum (2026-05-20)

- ✓ **Faz 2.0** TAMAM — SKAPP'tan LS cihazı eşleşip LsHomeScreen açılıyor. BLE+ECDH+passphrase + WiFi setup + reconnect tam.
- ⏳ **Faz 2.1-2.10** — bekliyor. Kullanıcı "ls fazlarına devam edelim" dediğinde Faz 2.1'den başla.

**Faz 2.0 closeout detayı:** `yapilacaklar.md` Madde 25 + memory `project_ls_faz1_decisions.md`.

**Hedef:** SKAPP (Flutter) tarafında LebensSpur cihazı eşleştirme + tüm CLI komutlarına bağlı GUI ekranları. Faz 2 sonunda kullanıcı SKAPP üzerinden cihazı eşleştirir, timer / relay / SMTP / mail groups / reset API ayarlarını yapar ve canlı countdown'u izler.

**Genel kural:** `esp32/ls/protocol/v1/commands.json` ve `events.json` SINGLE SOURCE OF TRUTH. Dart ekran kodlarında "string literal CLI komutu" kullanılmaz; her komut için kapsayıcı bir Dart service/binding katmanı olur ve protocol v1'i yansıtır.

---

## Mevcut Durum

`app/lib/features/devices/lebensspur/` altında 12 Dart dosyası VAR (Faz 1 öncesi iskelet):

| Dosya | Olası rol |
|---|---|
| `ls_pairing_screen.dart` | Eşleştirme akışı LS-özgü ekstra adım (varsa) |
| `ls_wifi_screen.dart` | WiFi yapılandırma |
| `ls_timer_screen.dart` | Geri sayım yönetimi |
| `ls_relay_screen.dart` | Röle yapılandırma |
| `ls_mail_screen.dart` | Mail config (SMTP + groups) |
| `ls_telegram_screen.dart` | Telegram bot |
| `ls_webhook_screen.dart` | Webhook (alarm API + LS API) |
| `ls_ota_screen.dart` | OTA |
| `ls_logs_screen.dart` | Log görüntüleme |
| `ls_info_screen.dart` | Cihaz bilgisi |
| `ls_providers.dart` | Riverpod providers |
| `ls_theme_tokens.dart` | LS-özgü tema token'ları |

**Kritik bulgu:** `app/lib/features/device_home/device_home_screen.dart`'ta sadece BF ve MS case'leri var. LS dispatch'i YOK; bu yüzden mevcut ekranlar şu an dead code.

---

## Alt Fazlar

### Faz 2.0 — LS Device Dispatch + Ana Ekran İskeleti ✓ TAMAM

**Tamamlandı 2026-05-20.** 7-ajan paralel implementasyon (BF audit firmware+SKAPP, LS firmware fix, LS SKAPP integration, validator).

Yapılan ekler:
- `device_home_screen.dart` → `case 'LS': return LsHomeScreen(deviceId: device.id);`
- `features/devices/lebensspur/ls_home_screen.dart` (NEW, 264 satır) — Identity card + 10 sub-screen ListTile + ConsumerWidget(deviceSessionProvider) loading/error/data branchleri.
- Firmware: 5 LS component factory-reset subscriber, sk_event_bus 32→64, sk_passphrase 5000→600 iter perf fix.

Doğrulandı: build temiz, flash temiz, BLE adv pairable, mDNS, TCP NDJSON 8080, pairing.status open, `flutter analyze` clean.

### Faz 2.0 (orijinal plan — referans için)

**Amaç:** SKAPP cihaz listesinde "LS-XXXXXXXX" görünce LS device home açılması.

**Dosyalar:**
- `app/lib/features/device_home/device_home_screen.dart` — `case 'LS': return LsHomeScreen(deviceId: device.id);`
- `app/lib/features/devices/lebensspur/ls_home_screen.dart` — NEW, ana shell + alt tab/section navigasyonu
- `app/lib/features/devices/lebensspur/ls_providers.dart` — gözden geçir, `lsDeviceSessionProvider` türü tanımla

**Çıktı:** LS cihazına tıklayınca açılan ana ekran (geri sayım ring + 4 ana sekme placeholder).

**Success criteria:** BF home pattern'ı ile aynı UX kalitesinde, mevcut ekranlar route'lara bağlandı (içerikleri Faz 2.1+'da doldurulacak).

---

### Faz 2.1 — LS CLI Binding Katmanı

**Amaç:** Dart tarafında `LsTimerService`, `LsRelayService`, `LsSmtpService`, `LsMailGroupsService`, `LsResetApiService` — `protocol/v1/commands.json` mappingleri ile.

**Dosyalar:**
- `app/lib/features/devices/lebensspur/data/ls_timer_service.dart`
- `app/lib/features/devices/lebensspur/data/ls_relay_service.dart`
- `app/lib/features/devices/lebensspur/data/ls_smtp_service.dart`
- `app/lib/features/devices/lebensspur/data/ls_mail_groups_service.dart`
- `app/lib/features/devices/lebensspur/data/ls_reset_api_service.dart`

**Pattern:** BF'deki `BfApiChainService` (örnek). Her servis:
- `Future<LsTimerStatus> getStatus()` → `timer.status` çağrısı, JSON parse
- `Future<void> setConfig({unit, value, alarms})` → `timer.set`
- `Stream<TimerTick> tickStream` → `timer.tick` event subscription
- vb.

**Event mapping:** SKAPP NDJSON envelope'tan gelen olayları `protocol/v1/events.json` şemasına göre parse edip Riverpod stream'lerine besle.

**Çıktı:** UI'ya tamamen ayrık, test edilebilir katman (mock'lanabilir). Faz 2.2+ ekranları sadece bu servisleri kullanır, raw CLI string'i yazmaz.

**Success criteria:** Dart unit test ile her servis komutunun doğru NDJSON üretip cevabı parse ettiği doğrulanmış.

---

### Faz 2.2 — Timer Dashboard (Ana Sekme)

**Amaç:** Geri sayım canlı + Start/Stop/Reset butonları + tatil göstergesi.

**Dosya:** `ls_timer_screen.dart` (mevcut iskeleti revize)

**İçerik:**
- Büyük geri sayım ring (eski LS'deki gibi — 5/15/30/60 dakika değil, dinamik kullanıcı süresi)
- Remaining sec → "12g 4s 30dk" gibi human format
- Start (timer.start) / Stop (timer.stop) / Reset (timer.reset) butonları
- "Süre ayarla" → modal: unit (gün/saat/dakika) + value (1-60) + alarms (0-10)
- Vacation indicator (timer.vacation event'ine bağlı)
- "Tatil moduna gir" → modal: days (1-60) → vacation.set
- "Tatili sonlandır" → vacation.cancel

**Live data:** `timer.tick` event her saniye → UI re-render. `timer.state` geçişlerinde animasyon.

**Success criteria:** Mock cihazda timer 60sn ayarlanıp başlatılınca SKAPP'ta canlı geri sayıyor. Tetiklenince state "triggered" görünüyor.

---

### Faz 2.3 — Relay Konfigürasyon Ekranı

**Amaç:** Röle GPIO + invert + delay + duration + pulse mode ayarı + manual test.

**Dosya:** `ls_relay_screen.dart` (mevcut)

**İçerik:**
- GPIO sayısal input (read-only by default; advanced mode'da editable)
- Invert toggle + altında durum kartı ("Idle: Power OFF, Triggered: Power ON")
- Start delay slider (0-10 sn)
- Active duration input + unit selector (sn/dk)
- Pulse mode toggle → açıkken pulse_duration alanı görünür
- Pulse cycle önizlemesi: "5s on / 5s off × 6 cycles = 60 sn toplam"
- "Test relay" butonu (relay.test) + "Abort" butonu (relay.abort)
- Live phase göstergesi (relay.fire.start/end event'lerinden)

**Success criteria:** Test butonu basıldığında 2-3 sn sonra fiziksel röle aktiflenir (LED ile doğrulanır).

---

### Faz 2.4 — SMTP + Mail Groups Ekranı

**Amaç:** SMTP server ayarı + 10 mail grubunun CRUD'u + recipient listesi yönetimi.

**Dosya:** `ls_mail_screen.dart` (mevcut)

**İçerik (iki sekme veya iki section):**

**SMTP Section:**
- Host / Port / Sender / API Key (password-style) form
- "Test mail gönder" → smtp.test → progress + sonuç banner

**Mail Groups Section:**
- Grup listesi (mail.group.list) — her satır: name + recipient count + enabled toggle
- "+ Yeni grup oluştur" → modal: name → mail.group.add
- Gruba tıklayınca detail:
  - name / subject / body / enabled fields
  - Recipient list (add/remove)
  - Sil butonu (mail.group.delete)

**Success criteria:** Test SMTP'si (örn. Gmail app password ile) ile gerçek mail geliyor. Grup oluşturulup recipient eklendikten sonra timer.triggered olayı tetiklenince mail attığı doğrulanır (cihaz log'undan).

---

### Faz 2.5 — Reset API Ekranı

**Amaç:** `/api/reset?key=...` endpoint'inin enable/disable + key regen + endpoint URL kopya.

**Dosya:** YENİ `ls_reset_api_screen.dart` (mevcut yok, ls_webhook_screen.dart farklı kapsam)

**İçerik:**
- Enabled toggle (reset_api.set --enabled)
- API key görüntüleme (maskeli son 4 char) + "Regen" butonu (reset_api.regen)
- Tam URL kopya butonu: `http://LS-XXX.local/api/reset?key=ls_xxxx`
- "Test et" butonu → SKAPP içinden bu URL'ye HTTP GET (kendi yapılandırmasını doğrulamak için)
- cURL örneği bloğu (kopyalanabilir)

**Success criteria:** Toggle açıkken cURL ile çağrı atılınca cihazda timer.reset.requested event'i loglanır + ekrandaki timer remaining sıfırlanır.

---

### Faz 2.6 — Erken Uyarı Aksiyonları (Telegram + Reminder Mail + Alarm API)

**Amaç:** `timer.alarm` event'inde tetiklenecek webhook/Telegram/SMTP zincirinin yapılandırması.

**Dosya:** `ls_telegram_screen.dart` + `ls_webhook_screen.dart` (mevcut)

**Mimari karar:** Bu actions sk_api endpoint'leri olarak NVS'e yazılır. CLI: `api.endpoint.add --name early-telegram --type telegram --url <chat_id> --token <bot_token>`. Cihaz `timer.alarm` event'ini dinleyip bu endpoint'leri tetikler.

**Bekleyen:** Cihaz tarafında `timer.alarm` → sk_api subscribe yok şu an. Bu Faz 2.6 öncesinde **firmware'a eklenmelidir** (mini Faz 1.7 olarak, küçük bir patch). Veya Faz 2.6 SKAPP-only kalır, firmware bağlantısı sonra eklenir.

**Karar gerekli:** Erken uyarı zinciri Faz 2.6'da SKAPP UI + cihaz subscriber birlikte mi (entegrasyon ağır), yoksa SKAPP UI önce + firmware subscriber sonra mı?

**Çıktı (UI):**
- Telegram: Bot token + chat ID + reminder message
- Webhook: URL + method + headers + body template
- Aktif/pasif toggle her biri için

**Success criteria:** Test mode'da timer.alarm tetiklenince Telegram'a mesaj düşer + webhook URL'ye HTTP POST atılır.

---

### Faz 2.7 — Info + Logs Ekranları

**Amaç:** Cihaz hardware bilgisi + son N log girdisi.

**Dosyalar:** `ls_info_screen.dart` + `ls_logs_screen.dart` (mevcut)

**İçerik:**
- Info: device.info komutuyla cihaz prefix, hw rev, fw version, uptime, restart reason, chip model, flash size, WiFi durumu, IP, RSSI, mDNS, bond count
- Logs: logs.get ile son N kayıt — boot başlıkları + level + tag + mesaj. Filtreleme (system/wifi/timer/smtp/error/ota gibi tag'lere göre)

**Success criteria:** BF Info ekranıyla aynı kalite — pattern reuse.

---

### Faz 2.8 — Pairing Akışı Uyumluluğu

**Amaç:** Discovery/Pairing wizard'ında LS prefix tanıma + ekstra adım gerek yok doğrulaması.

**Dosyalar:** `device_discovery/discovery_screen.dart`, `device_pairing/pairing_screen.dart`

**İş:** BF zaten çalışıyor; LS aynı kalıbı kullanıyor (ECDH + Mutual C-R + buton gate). Tek değişiklik: `device.typePrefix == 'LS'` durumunda LS branding (logo, isim "LebensSpur"). BF kalıbından kopyala.

**Success criteria:** Fresh LS cihazını eşleştirme akışı uçtan uca çalışıyor — Discovery → BLE pairing → WiFi setup → LsHomeScreen.

---

### Faz 2.9 — UI Tutarlılığı + i18n + Tema

**Amaç:** Tüm LS ekranları SKAPP tasarım kuralları + i18n + ikinci dil hazırlığı.

**Yapılacaklar:**
- Renk paleti zorunlu (krem/siyah/beyaz + hardal + kırmızı) — `project_design_rules` memory'sine sıkı uyum
- Em-dash yasağı (project-wide rule)
- SKAPP markası büyük harf (`feedback_app_name_uppercase`)
- i18n: her hardcoded TR string `app_en.arb` + `app_tr.arb` anahtarlarına taşınır
- Light + Dark tema test edilir
- Mobile + Desktop layout proporsiyonları kontrol edilir (`feedback_proportions_first` memory'sine uyum)

**Success criteria:** `flutter analyze` temiz + i18n audit'i geçti + her ekran mobile + desktop'ta proporsiyon kontrolü temiz.

---

### Faz 2.10 — Release Build + 2x Kontrol

**Amaç:** Win + Android release build temiz, kullanıcı kabul testi hazır.

**Yapılacaklar:**
- `flutter build windows --release` ve `flutter build apk --release` temiz çıkmalı
- Cihaz davranış testi (timer 2 dk, alarm, triggered, mail, relay, reset_api round-trip)
- 2x kontrol (kod hataları + entegrasyon — Faz 1'deki gibi)
- Memory güncellemesi (Faz 2 tamam)

---

## Tahmini Süreler ve Bağımlılıklar

| Alt-faz | Tahmini iş | Bağımlılık |
|---|---|---|
| 2.0 | 1-2 saat | Faz 1 build doğrulaması |
| 2.1 | 3-4 saat (5 servis) | 2.0 |
| 2.2 Timer | 2-3 saat | 2.1 |
| 2.3 Relay | 2 saat | 2.1 |
| 2.4 SMTP+Mail | 4-5 saat (kompleks form'lar) | 2.1 |
| 2.5 Reset API | 1 saat | 2.1 |
| 2.6 Erken uyarı | 3-4 saat (+ firmware patch?) | 2.1, karar gerekli |
| 2.7 Info+Logs | 2 saat (BF reuse) | 2.1 |
| 2.8 Pairing | 1 saat (BF reuse) | 2.0 |
| 2.9 UI/i18n | 2-3 saat | 2.2-2.7 |
| 2.10 Release | 1-2 saat | hepsi |
| **TOPLAM** | **~25-30 saat** | |

## Karar Gerekli Noktalar (Faz 2 başlamadan önce)

1. **Erken uyarı zincirinin firmware ayağı**: Faz 2.6 öncesinde `esp32/ls/main/main.c`'de `timer.alarm` → `sk_api_chain_run` subscribe'ı eklenecek mi? (mini Faz 1.7 olarak işaretlenebilir)
2. **Mevcut LS dart dosyalarının kapsamı**: Üzerine yazılacak mı, baştan yeniden mi yazılacak? (önerim: refactor + revise, baştan yazma)
3. **LsHomeScreen layout**: Constellation atlas tarzı mı (eski LS web design), yoksa BF home pattern mi (kart tabanlı)?
4. **SMTP+Mail tek ekran mı iki ekran mı**: UX kalabalık olmaması için 2 alt-sayfa daha temiz olabilir.

---

## Faz 2 Sonu Çıktıları

- ✓ SKAPP'tan LS cihazı eşleşebiliyor
- ✓ Timer, relay, SMTP, mail groups, reset API tamamen UI'dan yönetiliyor
- ✓ Live event stream UI'a yansıyor (countdown, fire phase, send result)
- ✓ Win + Android release build temiz
- ✓ İlk dış test sürümü için hazır

Faz 2'den sonra **Aşama 3** (varsa) opsiyonel: çoklu cihaz yönetimi, SKAPI script integration, ileri OTA, vb. Bu plan dışı.
