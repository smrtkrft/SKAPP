# SKAPP Linux APT Dağıtım Sistemi · Kavramsal Rehber

Bu belge, SKAPP'in Debian / Ubuntu / Raspberry Pi OS gibi APT tabanlı
Linux dağıtımlarında **`sudo apt install skapp`** komutuyla kurulmasını
ve **`sudo apt upgrade`** ile otomatik güncellenmesini sağlayacak
sistemin **nasıl ve neden** o şekilde kurulduğunu, hosting kararını ve
inşa sırasını anlatır.

Detay komutlar, dosya içerikleri ve faz-faz aksiyon listesi için
[yapilacaklar.md "Madde 21 · Linux // sudo apt install skapp"](yapilacaklar.md)
bölümüne bakın. Bu belge stratejik karar ve eğitim odaklıdır,
operasyonel kontrol listesi değildir.

---

## 1. Hedef

Bir Linux kullanıcısı sadece üç şey yapacak:

1. SKAPP web sitesinden tek satırlık kurulum komutunu kopyalar.
2. Komutu terminalde çalıştırır, parolasını girer.
3. Bundan sonra her sistem güncellemesinde (`sudo apt update && sudo apt upgrade`)
   SKAPP de otomatik güncellenir.

Bu yapı kurulduktan sonra her yeni SKAPP sürümü, tek bir `git tag` push'u
ile tüm Linux kullanıcılarına dağıtılabilir hale gelir.

---

## 2. APT sistemi nasıl çalışıyor (kavramsal)

Debian tabanlı sistemlerde paket yöneticisi APT'dir. APT'nin bilmesi
gereken tek şey: "paketleri hangi URL'den indireceğim?"

Bu URL bilgisi, kullanıcının makinesinde `/etc/apt/sources.list.d/`
klasöründe `.list` veya `.sources` uzantılı düz metin dosyalarında durur.
Her dosya bir satır içerir, örneğin:

```
deb [signed-by=/usr/share/keyrings/skapp.gpg] https://smartkraft.ch/apt stable main
```

Bu satır APT'ye der ki: "https://smartkraft.ch/apt adresinde `stable`
adlı bir kanal var, oradaki `main` bileşenini izle ve dosyaları
`skapp.gpg` ile imzalı kabul et."

APT komutları:

| Komut | Ne yapar |
|---|---|
| `sudo apt update` | Kayıtlı tüm URL'lerden **paket listesini** (metadata) indirir |
| `sudo apt install skapp` | Listede `skapp` paketini bulup indirir, kurar |
| `sudo apt upgrade` | Her kayıtlı paket için listede yeni sürüm varsa indirir, kurar |
| `sudo apt remove skapp` | SKAPP'i kaldırır, kullanıcı verisi kalır |
| `sudo apt purge skapp` | SKAPP'i ve sistem-geneli config'lerini kaldırır |

**Otomatik güncelleme bu yüzden ekstra bir mekanizma değildir:** SKAPP'i
sistemin paket yöneticisine kaydetmiş olduğun için, `apt upgrade` SKAPP'i
de sistemin geri kalanıyla birlikte günceller.

---

## 3. Üç Bileşen

APT dağıtımı kurmak için üç şey üretip yayınlaman gerekir:

### 3.1 `.deb` Paketi

Sıkıştırılmış bir arşiv. İçinde:

- SKAPP binary'si (`flutter build linux --release` çıktısı)
- Linux masaüstü entegrasyonu için `.desktop` dosyası (menüde görünür)
- Farklı boyutlarda PNG ikonlar (`hicolor` tema dizininde)
- `control` adlı metadata dosyası (paket adı, sürüm, bağımlılıklar,
  maintainer e-postası)

`.deb` formatı standartlaştırılmıştır; `dpkg-deb --build` komutuyla
üretilir. Her sürüm için ayrı bir `.deb` (örn. `skapp_0.1.0-1_amd64.deb`).

### 3.2 APT Repository (Klasör Yapısı)

APT'nin anladığı belli bir klasör + dosya yapısı vardır. Sen sadece
`.deb`'leri bir klasöre atmazsın; üzerinde yapısal metadata gerekir:

```
apt/
├── dists/
│   └── stable/
│       ├── Release          (kanal metadata'sı)
│       ├── Release.gpg      (imza)
│       ├── InRelease        (gömülü imzalı versiyon)
│       └── main/
│           └── binary-amd64/
│               ├── Packages
│               └── Packages.gz   (paket listesi)
└── pool/
    └── main/
        └── s/
            └── skapp/
                ├── skapp_0.1.0-1_amd64.deb
                └── skapp_0.2.0-1_amd64.deb
```

