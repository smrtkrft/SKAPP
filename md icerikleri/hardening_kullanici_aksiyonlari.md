# SKAPP Hardening · Kullanıcı Aksiyon Listesi

Bu dosya, SKAPP'in public GitHub push'undan önce **senin yapman gereken**
adımları içerir. Bu adımlar otomatize edilemez çünkü kişisel hesap, fiziksel
donanım, ödeme veya DNS gibi senin kontrolündeki kaynaklara erişim gerekiyor.

Faz 1 (memory) ve Faz 2 (`.gitignore`, `SECURITY.md`, güvenlik.md update)
zaten ben tarafından tamamlandı. Bu liste Faz 3 kullanıcı-aksiyonları.

İlerleyiş: her madde tamamlandıkça `[ ]` yerine `[x]` koy. Bittiğinde Faz 4
(CI scaffold + .deb build script) için onay verirsin.

---

## ŞİMDİ YAP (35 DAKİKA)

SKAPP henüz yayına hazır değil. Aşağıdaki adımların **sadece üçü**
şu an yapılır, geri kalanı SKAPP yayına yaklaşırken devreye girer:

1. **A1 + A2 (5 dk):** GitHub + e-posta hesabında SMS 2FA aktif et
2. **B (30 dk):** GPG anahtar üret + yedekle + parola yöneticisine kaydet
3. **H (1 dk):** Takvime "2028-05-16 GPG yenile" reminder

Geri kalan adımlar (C, D, E, F, G) **ileride**, SKAPP yayına yaklaşırken
veya public push kararı verince devreye girer.

### Adımların ne zaman devreye gireceği

```
[ŞİMDİ: SKAPP geliştirme devam]
   ↓
A (SMS 2FA) + B (GPG) + H (takvim)   35 dakika
   ↓
[GELIŞTIRME DEVAM EDER, AYLAR GEÇER]
   ↓
[SKAPP MVP yayına hazır kararı]
   ↓
Public/private karar (G1)
   ↓
Faz 4 (CI scaffold, ben yazarım)
   ↓
C (DNS) + D (hosting onay)
   ↓
G2 + G3 (push) + G4 (settings)
   ↓
İlk Linux apt repo sürümü yayınlanır
   ↓
[KULLANICI FEEDBACK'I GELİR]
   ↓
E (macOS Apple Dev) macOS ihtiyacı olursa
F (Windows signing) feedback olursa
```

---

## A · GitHub Hesabı Güvenliği (15 dakika)

### A1. 2FA aktivasyonu

GitHub hesabı tek failure point. Parola sızarsa saldırgan repo'na malicious
code commit edebilir, sürüm yayınlayabilir. 2FA = ikinci doğrulama katmanı.

**Karar (2026-05-16):** Şimdilik **SMS 2FA** yeterli (SKAPP henüz public
değil, saldırı yüzeyi sıfır). SKAPP kitleselleşince hardware key (YubiKey
~30 USD) ile yükseltilecek.

**Şimdi yapılacak (SMS yolu):**
1. https://github.com/settings/security adresine git
2. "Two-factor authentication" altında "SMS" veya "Authenticator app"
3. Telefonu ekle, doğrulama kodunu gir
4. Recovery codes'u **parola yöneticisine kaydet** (telefonu kaybedersen
   hesaba dönüş için tek yol)

**Gelecek (kitleselleşme sonrası):**
- YubiKey 5 USB-A veya USB-C alınır (~30 USD)
- "Add security key" eklenir, butona dokunarak kullanılır
- SIM swap saldırılarına karşı bağışık
- SMS 2FA o zaman kapatılır

- [x] A1 tamamlandı (SMS ile)

### A2. Email recovery güvenliği

GitHub hesabının kayıtlı olduğu code@smartkraft.ch e-postası da 2FA korumalı
olmalı. Email hesabı sızarsa GitHub recovery yoluyla ele geçirilebilir.

