# LS (LebensSpur) — CLI Komutları

Bu dosya LS firmware'inde (`esp32/LS/`) kayıtlı tüm CLI komutlarının kategorik listesidir. Komutlar `sk_cli_command_t` array'lerinde `.name = "<komut>"` field'ı ile kayıtlı; topic ve kategoriler `sk_cli_register_topic("topic", "summary", "CATEGORY")` çağrılarından gelir.

LS, sk_core kütüphanesini BF ile paylaşır — wifi/ble/pairing/ota/auth/api/device/bond/logs topic'leri her iki cihazda aynıdır. Bu MD'de bu paylaşılan komutlar ayrıntılı listelenir + LS'ye özgü (timer, vacation, smtp, mail, relay, reset_api) komutlar da kategorize edilmiştir.

**Yazım biçimi (SKAPP CLI ve LS monitor için aynı):**

```
wifi connect ofis_wifi 12345678              # önerilen, pozisyonel
wifi.connect ssid="ofis wifi" password="..." # named (boşluklu ad için tırnak)
timer set day 30 alarm 3                     # pozisyonel + flag
```

İşaretler:
- `[critical]` — confirm token gerektirir. Token cihazdan otomatik istenir, SKAPP onay diyaloğunda göstereceği şekilde geri gönderir
- `[hidden]` — `help` listesinde görünmez ama doğrudan çağrılabilir (SKAPP-internal / scripting)
- `[auth]` — sadece BLE/TCP authenticated transport'tan çağrılır

---

## TIMER

### timer — Countdown timer (set / start / stop / reset / status)

| Komut | Açıklama |
|---|---|
| `timer.set` | Süreyi ayarla: `<unit> <value>` (minute / hour / day, 1..60) + opsiyonel `alarm <0..10>` |
| `timer.get` | Mevcut timer konfigürasyonu |
| `timer.start` | Geri sayımı tam süreden başlat |
| `timer.stop` | Geri sayımı durdur (state → inactive) |
| `timer.reset` | Geri sayımı tam süreye sıfırla |
| `timer.status` | Timer runtime state |

`timer.set` kullanımı:

```
timer set <unit> <value> [alarm <N>]
```

Örnekler:
```
timer set day 30
timer set hour 12 alarm 3
timer set minute 45
```

### vacation — Vacation mode (geri sayımı N gün duraklat)

| Komut | Açıklama |
|---|---|
| `vacation.set` | Vacation pause süresini ayarla (N gün) |
| `vacation.cancel` | Vacation mode'u iptal et, geri sayımı sürdür |

---

## SETUP

### wifi — Network connection (primary + backup)

| Komut | Açıklama |
|---|---|
| `wifi.status` | Bağlantı durumu, SSID, IP, sinyal gücü |
| `wifi.scan` | Yakındaki ağları listele (max 12) |
| `wifi.list` | Kayıtlı ağları listele |
| `wifi.connect` | Ağa bağlan ve credentials'ı kaydet |
| `wifi.disconnect` | Mevcut bağlantıyı kes |
| `wifi.forget` | Kayıtlı credentials'ı sil (slot veya hepsi) `[critical]` |

`wifi.connect` kullanımı:

```
wifi connect <ssid> [password] [192.168.1.50[/24]] [primary|backup]
```

Örnekler:
```
wifi connect HomeWiFi pass1234
wifi connect HomeWiFi pass1234 192.168.1.111
wifi connect HomeWiFi pass1234 192.168.1.111/24
wifi connect HomeWiFi pass1234              # primary slot (default)
wifi connect OfficeWiFi pass5678 backup     # backup slot
```

### ble — Bluetooth transport