İyi haber: Bu yapıyı elle yönetmeyeceksin. **`reprepro`** adlı bir araç
sana her şeyi otomatik üretir. Sen sadece `reprepro includedeb stable
skapp_0.1.0-1_amd64.deb` dersin, klasörü doğru şekilde günceller +
imzalar.

### 3.3 GPG İmzası

Modern APT, imzasız repo'ları **reddeder**. Bu, kullanıcıyı paket
sahteciliğinden korur. İmzalama akışı:

1. Sen bir kez GPG anahtar çifti (private + public) üretirsin
2. Private key'i güvenli bir yerde saklarsın (offline yedek + parola
   yöneticisi)
3. Public key'i web sitende yayınlarsın (`https://smartkraft.ch/apt/skapp.gpg`)
4. Her `.deb`'i ve repo'nun `Release` dosyasını private key'le imzalarsın
   (reprepro otomatik yapar)
5. Kullanıcı bir kez kurulum sırasında public key'i indirip kendi
   sistemine ekler; APT bundan sonra senin imzalı paketlerine güvenir

Anahtar süresi tipik olarak 2 yıl, sonra yenilenir. Anahtarı
kaybedersen yeni anahtarla devam edersin, kullanıcılar bir kez yeni
anahtarı tekrar kurar.

---

## 4. Hosting Seçenekleri

Repo dosyalarını barındırmak için 4 seçenek var. SKAPP için ilk iki
seçeneği canlı tutuyoruz, son uygulama anına ertelendi.

### Seçenek A · Cloudflare Pages + `apt.smartkraft.ch`

Repo dosyalarını (örn. GitHub Actions üzerinden ürettikten sonra) bir
Git branch'a push edersin, Cloudflare Pages 30 saniyede yayına alır.

