# Shelly Cihazları — Genel Rehber

Shelly (Allterco Robotics) akıllı ev cihazları geniş bir ürün gamına sahip. **İki büyük API nesli** kullanır.

---

## Gen1 (Eski Nesil) — Klasik REST API

**API stili:** Basit REST, query string, GET istekleri
**Format:** JSON cevap
**Auth:** Opsiyonel (Settings > Restrict Login)

**Örnek:**
```
http://192.168.1.42/relay/0?turn=on
```

### Gen1 Cihaz Listesi

#### Anahtarlar / Röleler
- [1.md](1.md) — **Shelly 1** (SHSW-1) — Tek kanal, güç ölçümü yok
- [1pm.md](1pm.md) — **Shelly 1PM** (SHSW-PM) — Tek kanal + güç ölçümü
- 1L.md — **Shelly 1L** (SHSW-L) — Nötr gerektirmeyen tek kanal
- 2.md — **Shelly 2** (SHSW-21) — Eski 2 kanal (artık üretimde değil)
- [2.5.md](2.5.md) — **Shelly 2.5** (SHSW-25) — 2 kanal + güç ölçümü, roller mode
- 4pro.md — **Shelly 4 Pro** (SHSW-44) — DIN rail 4 kanal, eski

#### Akıllı Prizler
- plug.md — **Shelly Plug** (SHPLG-1) — Avrupa prizi, güç ölçümü
- [plug-s.md](plug-s.md) — **Shelly Plug S** (SHPLG-S) — Kompakt versiyon
- plug-us.md — **Shelly Plug US** (SHPLG-U1) — Amerikan prizi

#### Dimmer & Aydınlatma
- dimmer.md — **Shelly Dimmer** (SHDM-1) — İlk nesil dimmer
- [dimmer2.md](dimmer2.md) — **Shelly Dimmer 2** (SHDM-2) — Geliştirilmiş dimmer
- [rgbw2.md](rgbw2.md) — **Shelly RGBW2** (SHRGBW2) — RGB + W LED strip kontrolcüsü

#### Akıllı Ampuller
- bulb.md — **Shelly Bulb** (SHBLB-1) — RGBW ampul
- bulb-rgbw.md — **Shelly Bulb RGBW** (SHCB-1) — Yeni RGBW
- duo.md — **Shelly Duo** (SHBDUO-1) — Tunable beyaz E27
- duo-color.md — **Shelly Duo Color G10** (SHCB-1) — Tunable + RGB GU10
- vintage.md — **Shelly Vintage** (SHVIN-1) — Filament dimmable

#### Enerji Ölçerler
- [em.md](em.md) — **Shelly EM** (SHEM) — Tek faz CT clamp
- 3em.md — **Shelly 3EM** (SHEM-3) — 3 faz CT clamp

#### Sensörler (Pille çalışır, REST API sınırlı)
- ht.md — **Shelly H&T** (SHHT-1) — Sıcaklık + nem
- door-window.md — **Shelly Door/Window 2** (SHDW-2)
- motion.md — **Shelly Motion 2** (SHMOS-02)
- flood.md — **Shelly Flood** (SHWT-1) — Su baskını
- smoke.md — **Shelly Smoke** (SHSM-01) — Duman
- gas.md — **Shelly Gas** (SHGS-1) — Doğalgaz/LPG

#### Giriş Cihazları
- [i3.md](i3.md) — **Shelly i3** (SHIX3-1) — 3 kanallı kuru kontak (sadece input, röle yok)

#### Çok Amaçlı
- uni.md — **Shelly Uni** (SHUNI-1) — 2 input + 2 output, 12-24V

---

## Gen2 / Plus (Yeni Nesil) — JSON-RPC API

**API stili:** JSON-RPC 2.0, hem GET hem POST
**Format:** JSON
**Auth:** Digest Authentication

**Örnek (GET):**
```
http://192.168.1.42/rpc/Switch.Set?id=0&on=true
```

**Örnek (POST):**
```json
POST http://192.168.1.42/rpc
{ "id": 1, "method": "Switch.Set", "params": {"id": 0, "on": true} }
```

### Plus Serisi Cihazlar

#### Anahtarlar / Röleler
- plus1.md — **Shelly Plus 1** (SNSW-001X16EU) — Tek kanal
- [plus1pm.md](plus1pm.md) — **Shelly Plus 1PM** (SNSW-001P16EU) — Tek kanal + güç ölçümü
- [plus2pm.md](plus2pm.md) — **Shelly Plus 2PM** (SNSW-002P16EU) — 2 kanal + güç ölçümü, roller mode

