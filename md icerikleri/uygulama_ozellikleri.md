# SKAPP — Uygulama Özellikleri Referansı

Bu dosya, SmartKraft benzeri **tüketici IoT yapılandırma uygulamalarının** tipik özelliklerini toplar. Mevcut iskelette ne var, benzer uygulamalarda ne olur, her birinin önceliği ne. Kullanıcı buradan seçerek planlama yapacak.

**Son güncelleme:** 2026-04-23

---

## 1. Benzer Uygulamalar (referans)

IoT cihaz kontrol uygulamaları içinde en yakın olanlar:

| Uygulama | Cihaz tipi | Öne çıkan yönü |
|---|---|---|
| **Philips Hue** | Akıllı aydınlatma | Sahne/scene sistemi, renk paleti kontrolleri |
| **IKEA Home Smart** | Aydınlatma + priz | Basit, minimum özellik, oda bazlı |
| **Shelly Smart Control** | Anahtar, röle, sensör | Cihaz bazlı detay ekranı, timer'lar, manuel komut |
| **Sonoff eWeLink** | Anahtar, priz, termostat | Cihaz grupları, senaryolar |
| **Tuya Smart / SmartLife** | Her şey (evrensel) | Çok cihaz tipi, market gibi geniş katalog |
| **Home Assistant Companion** | Evrensel hub istemcisi | Dashboard editörü, otomasyon |
| **ESPHome** | DIY ESP32 cihazlar | OTA, YAML yapılandırma, loglar |
| **Govee Home** | Işık, sensör | Efektler, zamanlayıcılar, otomasyon |
| **Xiaomi Mi Home** | Her şey | Aktivite geçmişi, senaryolar, ev odaları |

SKAPP'in kendi konumu: **Shelly + ESPHome karışımı** — cihaz-başına detay + CLI-first altyapı + yerel (bulutsuz) yapılandırma.

---

## 2. Ana Navigasyon ve Ekranlar

Öncelik etiketleri:
- **[ZORUNLU]** — MVP'de olmalı
- **[YAYGIN]** — Benzer uygulamaların çoğunda var, faydalı
- **[GELİŞMİŞ]** — Güç kullanıcısı için, sonra eklenebilir
- **[ERTELEME]** — İleriye, şimdi gerek yok (genelde bulut/hesap gerektiren)

### 2.1 Giriş akışı

- [ZORUNLU] **Splash ekranı** — SmartKraft logo, 1-2 saniye ✅ VAR
- [YAYGIN] **Onboarding / tanıtım** — ilk açılışta 2-3 slayt ("Hoş geldiniz, SmartKraft cihazlarınızı nasıl ekleyeceksiniz, başlayın")
- [YAYGIN] **İzin ekranı** — Bluetooth/konum izinleri için açıklamalı ön-bilgi ekranı (Android 12+ için kritik)
- [GELİŞMİŞ] **İlk kurulum sihirbazı** — dil seç → tema seç → ilk cihaz ekle (tek adım akışı)
- [ERTELEME] ~~Hesap oluştur / giriş~~ (bulut yok)

### 2.2 Ana Sayfa (Dashboard)

