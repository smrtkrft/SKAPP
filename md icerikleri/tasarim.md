# SKAPP Tasarım Notları

Bu dosya SKAPP'in tasarım felsefesini, görsel kurallarını ve mimari ekosistem yaklaşımını toplar. Yeni ekranlar/özellikler eklerken referans noktasıdır.

**Son güncelleme:** 2026-04-23

---

## 1. Tasarım Kuralları (özet)

### 1.1 Renk paleti (KATI — izinsiz renk yasak)

| Rol | Light tema | Dark tema | Hex |
|---|---|---|---|
| Arka plan | Eggshell/off-white | Siyah | `#F5F2EC` / `#0A0A0A` |
| Ana metin | Siyah | Beyaz | `#0A0A0A` / `#F5F5F5` |
| Uyarı (engel olan hata) | Kırmızı | Kırmızı | `#D32F2F` |
| Dikkat (geri döndürülemez onay, önemli uyarı) | Hardal sarısı | Hardal sarısı | `#D4A017` |

**Kural:** Bu 5 hex dışında renk kullanmak için önce kullanıcıdan açık izin ve gerekçeyle onay alınır. Mavi/yeşil/mor vb. YASAK.

### 1.2 Yazı tipi

Şu an Flutter varsayılanı (Roboto). İleride SmartKraft'a özel bir yazı tipi (örn. Inter, IBM Plex) seçilirse tek yerden değiştirilebilir.

### 1.3 Kontrast ve minimum renk kullanımı

Vurgu elementleri (badge, ikon, kontur) renk yerine **kalınlık/opaklık** ile yapılır. Yeşil/kırmızı online/offline alışkanlığı yerine:
- Çevrimiçi → dolu ikon, tam opak metin
- Çevrimdışı → outline ikon, %50 opak metin, ince kesikli çerçeve

### 1.4 Animasyon felsefesi

Minimum mikro-animasyon. Sade, profesyonel görünüm. Ekran geçişleri Flutter varsayılan; ekstra parlama/dönme efektleri eklenmez (isteğe bağlı onay ile istisna yapılır).

---

## 2. Navigasyon Yapısı (mevcut)

Alt tab (bottom navigation):

- **Ana Sayfa** — SmartKraft logo + hızlı erişim + hızlı aksiyonlar (genişleyecek)
- **Cihazlarım** — kayıtlı cihaz listesi, kategorize
- **Ayarlar** — dil, tema, hakkında

Cihaz detay ekranları push route ile açılır (tab değil).

Gelecekte — Bölüm 4'te ekosistem paradigmasına göre **4. tab** önerilecek.

---

## 3. Özellikler Önceliklendirme (özet)

`uygulama_ozellikleri.md` dosyasındaki tam listeden çıkarılan, **SKAPP ekosistemine uyan** başlıklar:

**Faz 1 (hazır ✅):**
- Splash, 3 tab, dil/tema seçici, BLE scan (mock), passkey formu (mock)

**Faz 3 (firmware gelince):**
- Cihaz detay ekranı (manifest-driven)
- Gerçek BLE + provisioning
- Cihaz-özgü kontroller (timer, trigger, ayar)
- Factory reset, OTA, log görüntüleme

**Ertelenebilir:**
- Oda/zon sistemi — **muhtemelen SKAPP'e uygun değil** (bkz. Bölüm 4)
- Senaryo/otomasyon motoru — cihaz başına basit trigger yeter (şimdilik)
- Push bildirimleri (bulut gerekli, yok)
- Bulut hesabı / eş-zamanlama
- QR kod tarayıcı (cihazlarda QR yok)

---

## 4. SKAPP Ekosistem Yaklaşımı — KRİTİK AYIRIM

### 4.1 SKAPP nedir, ne değildir

SKAPP, **akıllı ev uygulaması DEĞİLDİR.** Philips Hue, IKEA Home, Tuya, SmartLife gibi "lamba-priz-termostat-perde" ekosistemine dahil değil.

**SKAPP, özgün/niş cihaz ekosistemidir.** Her cihaz kendi kullanım senaryosunu çözer. Benzer cihazlardan ziyade, **farklı deneyimler ve araçlar** olarak düşünülmeli.