#### Akıllı Prizler
- plus-plug-s.md — **Plus Plug S** (SNPL-00112EU)
- plus-plug-us.md — **Plus Plug US** (SNPL-00116US)
- plus-plug-uk.md — **Plus Plug UK** (SNPL-00112UK)
- plus-plug-it.md — **Plus Plug IT** (SNPL-00110IT)

#### Dimmer
- plus-wall-dimmer.md — **Plus Wall Dimmer** (SNDM-0013US)
- plus-0-10v-dimmer.md — **Plus 0-10V Dimmer** (SNGW-0A11WW)

#### RGBW
- plus-rgbw-pm.md — **Plus RGBW PM** (SNDC-0D4P10WW) — RGB + W + güç ölçümü

#### Giriş Cihazları
- [plus-i4.md](plus-i4.md) — **Plus i4** (SNSN-0024X) — 4 kanal kuru kontak

#### Sensörler
- plus-ht.md — **Plus H&T** (SNSN-0013A) — Sıcaklık + nem
- plus-smoke.md — **Plus Smoke** (SNSN-0031Z) — Duman

---

## Gen3 / Pro Serisi — DIN Rail Profesyonel

**API:** Aynı JSON-RPC (Plus ile aynı)
**Form Faktör:** DIN rail montaj, panolarda kullanım için
**Özellik:** Daha yüksek akım, daha gelişmiş ölçüm

### Pro Cihazları
- pro1.md — **Pro 1** (SPSW-001XE16EU)
- pro1pm.md — **Pro 1PM** (SPSW-001PE16EU)
- pro2.md — **Pro 2** (SPSW-002XE16EU)
- pro2pm.md — **Pro 2PM** (SPSW-002PE16EU)
- pro3.md — **Pro 3** (SPSW-003XE16EU)
- pro4pm.md — **Pro 4PM** (SPSW-004PE16EU) — 4 kanal + güç ölçümü
- pro-dimmer-1pm.md — **Pro Dimmer 1PM**
- pro-dimmer-2pm.md — **Pro Dimmer 2PM**
- pro-em.md — **Pro EM**
- pro-3em.md — **Pro 3EM** — 3 faz pano enerji ölçer
- [dali-dimmer.md](dali-dimmer.md) — **DALI Dimmer Gen3** — DALI lighting protocol
- pro-dual-cover.md — **Pro Dual Cover PM** — 2 perde/panjur motoru

---

## BLU Serisi (Bluetooth, AC Güç Yok)

Bunlar Bluetooth Low Energy cihazlar, **HTTP API'ye sahip değiller**. Bir Shelly Plus/Pro veya Home Assistant **gateway** olarak çalışmalı.

- blu-button.md — Tek butonlu uzaktan kumanda
- blu-doorwindow.md — Kapı/pencere sensörü
- blu-motion.md — Hareket sensörü
- blu-ht.md — Sıcaklık + nem

> Gateway üzerinden tetiklemek için Plus/Pro cihazına webhook konfigüre edilmeli.

---

## Hangi Nesle Sahip Olduğunu Anlama

Tarayıcıdan cihazın IP'sine git:
- `http://IP/shelly` → Gen1 ise eski format JSON döner
- `http://IP/rpc/Shelly.GetDeviceInfo` → Gen2+ ise yeni format JSON döner

Veya cihaz arkasındaki **sticker** model koduna bak:
- `SHSW-...`, `SHPLG-...`, `SHDM-...` → **Gen1**
- `SNSW-...`, `SNPL-...`, `SNSN-...`, `SNDM-...` → **Gen2/Plus**
- `SPSW-...`, `SPDM-...`, `SPEM-...` → **Gen3/Pro**
- `S3DM-...` → **Gen3 (DALI Dimmer)**

---

## SKAPI Şablon Mantığı

Her Shelly modeli için ayrı bir `.md` dosyası var. Her dosya o modelin **tüm API komutlarını** içerir. SKAPP, kullanıcı cihaz tipini seçince ilgili dosyadaki şablonları sunar.

Şu anda detaylı yazılmış olanlar:
- ✅ [1pm.md](1pm.md), [2.5.md](2.5.md), [dimmer2.md](dimmer2.md), [dali-dimmer.md](dali-dimmer.md)
- ✅ [plus1pm.md](plus1pm.md), [plus2pm.md](plus2pm.md), [plus-i4.md](plus-i4.md)
- ✅ [rgbw2.md](rgbw2.md), [em.md](em.md), [i3.md](i3.md), [plug-s.md](plug-s.md)

Diğerleri kademeli eklenecek; benzer model gruplarında API'ler büyük ölçüde örtüşür.
