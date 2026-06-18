# SKAPP ↔ ESP32-C6 CLI Contract

**Version:** 0.2.0 (draft)
**Scope:** Every SmartKraft device MUST implement this contract. The APP assumes these commands exist on every device and uses them for discovery, pairing, and baseline operations. Device-specific commands are discovered at runtime via `device.manifest`.

This document is the single source of truth. Firmware implements; APP consumes. Any change must be coordinated between both sides.

---

## 1. Transport

Three transports, identical wire semantics:

- **USB-C serial** (Serial/JTAG): 115200 baud, newline-delimited JSON
- **BLE GATT**: one write characteristic (client → device) + one notify characteristic (device → client); payloads are newline-delimited JSON chunks; large responses may be fragmented by the BLE stack
- **TCP NDJSON**: port 8080 (default), advertised via mDNS as `_skapp._tcp`. Newline-delimited JSON over TCP. WiFi-paired devices only.

All three transports parse the same grammar. Firmware's CLI dispatcher does not care which transport delivered the line.

## 2. Wire Format

### 2.1 Two modes: machine and human

The CLI accepts both **machine** (JSON) and **human** (space-separated tokens) input. Machine mode is what SKAPP uses; human mode is what a developer types into a serial console.

| Mode | Input format | Output format |
|---|---|---|
| Machine | `{"id":N,"cmd":"<dot.name>","args":{...}}\n` | `{"id":N,"ok":true,"result":...}\n` or `{"id":N,"ok":false,"err":"...","msg":"..."}\n` |
| Human | `wifi status` (space-separated; resolves to `wifi.status`) | Plain text. SKAPP never reads human-mode output. |

Mode is auto-detected per line: if the line starts with `{` → machine mode; otherwise → human mode.

### 2.2 Command names — dot-notation

Every command is **dot-separated lowercase**: `<topic>.<action>` or `<topic>.<sub>.<action>`. Examples:

- `wifi.scan`, `wifi.connect`, `wifi.status`
- `device.info`, `device.restart`, `device.factory-reset`
- `ota.fw.check`, `ota.fw.start`
- `api.endpoint.add`, `api.endpoint.list`

In human mode, dots are replaced by spaces (`wifi connect home …`). Firmware re-joins the first 1–3 tokens with `.` and looks up the canonical command.

### 2.3 Request envelope (machine mode)

```json
{"id":<u32>, "cmd":"<dot.name>", "args":{<object>}}
```

- `id` — client-assigned, echoed in response; monotonic per session
- `cmd` — command name in dot-notation
- `args` — optional object (absent if no args)
- Optional: `confirm_token` — present when the command requires it (see §6)

Terminated with `\n`.

### 2.4 Response envelope (machine mode)

**Success:**
```json
{"id":<u32>, "ok":true, "result":<any>}
```

**Error:**
```json
{"id":<u32>, "ok":false, "err":"<CODE>", "msg":"<human readable>", "params":{<optional>}}
```

**Unsolicited event (device pushes):**
```json
{"event":"<dot.name>", "data":<any>}
```

Terminated with `\n`.

### 2.5 Standard error codes

| Code | Meaning |
|---|---|
| `ERR_INVALID_ARG` | args missing, wrong type, or out of range |
| `ERR_UNKNOWN_CMD` | command not supported on this device |
| `ERR_NOT_PAIRED` | this transport requires a bonded session and there is none |
| `ERR_NOT_READY` | subsystem still initializing |
| `ERR_BUSY` | another long-running operation in progress |
| `ERR_TIMEOUT` | operation exceeded time limit |
| `ERR_IO` | hardware error (flash, peripheral, network) |
| `ERR_CONFIRM_REQUIRED` | command needs `confirm_token` (see §6) |
| `ERR_INTERNAL` | unexpected firmware state (should never happen) |

## 3. Mandatory Commands

Every SmartKraft device implements ALL of these. APP relies on them being present.

### 3.1 `device.info` — basic identity

Request:
```json
{"id":1,"cmd":"device.info"}
```

Response:
```json
{"id":1,"ok":true,"result":{
  "model":"BF",
  "prefix":"BF",
  "serial":"BF-A06TMFSQT",
  "product":"BlockingFocus",
  "fw_version":"0.1.0",
  "hw_version":"A",
  "protocol_version":"0.2.0",
  "build_info":null
}}
```

`serial` is the unique identity (`<PREFIX>-<HWREV><10 chars>`) — this is what users see and what bonds reference.

