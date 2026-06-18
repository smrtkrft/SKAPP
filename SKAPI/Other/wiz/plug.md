# Wiz Smart Plug — Tam API Komut Listesi

**Cihaz:** Wiz Smart Plug (akıllı priz)
**Protokol:** UDP, port 38899
**Format:** JSON

> Wiz Plug **çok basittir** — sadece on/off + güç ölçümü (bazı modeller).
> Renk, parlaklık, sahne yok. Sadece röle.

---

## 1. Cihaz Bilgisi

```json
UDP → IP:38899
{ "method": "getSystemConfig", "params": {} }
```

**Cevap:**
```json
{
  "result": {
    "moduleName": "ESP06_PLUG_T",   // veya benzer
    "fwVersion": "1.30.2",
    "mac": "..."
  }
}
```

`moduleName` içinde `PLUG` geçer.

---

## 2. Aç / Kapat

### Aç
```json
{ "method": "setPilot", "params": { "state": true } }
```

### Kapat
```json
{ "method": "setPilot", "params": { "state": false } }
```

### Mevcut durum sorgula
```json
{ "method": "getPilot", "params": {} }
```

**Cevap:**
```json
{
  "result": {
    "state": true,
    "src": "udp"
  }
}
```

> Plug'ta `dimming`, `r/g/b`, `temp`, `sceneId` parametreleri **anlamsız** — gönderirsen ignore edilir.

---

## 3. Konfigürasyon

### Power-on davranışı
```json
{
  "method": "setUserConfig",
  "params": {
    "userConfig": {
      "powerOnState": "ON_LAST"   // ON_LAST | ON_DEFAULT | OFF
    }
  }
}
```

---

## 4. Cihaz Yönetimi

```json
{ "method": "reboot", "params": {} }
{ "method": "reset", "params": {} }
```

---

## SKAPI Şablonları

### "Plug aç"
```yaml
id: wiz-plug-on
name: "Wiz Plug - Aç"
category: smarthome
target: wiz-plug
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true } }
params:
  - { key: ip, label: "Plug IP", type: ip, required: true }
```

### "Plug kapat"
```yaml
id: wiz-plug-off
name: "Wiz Plug - Kapat"
category: smarthome
target: wiz-plug
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": false } }
params:
  - { key: ip, label: "Plug IP", type: ip, required: true }
```

### "Plug toggle" (manuel)
SKAPP tarafında:
```yaml
id: wiz-plug-toggle
name: "Wiz Plug - Toggle"
endpoints:
  - { protocol: udp, port: 38899, payload: { "method": "getPilot", "params": {} } }
  # Cevap parse edilip mevcut state'in tersi gönderilir
```