**Artıları:**
- Tamamen ücretsiz
- Sınırsız bandwidth (Cloudflare CDN üzerinden global cache)
- Otomatik HTTPS sertifikası
- Custom domain ücretsiz (smartkraft.ch DNS'ine bir CNAME eklersin)
- Vendor lock-in yok: dosyalar zaten Git repo'nda, istediğin an taşırsın

**Eksileri:**
- Sürüm sayısı binlere ulaşırsa Cloudflare Pages build artifact limiti
  (20 bin dosya) sıkıntı çıkarabilir; yıllarca uzakta bir sorun
- GitHub Actions + Cloudflare arasında küçük bir token bağlantısı
  kurman gerekir

### Seçenek B · Kendi smartkraft.ch Hosting'in (Mevcut)

Mevcut hostingde `/apt/` klasörü açarsın. GitHub Actions'tan veya
manuel olarak `rsync` ile dosyaları senkronize edersin.

**Artıları:**
- URL markaya tam uyumlu (`https://smartkraft.ch/apt/`)
- Tam kontrol: log, indirme istatistikleri, paket popülerliği görürsün
- İleride başka şeyler de (OTA manifestleri, doc) aynı hosting altında
  durur, tutarlı

**Eksileri:**
- Bandwidth maliyeti olabilir (hosting planın 1000+ indirmeyi
  kaldırıyor mu?)
- TLS sertifikası ve nginx config senin sorumluluğunda
- CDN yok, coğrafi olarak uzak kullanıcılarda yavaş

### Seçenek C · GitHub Pages

Cloudflare Pages'in zayıf akrabası. Ücretsiz + TLS dahil ama bandwidth
soft limit (100 GB/ay) ve repo boyut limiti (1 GB) var. Erken aşamada
çalışır, kalıcı çözüm değil. Cloudflare Pages'i tercih ediyoruz.

### Seçenek D · Cloudsmith / packagecloud (Managed)

Yönetilen apt-repo servisleri. GPG imzalama, web UI ve istatistik
dahildir. Free tier var ama vendor lock-in ve URL `cloudsmith.io`
uzantılı kalır. Şu an SKAPP için gerekli ek değer yok.

### Karar

İki canlı seçenek **A** ve **B** kalıyor. Karar implement aşamasında,
mevcut smartkraft.ch hosting planının bandwidth/disk limitlerine
bakarak verilecek. Her iki yolda da `.deb` ve repo yapısı aynı kalır,
sadece dosyaların durduğu yer değişir. Yani bir tercihten diğerine
geçmek 1-2 saatlik iştir, yanlış karar uzun vadeli hapsetmez.

**Şu an çalışıyorsa hazır olan referans URL formatı:**
`https://smartkraft.ch/apt/...` veya `https://apt.smartkraft.ch/...`

### Subdomain vs klasör (URL şekli)

İki ayrı URL şeması var, APT için fark etmez (teknik olarak ikisi de
çalışır), ama hosting tarafında büyük operasyonel fark:

| Konu | `apt.smartkraft.ch` (subdomain) | `smartkraft.ch/skapp/apt` (klasör) |
|---|---|---|
| GitHub Pages uyumu | ✅ CNAME ile çalışır | ❌ Pages tüm domain'i alır, altpath veremez |
| Ana web siten etkilenir mi | Hayır, ayrı | Aynı hostingde yan yana |
| Bandwidth maliyeti | 0 TL (GitHub absorbe) | Hosting planına bağlı |
| Klasör tercihi durumunda | YOL B (kendi hosting'in zorunlu) | |

**Pratik tavsiye:** Subdomain seç, GitHub Pages mimarisinin önünü açar.
Klasör tercih edilirse YOL B (kendi hosting'i) otomatik seçilmiş olur,
GitHub Pages bu durumda kullanılmaz. Bkz. `hardening_kullanici_aksiyonlari.md`
§C daha detaylı tablo içerir.

---

## 5. İnşa Sırası (Yüksek Seviye)

Detay komutlar yapilacaklar.md Madde 21'de. Burada **neden bu sıra**
sorusuna cevap veriyoruz.

### Adım 1 · GPG Keypair

En başta yapılır çünkü her şey buna bağlı. `gpg --full-generate-key`
ile RSA 4096, parolalı, 2 yıl geçerli bir çift üretilir. Private key
offline yedek + parola yöneticisi, public key web sitede yayınlanır.

CI/CD kurulduğunda private key'in bir kopyası GitHub Actions Secrets'a
şifrelenmiş olarak yüklenir. Tüm imzalama orada çalışır.

### Adım 2 · `.deb` Build Scripti

Manuel build akışı önce çalışsın diye otomasyondan ÖNCE yazılır.
`tools/build/linux_deb.sh`: `flutter build linux --release` çalıştırır,
çıktıyı standart Debian path'lerine (`/usr/share/skapp/`, `/usr/bin/skapp`)
yerleştirir, `.desktop` ve ikonları yerine koyar, `dpkg-deb --build` ile
sıkıştırır.

İlk birkaç sürümü kendi laptop'undan üretip elle test edersin. Süreci
anladıktan sonra CI'a taşırsın.

### Adım 3 · reprepro ile Repo Dizini

Bir kez yapılır, sonra her sürümde sadece `reprepro includedeb` çağrısı
yapılır. Repo'nun `conf/distributions` dosyasında bir kere kanal adı
(`stable`), mimariler (`amd64 arm64`) ve imzalama anahtar ID'si
tanımlanır.

Bu adımdan sonra elinde dağıtılabilir bir klasör vardır. Bir dahaki
adım sadece o klasörü internete açmak.

### Adım 4 · Hosting'e Yükleme

Seçenek A ise: `apt/` klasörünü bir Git branch'a push, Cloudflare
Pages dağıtır.

Seçenek B ise: `rsync -avz apt/ user@smartkraft.ch:/var/www/apt/`.

Her iki yolda da bir kere TLS ve domain ayarı yapılır. Sonraki tüm
sürümler sadece dosya senkronizasyonudur.

### Adım 5 · Tek-Satır Kurulum Scripti

Web sitende bir bash script (`https://smartkraft.ch/install-skapp.sh`)
yayınlarsın. Bu script kullanıcının makinesinde sırasıyla:

1. GPG public key'i indirir, `/usr/share/keyrings/skapp.gpg`'ye koyar
2. Sources.list.d altına repo satırını yazar
3. `apt update` çalıştırır
4. `apt install -y skapp` çalıştırır
5. Başarı mesajı yazdırır

Kullanıcı **tek komut** kopyalar:

```
curl -fsSL https://smartkraft.ch/install-skapp.sh | sudo bash
```

Bu komut çalıştıktan sonra SKAPP kurulu, kullanıcı menüde "SKAPP"
ikonunu görür, gelecek tüm `apt upgrade`'ler otomatik yeni sürümü
indirir.

**Güvenlik notu:** `curl | bash` deseni kullanıcıyı tedirgin edebilir.
Bu yüzden script kodu web sitende açık + okunabilir olmalı, ve "manuel
4 adım" alternatifi de yan yana belgelenmeli. Bu standart pratiktir
(Docker, Rust, Tailscale hepsi aynı paterni kullanıyor).

### Adım 6 · GitHub Actions ile Otomasyon

İlk 2-3 sürümü elle yaptıktan sonra. Workflow:

1. Tag push (`v0.3.0`)
2. CI matrix: `[amd64, arm64]` (GitHub Actions arm64 runner public
   repo'da ücretsiz)
3. Her runner'da: Flutter setup → build linux release → linux_deb.sh
4. GPG private key import (Secrets'tan)
5. reprepro ile repo'ya `.deb` ekle
6. Cloudflare Pages branch'ına / hosting'e push
7. 5-10 dakika sonra dünya çapında yeni sürüm `apt update`'de görünür

### Adım 7 · Test ve Doğrulama

Üretim öncesi son adım:

1. Temiz Docker `ubuntu:22.04` container'ı → tek-satır kurulum komutu
   → SKAPP başlatılabilir mi
2. Pi 4 + Raspberry Pi OS Bookworm → aynı komut çalışıyor mu
3. Auto-update senaryosu: `v0.1.0` kurulu → `v0.2.0` repo'ya yüklendi
   → `apt update && apt upgrade` → yeni sürüm geldi mi, kullanıcı verisi
   (`~/.config/skapp/`) korundu mu
4. Uninstall: `apt remove` kullanıcı verisini bırakıyor, `apt purge`
   sistem config'lerini de siliyor

---

## 6. İnşa Sırasında Verilecek Kararlar

Madde 21 hazır plan, ama implementasyon başlamadan netleştirilmesi
gereken birkaç nokta:

1. **Hosting seçimi (A vs B):** Mevcut smartkraft.ch hosting'in disk +
   bandwidth kapasitesini öğren. Sınırsızsa B, kısıtlıysa A.
2. **GPG anahtar sahibi:** Tek-kullanıcı anahtar (sadece sen) mi, yoksa
   uzun vadede ekip için ayrı anahtarlar mı? Şimdilik tek-kullanıcı
   yeterli, expand edilirse anahtar imzalama hiyerarşisi kurulur.
3. **Kanal isimleri:** Şimdilik tek kanal `stable`. İleride `beta`
   eklenebilir (tester'lar `deb ... beta main` satırını ekler, normal
   kullanıcı `stable`'da kalır). Madde 21 sadece `stable` öneriyor,
   yeterli.
4. **Sürüm numaralandırma:** SemVer kabul edildi (`0.1.0-1`). Debian
   format'ı `<upstream>-<debianrev>`. Her yeni paket için debian-rev
   artar; sadece paketleme değiştiyse upstream aynı kalır.
5. **AppImage paralel mi?** Apt repo'yu kullanmayan dağıtımlar (Arch,
   Fedora) için web sitede AppImage indirme butonu da olmalı. Madde 21
   Faz 10'da paralel iş kalemi olarak duruyor, MVP için ertelendi.

---

## 7. Süre ve Maliyet Tahmini

| İş | Süre |
|---|---|
| GPG anahtar üretimi + yedekleme | 30 dk |
| `.deb` build scripti (manuel, ilk versiyon) | 4-6 saat |
| reprepro repo kurulumu | 2 saat |
| Hosting + DNS ayarları | 2-3 saat |
| Tek-satır install scripti + web sayfası | 2-3 saat |
| GitHub Actions otomasyonu (CI/CD) | 1 tam gün |
| Test (Docker + Pi) | 4-6 saat |
| **TOPLAM** | **2-3 tam gün** |

İlk sürüm yayınlandıktan sonra her sürüm için: **`git tag` push + 10 dk
otomatik build**.

**Maliyet:**
- Cloudflare Pages seçilirse: 0 TL/ay
- Kendi hosting seçilirse: mevcut hosting planı dahilinde, ek 0 TL
- AppImage CDN'i (varsa): 0 TL (GitHub Releases ücretsiz host eder)

---

## 8. İlgili Belgeler

- **Operasyonel kontrol listesi:** [yapilacaklar.md Madde 21](yapilacaklar.md)
- **Genel güncelleme stratejisi:** [project_update_strategy memory'si](#)
  (platform başına kanal kararı)
- **OTA güncelleme (cihaz firmware'i):** ayrı, `ota.md` arşivinde, bu
  belgeyi etkilemez
- **Linux runtime kurulum (son kullanıcı):** [SKAPI/LX/setup.md](SKAPI/LX/setup.md)
  (tek `.deb` kurulumu, ayrı kapsam)

---

## 9. Sözlük

- **APT (Advanced Package Tool):** Debian/Ubuntu'nun paket yöneticisi
- **Repository (repo):** Paketlerin barındığı sunucu/klasör
- **`.deb`:** Tek bir Debian paketi (sıkıştırılmış arşiv)
- **reprepro:** Bir APT repo'sunu otomatik yöneten araç
- **GPG (GNU Privacy Guard):** Açık anahtarlı imzalama aracı
- **Keyring:** Güvenilen public anahtarların saklandığı dosya
- **Codename / Suite:** Repo kanalı adı (`stable`, `beta`, `nightly`)
- **Component:** Repo içinde alt grup (`main`, `contrib`, `non-free`)
- **Pool:** Repo'da fiziksel `.deb` dosyalarının bulunduğu klasör
- **Cross-compile:** Bir mimaride başka mimari için derleme (Flutter
  Linux build şu an cross-compile yapmıyor, bu yüzden CI matrix'te
  gerçek arm64 runner gerekiyor)