### 4.2 Kullanıcı senaryosu (kullanıcı örneği — Blocking Focus)

> Kullanıcı yoğun çalışıyor, zamanı unutuyor. Telefonundaki alarmı sürekli erteliyor. Masasında SmartKraft Blocking Focus var. Cube'ün üst yüzeyinde 5/15/30/60 dakika seçilebilir. Seçilen süre bittiğinde cube alarm çalar + önceden tanımlı API'ı tetikler → laptop otomatik kapanır. Kullanıcı zorunlu mola vermek zorunda kalır.

Bu cihaz Philips Hue ile aynı kategoride değil. Sadece bilgi göstermiyor, **davranış değiştiriyor**. "Akıllı ev" paradigmasındaki "oda + cihaz + sahne" modeli buna uymuyor.

### 4.3 Ekosistem kategorileri (öneri)

Olası SmartKraft cihaz tipleri:

- **Odak / Produktivite araçları** — Blocking Focus, Odak Sayacı, Do-Not-Disturb signal
- **API tetikleyiciler** — fiziksel buton/anahtar → webhook, IFTTT benzeri bridge
- **Davranış destekleyiciler** — alışkanlık takibi, günlük rutin hatırlatıcı
- **Veri / çevre izleyicileri** — sıcaklık, CO2, gürültü seviyesi (ama tablet göstergesi değil, cihaz kendi başına uyarıyor)
- **Etkileşimli oyuncaklar / deneyimler** — zar atan küp, rastgele seçici, masa üstü duygu ışığı
- **DIY / maker** — kullanıcının özel yaptığı ESP32 projeleri
- **Gelecekte** — evcil hayvan için otomatik mama kabı, özel aydınlatma, müzik/ses tetikleyici

Bu çeşitlilik sadece "cihaz ekle → aç/kapa" arayüzüyle karşılanmaz. Her cihaz kendi zihinsel modelini sunmalı.

---

## 5. İskelette Olması Gereken Yapılar (ekosisteme özel)

### 5.1 Ana Sayfa — "Dashboard" değil, "Aktivite Merkezi"

Hue'nun anasayfası bağlı lambaların durumunu gösterir. SKAPP'inki **şu anki aktiviteyi** göstermeli:

- **Aktif cihaz kartları** — şu an çalışan cihazlar (örn. "Blocking Focus: 23 dakika kaldı", geri sayım canlı)
- **Hızlı aksiyonlar** — sık kullanılan cihaza doğrudan başlatma butonu ("Yeni 30 dk focus session başlat")
- **Son aktivite zaman çizgisi** — "Bugün 14:05: Blocking Focus 30 dk, tamamlandı. API tetiklendi."
- **Günlük özet** — "Bugün 3 focus session, toplam 90 dk" (isteğe bağlı, cihaz destekliyorsa)
- **Cihaz ekle** CTA (varsayılan)

### 5.2 Cihazlarım — kategori bazlı, oda bazlı değil

Oda (salon, mutfak) SKAPP'e uymuyor. Onun yerine:

**Kategori bazlı gruplama:**
- "Odak & Produktivite"
- "API Tetikleyiciler"
- "Deneyimler & Oyun"
- "İzleme & Veri"
- "Özel / DIY"

Her cihaz manifest'inde bir kategori etiketi taşır, APP otomatik gruplar.

**Kullanıcı özel gruplama** (opsiyonel):
- Kullanıcı kendi koleksiyonları oluşturabilir ("İş Masam", "Uyku Odası", "Geliştirme Setup'ım")
- Cihazları birden fazla koleksiyona ekleyebilir

### 5.3 Yeni 4. Tab: **"Aksiyonlar" veya "Entegrasyonlar"**

SKAPP ekosisteminin kalbi burası. Eski 3 tab yerine 4 tab:

```
[ Ana Sayfa ]  [ Cihazlarım ]  [ Aksiyonlar ]  [ Ayarlar ]
```

