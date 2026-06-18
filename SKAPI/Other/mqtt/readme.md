# MQTT — Genel Publish/Subscribe

MQTT (Message Queuing Telemetry Transport), IoT için tasarlanmış hafif pub/sub mesajlaşma protokolü. Smart home dünyasının "lingua franca"sı.

---

## Mimari

```
Cihaz A ──publish topic──►  ┌─────────────┐  ◄──subscribe topic── Cihaz B
                            │ MQTT Broker │
Cihaz C ──publish topic──►  │ (Mosquitto, │  ◄──subscribe topic── Cihaz D
                            │  HiveMQ vb.)│
                            └─────────────┘
```

Cihazlar birbirini **direkt tanımaz**. Hepsi broker'a bağlanır, topic'lerle haberleşir.

---

## Broker Seçenekleri

| Broker | Use case |
|---|---|
| **Mosquitto** | En yaygın, açık kaynak, hafif (Raspberry Pi, NAS, hatta laptop) |
| **Home Assistant Mosquitto add-on** | HA varsa zaten gelir |
| **EMQX** | Enterprise, milyonlarca bağlantı |
| **HiveMQ** | Bulut + on-premise |
| **Eclipse Mosquitto on Docker** | `docker run -d -p 1883:1883 eclipse-mosquitto` |

> SKAPI senaryosu: çoğu kullanıcının zaten **Home Assistant** ya da **Mosquitto** broker'ı vardır. SKAPP hangi broker'a bağlanacağını ayarlardan alır.

---

## Topic Hierarchy

Topic'ler `/` ile ayrılmış string'lerdir.

Örnek topic yapısı (SKAPI önerisi):
```
skapp/laptop1/cmd/break              ← komut
skapp/laptop1/state                  ← durum
skapp/esp32-mola/timer/started       ← event
skapp/+/cmd/+                        ← wildcard subscribe
shellies/shellyplus1pm-XXX/status    ← Shelly cihazı
homeassistant/light/salon/state      ← HA discovery
```

### Wildcards
- `+` — tek seviye (`skapp/+/state` → tüm cihazların state)
- `#` — çok seviye (`skapp/#` → skapp altındaki her şey)

---

## QoS (Quality of Service)

| QoS | Garanti | Use case |
|---|---|---|
| 0 | "fire and forget" | Sensör verisi (kayıp tolere edilir) |
| 1 | "en az bir kez" | Komutlar |
| 2 | "tam bir kez" | Kritik aksiyonlar (nadir kullanılır) |

> **SKAPI tavsiyesi:** Komutlar için QoS 1, sensör verisi için QoS 0.

---

## Retained Messages

`retain: true` ile yayınlanan mesaj broker'da kalır. Yeni subscribe olan cihaz **son retained mesajı** anında alır.

Use case: cihaz state'i. Yeni bağlanan SKAPP, retained "on" mesajını görüp state'i bilir.

---

## Last Will and Testament (LWT)

Cihaz beklenmedik şekilde koparsa, broker önceden tanımlı "last will" mesajını yayınlar.

Use case: SKAPP `skapp/laptop1/state` → "online" yayınlar (retained). Bağlantı koparsa LWT olarak "offline" yayınlanır.

---

## Auth

- **Anonymous** — auth yok (test için)
- **Username/Password** — basic auth
- **TLS + client certificate** — kurumsal

> SKAPI varsayılan: username/password, TLS opsiyonel.

---

## Komut Araçları (CLI)

### Publish
```bash
mosquitto_pub -h 192.168.1.10 -p 1883 -t "skapp/laptop1/cmd/break" -m '{"duration": 60}'
```

### Subscribe
```bash
mosquitto_sub -h 192.168.1.10 -p 1883 -t "skapp/+/cmd/+"
```

### Auth ile
```bash
mosquitto_pub -h 192.168.1.10 -u USER -P PASS -t "topic" -m "msg"
```

---

## Bu Klasördeki Dosyalar

- [publish-subscribe.md](publish-subscribe.md) — Yayınlama ve abone olma için SKAPI şablonları
- ha-discovery.md — Home Assistant MQTT discovery format (yakında)
- skapp-topics.md — SKAPP'in standart topic yapısı (yakında)
- broker-setup.md — Mosquitto kurulum + auth + TLS (yakında)

---

## SKAPI'de MQTT'nin Rolü

MQTT, SKAPI mimarisinin **opsiyonel ama güçlü** parçasıdır. 3 use case:

1. **ESP32 → Broker → SKAPP**: ESP32 timer biter → MQTT publish → SKAPP subscribe → mola tetiklenir
2. **SKAPP → Broker → Cihazlar**: SKAPP "mola başladı" yayınlar, akıllı ışıklar/sensörler subscribe ederek tepki verir
3. **Sensörler → Broker → SKAPP**: Sıcaklık/CO2/hareket sensörleri SKAPP'in koşullu mantığı için veri sağlar

MQTT olmadan da SKAPI çalışır (HTTP REST yeterli), ama ekosisteme entegrasyon için en güçlü protokol.