### 3.2 `device.commands` — flat list of supported command names

Request:
```json
{"id":2,"cmd":"device.commands"}
```

Response: array of every registered command name (mandatory + device-specific).

```json
{"id":2,"ok":true,"result":[
  "device.info","device.commands","device.status","device.manifest",
  "device.restart","device.factory-reset","device.capabilities",
  "wifi.scan","wifi.connect","wifi.status","wifi.forget","wifi.list","wifi.disconnect",
  "ble.status",
  "ota.fw.check","ota.fw.start","ota.fw.status","ota.fw.rollback","ota.fw.partition",
  "logs.get","time.set",
  "api.enable","api.disable","api.status","api.endpoint.list","api.endpoint.add","api.endpoint.remove","api.send",
  "timer.status","timer.cancel","face.status","battery.status","vibration.enable"
]}
```

The APP calls this immediately after pairing to see what the device exposes. Hidden commands (debug-only) MAY be omitted.

### 3.3 `device.status` — current runtime state

Request:
```json
{"id":3,"cmd":"device.status"}
```

Response (every key MUST be present; values are nullable when not applicable):
```json
{"id":3,"ok":true,"result":{
  "uptime_sec":3421,
  "wifi":{"connected":true,"ssid":"home","rssi":-52,"ip":"192.168.1.34"},
  "ble":{"advertising":false,"paired_clients":1},
  "battery":{"present":true,"percent":87,"voltage_mv":4012,"charging":false},
  "last_error":null,
  "time":{"valid":true,"unix":1745404812,"source":"ntp"}
}}
```

Fields the device cannot answer (no battery, no clock, etc.) report `present:false` or `valid:false`. APP must not assume keys exist on every device beyond this baseline.

### 3.4 `device.manifest` — runtime UI manifest

Critical for the multi-device APP: cihaz kendi UI'ını **runtime'da** SKAPP'a anlatır. Statik manifest dosyası yok.

Request:
```json
{"id":4,"cmd":"device.manifest"}
```

Response (sketched — schema documented in `manifest_schema.md`):
```json
{"id":4,"ok":true,"result":{
  "device":{
    "prefix":"BF",
    "product":"BlockingFocus",
    "screens":[
      {"id":"focus","title":"Geri Sayim","kind":"timer_dashboard"},
      {"id":"prefs","title":"Tercihler","kind":"toggle_list"},
      {"id":"api","title":"Webhook'lar","kind":"endpoint_editor"}
    ]
  },
  "commands":[
    {"name":"timer.status","group":"focus","summary":"Geri sayim durumu","args":[]},
    {"name":"timer.cancel","group":"focus","summary":"Aktif sayimi iptal","args":[]},
    {"name":"vibration.enable","group":"prefs","summary":"Titresim ac/kapa","args":[
      {"name":"value","type":"bool"}
    ]}
  ],
  "events":["face.changed","timer.expired","api.sent","battery.low"]
}}
```

APP renders screens from `screens[]`, binds buttons to `commands[]`, subscribes to `events[]`. **Manifest evolves with firmware**; eski APP yeni alanlari gormezse onlari yok sayar (forward-compat).

### 3.5 `device.restart` — reboot

```json
{"id":5,"cmd":"device.restart"}
```

Response sent before reboot, then the connection drops.

### 3.6 `device.factory-reset` — clear all user state

Wipes: WiFi credentials, BLE bonds, API endpoints, user preferences. Preserves: firmware, hardware identity, factory keys.

Requires a `confirm_token` (see §6):

```json
{"id":6,"cmd":"device.factory-reset","args":{},"confirm_token":"abc123"}
```

Response: `{"ok":true}` then device reboots.

### 3.7 `wifi.scan` — list nearby SSIDs

Response:
```json
{"id":7,"ok":true,"result":[
  {"ssid":"home","rssi":-45,"auth":"wpa2"},
  {"ssid":"office","rssi":-71,"auth":"wpa3"}
]}
```

### 3.8 `wifi.connect` — connect to a WiFi network

```json
{"id":8,"cmd":"wifi.connect","args":{"ssid":"home","pass":"..."}}
```

Response when connected (or after timeout):
```json
{"id":8,"ok":true,"result":{"connected":true,"ip":"192.168.1.34","ssid":"home"}}
```

### 3.9 `wifi.status` — current WiFi state

Same shape as `device.status.wifi`.

### 3.10 `wifi.forget` — clear stored credentials