**Aksiyonlar sekmesinde:**
- **Webhook/API endpoint kütüphanesi** — kullanıcı oluşturduğu API çağrıları. Her biri: URL, method, header, body şablonu
  - Örnek: "Laptop kapat" = `POST http://localhost:1337/shutdown`
  - Örnek: "Slack DND aç" = `POST https://slack.com/api/dnd.setSnooze`
- **Aksiyonu test et** — gerçek cihaz olmadan endpoint'i tetikleyip cevabı görme
- **Aksiyon-cihaz eşleme** — "Blocking Focus 30 dk bittiğinde → 'Laptop kapat' aksiyonunu çalıştır"
- **Aksiyon geçmişi** — hangi cihaz ne zaman hangi aksiyonu tetikledi

### 5.4 Ayarlar — ekosisteme özel ekler

Mevcut ayarlar (dil, tema) + eklenecek:

- **Varsayılan davranışlar** — "Focus session'lar bitince otomatik API çalıştır" gibi kullanıcı tercihleri
- **Geliştirici modu** — gelişmiş kullanıcılar için manuel CLI kabuk, detaylı loglar, cihaz simulator bağlantısı
- **API ayarları** — genel zaman aşımı, SSL doğrulama, debug
- **Yerel sunucu** — bazı aksiyonlar APP'in localhost üzerinden çalışan minik bir sunucusunu tetikleyebilir (laptop kapatma vb.) — bu sunucunun açık/kapalı durumu
- **Cihaz yönetimi** — toplu factory reset, toplu unpair, veri yedekleme/içe aktarma

### 5.5 Info / Hakkında — SmartKraft felsefesi

Standart "sürüm + geliştirici" yerine zengin:

- **SmartKraft nedir?** — kısa manifesto. "Akıllı ev değil, akıllı gereç. Niş cihazlar, özgün senaryolar."
- **Cihaz kataloğu** — SKAPP üzerinden yönetebileceğiniz tüm SmartKraft cihazları ve ne işe yaradıkları
  - Her cihaz kartı: ikon, isim, kısa açıklama, "şimdi satın alınabilir mi" durumu
  - Eklenecek cihazları da "yakında" etiketiyle tanıtmak mümkün (pazarlama amaçlı)
