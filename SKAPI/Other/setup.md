# Akıllı Cihazlar Kurulumu

Bu klasör, **akıllı ev cihazlarınızı** ESP32-C6'nızdan tetiklemek için hazır komut şablonlarını içerir.

> **İyi haber:** Bu cihazlarda **hiçbir şey kurmanıza gerek yok.** Cihazlar zaten kendi API'lerine sahipler. ESP32 doğrudan onlara HTTP komutu gönderir.

---

## Genel Kullanım

3 adım:

1. ✅ Cihaz **aynı Wi-Fi ağında** olmalı
2. ✅ Cihazın **IP adresini** bilin (genelde cihazın kendi uygulamasından öğrenilir)
3. ✅ SKAPP'te şablon seçip IP'yi girin → ESP32'ye yükleyin

Bitti. Geri sayım bittiğinde ESP32 doğrudan cihaza komut gönderir.

---

## Desteklenen Cihazlar

| Cihaz | Yapabildikleri | Token gerekli mi |
|---|---|---|
| **Wiz** ampuller | Aç/kapat, parlaklık, renk, sahne | Hayır |
| **Shelly** rölele/anahtarlar | Aç/kapat, durum oku | Opsiyonel |
| **Philips Hue** | Aç/kapat, parlaklık, renk | Evet (Bridge token) |
| **TP-Link Tapo / Kasa** | Aç/kapat, parlaklık | Evet (hesap) |
| **Tuya / Smart Life** | Cihaza bağlı | Evet (local key) |
| **Home Assistant** | HA'da ne tanımlıysa hepsi | Evet (long-lived token) |
| **ESPHome** cihazlar | Cihaza özel | Opsiyonel |
| **MQTT cihazlar** | Topic'e publish | Broker bağlantısı |
| **Generic HTTP** | İstediğiniz herhangi bir HTTP API | İsteğe bağlı |

Her cihaz için detaylı şablon kendi alt klasöründe. Bkz. `wiz/`, `shelly/`, `hue/`, `homeassistant/`, vb.

---

## Cihaz IP'sini Nasıl Bulurum

### Yöntem 1: Cihazın kendi uygulamasından
- **Wiz app** → cihaz ayarları → "Cihaz bilgisi"
- **Shelly app** → cihaz → "Internet & Security" → IP
- **Hue app** → Hue Bridge IP'si app içinde gösterilir
- **Tuya / Smart Life** → cihaz → ayarlar → "Cihaz bilgisi"

### Yöntem 2: Router yönetim panelinden
- Router'ınıza bağlanın (genelde `192.168.1.1` veya `192.168.0.1`)
- "Bağlı cihazlar" listesinden cihazınızı bulun

### Yöntem 3: Ağ tarama uygulaması
- Telefondan **Fing** uygulaması
- Bilgisayardan `nmap -sn 192.168.1.0/24`

> **Tavsiye:** Router'ınızdan cihaza **DHCP rezervasyonu** yapın → IP hiç değişmez, ESP32'deki konfigürasyon hep çalışır.

---

## Hızlı Test

ESP32'ye yüklemeden önce komutun çalıştığını test edebilirsiniz.

### Tarayıcıdan (basit komutlar için)
```
http://192.168.1.42/api/v1/state
```

### Komut satırından
```bash
curl -X POST http://192.168.1.42/api/v1/state \
  -H "Content-Type: application/json" \
  -d '{"state":false}'
```

### SKAPP içinden
- Şablonu seçin
- IP girin
- **"Test Et"** butonuna basın
- Cihazınız tepki verirse → şablon hazır, ESP32'ye yüklenebilir

---

## Sorun Giderme

### "Komut gitmiyor / cihaz tepki vermiyor"
- Cihaz açık ve Wi-Fi'ya bağlı mı?
- IP doğru mu? (Router'dan değişmiş olabilir)
- Aynı Wi-Fi ağında mı? (5GHz/2.4GHz farklı sayılır bazen)
- Router'da "AP Isolation" kapalı mı? (cihazlar birbirini görsün)

### "Çalışıyordu, şimdi çalışmıyor"
- Cihazın IP'si değişmiş olabilir → DHCP rezervasyonu yapın
- Cihaz firmware güncellemesi API'yi değiştirmiş olabilir → şablonu güncelleyin

### "Token / şifre soruyor"
- Hue, Tuya, HA gibi cihazlar token gerektirir
- İlgili klasörün içindeki dokümana bakın (örn. `homeassistant/setup.md`)

### "Birden fazla cihaz aynı anda tetiklensin istiyorum"
- ESP32'ye birden fazla aksiyon eklenebilir
- Hepsi sırayla otomatik yürütülür
- Veya: MQTT broker (Home Assistant) üzerinden tek mesajla birden çok cihaz tetiklenir

---

## WIN/MAC/LX Klasörlerinden Farkı

| Konu | WIN/MAC/LX (bilgisayar) | Other (akıllı cihaz) |
|---|---|---|
| Hedef cihazda program kurulumu | SKAPP gerekli | Hiçbir şey gerekmez |
| Konfigürasyon | İlk kurulum sihirbazı | Sadece IP yazılır |
| Token | SKAPP token'ı | Cihaza göre var/yok |
| Firewall | İzin verilmesi gerekebilir | Cihaz zaten dinliyor |
| Keşif | mDNS + IP | Sadece IP |

---

## Sonraki Adım

Hangi cihazı kullanmak istiyorsanız ilgili alt klasöre gidin:

- [wiz/](wiz/) — Wiz ampuller
- [shelly/](shelly/) — Shelly anahtarlar/röleler
- [hue/](hue/) — Philips Hue
- [homeassistant/](homeassistant/) — Home Assistant entegrasyonu
- [tuya/](tuya/) — Tuya / Smart Life cihazlar
- [esphome/](esphome/) — ESPHome cihazlar
- [mqtt/](mqtt/) — Genel MQTT publish
- [http-generic/](http-generic/) — Özel HTTP API

Her klasörde o cihaza özel hazır şablonlar bulunur.
