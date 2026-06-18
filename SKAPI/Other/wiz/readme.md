# Wiz Connected Cihazları — Genel Rehber

Wiz (Signify/Philips bünyesinde) akıllı aydınlatma ürünleri **UDP tabanlı JSON protokolü** kullanır.

> **Önemli:** Wiz, Shelly gibi HTTP REST kullanmaz. **UDP port 38899** üzerinde JSON-RPC benzeri mesajlaşma yapar.
> Bu, ESP32 için sorun değil — UDP kütüphaneleri kolay kullanılır.

---

## Protokol Özeti

- **Port:** UDP 38899
- **Format:** JSON
- **Auth:** Yok (yerel ağda açık) — güvenlik için cihazlar kendi Wi-Fi'larına izole olmalı
- **Discovery:** UDP broadcast ile (255.255.255.255:38899)

### Tipik istek
```json
{
  "method": "setPilot",
  "params": { "state": true, "dimming": 50 }
}
```

### Tipik cevap
```json
{
  "method": "setPilot",
  "env": "pro",
  "result": { "success": true }
}
```

### Komut göndermek için (örnek)
```bash
echo '{"method":"setPilot","params":{"state":true,"dimming":50}}' | nc -u -w1 192.168.1.42 38899
```

ESP32 / Python / Node — UDP socket üzerinden aynı JSON gönderilir.

---

## Cihaz Tipleri

Wiz ürün gamı geniş, ama API'ler benzer. Önemli ayrım: **hangi parametreler destekleniyor?**

| Cihaz tipi | Parametreler |
|---|---|
| **Tunable White Bulb** | `state`, `dimming`, `temp` (Kelvin), `sceneId` (sınırlı) |
| **Color (RGB) Bulb** | `state`, `dimming`, `temp`, `r`, `g`, `b`, `c`, `w`, `sceneId` (32 sahne) |
| **Filament / Vintage** | `state`, `dimming`, `sceneId` |
| **LED Strip** | `state`, `dimming`, `temp`, `r`, `g`, `b`, `sceneId`, `speed` |
| **Smart Plug** | `state` (sadece) |

Cihaz tipini öğrenmek için `getSystemConfig` çağrısı yapılır.

---

## Ana Method'lar

| Method | Amaç |
|---|---|
| `getPilot` | Mevcut durum (parlaklık, renk, sahne) |
| `setPilot` | Durum değiştir (ana komut) |
| `getSystemConfig` | Cihaz tipi, MAC, FW sürümü |
| `setSystemConfig` | Sistem ayarlarını değiştir (Wi-Fi, isim) |
| `setUserConfig` | Kullanıcı tercihleri (varsayılan parlaklık vb.) |
| `getUserConfig` | Kullanıcı tercihlerini oku |
| `setSchedule` | Zamanlama tanımla |
| `getSchedule` | Zamanlama listesi |
| `registration` | Cihazı uygulamaya kayıt et |
| `setWifi` | Wi-Fi ayarlarını değiştir |
| `pulse` | Cihazı kısaca yanıp söndür (identify için) |
| `reboot` | Yeniden başlat |
| `reset` | Fabrika ayarları |
| `firstBeat` | İlk tanıtım (provisioning) |

---

## setPilot Tüm Parametreleri

```json
{
  "method": "setPilot",
  "params": {
    "state": true,           // bool — açık/kapalı
    "dimming": 50,           // int 10-100 — parlaklık (10 altı kabul edilmez)
    "temp": 3000,            // int 2200-6500 — Kelvin (sadece tunable/color)
    "r": 255,                // int 0-255 — kırmızı (sadece RGB)
    "g": 0,                  // int 0-255 — yeşil
    "b": 0,                  // int 0-255 — mavi
    "c": 0,                  // int 0-255 — cool white kanalı (RGBCW)
    "w": 0,                  // int 0-255 — warm white kanalı (RGBCW)
    "sceneId": 1,            // int 1-32 — preset sahne
    "speed": 100,            // int 10-200 — sahne animasyon hızı
    "ratio": 50              // int 0-100 — warm/cool oranı (tunable için)
  }
}
```

### Önemli Kural
- `r/g/b` ile `temp` aynı anda gönderilemez (renk MODU vs beyaz MODU)
- `sceneId` gönderildiğinde rgb/temp ignore edilir
- `state=false` gönderildiğinde diğer parametreler yine de saklanır (cihaz açıldığında geri yüklenir)

---

## Sahne ID'leri (sceneId 1-32)

Color bulb'larda hepsi geçerli. White-only bulb'larda sadece beyaz sahneler.

| ID | Sahne | Tip |
|---|---|---|
| 1 | Ocean | Renkli, dinamik |
| 2 | Romance | Renkli |
| 3 | Sunset | Renkli |
| 4 | Party | Renkli, hızlı |
| 5 | Fireplace | Sıcak, dinamik |
| 6 | Cozy | Sıcak beyaz |
| 7 | Forest | Yeşil tonları |
| 8 | Pastel Colors | Yumuşak renkler |
| 9 | Wake up | Dinamik, parlaklığı yavaş artırır |
| 10 | Bedtime | Sıcak, dinamik söner |
| 11 | Warm white | Sabit sıcak beyaz |
| 12 | Daylight | Sabit doğal beyaz |
| 13 | Cool white | Sabit soğuk beyaz |
| 14 | Night light | Çok kısık sıcak |
| 15 | Focus | Soğuk beyaz, parlak |
| 16 | Relax | Sıcak beyaz, kısık |
| 17 | True colors | Renkli statik |
| 18 | TV time | Mavi tonları |
| 19 | Plantgrowth | Pembe-mor (büyüme spektrumu) |
| 20 | Spring | Yeşil-pembe |
| 21 | Summer | Sarı-turuncu |
| 22 | Fall | Turuncu-kırmızı |
| 23 | Deep dive | Mavi tonları |
| 24 | Jungle | Yeşil tonları |
| 25 | Mojito | Yeşil-sarı |
| 26 | Club | Renkli, çok hızlı |
| 27 | Christmas | Kırmızı-yeşil dönüşümlü |
| 28 | Halloween | Turuncu-mor |
| 29 | Candlelight | Sıcak titreşimli |
| 30 | Golden white | Sıcak altın |
| 31 | Pulse | Renk değiştiren nabız |
| 32 | Steampunk | Sıcak amber, dönen |

---

## Bu Klasördeki Cihazlar

- [white-bulb.md](white-bulb.md) — Wiz Tunable White ampul (sadece beyaz)
- [color-bulb.md](color-bulb.md) — Wiz Color (RGB) ampul (tam renk)

İleride: led-strip, plug, filament, candle, spot