- [ZORUNLU] **Hoşgeldin/özet alanı** — logo + kısa açıklama ✅ VAR (basit hali)
- [ZORUNLU] **"Cihaz ekle" CTA butonu** ✅ VAR
- [YAYGIN] **Bağlı cihaz özet kartları** — aktif cihazların hızlı kontrolü (örn. lambayı aç/kapa doğrudan dashboard'dan)
- [YAYGIN] **Durum banner'ı** — "3 cihaz çevrimdışı", "1 güncelleme var", tema hardal sarısı
- [YAYGIN] **Son aktivite** — "15 dk önce: Mutfak ışığı yakıldı"
- [GELİŞMİŞ] **Widget düzenleyici** — kullanıcı dashboard'u özelleştirebilir
- [GELİŞMİŞ] **Hızlı senaryolar** — "Evden çık" butonuyla tüm ışıkları söndür, vb.

### 2.3 Cihazlarım Sekmesi

- [ZORUNLU] **Cihaz listesi** ✅ VAR (şu an boş durum)
- [ZORUNLU] **Cihaza tıkla → detay ekranı** (push navigation)
- [ZORUNLU] **"+" ile cihaz ekle** ✅ VAR
- [YAYGIN] **Tip'e göre gruplama** — "Işıklar (3)", "Termostatlar (1)" ↓ açılır/kapanır başlıklar
- [YAYGIN] **Oda/zon desteği** — "Oturma Odası", "Mutfak" kategorileri. Her cihazı bir odaya atama
- [YAYGIN] **Liste / ızgara görünüm** — 2 sütunlu grid alternatifi
- [YAYGIN] **Arama çubuğu** — cihaz sayısı 10+ olunca gerekli
- [YAYGIN] **Bağlantı durumu rozeti** — her kartta "çevrimiçi/çevrimdışı" göstergesi (renk kısıtı gereği ikon/stil ile)
- [YAYGIN] **Çekerek yenile (pull-to-refresh)** — elle tarama tetikler
- [YAYGIN] **Uzun bas / kaydır** — cihaz silme / yeniden adlandırma / oda değiştirme menüsü
- [GELİŞMİŞ] **Favoriler** — işaretlenen cihazlar Ana Sayfa'ya fırlar
- [GELİŞMİŞ] **Toplu işlem modu** — birden fazla cihaz seç → grup olarak yeniden adlandır/sil

### 2.4 Cihaz Detay Ekranı (her cihaz için)

Bu ekran her SmartKraft cihazının kendine özgü arayüzü. Manifest'ten otomatik üretilecek. Yaygın yapı:

- [ZORUNLU] **Başlık alanı** — cihaz ismi + ikon + çevrimiçi/çevrimdışı badge
- [ZORUNLU] **Ana kontrol** — cihaza göre değişir (slider, toggle, dropdown). Manifest belirliyor
- [YAYGIN] **Alt sekmeler veya kartlar:**
  - **Durum** — canlı sensör değerleri, son güncelleme
  - **Ayarlar** — cihaz-özgü yapılandırma (sıcaklık eşiği, zamanlayıcı, vb.)
  - **Zamanlayıcı/programlar** — "her gün 07:00'da aç"
  - **Otomasyon** — "X olduğunda Y yap" kuralları
  - **Geçmiş/geçmiş değerler** — grafik (sıcaklık 24 saat, vb.)
  - **Gelişmiş** — yeniden adlandır, odaya ata, OTA, factory reset, cihazı kaldır
- [YAYGIN] **WiFi/bağlantı göstergesi** — RSSI bar, IP, SSID
- [YAYGIN] **Pil durumu** (pilli cihazlar varsa)
- [YAYGIN] **Firmware sürüm göstergesi + "güncelle" butonu**
- [YAYGIN] **Cihaz bilgisi paneli** — serial, model, donanım sürümü, ilk bağlanma tarihi
- [GELİŞMİŞ] **Canlı log akışı** — DEBUG/INFO mesajları anlık akar
- [GELİŞMİŞ] **Manuel CLI kabuk** — güç kullanıcısı için "Her komutu elle yazabilirsin" paneli (ESPHome ve Shelly'de var — debug için altın değerinde)

### 2.5 Keşif / Cihaz Bul Ekranı

- [ZORUNLU] **BLE tarama** ✅ VAR (mock)
- [ZORUNLU] **Bulunan cihazlar listesi** — isim + RSSI ✅ VAR
- [ZORUNLU] **Cihaza tıkla → eşleştirme akışı** ✅ VAR
- [YAYGIN] **"Yeniden tara" butonu** ✅ VAR
- [YAYGIN] **İzin hatası durumu** — "Bluetooth izni gerekli → Ayarları aç" bloğu (metin hazır, UI entegrasyon eksik)
- [YAYGIN] **Bluetooth kapalı durumu** — "Bluetooth açık değil → Aç" (Android'de sistem diyaloğuna yönlendirir)
- [YAYGIN] **Manuel ekleme** — "Cihaz bulamadınız mı? ID'yi elle girin" seçeneği
- [GELİŞMİŞ] **QR kod tarayıcı** — cihaz kutusunda QR olursa (şimdilik yok ama iyi ileri düşünce)
- [GELİŞMİŞ] **WiFi üzerinden bulma** — aynı ağdaki önceden eşleştirilmiş cihazları mDNS ile listele

### 2.6 Eşleştirme / Provisioning Akışı

- [ZORUNLU] **Passkey giriş formu** ✅ VAR (mock, firmware yok)
- [ZORUNLU] **WiFi SSID seçme** (Faz 3'te cihaz `wifi_scan` komutu ile listeleyecek)
- [ZORUNLU] **WiFi şifre giriş**
- [ZORUNLU] **Bağlanma sonucu ekranı** — başarılı/başarısız
- [YAYGIN] **Adım göstergesi** — "1/3: Eşleştir", "2/3: WiFi", "3/3: Son ayarlar"
- [YAYGIN] **Cihaza isim ver ekranı** — ilk kez eklendikten sonra "Bu cihaz hangi oda?" + "İsim ver"
- [YAYGIN] **Başarı animasyonu** — check işareti + kısa metin
- [GELİŞMİŞ] **WiFi'yi atla** — "Sadece BLE kullanacağım" seçeneği (cihaz destekliyorsa)

### 2.7 Ayarlar Sekmesi

- [ZORUNLU] **Dil seçici** ✅ VAR
- [ZORUNLU] **Tema seçici** ✅ VAR
- [ZORUNLU] **APP sürümü** ✅ VAR
- [ZORUNLU] **Geliştirici/hakkında** ✅ VAR
- [YAYGIN] **Bildirimler ayarları** — hangi durumda uyarı al (cihaz çevrimdışı, güncelleme var, vb.)
- [YAYGIN] **Veri/gizlilik** — "Logları üreticiye gönder" opsiyonu (varsayılan kapalı)
- [YAYGIN] **Yardım / SSS** — kısa rehber ekranı
- [YAYGIN] **İletişim** — e-posta, website, destek linki
- [YAYGIN] **Lisanslar / yasal** — üçüncü parti kütüphane lisansları (`showLicensePage`)
- [GELİŞMİŞ] **Veri dışa aktarma** — cihaz listesi + ayarları JSON olarak yedekle
- [GELİŞMİŞ] **Veri içe aktarma** — yedeği geri yükle
- [GELİŞMİŞ] **Beta özellikler / developer modu** — deneysel seçenekleri aç
- [GELİŞMİŞ] **Tema özelleştirme** — renk paleti kurala bağlı, ama belki yazı boyutu / küçük-büyük tercih

### 2.8 Bildirim / Uyarı Merkezi

- [YAYGIN] **Tek sayfa bildirim geçmişi** — "Salon ışığı 1 saat önce bağlantısı koptu", "Termostat firmware güncellendi"
- [YAYGIN] **Bildirim rozetleri** — bottom nav'da "Cihazlarım" sekmesinde kırmızı nokta (sorun varsa)
- [GELİŞMİŞ] **Bildirim geçmişi filtreleme** — tarih / cihaz / seviye
- [ERTELEME] ~~Push bildirimleri~~ (bulut gerekiyor, sonraya)

---

## 3. Görsel Standartlar (5-renk kuralıyla uyarlanmış)

Benzer uygulamaların kullandığı görsel pattern'ler, bizim kurallara uyarlandı:

### 3.1 Durum göstergeleri (normalde yeşil/kırmızı)

Renk paletimiz yeşil içermiyor. Alternatifler:

- **Çevrimiçi:** dolu daire (●) veya kalın kontur; başlık **normal renkte**
- **Çevrimdışı:** boş daire (○) veya ince kesikli çerçeve; başlık **%50 opaklıkta** (soluklaşmış)
- **Hata / bağlantı koptu:** kırmızı daire (●) — yalnızca ciddi hata durumunda
- **Güncelleme var / uyarı:** hardal sarısı nokta — sadece dikkat çekmek gerekirse

### 3.2 Yaygın UI öğeleri

- **Kartlar (cards)** — cihaz kartları için. Köşeleri yumuşak (8px border radius)
- **Liste satırları** — `ListTile` pattern'i (başlık + alt başlık + sağda chevron/aksiyon)
- **Alt tab'lar** ✅ VAR
- **App bar** (üst başlık) ✅ VAR
- **Bottom sheet** — alttan kayar panel (Ayarlar'da tema seçici gibi) ✅ VAR
- **Modal dialog** — onaylama, uyarı diyalogları
- **Snackbar** — geçici bilgi mesajları ("Cihaz silindi", alt kenardan gelir)
- **Floating Action Button (FAB)** — "+" ile hızlı ekle, Cihazlarım sekmesinde üst sağda var şu an
- **Empty state illüstrasyon** — "Henüz cihaz yok" ekranı ikonla zenginleştirilebilir
- **Shimmer/iskelet yükleme** — liste yüklenirken gri çubuklar

### 3.3 Interaksiyon pattern'leri (benzer app'lerde var)

- **Pull-to-refresh** — listede aşağı çek → yenile
- **Swipe-to-action** — liste item'ı sola kaydır → sil/düzenle butonları
- **Long-press** — bağlam menüsü
- **Tap to toggle** — cihaz kartına tıkla, varsayılan aksiyon (aç/kapa)
- **Drag-to-reorder** — cihazların sırasını elle değiştir (iki çizgili tutamaç ikonu ile)

### 3.4 Animasyon / geçişler

- [ZORUNLU] **Ekranlar arası geçiş** — Flutter'ın varsayılan (iOS: slide, Android: fade) ✅ ÇALIŞIYOR
- [YAYGIN] **Yükleme spinner** ✅ VAR (discovery'de)
- [YAYGIN] **Başarı/hata geri bildirimi** — snackbar
- [GELİŞMİŞ] **Mikro-animasyonlar** — ikon dönüşleri, kart parlaması (tema hassasiyeti gerektirir — sade uygulamalarda az kullanılmalı)

---

## 4. Şu an hangi seviyedeyiz?

| Bölüm | Durum (2026-05-07 güncellendi) |
|---|---|
| Splash + 6 tab iskelet | ✅ Tam (origami açılış animasyonu eklendi; tab listesi: Home/SmartKraft/Devices/SKAPI/Notes/Settings) |
| Tema + dil | ✅ Tam (light + dark, M3 ColorScheme tüm tokenlar; TR + EN, 6 dil bekliyor) |
| BLE gerçek tarama | ✅ Tam (mock kalktı, flutter_blue_plus + ECDH pairing) |
| Passkey giriş formu | ✅ Tam (BF passphrase gate, 10 deneme lockout) |
| Cihaz detay ekranı | ✅ Tam (BF + LebensSpur kendi tam ekran setleriyle) |
| Oda/zon yapısı | ❌ Yok (kullanıcı-tanımlı grup kararı verildi, UI iskelet bekliyor) |
| Cihaz kartı (durum + toggle) | ✅ Tam (constellation + grid; status dot + name + type + ID) |
| Pull-to-refresh, swipe | ❌ Yok |
| Bildirim merkezi | ❌ Yok |
| Senaryo/otomasyon | ✅ Tam (SKAPI bind: cihaz event → script tetik) |
| Log görüntüleme | ✅ Tam (bf_logs_screen `logs.get` ile cihazdan çekiyor; tarihsel persist yok) |
| OTA akışı | ❌ Yok (`Faz 3 ertelendi`) |
| Aksiyon kütüphanesi | ✅ Tam (SKAPI: 26 PowerShell + 14+ Linux/Mac script bundled, bind + manuel run + uzaktan run) |
| Pairing flow (BLE + WiFi/mDNS) | ✅ Tam (DiscoveryScreen + WifiDiscoveryScreen + ECDH bootstrap + WiFi setup wizard) |
| Peer-to-peer (telefon ↔ desktop) | ✅ Tam (skapp_http_server + skapp_listener_service + QR + manuel pairing); güvenlik audit yapıldı: [güvenlik.md](güvenlik.md) |
| USB CLI Console (dev mod) | ✅ Tam ([usb_console_screen.dart](app/lib/features/dev/usb_console_screen.dart), Android aktif, desktop paket bekliyor) |

**Şimdiki seviye:** "Cihaz sayısı sıfır iskelet" cümlesi artık geçerli değil. BF + LebensSpur tam ekran setleri, SKAPI sistemi, peer-to-peer, OTA dışında her şey çalışıyor.

---

## 5. Öncelik Önerileri (hangisinden devam?)

### A. Faz 1'i kilitleyip Faz 2'ye (firmware) geçmek — **önerilen**
Mevcut iskelet Kurallar.md'deki durdurma noktasına ulaştı. Firmware olmadan test edecek bir şey yok. Cihaz detay ekranı ve oda sistemleri firmware'le birlikte anlamlı olur.

### B. İskelete bazı yaygın özellikleri önceden eklemek
Firmware beklerken ek UI bileşenleri kurulabilir, mock data ile test edilir. Faydalı olanlar:
- **Cihaz kartı komponenti** (isim + durum badge + hızlı toggle) — sonra her yerde kullanılır
- **Oda/zon alt yapısı** — cihazlara oda ataması için veri modeli + UI
- **Bildirim merkezi iskelet** — boş state ile, sonra doldurulur
- **Onboarding akışı** (ilk açılış tanıtımı) — basit 3 slayt
- **Shimmer yükleme** komponenti
- **Boş state illüstrasyonları**

### C. Sadece iyileştirmeler
- Anasayfadaki "cihaz ekle" butonunu daha büyük/vurgulu
- Ayarlar'a "Yardım" ve "İletişim" bölümleri
- Discovery'ye "manuel ID girişi" alternatifi
- Hakkında sayfasına GPL/lisans listesi (`showLicensePage`)

---

## 6. Sizden cevap beklediğim sorular

1. **Hangi yoldan devam?** — A (firmware'e odaklan), B (iskelete bileşen ekle), C (küçük iyileştirmeler)?
2. **Oda/zon sistemi olacak mı?** — cihazları odalara gruplama yaygın, ama MVP dışına atılabilir
3. **Senaryo/otomasyon sistemi gelecek mi?** — "Akşam olunca ışıkları yak" gibi. Yoksa gelecek ürünü az ama varsa Faz 3'te tasarım değişir
4. **Bildirim merkezi şart mı?** — local bildirimler şimdiden desteklenebilir (hata durumları için)
5. **Manuel CLI kabuk ekranı** — güç kullanıcısı için değerli. Sadece gelişmiş kullanıcıya göstermek için "developer mode" arkasında saklanır. Eklensin mi?