| Komut | Açıklama |
|---|---|
| `ble.unpair` | Tüm eşleşmiş telefonları unutur (bond slot'larını temizler) `[critical]` |

### pairing — BLE pairing window

| Komut | Açıklama |
|---|---|
| `pairing.status` | Pairing window durumu + dolu bond slot sayısı |
| `pairing.start` | 60 saniyelik BLE pairing window aç (SKAPP cihazı keşfeder) |
| `pairing.stop` | Pairing window'u erken kapat |

### auth — Content-access passphrase

| Komut | Açıklama |
|---|---|
| `auth.passphrase.status` | Passphrase config (set durumu, mode, kalan deneme) |
| `auth.passphrase.set` | İlk kez passphrase set et `[critical]` |
| `auth.passphrase.change` | Mevcut passphrase'i değiştir (eski doğrulanır) `[critical]` |
| `auth.passphrase.clear` | Passphrase'i kaldır (eski doğrulanır) `[critical]` |
| `auth.passphrase.mode.set` | İki enforcement toggle'ı ayarla `[critical]` |
| `auth.token.rotate` | Aktif session token'ı döndür (SKAPP-only) `[critical]` `[hidden]` |

### ota — Firmware updates

| Komut | Açıklama |
|---|---|
| `ota.status` | Güncelleme durumu, current/available sürümler, aktif partition |
| `ota.check` | Sunucudan yeni firmware var mı sor (kurmaz) |
| `ota.update` | `ota.check` ile bulunan firmware'i kur (cihaz reboot eder) `[critical]` |
| `ota.rollback` | Bir önceki firmware'e geri dön (yeni build bozuksa) `[critical]` |

---

## ALARM OUTPUT

### smtp — SMTPS mail sunucusu

| Komut | Açıklama |
|---|---|
| `smtp.host` | SMTP server hostname |
| `smtp.port` | SMTP server port |
| `smtp.sender` | Gönderen e-posta adresi |
| `smtp.key` | SMTP API key (şifre) `[auth]` |
| `smtp.get` | Mevcut SMTP konfigürasyonu |
| `smtp.test` | Test maili gönder (SMTP bağlantısı doğrulanır) |

### api — Outbound webhook presets

| Komut | Açıklama |
|---|---|
| `api.on` | Master switch: kayıtlı endpoint'ler tetiklenebilsin |
| `api.off` | Master switch: tüm API çağrılarını engelle (kayıtlar korunur) |
| `api.status` | Master switch durumu + endpoint sayıları |
| `api.endpoint.list` | Kayıtlı endpoint'leri listele (USER + SYSTEM) |
| `api.endpoint.add` | USER (manuel) endpoint ekle/güncelle |
| `api.endpoint.remove` | USER endpoint'i isimle sil |
| `api.system.add` | SYSTEM (paired-SKAPP) endpoint ekle |
| `api.system.remove` | SYSTEM endpoint kaldır |
| `api.system.purge` | Tüm SYSTEM endpoint'leri sil |
| `api.system.list` | Tüm SYSTEM endpoint'leri listele |
| `api.send` | Tek endpoint'i hemen tetikle (manuel test) |
| `api.chain.run` | Tüm endpoint'leri tetikle (USER sonra SYSTEM, sıralı) |

---

## LS OUTPUT

### mail — Mail grupları (alıcılar + konu + gövde)

| Komut | Açıklama |
|---|---|
| `mail.group.add` | Yeni mail grubu oluştur |
| `mail.group.delete` | Mail grubunu sil |
| `mail.group.enable` | Mail grubunu aç/kapat |
| `mail.group.name` | Mail grubu adı/etiketi |
| `mail.group.subject` | E-posta konusu |
| `mail.group.body` | E-posta gövde template'i |
| `mail.group.list` | Tüm mail gruplarını listele |
| `mail.group.get` | Belirli mail grubunun detayı |
| `mail.group.recipient.add` | Mail grubuna alıcı ekle |
| `mail.group.recipient.remove` | Mail grubundan alıcı çıkar |

### relay — Çıkış rölesi (GPIO + delay + duration + pulse)

| Komut | Açıklama |
|---|---|
| `relay.gpio` | Röle GPIO pin numarası |
| `relay.invert` | Röle polaritesi (active high/low) |
| `relay.delay` | Aktivasyon öncesi gecikme |
| `relay.duration` | Aktif kalma süresi |
| `relay.pulse` | Pulse modu aç/kapat |
| `relay.get` | Mevcut röle konfigürasyonu |
| `relay.test` | Mevcut config ile röleyi test et |
| `relay.fire` | Röleyi anında tetikle |
| `relay.abort` | Devam eden röle aktivasyonunu iptal et |
| `relay.status` | Röle durumu ve faz |

---

## SYSTEM

### device — Identity, restart, factory reset

| Komut | Açıklama |
|---|---|
| `device.info` | Identity + runtime snapshot (info + status birleşik) |
| `device.commands` | Tüm kayıtlı komutları JSON array olarak listele `[hidden]` |
| `device.manifest` | SKAPP için runtime UI manifest `[hidden]` |
| `device.restart` | Cihazı yeniden başlat `[critical]` |
| `device.factory-reset` | Bond, ayar, hepsini sıfırla — fabrika ayarları `[critical]` |
| `device.capabilities` | Yüklü kütüphaneler ve sürümler `[hidden]` |
| `device.confirm-token` | Kritik komut için tek-kullanımlık token üret |

### bond — Paired SKAPP installs

| Komut | Açıklama |
|---|---|
| `bond.list` | Eşleşmiş SKAPP'ları listele (slot, peer_id, label, paired_at) |
| `bond.remove` | Eşleşmeyi slot ile kaldır (o SKAPP'ı unut) `[critical]` |

### reset_api — Inbound HTTP /api/reset endpoint

| Komut | Açıklama |
|---|---|
| `reset_api.enable` | Reset API endpoint'i aç/kapat |
| `reset_api.key` | Reset API authentication key `[auth]` |
| `reset_api.regen` | Yeni reset API key üret `[auth]` |
| `reset_api.get` | Mevcut reset API konfigürasyonu |
| `reset_api.status` | Reset API durumu |

### logs — Log entries (ring buffer)

| Komut | Açıklama |
|---|---|
| `logs.get` | Ring buffer'dan son log girişlerini oku |

`logs.get` kullanımı: `logs get [--limit N] [--level LVL]`

---

## ROOT (namespace'siz)

| Komut | Açıklama |
|---|---|
| `help` | Komutları listele veya tek komut detayı |
| `json.on` | NDJSON machine mode'a geç `[hidden]` |
| `json.off` | Human mode'a dön `[hidden]` |
| `time.set` | UNIX zaman push (SKAPP-only, NTP yokken) `[hidden]` |

`help` kullanımı:

```
help               # tüm topic'lerin başlıklarını gör
help wifi          # bir topic'in komutları
help timer.set     # tek komut detayı (usage + örnekler)
help all           # tüm komutlar gruplı (gizliler dahil)
```

---

## İstatistikler

- **Toplam komut:** ~75
- **Topic sayısı:** 13
- **Critical komutlar:** 12 (confirm token gerektirir)
- **Hidden komutlar:** 4 (SKAPP-internal)
- **Auth-gerektiren komutlar:** ~3 (smtp.key, reset_api.key/regen)

**Paylaşılan topic'ler (BF ile aynı):** wifi, ble, pairing, ota, auth, api, device, bond, logs, root builtins (help, json.*, time.set)

**LS'ye özgü:** timer, vacation, smtp, mail, relay, reset_api

**Cihaz farkları:**
- **BF**'de var, LS'de yok: vibration, tilt.warn, low_batt.warn, face, battery, accel, eyes, power, secure, userdata
- **LS**'de var, BF'de yok: timer, vacation, smtp, mail, relay, reset_api