- [x] A2 tamamlandı (e-posta hesabında 2FA aktif)

---

## B · GPG Anahtarı Üretimi (30 dakika)

GPG anahtarı apt repo imzalama için zorunlu, sürüm imzalama için de
kullanılacak. Bir defa üretilir, 2 yıl kullanılır.

### B1. GPG kurulumu (Windows)

PowerShell aç:

```powershell
# scoop yüklüyse:
scoop install gpg
# veya:
winget install GnuPG.Gpg4win
```

Versiyonu doğrula:

```powershell
gpg --version
```

### B2. Anahtar üret

```powershell
gpg --full-generate-key
```

Seçenekler:
- Anahtar türü: `1` (RSA and RSA)
- Anahtar boyutu: `4096`
- Geçerlilik: `2y` (2 yıl)
- Real name: `SmartKraft`
- Email: `code@smartkraft.ch`
- Comment: `SKAPP signing key`
- Passphrase: **güçlü ve UNIQUE bir parola** (parola yöneticisine kaydet,
  asla bilgisayar dışında bir yere yazma)

Üretim 1-3 dakika sürebilir (entropy bekler).

### B3. Anahtar bilgisini al

```powershell
gpg --list-secret-keys --keyid-format=long
```

Çıktıda `sec rsa4096/ABCD1234EF567890 2026-05-16 [SC] [expires: 2028-05-16]`
gibi bir satır olacak. **`ABCD1234EF567890` kısmı senin KEY_ID**'ndir;
parola yöneticisine kaydet, sonra lazım olacak.

### B4. Public key dışa aktar

```powershell
gpg --armor --output skapp.gpg --export ABCD1234EF567890
```

**Önemli:** PowerShell'in `>` operatörü UTF-16 BOM yazar ve armored çıktıyı
bozar. Yukarıdaki gibi GPG'nin kendi `--output` flag'ini kullan.