```json
{"id":10,"cmd":"wifi.forget"}
```

### 3.11 `logs.get` — dump ring buffer

Request:
```json
{"id":11,"cmd":"logs.get","args":{"limit":100,"level":"warn"}}
```

`limit` (default 50, max 200) and `level` (`"debug"|"info"|"warn"|"error"`, default `"info"`) are optional.

Response:
```json
{"id":11,"ok":true,"result":[
  {"ts":1745404712,"lvl":"warn","tag":"wifi","msg":"reconnect attempt 3"}
]}
```

`ts` is `null` if device never had valid time.

### 3.12 `ota.fw.check` — is newer firmware available

Response:
```json
{"id":12,"ok":true,"result":{"current":"0.1.0","latest":"0.2.0","url":"https://..."}}
```

If no manifest URL configured: `{"ok":false,"err":"ERR_NOT_READY","msg":"OTA disabled"}`.

### 3.13 `ota.fw.start` — begin update

```json
{"id":13,"cmd":"ota.fw.start","args":{"url":"https://...","sha256":"..."}}
```

Device pushes progress events:
```json
{"event":"ota.progress","data":{"pct":42}}
```

Final event:
```json
{"event":"ota.done","data":{"ok":true,"new_version":"0.2.0"}}
```

### 3.14 `time.set` — accept time from APP

Used when device has no valid clock yet (no WiFi/NTP):
```json
{"id":14,"cmd":"time.set","args":{"unix":1745404812}}
```

Response: `{"ok":true,"result":{"unix":1745404812}}`.

APP otomatik olarak ilk yapilandirma sirasinda cagirir; kullaniciya gorunmez.

### 3.15 `device.capabilities` — book registry (debug)

Hidden from human help. Reports loaded `sk_*` books and versions for fingerprinting:
```json
{"id":15,"ok":true,"result":{
  "device_id":"BF-A06TMFSQT","fw_version":"0.1.0",
  "books":[{"name":"sk_core","version":"0.1.0"},{"name":"sk_api","version":"0.1.0"}]
}}
```

## 4. Device-Specific Commands

Not part of this contract — discovered runtime via `device.manifest`. APP renders matching widgets from the manifest's `commands[]` list.

Example for Blocking Focus:
- `timer.status` → `{"running":true,"face":3,"remaining_sec":820}`
- `timer.cancel` → `{"ok":true}`
- `face.status` → `{"current":3,"stable_sec":12.4}`
- `vibration.enable` → `args:{"value":true}`

## 5. Versioning Rules

`protocol_version` (returned by `device.info`) follows semver.

- **Patch** bump: clarification, no contract change.
- **Minor** bump: new optional commands or fields added; old APP still works (forward-compat).
- **Major** bump: breaking change — APP MUST check `protocol_version` and refuse to proceed if major mismatches its supported range.

`device.commands` is the runtime escape hatch: APP gates UI by what's actually exposed, not by what semver implies.

## 6. Auth & confirmation tokens

This contract assumes the BLE/TCP transport is **authenticated** via sk_auth (ECDH key agreement + mutual challenge-response, bonded after first pairing). USB transport is implicitly trusted (physical access).

Some destructive commands (`device.factory-reset`, future `device.unpair`) require a one-time `confirm_token`:

1. APP sends the command without `confirm_token`. Device replies with `ERR_CONFIRM_REQUIRED` and a fresh token in `params.confirm_token`.
2. APP re-sends the same command with that token in the request envelope's top-level `confirm_token` field.
3. Device validates and executes. Tokens are single-use and expire after 30 s.

This prevents accidental destructive ops without requiring the user to type a passkey.

### First pairing UX

Per Yapilacaklar.md §9, kullanicinin attigi tek ek adim: cihazda **butona kisa basip** pairing window'unu acmak. APP cihazi bulur, ECDH handshake otomatik yapilir, bond NVS'e yazilir. **Sifre/PIN girisi yoktur.** Sonraki baglantilar bond ile sessizce kurulur.

## 7. Open items

- **BLE MTU & chunking**: large `device.manifest` cevaplari MTU'yu asabilir. v0.3'te chunking protokolu (`{"id":N,"chunk":k/total,...}`) tanimlanacak.
- **Event subscription model**: simdilik tum event'ler bagli her client'a push'lanir. Filtre/abonelik v0.3'te.
- **Time-zone**: `time.set` UTC unix epoch; lokal saat donusumu APP tarafinda.
