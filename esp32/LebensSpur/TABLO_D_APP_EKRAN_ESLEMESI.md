# Tablo D — SKAPP Ekran → CLI Komut/Event Eşlemesi

Eski tarayıcı SPA'sının her sayfası → yeni Flutter ekranı + tetiklediği CLI komutları + dinlediği event'ler.

SKAPP navigasyon (memory'deki kurala uygun):
- **Alt sekme 3'lü**: Ana Sayfa / Cihazlarım / Ayarlar
- **Cihaz detay**: push route (Cihazlarım → cihaz kartı tap)

LS cihaz detay ekranı altında alt sayfalar (eski SPA pages'in Flutter karşılığı).

---

## SKAPP global ekranlar

### Alt sekme 1: **Ana Sayfa** (bilgi merkezi)

Memory (`project_home_screen.md`): "şimdilik bilgilendirme merkezi (reklam değil, cihaz sayısı + uyarılar)".

| Bileşen | Komutlar | Event'ler |
|---|---|---|
| Bağlı cihaz sayacı | Per cihaz `device.info` (cache) | `device.boot` |
| Aktif timer'lar özeti | Per cihaz `timer.status` (polling) | `timer.tick` (dashboard odaklıyken), `timer.expired` |
| Aktif uyarılar listesi | — | `timer.alarm.triggered`, `timer.expired`, `ota.fw.done`, `auth.handshake.fail`, `webhook.rate-limit.hit` |
| OTA bildirimleri | Per cihaz `ota.fw.info` | `ota.fw.done` (her cihaz) |

### Alt sekme 2: **Cihazlarım**

| Bileşen | Komutlar | Event'ler |
|---|---|---|
| Pair'li cihaz kartları | Per cihaz `device.info` + online ping | — |
| Online ikonu | (lokal — son response zamanı) | `auth.handshake.ok/fail` |
| "Cihaz ekle" butonu | BLE scan + mDNS scan; pairing mode cihazları filtrele | — |
| Pair wizard | BLE connect → ECDH → `pairing.status` → `device.info` | `pairing.completed` |
| Cihaz kartı tap | Push route → cihaz detay | — |

Native iş (APP tarafında): BLE scan, mDNS scan. Bunlar CLI komutu değil, OS-level BLE/mDNS API.

### Alt sekme 3: **Ayarlar**

Lokal APP ayarları — cihazdan bağımsız.

| Bileşen | İşlev |
|---|---|
| Dil seçimi | Flutter i18n ARB (EN/TR/DE/ES/FR/IT) |
| Tema | Açık/koyu (memory paleti: krem/siyah/beyaz + kırmızı/hardal) |
| Bildirim tercihleri | Hangi event'lere native push göndersin |
| Hakkında / Versiyon | APP versiyon bilgisi |
| Advanced → Developer | Seçili cihaza raw CLI terminal (troubleshooting) |

CLI komutu yok (bu ekran lokal).

---

## LS Cihaz Detay — alt ekranlar

Cihaz kartına tıklanınca push route, tab bar:
- Ana / Timer / Mail / Telegram / Relay / Actions / WiFi / Webhook / Logs / OTA / Pairing / Info

### Alt ekran: **LS Ana Sayfa** (dashboard)

Karşılık: eski `#home` sayfası.

| UI bileşeni | Komut | Event |
|---|---|---|
| Widget mount | `timer.status`, `relay.status`, `wifi.status`, `device.info` (paralel) | — |
| Timer remaining sayaç | — | `timer.tick` (canlı), `timer.set`, `timer.restart`, `timer.cancel`, `timer.expired` |
| Büyük **"Erteleme"** butonu | `timer.restart` | → `timer.restart` event ile UI senkron |
| Relay durumu ikonu | — | `relay.state` |
| WiFi durumu ikonu | — | `wifi.state` |
| "Alarm tetiklendi" banner | — | `timer.alarm.triggered` |
| "Süre doldu" uyarı | — | `timer.expired` |
| Son 3 log satırı | `log.list --count 3` ilk yükleme | `log.added` |
| Fiziksel buton basımı sync | — | `button.pressed`, `button.long-press` |

### Alt ekran: **Timer Ayarları**

| UI bileşeni | Komut | Event |
|---|---|---|
| Load | `timer.status` | — |
| Süre save | `timer.set {value, unit}` | `timer.set` |
| Erken uyarı sayısı slider | `timer.alarm-count.set {count}` | — |
| Tatile çık butonu | `timer.vacation.set {days}` | `timer.vacation.started` |
| Tatili iptal butonu | `timer.vacation.cancel` | `timer.vacation.ended` |
| Timer durdur | `timer.cancel` | `timer.cancel` |
| Timer sıfırla | `timer.restart` | `timer.restart` |

### Alt ekran: **SMTP / Mail Ayarları**

| Section | UI alanı | Komut | Event |
|---|---|---|---|
| SMTP | Load | `smtp.get` | — |
| | Save | `smtp.save {server, port, user, api_key}` | — |
| | Test | `smtp.test` | `smtp.test.progress`, `smtp.test.done` |
| Erken Mail | Load | `mail.early.get` | — |
| | Save | `mail.early.save {email, subject, body}` | — |
| Tetikleme Gruplar | List | `mail.trigger.get` | — |
| | Save (group) | `mail.trigger.save {id, subject, body, recipients}` | — |
| | Delete (group) | `mail.trigger.delete {id}` | — |
| | File list | `mail.trigger.file.list {group}` | — |
| | File upload | `file.upload.init/chunk/finish` | `file.upload.progress/done` |
| | File delete | `mail.trigger.file.delete {group, name}` | — |

Ayrıca canlı bildirim: `smtp.send.success/fail` (trigger olduğunda log'a düşer).

### Alt ekran: **Telegram Ayarları**

| UI | Komut | Event |
|---|---|---|
| Load | `telegram.get` | — |
| Save | `telegram.save {token, chat_id, message}` | — |
| Test | `telegram.test` | `telegram.test.done` |

### Alt ekran: **Relay Ayarları**

| UI | Komut | Event |
|---|---|---|
| Load | `relay.status` | `relay.state` (canlı) |
| Mode/duration/pulse/delay save | `relay.set {mode, duration, pulse, delay}` | — |
| Test | `relay.test` | `relay.state` (on sonra off) |
| Manual trigger | `relay.trigger` | — |
| Turn off | `relay.off` | — |
| Inverted toggle | `relay.set` (inverted flag dahil) | — |

### Alt ekran: **Actions (Tetik Bayrakları)**

| UI | Komut |
|---|---|
| Load | `actions.get` |
| 4 toggle (early_mail, early_tg, trig_mail, trig_relay) | `actions.save {...}` |

### Alt ekran: **WiFi Ayarları**

AP modu kaldırıldı. Sadece STA + backup + scan.

| Section | UI | Komut | Event |
|---|---|---|---|
| Status | — | `wifi.status` | `wifi.state`, `wifi.ip.acquired/lost` |
| Scan | "Ağları tara" | `wifi.scan` | `wifi.scan.done` |
| Connect | SSID/pass/static | `wifi.connect {ssid, pass, static?}` | `wifi.state` |
| Disconnect | Düğme | `wifi.disconnect` | `wifi.state` |
| Primary Clear | Düğme | `wifi.primary.clear` | — |
| Backup Save | Form | `wifi.backup.save {...}` | — |
| Backup Clear | Düğme | `wifi.backup.clear` | — |
| Config görüntüleme | — | `wifi.config.get` | — |

### Alt ekran: **Webhook / External API (Virtual Button)**

Karşılık: eski `#api-settings`.

| UI | Komut | Event |
|---|---|---|
| Load | `webhook.reset.config.get` | — |
| Enable/disable toggle | `webhook.reset.config.set {enabled}` | — |
| Generate new key | `webhook.reset.key.generate` | — |
| Clear key | **Critical**: `device.confirm-token.get` → `webhook.reset.key.clear` | — |
| Show example URL | APP hesaplar: `http://<wifi.ip>/api/reset?key=<plaintext_key>` | — |
| Canlı çağrı bildirimi | — | `webhook.triggered`, `webhook.rate-limit.hit` |

### Alt ekran: **Device Logs**

| UI | Komut | Event |
|---|---|---|
| Load son N | `log.list --count 100` | `log.added` (canlı) |
| Type filter | `log.list --type ERROR` | — |
| Clear (Critical) | `device.confirm-token.get` → `log.clear` | — |
| Export | Lokal APP JSON olarak kaydeder | — |

### Alt ekran: **Firmware & OTA**

| UI | Komut | Event |
|---|---|---|
| Info | `ota.fw.info`, `device.detail` | — |
| Check for updates | `ota.fw.check [custom_url?]` | `ota.fw.state` |
| Start (Critical) | `device.confirm-token.get` → `ota.fw.start` | `ota.fw.progress`, `ota.fw.done`, `device.shutdown.imminent` |
| Status polling | `ota.fw.status` (fallback; event tercih edilir) | — |
| Rollback (Critical) | `device.confirm-token.get` → `ota.fw.rollback` | `ota.fw.done`, shutdown |

### Alt ekran: **Pairing & Security**

| UI | Komut | Event |
|---|---|---|
| Bond listesi | `pairing.status` | — |
| Pairing mode aç (USB senaryosu) | `pairing.start` | `pairing.mode.open/close` |
| Pairing mode kapat | `pairing.stop` | — |
| Unpair bu APP (Critical) | `device.confirm-token.get` → `ble.unpair --this-bond` | `auth.bond.revoked` |
| Unpair specific | `device.confirm-token.get` → `ble.unpair {bond_id}` | `auth.bond.revoked` |
| Token rotate (Critical) | `device.confirm-token.get` → `auth.token.rotate` | `auth.token.rotated` (bağlantı düşer) |
| Handshake log | — | `auth.handshake.ok/fail` |

### Alt ekran: **Device Info / Diagnostics**

| UI | Komut |
|---|---|
| Özet | `device.info` |
| Detay (chip, heap, reset_reason) | `device.detail` |
| Uptime | `system.uptime` |
| Heap (realtime) | `system.heap` (periyodik) |
| Reset reason | `system.reset-reason` |
| Restart (Critical) | `device.confirm-token.get` → `device.restart` |
| Factory reset (Critical + APP modal üçüncü seviye onay) | `device.confirm-token.get` → `device.factory-reset` |
| Capabilities | `device.capabilities` |

---

## Tetikleyici: kritik komut akışı (UI perspektifi)

Kritik komutlar için APP şu akışı uygular:

```
1. Kullanıcı "Factory Reset" düğmesine basar
2. APP modal: "Bu cihaz fabrika ayarlarına dönecek. Emin misin?"
3. Kullanıcı onaylar → APP: device.confirm-token.get
4. Cihaz: {"token":"abc123...","ttl_sec":30}
5. APP: device.factory-reset + confirm_token="abc123..."
6. Cihaz doğrular → siler → EVT_DEVICE_SHUTDOWN_IMMINENT → restart
7. APP: cihazı "yeniden başlatılıyor" state'inde gösterir, re-discovery bekler
```

---

## Özet: ekran-komut-event haritası

| SKAPP Ekran | Ana komut grupları | Dinlenen event'ler |
|---|---|---|
| Ana Sayfa (alt sekme) | aggregate polling | tüm cihaz `timer.alarm.*`, `timer.expired`, `ota.fw.done`, `auth.handshake.fail` |
| Cihazlarım | native BLE/mDNS scan, pairing | `pairing.completed` |
| LS Ana Sayfa | timer.*, relay.*, wifi.*, device.info, log.list | timer.tick, timer.*, relay.state, wifi.state, log.added, button.*, timer.alarm.triggered, timer.expired |
| Timer Ayarları | timer.* | timer.set, timer.vacation.*, timer.restart |
| SMTP/Mail | smtp.*, mail.*, file.upload | smtp.*, file.upload.* |
| Telegram | telegram.* | telegram.* |
| Relay | relay.* | relay.state |
| Actions | actions.* | — |
| WiFi | wifi.* | wifi.state, wifi.ip.*, wifi.scan.done |
| Webhook | webhook.reset.* | webhook.triggered, webhook.rate-limit.hit |
| Logs | log.list, log.clear (C) | log.added |
| OTA | ota.fw.*, device.confirm-token | ota.fw.*, device.shutdown.imminent |
| Pairing | pairing.*, ble.unpair (C), auth.token.rotate (C) | pairing.*, auth.*, auth.bond.revoked |
| Device Info | device.*, system.* | device.boot, device.shutdown.imminent, device.capability.changed |

(C) = Critical — confirm token gerekli.

---

## Flutter widget ağacı önerisi

```
lib/
├── screens/
│   ├── home_screen.dart                      (alt sekme 1)
│   ├── devices_screen.dart                   (alt sekme 2)
│   └── settings_screen.dart                  (alt sekme 3)
├── devices/
│   └── lebensspur/
│       ├── ls_detail_scaffold.dart           (tab bar ana iskelet)
│       ├── ls_dashboard_page.dart            (LS Ana Sayfa)
│       ├── ls_timer_page.dart
│       ├── ls_mail_page.dart
│       ├── ls_telegram_page.dart
│       ├── ls_relay_page.dart
│       ├── ls_actions_page.dart
│       ├── ls_wifi_page.dart
│       ├── ls_webhook_page.dart
│       ├── ls_logs_page.dart
│       ├── ls_ota_page.dart
│       ├── ls_pairing_page.dart
│       └── ls_info_page.dart
├── cli_client/                               (sk_core Dart paketi, sk_app/packages)
│   ├── transport/
│   │   ├── ble_transport.dart
│   │   ├── tcp_transport.dart
│   │   └── usb_transport.dart
│   ├── auth/
│   │   ├── ecdh_handshake.dart
│   │   ├── mutual_challenge.dart
│   │   └── hmac_signer.dart
│   ├── command_client.dart
│   ├── event_stream.dart
│   └── device_registry.dart
└── theme/
    ├── colors.dart                           (krem/siyah/beyaz + kırmızı/hardal)
    ├── typography.dart
    └── spacing.dart
```

---

## Stil dönüşümü (eski `style.css` → Flutter theme)

Eski GUI'nin 2991 satırlık CSS'i Flutter theme token'larına dönüşür:
- CSS değişkenleri (`--primary`, `--bg`, vb.) → `lib/theme/colors.dart` const'ları
- Font stack → `TextTheme` stili
- Padding/margin token'ları → `lib/theme/spacing.dart`
- Border radius → `ThemeData.cardTheme.shape` vb.
- Animasyonlar (CSS transitions) → `AnimatedContainer` / `AnimationController`

%90 görsel kimlik hedeflenir (S8 kararı); kalan %10 Flutter-idiomatic.

---

## Eski SPA → Flutter sayfa eşlemesi özeti

| Eski HTML bölümü | Flutter sayfası |
|---|---|
| `#home` | `ls_dashboard_page.dart` |
| `#timer-settings` | `ls_timer_page.dart` |
| `#mail-settings` | `ls_mail_page.dart` |
| `#telegram-settings` | `ls_telegram_page.dart` |
| `#relay-settings` | `ls_relay_page.dart` |
| `#actions-settings` | `ls_actions_page.dart` |
| `#wifi-settings` | `ls_wifi_page.dart` |
| `#api-settings` (reset webhook) | `ls_webhook_page.dart` |
| `#logs` | `ls_logs_page.dart` |
| `#gui-ota` + `#fw-ota` | `ls_ota_page.dart` (gui-ota kısmı kaldırıldı) |
| `#test` (eski test sayfası) | KALDIRILACAK (README'deki not) |
| — (yeni) | `ls_pairing_page.dart` |
| — (yeni) | `ls_info_page.dart` |