Bu `skapp.gpg` dosyası ileride web sitende yayınlanacak (kullanıcılar
indirip APT'ye ekler).

### B5. Private key yedekle (KRİTİK)

```powershell
gpg --armor --output skapp-private-BACKUP.gpg --export-secret-keys ABCD1234EF567890
```

**Bu dosya:**
- Şifreli bir USB diskte sakla (örn. VeraCrypt container)
- Asla cloud sync'leme (Dropbox, OneDrive, Google Drive)
- Parola yöneticinde notlama olarak da fingerprint'i kaydet
- İki ayrı fiziksel konumda yedek (ev + işyeri / banka kasası)
- Dosyayı diskinden sil (yedekledikten sonra), repo'ya commit ETME

### B6. Revocation certificate üret (kayıp senaryosu)

```powershell
gpg --output skapp-revoke.gpg --gen-revoke ABCD1234EF567890
```

Reason kodu: `1` (Key has been compromised). Description: `lost`.

Bu dosya da private key gibi güvenli yerde durmalı; private key'i
kaybedersen bu sertifika ile public dünyaya "bu key artık geçersiz"
diyebilirsin.

- [ ] B1-B6 tamamlandı, anahtar ID parola yöneticisinde kayıtlı

---

## C · DNS Kayıtları (SKAPP yayına yaklaşırken, 15 dakika)

**Bu adım şu an YAPILMIYOR.** İlk Linux apt sürümü yayınlanmadan önce
yapılır. DNS yayılması 5-60 dakika sürer, son anda yapma stresine girme.

### Subdomain vs klasör seçimi

İki yol var, ikisi de teknik olarak çalışır. APT URL'i base olarak alır,
içinden path concat eder; nerede olursa olsun fark etmez.

| Konu | Subdomain (`apt.smartkraft.ch`) | Klasör (`smartkraft.ch/skapp/apt`) |
|---|---|---|
| GitHub Pages kullanılabilir mi | ✅ Evet | ❌ Hayır, GitHub Pages tüm domain'i alır |
| Ana web siten etkilenir mi | ❌ Hayır, ayrı çalışır | ⚠️ Aynı hostingde yan yana yaşar |
| Kim host eder | GitHub (ücretsiz, sınırsız bandwidth) | Senin hosting'in (smartkraft.ch sunucusu) |
| DNS kaydı | CNAME 1 satır, 5 dk | Yok, hosting mevcut |
| Bandwidth maliyeti | 0 TL (GitHub absorbe eder) | Hosting planına bağlı |

**Önerim:** Subdomain (`apt.smartkraft.ch`). Sebep: GitHub'ın ücretsiz CDN
kullanılır, ana site trafiği ile karışmaz, hosting kapasiteni meşgul etmez.

**Klasör tercihi mantıklı olursa:** Kendi smartkraft.ch hostinginde apt
repo dosyalarını manuel push edersin (rsync veya FTP), GitHub Pages
kullanılmaz. Bu durumda Faz 4 (CI scaffold) bu hostingin SSH/FTP
erişimine göre yazılır.

### Subdomain seçildiyse (önerilen yol)

Hosting sağlayıcının (Cloudflare, Natro, GoDaddy vb.) DNS panelinde CNAME
kayıtları ekle:

```
apt.smartkraft.ch        CNAME   <kullanici>.github.io.
update.smartkraft.ch     CNAME   <kullanici>.github.io.
ota.smartkraft.ch        CNAME   <kullanici>.github.io.
```

`<kullanici>` yerine kendi GitHub kullanıcı adın. Repo public push
edildiğinde Pages otomatik aktif olur.

`nslookup apt.smartkraft.ch` ile doğrula.

- [ ] C: Subdomain vs klasör kararı verildi
- [ ] C: CNAME'ler aktif (subdomain seçildiyse)

---

## D · Hosting Kararı (10 dakika analiz)

`apt_kurulum.md` §4'te 4 seçenek listelendi. Tek GitHub mimarisi konseptini
seçtin (Cloudflare Pages 25 MB limiti yerine GitHub Pages 100 MB). Bunu
onayla:

- [ ] GitHub Pages + GitHub Releases mimarisi seçildi
- [ ] Alternatif olarak smartkraft.ch hosting + GitHub aktif kalır (yedek)

---

## E · Apple Developer (ERTELENDI, macOS feedback'i gelirse)

**Karar (2026-05-16):** Şimdi YAPILMAYACAK. macOS ihtiyacı doğunca dön
(ilk Mac kullanıcısı bulunca veya macOS hedefli sürüm planlanınca).

### Niye ileride zorunlu olabilir

macOS, Apple tarafından "tanınmamış" uygulamayı şüpheli işaretler. Apple
Developer Program ($99/yıl) bu sertifikayı verir. Notarize edilmemiş .dmg
açmak için Sequoia 15.1'de kullanıcı 4-5 ayar tıklayarak açıyor, çoğu
vazgeçer.

### Yapılacaksa adımlar (referans)

1. https://developer.apple.com/programs/enroll/ adresine git
2. Apple ID ile giriş yap
3. Bireysel ya da kuruluş seç:
   - **Bireysel:** kişisel adınla, ürünler "Sebastian Erdem Üresin"
     adıyla görünür
   - **Kuruluş:** "SmartKraft" markası, DUNS numarası gerekiyor (ücretsiz
     başvuru ama 5-15 iş günü)
4. $99 ödeme
5. Apple'dan onay e-postası (1-7 gün, bireysel hızlı, kuruluş yavaş)

**Önerim (yapılacağında):** Kuruluş aç, SmartKraft markası daha profesyonel.

- [ ] E: Ertelendi, macOS ihtiyacı olunca dönülecek

---

## F · Microsoft Trusted Signing (Windows ertelendi)

Windows code signing MVP'de ertelendi (`reference_code_signing_2026` memory).
Şu an aksiyon yok. Public push sonrası ilk feedback gelince yeniden
değerlendir:

- Microsoft Trusted Signing ($10/ay) bireysel onay alabilirsen
- Veya OV cert (~$200/yıl, SSL.com gibi tedarikçilerden)

- [ ] F: Ertelendi, geri dönülecek

---

## G · GitHub Repo Push Hazırlık

Repo henüz GitHub'da değil. Public/private karar verildiğinde push yapılır.

### G1. Karar netleştir

`project_branding_and_distribution` memory'sinde "public/private düşünülüyor"
notu var. Bu kararı vermeden push yapma.

- [ ] G1: Public/private karar netleşti

### G2. Push öncesi son tarama

Repo zaten benim agent'ım tarafından tarandı (temiz). Yine de push'tan
hemen önce tekrar tarayı çalıştır:

```bash
# Windows için: scoop install gitleaks
gitleaks detect --source c:/Users/SEU/Desktop/GitHub/SKAPP --verbose
```

Beklenen sonuç: **0 leak.**

- [ ] G2: Push öncesi son tarama temiz

### G3. İlk push

```powershell
cd c:\Users\SEU\Desktop\GitHub\SKAPP
git init
git add .
git status   # KONTROL: .gitignore'da olması gerekenler stage'lenmemiş mi
git commit -m "Initial public commit"
git branch -M main
git remote add origin https://github.com/<kullanici>/SKAPP.git
git push -u origin main
```

- [ ] G3: İlk push başarılı, repo erişilebilir

### G4. Repo settings sıkılaştırma (push sonrası, 30 dakika)

GitHub repo sayfasında "Settings" sekmesinden:

1. **Branches → main:**
   - "Require status checks to pass before merging" AÇ
   - Status check listesinde "lint" + "test" işaretle (CI workflow eklendiğinde)
   - PR review kuralını AÇMA (solo dev için anlamsız)

2. **Code security and analysis:**
   - "Dependabot alerts" AÇ
   - "Dependabot security updates" AÇ
   - "Secret scanning" AÇ
   - "Push protection" AÇ
   - "CodeQL" KAPALI BIRAK (Dart desteklemiyor)

3. **Environments:**
   - "release" adında yeni environment yarat
   - "Required reviewers" listesine kendini ekle
   - "Deployment branches" → sadece `main`

4. **Actions → Secrets and variables → Actions:**
   - `GPG_PRIVATE_KEY` (B2'de yedeklediğin private key armored format)
   - `GPG_PASSPHRASE` (B2'de belirlediğin parola)
   - `GPG_KEY_ID` (B3'te aldığın 16 hane key ID)
   - macOS hedef ise: `APPLE_DEV_ID_CERT_P12_BASE64`, `APPLE_DEV_ID_CERT_PASSWORD`,
     `APPLE_NOTARIZATION_USERNAME`, `APPLE_NOTARIZATION_PASSWORD`

- [ ] G4: Repo settings tamamlandı

---

## H · Calendar Reminder'ları

Anahtar rotation ve hesap yenileme tarihlerini takvime ekle:

- [ ] H1: 2028-05-16 (2 yıl sonra) → GPG anahtar yenileme
- [ ] H2: Yıllık → Apple Developer Program yenileme ($99)
- [ ] H3: 6 ayda bir → güvenlik.md gözden geçirme

---

## Sonraki adım

Bu listedeki maddeler bittiğinde "Faz 4 başlasın" deyince ben:
- `.github/workflows/lint.yml` yazarım (dart analyze + format check)
- `.github/workflows/release.yml` yazarım (multi-platform build pipeline)
- `.github/dependabot.yml` yazarım
- `tools/build/linux_deb.sh` yazarım (Flutter Linux → .deb paketleme)

A, B, G1, G2, G3 minimum (public push için zorunlu); C, D, E, G4 yayın
öncesinde ama push sonrası da yapılabilir.

**Tahmini toplam süre:** A+B 45 dk, C+D 25 dk, G 30 dk = **1.5-2 saat**
(macOS Apple Developer hariç, o ayrı süreç).