- **Başlangıç rehberi** — genel kullanım + cihaz başına özel rehber (yine manifest'ten)
- **SSS / destek** — tipik sorunlar
- **DIY / maker modu** — kullanıcı kendi ESP32 projesi için manifest yazabilir (gelişmiş)
- **İletişim** — e-posta, website, topluluk linki (varsa)
- **Sürüm + lisans** (klasik)

### 5.6 Cihaz Detay Ekranı — her cihaz kendine özel

Blocking Focus örneğinde ekran içeriği:

- Büyük geri sayım (aktifse)
- Süre seçici (5/15/30/60 dk)
- "Başlat / Duraklat / Sıfırla" butonları
- Tamamlanınca tetiklenecek aksiyon seçici ("Hangi aksiyon?")
- Ayarlar: ses, titreşim, LED parlaklığı, otomatik başlat
- Geçmiş: son 10 session, tamamlanma oranı
- Gelişmiş: manuel komut, firmware sürümü, factory reset

Manifest bu ekranı tanımlayacak. Shelly'nin "bir lamba için aç/kapa" ekranından çok farklı.

---

## 6. Mevcut İskelete Yapılacak Değişiklikler (öneriler)

### Kısa vadede (Faz 1'e ek, firmware beklerken yapılabilir):

- [x] ~~**4. tab ekle:** `Aksiyonlar` — şimdilik boş iskelet, Faz 3'te doldurulur~~ → **SKAPI** olarak yenilendi (4-platform kütüphanesi + bind sistemi)
- [x] ~~**Ana Sayfa'yı "Aktivite Merkezi"ne dönüştür**~~ → Sticky-note dashboard (logo + 4 stat + 5 sticky kart) implement edildi
- [ ] **Cihazlarım kategori bazlı gruplama altyapısı** — manifest'te `category` alanı + UI gruplama (şu an boş; karar 7.3'te "kullanıcı tanımlı grup" olarak yenilendi, sıkı kategori yok)
- [x] ~~**Info/Hakkında genişlet** — SmartKraft felsefesi kısa metin + cihaz kataloğu iskelet (boş placeholder kartlar)~~ → [about_screen.dart](app/lib/features/about/about_screen.dart) tam yapıldı
- [x] ~~**Ayarlar → Geliştirici modu** toggle ekle~~ → toggle var + USB Console ekrana bağlandı (madde 7.7'de yapılan)

### Orta vadede (Faz 3'te firmware ile birlikte):

- [x] ~~Aksiyonlar sekmesi full implementation: API endpoint CRUD, test, eşleme~~ → SKAPI sekmesi (script kütüphanesi + bindings + run + remote run + favouriting)
- [x] ~~Cihaz detay ekranı — manifest-driven UI generator~~ → BF + LebensSpur kendi ekran setleri (monolitik karar, manifest mimarisi iptal — memory: project_plugin_architecture.md)
- [ ] Aktivite log kalıcı storage + zaman çizgisi UI (cihaz tarafı [bf_logs_screen.dart](app/lib/features/devices/bf/bf_logs_screen.dart) ile mevcut, zaman çizgisi UI yok)
- [x] ~~Yerel sunucu (masaüstünde, "laptop kapat" gibi aksiyonları karşılayan mini HTTP server — isteğe bağlı opt-in)~~ → [skapp_http_server.dart](app/lib/core/network/skapp_http_server.dart) + [skapp_listener_service.dart](app/lib/core/network/skapp_listener_service.dart)

### Uzun vadede:

- [ ] Kullanıcı kendi aksiyon tipleri yazabilir (örn. JavaScript snippet) — gelişmiş (script editörü iskelet hazır: [skapi_script_editor_screen.dart](app/lib/features/skapi/skapi_script_editor_screen.dart))
- [ ] DIY manifest editörü — kullanıcı kendi ESP32 cihazını APP'e tanıtabilir (monolitik karara çelişiyor; iptal kategoride)
- [ ] Cihazlar arası koordinasyon — "Blocking Focus bitince Ambient Light dimme at" gibi

---

## 7. Verilen Kararlar (2026-04-24)

### 7.1 — 4. tab "Aksiyonlar" ✅ EKLENDİ

Alt navigasyon 3 → 4 tab:

```
[ Ana Sayfa ]  [ Cihazlarım ]  [ Aksiyonlar ]  [ Ayarlar ]
```

[features/actions/actions_screen.dart](app/lib/features/actions/actions_screen.dart) oluşturuldu, Faz 1'de boş iskelet + "ilk cihaz eşleştirilince aktifleşir" notu içeriyor.

### 7.2 — Ana Sayfa: Bilgilendirme Merkezi (geçici)

**Kullanıcı notu:** Son karar erteledi. Şimdilik "bilgilendirme merkezi" olarak tasarlandı. Reklam/pazarlama alanı DEĞİL, kullanıcı deneyimi odaklı.

İçerik:
- SmartKraft logo
- Cihaz özet kartı (bağlı sayısı / çevrimdışı sayısı)
- Bekleyen güncelleme uyarısı (hardal sarısı, varsa)
- Log/hata uyarısı (kırmızı, varsa)
- "Her şey yolunda" durumu (problem yoksa)
- "Cihaz ekle" CTA (özellikle cihaz sıfırken belirgin)

**Yer ALMAYACAK:** Cihaz kataloğu, pazarlama metinleri, önerilen senaryo upsell'leri (bunlar Info/Hakkında'da).

[features/home/home_screen.dart](app/lib/features/home/home_screen.dart) tamamen yeniden yazıldı.

### 7.3 — Cihaz grupları: KULLANICI TANIMLI ✅

**Karar:** Üretici ön-tanımlı kategori YOK. Kullanıcı kendi gruplarını yaratır. Seçme özgürlüğü SKAPP'in temel prensibi.

- Her cihaz 0, 1 veya birden fazla gruba dahil olabilir
- Grup isimleri tamamen kullanıcıya ait ("İş Masam", "Atölye", "Uyku Odası", "Konuk Modu"...)
- APP, üretici-tanımlı kategori SUNMAZ

