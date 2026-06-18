# LebensSpur Dönüşüm Planı (Web GUI → CLI + BLE)

**Son güncelleme**: 2026-04-24 (3. oturum — S12 güvenlik ECDH'ye revize, CLI inline-help prensibi, cihaz ID politikası)
**Durum**: Planlama tamamlandı, **final tablolar (A/B/C/D) üretimi beklemede**. Kod yazımı implementasyon fazına (ayrı onay) bırakıldı.
**Amaç**: Eski LebensSpur web-tabanlı ESP-IDF kodunu iki başlıkta yeniden düzenle:
1. **ESP32-C6 tarafı**: Web server + tarayıcı GUI → CLI (USB + BLE + WiFi NDJSON) + minimal `webhook_server`. BLE eklenecek.
2. **SKAPP tarafı**: Eski GUI'yi Flutter'a birebir görsel taşı, CLI ile köprüle.

> **Yeni oturumda bu dosyayı okumadan ilerleme.** Kararlar bölümünden devam et. Plan mode oturumu kaydı: `C:/Users/SEU/.claude/plans/harmonic-wiggling-ripple.md`.

---

## 1. Kapsam

### Silinecek / kaldırılacak
- `web_server` tarayıcı GUI sunumu (1655+2991+2830 satırlık SPA kaynağı), SSE, CORS — component refactor
- `wifi_manager` AP modu ve captive portal mantığı (STA kalır)
- `gui_ota` component (tarayıcı GUI artık yok)
- Harici flash'ta `slot_a` / `slot_b` LittleFS partition'ları (user_data'ya genişletilecek)
- Statik IP atama UI (CLI komutu olacak)
- `/api/events` SSE → yerine event bus
- `/api/trigger-mail/upload` multipart → chunk'lu CLI `file.upload`
- `flash_sync` component (web'e özgü senkronizasyonlar varsa kalkar — implementasyonda doğrulanır)
- **Passkey Entry / 6 haneli kod mekaniği** (hiçbir zaman yazılmadı; ECDH'ye revize edildi)
- **Fiziksel etikete kullanıcı bilgisi basımı** (pairing için kod yok; kılavuz yeterli)

### Eklenecek
- **`webhook_server` (minimal)**: Tarayıcı GUI yok, sadece external HTTP API. Şu an `GET /api/reset?key=xxx`, gelecekte genişletilebilir. IFTTT/Zapier/cron gibi araçlar için. **Rate limit zorunlu** (webhook key brute force savunması).
- **BLE GATT server**: custom service, `cmd_rx` (write) + `event_tx` (notify); MTU ≥ 247; **Secure Connections Just Works + ECDH** (passkey YOK)
- **Fiziksel pairing butonu mantığı**: Cihazda buton 3 sn basılı tutma → "pairing mode" 60 sn açılır, LED görsel feedback
- **USB CLI**: `esp_console` + `linenoise` + `argtable3`, USB-Serial/JTAG üzerinden (sürücüsüz Windows)
- **WiFi NDJSON TCP sunucu**: STA bağlıyken aynı protokol, simülatör ile eş
- **Event bus**: timer tick / alarm / buton / röle / log → tüm aktif taşıyıcılara push
- **CLI komut tablosu**: NDJSON machine mode (`timer.set`) + human alias (`timer set`), tek dispatcher
- **CLI inline-help**: Her `status`/`get` çıktısında parametre haritası + örnek + tip (Prensip #11)
- **Chunk'lu file transfer**: mail ekleri için (base64 + offset + CRC)
- **mDNS `_skapp._tcp.local`**: SKAPP keşfi için
- **Mutual Challenge-Response auth**: BLE + WiFi ortak
- **Session token** (ECDH'den türer): NVS `ls_auth.token`

### Korunacak
- `timer_manager`, `output`, `smtp_client`, `telegram_client`, `device_log`, `fw_ota`, `system_info`
- `ext_flash` (sadece user_data partition'ı)
- Cihaz ID formatı: `LS-XXXXXXXXXX` (2+10) — yeni SmartKraft standardı (kullanımı için Bölüm 7'ye bkz)
- NVS namespace'leri: `ls_actions`, `ls_ew_mail`, `ls_tg_mail`, `ls_reset`
- Virtual button mekaniği: `ls_reset.api_key` (format `ls_XXXXXXXX`), `ls_reset.enabled`, `GET /api/reset?key=xxx`
- Fiziksel 5x buton factory reset (output component'inde mevcut)

---

## 2. Mevcut Durum Keşif Özeti

### ESP32 tarafı
- `esp32/LebensSpur/HW/main/main.c` (550 satır) — app_main, callback'ler
- 12 component: `wifi_manager`, `web_server`, `ext_flash`, `flash_sync`, `timer_manager`, `smtp_client`, `telegram_client`, `device_log`, `output`, `gui_ota`, `fw_ota`, `system_info`
- `web_server.c` 2361 satır, 40+ API endpoint
- `ext_flash` EMBED_TXTFILES ile GUI kaynaklarını binary'ye gömer (`CMakeLists.txt:7-21`)

### Reset endpoint'leri keşif (S11 cevabı)
`web_server.c:1455-1592`:
- **NVS namespace**: `ls_reset`
  - `api_key` (string, format `ls_XXXXXXXX` = `ls_` + 8 hex random)
  - `enabled` (u8)
- **`api_reset_config_get_handler`** (GET): enabled + maskeli key (`ls_a3f7****`) döner
- **`api_reset_config_save_handler`** (POST): enabled toggle
- **`api_reset_generate_handler`** (POST): `esp_random()` ile 8-hex üretir, otomatik enable
- **`api_reset_handler`** (GET `?key=xxx`): enabled değilse 403, yanlış key 401, başarılıysa `timer_manager_restart()` + event push

Bu mantık `webhook_server`'a **aynı endpoint path + aynı NVS yapısıyla** taşınır (harici otomasyonlar bozulmasın). **Brute force savunması eklenir** (rate limit, exp backoff). Key uzatma opsiyonel (16 hex) — implementasyonda değerlendirilir.

### SNTP keşif
`esp_sntp` / `esp_netif_sntp` main.c'de kullanılmıyor. Cihaz gerçek zaman tutmuyor; timer relative, log `uptime saniye`. Bu davranış **korunur**.

### GUI kaynakları (`esp32/LebensSpur/GUI/`)
| Dosya | Satır / boyut | Not |
|---|---|---|
| `index.html` | 1655 | Tek SPA |
| `style.css` | 2991 | Tek stil |
| `app.js` | 2830 | SPA router + fetch wrapper |
| `lang/{en,tr,de,es,fr,it}.json` | 393 (en) | 6 dil |
| `config.json` | 1 | — |
| `pic/{logo,darklogo}.png` | 11 KB / 10 KB | — |

### Web API endpoint grupları (CLI komut haritasının temeli)
- `timer/*` (get, set, vacation)
- `wifi/*` (connect, backup/save, config, ap/set)
- `smtp/*` (get, save, test)
- `telegram/*` (get, save, test)
- `relay/*` (get, set, test)
- `early-mail/*`, `trigger-mail/*` (upload/delete/files/file-delete)
- `actions/*` (early_mail/trig_mail/trig_relay/early_tg bayrakları)
- `reset/*` — **virtual button webhook**, `webhook_server`'a taşınacak
- `system/*` (info, detail, logs)
- `device/*` (restart, factory-reset)
- `gui-ota/*` (silinecek), `fw-ota/*` (kalacak)
- `events` (SSE → event bus)
- `/ext/*` (statik dosya → `file.download`)

---

## 3. Alınan Kararlar

### S1 — Cihaz ID formatı
`LS-XXXXXXXXXX` (2+10) **korunacak**. Yeni SmartKraft standardı. Memory `project_device_naming.md` güncellendi.

### S2 — WiFi & BLE
- AP modu kaldırıldı, BLE eklendi (ilk kurulum), WiFi STA kalıyor, SKAPP oto-discovery WiFi'de.

### S3 — Harici flash
- GUI slot'ları silinir, 32MB harici flash tamamen user_data'ya.

### S4 — Web server silme
Zaman kontrolü dışında kritik etki yok. mDNS kalacak, event bus + chunk'lu file transfer yeniden.

### S5 — Web server tarandı
40+ endpoint listelendi.

### S6 — Faz sırası
Paralel, esnek. Şimdilik ilk cihaz + SKAPP uyumuna odaklanılıyor.

### S7 — GUI kaynakları incelendi
Yapısal tarama tamam.

### S8 — Görsel taşıma
%90 uyum kabul, kalan %10 manuel.

### S9 — Taşınmayacak bileşen yok
Her şey taşınıyor.

### Ek sorular 1–4
mDNS bağımsız (web server gerekmez); SKAPP rolü = GUI↔CLI köprüsü; S4 eksiksiz; %90 uyum kabul.

### S10 — Virtual button webhook KALIYOR
Cihazın en büyük özelliklerinden biri. `webhook_server` (minimal) — tarayıcı GUI yok, sadece external API. Rate limit zorunlu.

### S11 — Reset endpoint'leri = virtual button
Bkz. Bölüm 2. NVS + endpoint path + key formatı aynen korunur.

### S12 — Güvenlik: ECDH + Fiziksel Buton Gate + Mutual C-R (KULLANICI SIFIR KOD)

Kullanıcı isteği: "ne laptoptan ne SKAPP'ten bir şifre girme işlemi olmayacak, ama BLE ve WiFi ile SKAPP açıldığında karşılıklı haberleşerek ağın güvenli olduğu netleştirilecek". Teknik karşılık: **ECDH key exchange + fiziksel buton pairing gate + Mutual Challenge-Response + per-mesaj HMAC**. Passkey Entry (6 haneli kod) yok.

**İlk kurulum (tek seferlik, kullanıcı sadece butona basar):**

```
1. Kullanıcı cihaz üstündeki fiziksel butona 3 sn basılı tutar
2. Cihaz "pairing mode" açar → LED yanıp söner → 60 sn aktif
3. Özel BLE advertising flag ile "eşlenmeye hazır" yayın
   (SKAPP pairing mode'daki cihazları ayrı kategoride listeler)
4. SKAPP cihazı seçer → BLE connect
5. ECDH (X25519) key exchange — BLE Secure Connections Just Works modu otomatik yapar
     cihaz  → SKAPP : cihazın public key'i
     SKAPP  → cihaz : SKAPP'in public key'i
     her iki taraf ortak secret'ı hesaplar (hat üzerinden gitmez)
6. Cihaz ortak secret'ten 32-byte session token türetir
   - cihaz: NVS `ls_auth.token`
   - SKAPP: FlutterSecureStorage (Android Keystore / iOS Keychain / Win DPAPI / macOS Keychain / Linux libsecret)
7. Pairing mode hemen kapanır, LED sabit yanar
8. Kullanıcı tek bir kod girmedi — sadece butona bastı
```

**MITM savunma hatları (pairing anında)**:
- **Fiziksel buton gate**: pairing mode sadece cihaz butonu açar; APP uzaktan açamaz → saldırgan kullanıcıyla senkronize olamaz
- **Tek bağlantı kilidi**: pairing mode'da aynı anda sadece 1 connection kabul
- **60 sn otomatik timeout**
- **Başarılı pairing sonrası anında kapanma**

**Sonraki bağlantılar (BLE veya WiFi, aynı protokol):**

Mutual Challenge-Response (her bağlantı açılışında):
```
cihaz  → client : challenge_c = 16 byte random
client → cihaz  : resp_c = HMAC-SHA256(token, challenge_c)[:16]
cihaz doğrular — yanlışsa veya 5 sn içinde gelmezse bağlantı KAPATILIR
client → cihaz  : challenge_s = 16 byte random
cihaz  → client : resp_s = HMAC-SHA256(token, challenge_s)[:16]
client doğrular — sahte cihaz koruması
handshake OK → komut kanalı açık
```

Per-mesaj HMAC (replay önleme):
```json
{"cmd":"timer.set","args":{...},"id":42,"nonce":7182,"ts":1713960000,
 "sig":"HMAC-SHA256(token, canonical_body)[:16]"}
```
- Nonce: monoton artan, sliding window 64
- Timestamp: ±60 sn pencere

**Kritik komutlarda ek onay**: `device.factory-reset`, `ota.fw.start` gibi yıkıcı komutlarda cihaz tek-kullanımlık confirm token ister (`device.confirm-token.get` → cevapta token → komut bu token ile gönderilir). Bu 60 sn replay penceresinde bile ikinci kez geçerli olmaz.

**Unpair akışı**:
- `ble.unpair` komutu (SKAPP'ten): cihazda bond + token silinir
- Fiziksel 5x buton factory reset: tüm veri + token + bond + api_key silinir
- APP "cihazı unut": APP'te token silinir; cihazda temizlik için `ble.unpair` gönderilmeli (yoksa cihaz eski bond ile yaşayan state'te kalır)

**Gelecek yükseltme**: WiFi trafiği TLS (self-signed + cert pinning) ile dışa sarılabilir. Mevcut C-R + HMAC katmanı değişmez, TLS tüneline oturtulur. Dart native `SecureSocket` destekler.

### S13 — File transfer sınırları
- BLE'de >500KB YASAK, USB-C mümkün (~300-400 KB/s), platform matrisi Bölüm 6'da
- Desktop: USB-C + WiFi, Android: WiFi öncelikli + USB OTG opsiyonel, iOS: WiFi zorunlu

### S14 — mDNS şablonu
- Hostname: `LS-XXXXXXXXXX.local` (13 karakter)
- CLI service: `_skapp._tcp.local`, port 8080
- Webhook service (opsiyonel): `_skapp-webhook._tcp.local`, port 80
- TXT: `devtype=LS,id=LS-XXXXXXXXXX,fw=<v>`

### S15 — Dil
Cihazlar EN-only (CLI + hata kodları). SKAPP Flutter i18n (ARB). Cihazda dil JSON YOK.

### S16 — Eski GUI akıbeti
Flutter taşıma öncesi screenshot arşivi (`docs/legacy-gui-screenshots/`). Taşıma bitince `docs/legacy-gui/`.

### S17 — CLI komut naming
Machine: `timer.set` (NDJSON). Human: `timer set` (interaktif). Aynı dispatcher, alias tablosu.

### S18 — Memory güncelleme kadansı
Kritik kararlar anlık. Güncel memory: `project_device_naming.md` (2+10), `project_ls_migration_doc.md` (aktif referans), `project_security.md` (ECDH + Mutual C-R), `project_cli_ux_pattern.md` (inline-help formatı).

---

## 4. Açık Sorular

**Tüm sorular kapandı** (S1–S18 + ek sorular + S12 revize edildi). Yeni soru çıkarsa buraya eklenir.

---

## 5. Protokol Tasarım Prensipleri

Aşağıdaki prensipler CLI komut tablosu ve APP tasarımının temeli:

1. **Çift yönlü**: request/response + async event stream. Event bus üzerinden tüm taşıyıcılar abone.
2. **State snapshot**: `state.snapshot` tek komutla tüm cihaz durumunu döner. Sonra event'lerle senkron.
3. **Hata modeli**: `{"ok":false,"err":"ERR_CODE","params":{...}}` — kod cihazdan, çeviri APP.
4. **Komut ID**: Her request'e `id`, response aynı `id`. Event'te `seq` (kaçırma tespiti).
5. **Idempotency**: Aynı `id` tekrar gelirse cihaz aynı yanıtı döner.
6. **Offline queue**: SKAPP kuyruklar, cihaz bağlanınca gönderir. Cihaz "last-write-wins".
7. **Capabilities**: `device.capabilities` — destek edilen komutlar/alanlar. APP özellik gizler.
8. **Binary**: Ek dosyalar base64 chunk + CRC. BLE'de >500KB reddedilir.
9. **BLE framing**: MTU ≥ 247. NDJSON satırı chunk'lara bölünürse start/end delimiter.
10. **Auth**: USB fiziksel = yetki (handshake opsiyonel). BLE + WiFi: **ECDH pairing + Mutual C-R + per-mesaj HMAC** (S12). Kritik komutlar tek-kullanımlık confirm token ister.
11. **CLI inline-help (human mode)**: Her `status`/`get` komutu şu formatta döner:
    - `Current <something>:` + alan değerleri (enum ise `[ref]` numarası)
    - `To change: <cmd syntax>` + numaralı parametre haritası (değer anlamıyla: `0 = NC (normally closed)`)
    - `Example:` en az 1 gerçekçi komut
    - `Tip:` (opsiyonel) ilgili shortcut / yan komut
    Machine mode atlar, sadece `data` döner. Kullanıcı help'e bakmadan CLI'yı keşfeder.

---

## 6. Taşıyıcılar (Transport) Özeti

| Taşıyıcı | Kullanım | Avantaj | Dezavantaj |
|---|---|---|---|
| USB-Serial/JTAG | Geliştirme, desktop SKAPP kurulum, büyük dosya | Sürücüsüz Win, hızlı (~300-400 KB/s), kablolu güven | Fiziksel kablo; mobilde sınırlı |
| BLE GATT | İlk kurulum, WiFi yok iken | Kablosuz, telefonla direkt, low-energy | Yavaş (10-30 KB/s), MTU ≤ 247, >500KB yasak |
| WiFi TCP NDJSON | Normal kullanım, SKAPP ana kanalı | Hızlı, aynı LAN, simülatör ile eş protokol | Mutual C-R şart, WiFi kurulumu ön şart |
| Webhook HTTP | 3. parti otomasyon (IFTTT/cron) | Standart HTTP, tek endpoint | API key brute-force riski → rate limit zorunlu |

---

## 7. Cihaz ID ve Etiket Politikası

### Cihaz ID kullanım haritası (`LS-XXXXXXXXXX`)
| Yer | Zorunluluk | Neden |
|---|---|---|
| BLE advertising name | ZORUNLU | Scan'de cihazları ayırmak |
| mDNS hostname (`LS-XXXXXXXXXX.local`) | ZORUNLU | Aynı WiFi'de çoklu cihaz |
| mDNS TXT record (`id=`) | ZORUNLU | Servis metadata, SKAPP keşfi |
| APP cihaz listesi (iç identifier) | ZORUNLU | Kullanıcı alias çakışabilir, ID çakışmaz |
| Device log entry | ZORUNLU | Çoklu cihaz logu birleşiminde ayırma |
| Telemetri / üreticiye gönderim | ZORUNLU | Destek talebinde cihaz tanıma |
| OTA manifest | OPSİYONEL | Firmware kanal/beta (ileride) |
| Webhook URL (`/api/reset`) | GEREKSİZ | IP zaten cihazı gösterir |
| Pairing akışı | GEREKSİZ | ECDH otomatik, kullanıcı ID ile uğraşmaz |

### Etiket politikası
- **Pairing için kod** artık yok (ECDH otomatik) → kullanıcıya basım gereksiz
- Kullanıcı cihaz ID'yi asla **elle girmez**; SKAPP BLE scan / mDNS ile otomatik keşfeder
- **Standart kullanım kılavuzu yeterli**: "Cihaza 3 sn bas, APP'ten bağlan"
- Regülasyon etiketi (CE/FCC/model no) üretim aşamasında nasılsa takılır — o etiket üzerine küçük QR (cihaz ID için, support kolaylığı) **opsiyonel** eklenebilir, zorunlu değil
- Kullanıcı tercihi: **etiket yok, kılavuz var**

---

## 8. Final Tablolar ✅ ÜRETİLDİ

Aşağıdaki dört tablo dosya olarak yazıldı. İmplementasyon fazı başladığında bunlar **tek kaynak kabul** edilir.

### (A) [TABLO_A_DOSYA_DEGISIKLIK.md](TABLO_A_DOSYA_DEGISIKLIK.md)
Her LS component'ının yeni yapıda nereye gittiği (sil/taşı/kırp/revize/kalır/yeni). Satır sayısı farkları (LS-özel koddan −63%). Silme onayı gereken dosyaların listesi (implementasyon onayıyla).

### (B) [TABLO_B_CLI_KOMUTLARI.md](TABLO_B_CLI_KOMUTLARI.md)
66 komut + meta + 38 hata kodu. Her komut: machine/human isim, args şeması, response şeması, hatalar, kitap ataması, critical bayrağı. Örnek inline-help çıktıları (timer, relay). Namespace'ler: timer, relay, wifi, smtp, telegram, mail.early, mail.trigger, actions, log, ota.fw, device, file, webhook, pairing+auth, system, meta.

### (C) [TABLO_C_EVENT_LISTESI.md](TABLO_C_EVENT_LISTESI.md)
~45 event türü. Her event: payload şeması, tetikleyici, taşıyıcı, event bus kitabı. Filter ve throttling kuralları. `events.subscribe` örnekleri (dashboard / arka plan / log ekranı).

### (D) [TABLO_D_APP_EKRAN_ESLEMESI.md](TABLO_D_APP_EKRAN_ESLEMESI.md)
Flutter widget ağacı önerisi. Her ekran → tetiklediği komutlar + dinlediği event'ler. Kritik komut akışı (confirm token). Eski SPA sayfaları → Flutter sayfa eşlemesi. Stil dönüşümü (CSS → Flutter theme).

---

## Implementasyon sırası önerisi (final tablolara dayalı)

İmplementasyon kullanıcı onayıyla başlayacak. Önerilen sıra:

**Faz A — sk_core + sk_cli MVP** (2 hafta)
1. `sk_core` (identity, errors, event_bus, cli, capabilities)
2. `sk_transport_usb` — USB CLI üzerinde test
3. `sk_storage/sk_log` — mevcut device_log refactor
4. LS `timer_manager` event bus entegrasyonu
5. USB üzerinden timer + log komutları çalışır

**Faz B — BLE + Auth** (3 hafta)
6. `sk_auth` (ECDH, session token, Mutual C-R, HMAC)
7. `sk_io` (buton, pairing mode gate)
8. `sk_transport_ble` (GATT server)
9. SKAPP pairing wizard MVP

**Faz C — WiFi + Network** (2 hafta)
10. `sk_network` (wifi + mdns) — wifi_manager refactor
11. `sk_transport_tcp`
12. SKAPP mDNS discovery

**Faz D — Webhook + OTA + File** (2 hafta)
13. `sk_webhook` + `webhook_server` component
14. `sk_ota` (fw_ota refactor)
15. `sk_file_xfer` (chunk'lu dosya)
16. LS ls_cli tüm komutları register

**Faz E — SKAPP** (3-4 hafta, Faz A sonrası paralel başlayabilir)
17. `sk_flutter_core` paketi (transport, auth, cli_client, event_stream)
18. LS cihaz ekranları (Tablo D'deki ağaç)
19. Flutter theme (style.css dönüşümü)
20. Screenshot karşılaştırma iterasyonu

**Toplam**: ~10-14 hafta tek başına. Çoğu paralel gidebilir (core + SKAPP eşzamanlı).

---

## 9. SKAPP Library Mimarisi

Tüm SmartKraft cihazlarının ortak ESP-IDF altyapı kütüphanesi: **`esp32/skapp-library/`** (klasör iskeleti oluşturuldu, component'lar planlama aşamasında). Her cihaz ihtiyacı kadar "kitap" alır, üstüne kendi iş mantığını koyar. Tek source of truth → tüm cihazlar aynı protokol, aynı güvenlik, aynı UX.

### Kademeli kitaplar (9 seviye, 11 kitap)

| Seviye | Kitap | Zorunlu? | İçerik | Bağımlılık |
|---|---|---|---|---|
| 1 | `sk_core` | EVET | sk_identity, sk_errors, sk_event_bus, sk_cli, sk_capabilities | yok |
| 2a | `sk_transport_usb` | opsiyonel | USB-Serial/JTAG + linenoise | sk_core |
| 2b | `sk_transport_ble` | opsiyonel | GATT server, MTU, framing | sk_core, sk_auth |
| 2c | `sk_transport_tcp` | opsiyonel | TCP NDJSON | sk_core, sk_auth, sk_network |
| 3 | `sk_auth` | BLE/WiFi varsa | ECDH, fiziksel buton gate, Mutual C-R, HMAC, confirm token | sk_core |
| 4 | `sk_io` | opsiyonel | sk_button (kısa/uzun/multi-tap), sk_led, sk_gpio_helper | sk_core |
| 5 | `sk_network` | opsiyonel | sk_wifi (STA), sk_mdns | sk_core |
| 6 | `sk_storage` | opsiyonel | sk_log (ring + LittleFS), sk_nvs_helper | sk_core |
| 7 | `sk_ota` | opsiyonel | GitHub/custom URL, A/B, rollback | sk_core, sk_network |
| 8 | `sk_webhook` | opsiyonel | Minimal HTTP, key + rate limit | sk_core, sk_network |
| 9 | `sk_file_xfer` | opsiyonel | Chunk'lu NDJSON base64, CRC, BLE >500KB reddet | sk_core |

### LebensSpur'un alacağı kitaplar
sk_core + sk_transport_{usb,ble,tcp} + sk_auth + sk_io + sk_network + sk_storage + sk_ota + sk_webhook + sk_file_xfer = **9 kitap** (tümü)

### Blocking Focus benzeri minimalist cihaz
sk_core + sk_transport_ble + sk_auth + sk_io = **4 kitap**

### LS cihazının kendi iş mantığı (kütüphane dışında)
`esp32/LebensSpur/HW/components/` altında kalır:
- `timer_manager` — countdown (LS'ye özgü)
- `smtp_client` — SMTP gönderimi
- `telegram_client` — Telegram bot
- `relay_control` — röle pin mantığı (sk_io'yu kullanır)
- `mail_attachments` — NVS-backed mail grupları

### Bu oturumda alınan kararlar (2026-04-24)
- **Klasör adı**: `skapp-library` (boşluk kaldırıldı, ESP-IDF path uyumu)
- **Component prefix**: `sk_` (SmartKraft kısaltması)
- **Granülarite**: Her kitap tek ESP-IDF component (tek idf_component.yml); içinde alt-modüller (örn. sk_core 5 modül tek paket)
- **Protokol spec yeri**: `skapp-library/protocol/v1/` (ayrı repo ileride, marka olgunlaşınca düşünülür)
- **Örnek şablon**: `skapp-library/examples/minimal/` içinde
- **Versiyonlama**: Her kitap **bağımsız semver**

### LS migration guide (final tabloların ürünü)
Final tablolar (A/B/C/D) üretilirken otomatik çıkarılır: LS'nin her mevcut component'ı hangi kitaba veya hangi cihaz-özel klasöre taşınıyor, satır/fonksiyon detayında.

### Planlanacak başlıklar (implementasyon öncesi)
- Partition table şablonu (sk_core önerisi)
- Ortak `sdkconfig.sk_defaults`
- Component registry stratejisi (başta local `EXTRA_COMPONENT_DIRS`, yaygınlaşınca Espressif registry)
- Protokol v1 → v2 geriye uyumluluk politikası
- Test matrisi (QEMU host + LS integration)

### SKAPP tarafı eşleniği (ileride)
`sk_app/packages/sk_core/` Dart paketi — aynı kitap mantığıyla: transport, auth, cli_client, event_stream, discovery, device_registry. Şu anda APP görseli beklemede (S6); cihaz + core'a odaklanılıyor.

---

## 10. Notlar

- Bu dosya **planlama belgesi / çalışma dokümanı**. Her oturumda güncellenir.
- **Yeni oturum**: önce bu dosya okunur, "Alınan Kararlar"dan devam edilir.
- **Plan mode kaydı**: `C:/Users/SEU/.claude/plans/harmonic-wiggling-ripple.md`.
- **Memory referansları**:
  - `project_cli_first_architecture.md`
  - `project_connectivity_policy.md`
  - `project_security.md` — S12 ECDH + Mutual C-R revize
  - `project_app_role.md`
  - `project_repo_structure.md`
  - `project_device_naming.md` — 2+10 revize
  - `project_ls_migration_doc.md` — bu dosyaya işaret
  - `project_cli_ux_pattern.md` — inline-help formatı
  - `project_core_library.md` — SKAPP Library kitap mimarisi
- **Kod üretme kuralı**: Final tablolar (A/B/C/D) onaylanmadıkça implementasyon YOK.
