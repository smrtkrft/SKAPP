# BF (Blocking Focus) — CLI Komutları

Bu dosya BF firmware'inde (`esp32/BF/`) kayıtlı tüm CLI komutlarının kategorik listesidir. Komutlar `sk_cli_command_t` array'lerinde `.name = "<komut>"` field'ı ile kayıtlı; topic ve kategoriler `sk_cli_register_topic("topic", "summary", "CATEGORY")` çağrılarından gelir.

**Yazım biçimi (SKAPP CLI ve LS monitor için aynı):**

```
wifi connect ofis_wifi 12345678              # önerilen, pozisyonel
wifi.connect ssid="ofis wifi" password="..." # named (boşluklu ad için tırnak)
wifi connect --ssid ofis_wifi --password 12345678  # named flag stili
```

İşaretler:
- `[critical]` — confirm token gerektirir. Token cihazdan otomatik istenir, SKAPP onay diyaloğunda göstereceği şekilde geri gönderir
- `[hidden]` — `help` listesinde görünmez ama doğrudan çağrılabilir (SKAPP-internal / scripting)
- `[auth]` — sadece BLE/TCP authenticated transport'tan çağrılır; USB CLI'da `ERR_NOT_AUTHENTICATED` döner

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

İki slot mantığı: primary fail olursa birkaç denemeden sonra backup'a düşer (ev + ofis arası gezen cihaz için faydalı).

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

### ota — Firmware updates (check / install / rollback)

| Komut | Açıklama |
|---|---|
| `ota.status` | Güncelleme durumu, current/available sürümler, aktif partition |
| `ota.check` | Sunucudan yeni firmware var mı sor (kurmaz) |
| `ota.update` | `ota.check` ile bulunan firmware'i kur (cihaz reboot eder) `[critical]` |
| `ota.rollback` | Bir önceki firmware'e geri dön (yeni build bozuksa) `[critical]` |

### auth — Content-access passphrase (set / change / mode)

| Komut | Açıklama |
|---|---|
| `auth.passphrase.status` | Passphrase config (set durumu, mode, kalan deneme) |
| `auth.passphrase.set` | İlk kez passphrase set et `[critical]` |
| `auth.passphrase.change` | Mevcut passphrase'i değiştir (eski doğrulanır) `[critical]` |
| `auth.passphrase.clear` | Passphrase'i kaldır (eski doğrulanır) `[critical]` |
| `auth.passphrase.mode.set` | İki enforcement toggle'ı ayarla `[critical]` |
| `auth.token.rotate` | Aktif session token'ı döndür (SKAPP-only) `[critical]` `[hidden]` |

---

## OUTPUT

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

### vibration — Vibration motor master switch

| Komut | Açıklama |
|---|---|
| `vibration.on` | Vibration motor'u aç |
| `vibration.off` | Vibration motor'u kapat |
| `vibration.status` | Master switch durumu |
| `vibration.burst` | Vibration burst (pulse pattern) |

### Tilt / Battery Warnings

| Komut | Açıklama |
|---|---|
| `tilt.warn.on` | Tilt warning vibration aç |
| `tilt.warn.off` | Tilt warning vibration kapat |
| `tilt.warn.status` | Tilt warning durumu |
| `low_batt.warn.on` | Düşük pil uyarı titreşimi aç |
| `low_batt.warn.off` | Düşük pil uyarı titreşimi kapat |
| `low_batt.warn.status` | Düşük pil uyarı durumu |

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

### logs — Log entries (ring buffer)

| Komut | Açıklama |
|---|---|
| `logs.get` | Ring buffer'dan son log girişlerini oku |

`logs.get` kullanımı: `logs get [--limit N] [--level LVL]`

---

## BF Donanım/Davranış Komutları

### secure — Encrypted key-value store

| Komut | Açıklama |
|---|---|
| `secure.get` | Şifrelenmiş KV değeri oku (SKAPP-only) `[auth]` |
| `secure.set` | Şifrelenmiş KV değeri yaz (SKAPP-only) `[auth]` |
| `secure.erase` | Şifrelenmiş KV girişi sil `[auth]` |
| `secure.list` | Şifrelenmiş KV key adlarını listele `[auth]` |

### userdata — User script blob

| Komut | Açıklama |
|---|---|
| `userdata.size` | User-script blob'un mantıksal boyutu `[auth]` |
| `userdata.read` | User-script blob'undan slice oku (base64) `[auth]` |
| `userdata.write` | User-script blob'una slice yaz `[auth]` |
| `userdata.truncate` | Mantıksal boyutu ayarla (büyürse sıfırla doldurur) `[auth]` |
| `userdata.clear` | User-script blob'unu temizle `[critical]` `[auth]` |

### face — Yüz algılama

| Komut | Açıklama |
|---|---|
| `face.status` | Yüz algılama durumu |

### battery — Pil monitör

| Komut | Açıklama |
|---|---|
| `battery.status` | Pil voltajı ve threshold event'leri |

### accel — İvmeölçer

| Komut | Açıklama |
|---|---|
| `accel.read` | LIS3DSH ivmeölçer verisi |

### eyes — Ekran/UI animasyonları

| Komut | Açıklama |
|---|---|
| `eyes.set` | Göz animasyon frame'i ayarla |
| `eyes.next` | Sonraki göz animasyonuna geç |
| `eyes.list` | Mevcut göz animasyonlarını listele |

### power — Güç yönetimi

| Komut | Açıklama |
|---|---|
| `power.status` | Güç yönetimi durumu |
| `power.kick` | Power watchdog timer'ı sıfırla |

### timer — Zamanlayıcı motoru

| Komut | Açıklama |
|---|---|
| `timer.status` | Timer durumu |
| `timer.cancel` | Çalışan timer'ı iptal et |

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
help wifi.connect  # tek komut detayı (usage + örnekler)
help all           # tüm komutlar gruplı (gizliler dahil)
```

---

## İstatistikler

- **Toplam komut:** ~80
- **Topic sayısı:** 14
- **Critical komutlar:** 12 (confirm token gerektirir)
- **Hidden komutlar:** 6 (SKAPP-internal)
- **Auth-gerektiren komutlar:** 9 (secure.*, userdata.*) — sadece BLE/TCP authenticated

**Paylaşılan topic'ler (LS ile aynı):** wifi, ble, pairing, ota, auth, api, device, bond, logs, root builtins (help, json.*, time.set)

**BF'e özgü:** vibration, tilt.warn, low_batt.warn, face, battery, accel, eyes, power, timer, secure, userdata