[features/devices/devices_screen.dart](app/lib/features/devices/devices_screen.dart) bu yapıyla iskelet halinde hazır (grup yaratma butonu şu an pasif — Faz 3'te aktif olacak, cihaz yoksa anlamsız).

### 7.4 — API test: localhost YOK, komut cihaza ✅ KRİTİK PRENSİP

**Kullanıcı netleştirdi:** SKAPP asıl işi YAPMIYOR. Asıl işi **cihaz** yapıyor.

- ❌ YANLIŞ yaklaşım: SKAPP yerel HTTP server çalıştırır, API testi için kendisi çağırır
- ✅ DOĞRU yaklaşım: SKAPP cihaza `{"cmd":"test_api","args":{...}}` gönderir → cihaz kendi WiFi'si ile API'yi çağırır → cevap BLE üzerinden SKAPP'e döner → SKAPP gösterir

**Bu bir mimari prensip:**
- SKAPP = yapılandırma + GUI katmanı
- Cihaz = asıl iş yapıcı (HTTP çağrısı, timer, tetikleme, logging, OTA)
- SKAPP relay/proxy/executor DEĞİL
- SKAPP bozulsa cihazlar çalışmaya devam eder (APP kritik yol değil)

**Aksiyonlar sekmesi bu prensibe göre:**
- Kullanıcı endpoint'i SKAPP'te tanımlar (URL, method, header, body)
- SKAPP bu tanımı BLE üzerinden cihaza push eder
- Cihaz yerel olarak saklar
- Tetikleyici olunca cihaz **kendisi** URL'i çağırır — APP açık olmasa bile çalışır

Memory'de: `project_app_role.md` — tam detay.

### 7.5 — Info/Hakkında + cihaz kataloğu ✅ EKLENDİ

[features/about/about_screen.dart](app/lib/features/about/about_screen.dart) oluşturuldu, Ayarlar → "SKAPP Hakkında" tile'ından açılır. İçerik:
- SmartKraft manifesto metni (EN + TR, niş/özgün cihaz felsefesi)
- Cihaz kataloğu (şu an "hazırlanıyor" placeholder — Faz 2'de ilk cihaz belirlenince doldurulacak)
- İletişim: code@smartkraft.ch
- Sürüm bilgisi

### 7.6 — Faz 2 ilk cihaz: ERTELENDİ

Kullanıcı ilk cihaz seçimini henüz yapmadı. Firmware yazmaya başlanacağı zaman netleşecek. APP tarafı cihazdan-bağımsız — manifest-driven yapı sayesinde hangi cihaz olursa olsun çalışacak.

### 7.7 — Ek: Geliştirici modu toggle

Ayarlar ekranına "Geliştirici modu" toggle'ı eklendi (Bölüm 5.4'te önerilmişti). Şu an UI sadece — bağlı ekranlar (manuel CLI kabuk, detaylı loglar, simulator) Faz 3'te bu toggle arkasına açılacak.

---

## 8. Mevcut İskelet Durumu (2026-04-24)

```
Alt nav: [Ana Sayfa] [Cihazlarım] [Aksiyonlar] [Ayarlar]

Ana Sayfa:
  Logo + "Henüz cihaz yok" boş state kartı + "Cihaz ekle" CTA
  (Cihaz var olunca: özet + uyarı kartları + "her şey yolunda")

Cihazlarım:
  "Tüm cihazlar" section → boş
  "Gruplarınız" section → ipucu metni + boş + "Yeni grup" (pasif)
  + butonu → BLE keşif ekranı

Aksiyonlar:
  Açıklama + "ilk cihaz eşleştirilince aktifleşir" sarı banner + boş state

Ayarlar:
  Görünüm: Dil, Tema
  Gelişmiş: Geliştirici modu toggle
  Hakkında: "SKAPP Hakkında" → AboutScreen
  Sürüm: 0.1.0

Hakkında (Settings'ten push):
  Logo + manifesto + cihaz kataloğu (placeholder) + iletişim
```

Durum: `flutter analyze` 0 issue, `flutter test` geçiyor.
