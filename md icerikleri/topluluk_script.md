# SKAPI Topluluk Script Paylaşımı — Plan

Kullanıcıların yazdığı SKAPI script'lerini SmartKraft'a göndermesi ve herkesin kullanabileceği bir kütüphaneye dahil etmesi için aşamalı plan. Şu an SKAPI ekranında `_ContributeFooter` widget'ı `_showComingSoon` snackbar atıyor; bu doküman bu işlevin nasıl gerçek hâle geleceğini detaylandırıyor.

Bu doküman `yapilacaklar.md` içindeki **GF-12** maddesinin referansıdır.

---

## Hedef ekosistem

- Kullanıcı `SKAPI` sekmesinde **SmartKraft'a Gönder** butonu görür.
- Form doldurur (title, açıklama, platform, kod, manifest), gönderir.
- SmartKraft moderasyon ekibi güvenlik review'undan geçirir, onaylanan script SKAPP'in **Community** bölümünde yayınlanır.
- Diğer kullanıcılar SKAPP'i açtığında bu script'leri SKAPI kütüphanesinde "Topluluk" rozetiyle görür ve çalıştırabilir.
- Her script `author`, `version`, `license` bilgisi taşır; kötü amaçlı script raporlanabilir, geri çekilebilir.

---

## Faz 0 — Dürüst placeholder (1 günlük iş, **ilk yapılacak**)

`_ContributeFooter.onTap` snackbar yerine bilgilendirme dialog'u açar. Kullanıcıya gerçek katkı kanalı gösterilir, kasırga yapmak yerine async kanaldan ilk script'ler toplanmaya başlar.

### Yapılacaklar (Faz 0)

1. **`_ContributeFooter` callback'i** [skapi_screen.dart](app/lib/features/skapi/skapi_screen.dart) — `_showComingSoon` yerine yeni `SkCenteredDialog` aç:
   - Başlık: "Script gönderme yakında otomatize edilecek"
   - İçerik: 3 satır metin — "Şimdilik GitHub issue veya e-mail ile gönderebilirsin", "her gönderim insan tarafından incelenir", "onaylananlar gelecek SKAPP sürümüyle dağıtılır"
   - 2 OutlinedButton: "GitHub'da issue aç" (URL launcher) + "E-mail gönder" (`mailto:code@smartkraft.ch?subject=SKAPI%20script%20katki...`)
2. **L10n key'leri** ekle (en + tr): `skapiContributeDialogTitle`, `skapiContributeDialogBody`, `skapiContributeOpenGithub`, `skapiContributeSendEmail`.
3. **`_ContributeFooter` görsel** — mevcut "yakında" rozeti kalsın, başlık değişmesin; sadece tap davranışı bilgilendirici dialog'a yönelsin.

### GitHub tarafında (Faz 0 için)

- **Yeni repo aç**: `smartkraft/skapi-community-scripts` (public, MIT lisansı)
- **README.md** içeriği:
  - "Buraya hoş geldin: SKAPP SKAPI script kütüphanesine topluluk katkıları"
  - Neyin paylaşılabileceği (PowerShell/bash/zsh script'leri, platform-spesifik)
  - Neyin kabul edilmeyeceği (banlist: network download+exec, registry HKLM yazımı, Defender bypass, vb.)
  - Kabul süreci akışı (issue/PR → otomatik lint → insan review → onay → merge → bir sonraki SKAPP sürümünde dağıtılır)
  - Lisans politikası: tüm katkılar MIT veya Apache 2.0 zorunlu (kullanıcılar bunu kabul ederek gönderir)
- **ISSUE_TEMPLATE/script-submission.yml** (GitHub Forms):
  - Title, Description, Platform (win/mac/lx-debian/lx-arch/other dropdown), Group (visual-break / programs / power / display-audio / vb.), Script code (block), Manifest JSON (block), Author name, License (MIT / Apache-2.0 dropdown), Tested on (free text)
- **CONTRIBUTING.md**:
  - Manifest schema referansı (`schemaVersion`, `id`, `platform`, `group`, `tier`, `runtime`, `scriptFile`, `i18n`, `params`, `remoteRunnable`)
  - Tier kuralları (1: production-ready, 2: experimental + flaky bilinen, 3: blocked + stub)
  - Klasör yapısı: `catalog/<platform>/<script-id>/{<script-id>.ps1, <script-id>.json, README.md}`
  - Lint geçiş şartı: `[Parser]::ParseFile` parse OK + JSON schema doğrulama + banlist regex temiz
- **CODE_OF_CONDUCT.md** (Contributor Covenant 2.1 standart şablonu)
- **LICENSE** — MIT (repo lisansı; tek tek script'ler de MIT/Apache-2.0)

### Faz 0 doğrulama

- SKAPI ekranında "SmartKraft'a Gönder" tıklanır, dialog açılır, GitHub link çalışır, mailto açılır.
- GitHub repo'da issue template form göstergesinden yeni katkı simüle edilir.

---

## Faz 1 — In-app form, GitHub'a otomatik issue (1-2 hafta, **Faz 0'dan 5 katkı sonrası**)

Kullanıcı uygulama içinde form doldurur, manifest otomatik üretilir, submit → GitHub issue açılır.

### Yapılacaklar (Faz 1)

1. **Yeni Flutter ekran** `lib/features/skapi/contribute/contribute_screen.dart`:
   - Multi-step form: Bilgi → Script & Manifest → Önizleme → Gönder
   - Platform/grup dropdown (mevcut `kSkapiPlatforms` ve grup manifest'leri okuyarak)
   - Script kodu için multiline `TextField` (monospace, syntax highlight opsiyonel paket)
   - Parametre ekleme UI: ad/tür/varsayılan/min/max → arka planda manifest JSON inşa edilir
   - Önizleme adımında: kullanıcının göreceği card render (mevcut script detail screen template'i)
   - Submit butonu → form payload'ı issue URL'e encode edip `url_launcher` ile aç (Faz 1.A) **VEYA** Cloudflare Worker'a POST (Faz 1.B)
2. **Lisans onayı checkbox** — kullanıcı MIT/Apache seçer, "katkımın bu lisansla yayınlanmasını kabul ediyorum" onaylar.
3. **Hata yönetimi**: ağ yoksa form draft'ı SharedPreferences'a kaydet, sonra tekrar dene.

### GitHub tarafında (Faz 1)

- **PR template**: `.github/PULL_REQUEST_TEMPLATE/script-submission.md` — checklist (test edildi mi, dokümantasyon var mı, banlist temiz mi, lisans seçildi mi).
- **GitHub Actions** `.github/workflows/lint-submission.yml`:
  - Trigger: PR açıldığında
  - Adımlar:
    1. PowerShell parser: `[System.Management.Automation.Language.Parser]::ParseFile` her `.ps1` için, hata sayısı > 0 ise fail
    2. JSON schema validate: her `.json` için (Ajv veya yajsv ile)
    3. Banlist regex grep: `Invoke-WebRequest.*-OutFile`, `Remove-Item.*-Recurse.*C:\\`, `Set-MpPreference`, `iex`, `Invoke-Expression` (download/eval kombinasyonları); eşleşme varsa PR'a comment + label `security-review-needed`
    4. Klasör yapısı denetimi (`catalog/<platform>/<script-id>/...` formatı)
- **Branch protection** main üzerinde:
  - PR review zorunlu (CODEOWNERS dosyasında SmartKraft team)
  - Tüm checks geçmeli
  - Force push yasak
- **Bot/proxy seçeneği (Faz 1.B)**:
  - Cloudflare Worker, `smartkraft.ch/skapi/submit` endpoint
  - POST body: form payload
  - Worker GitHub API üzerinden issue açar (kişisel access token Worker secret'ında)
  - Rate limit: IP başına 5 submit/saat
  - Spam koruması: hcaptcha veya cloudflare turnstile
- **Issue labels**: `submission`, `win`, `mac`, `linux`, `power`, `visual-break`, `programs`, `display-audio`, `security-review`, `approved`, `needs-changes`

### Faz 1 doğrulama

- Form doldurulup gönderilir → GitHub'da issue açılır (Faz 1.A) veya direkt PR (Faz 1.B + Worker).
- Otomatik lint workflow çalışır, sonuç PR'a comment olur.
- Kötü amaçlı script örnek olarak test edilir (download+exec) → lint reddeder.

---

## Faz 2 — Curated katalog + OTA dağıtımı (1-2 ay sonra, **10-20 onaylı script biriktikten sonra**)

GitHub'daki `catalog/` klasörü SKAPP tarafından okunup kullanıcıya gösterilir.

### Yapılacaklar (Faz 2)

1. **Catalog index oluşturma** (GitHub Actions):
   - Main branch'e merge olduğunda otomatik çalışır
   - `catalog/` altındaki tüm script JSON'larını birleştirip `community-index.json` üretir
   - İndex: `{ scripts: [{ id, platform, group, tier, author, version, sha256, sourceUrl }] }`
   - `smartkraft.ch/skapi/community/index.json` adresinde host edilir (GitHub Pages veya Cloudflare Pages)
2. **SKAPP catalog fetcher**:
   - `lib/features/skapi/data/community_repository.dart` (yeni)
   - App startup'ta index'i fetch eder, lokal cache'e yazar (`SharedPreferences` veya dosya)
   - Offline'da cache'den okur, online'da arka planda yeniler
3. **Script manifest extension**: `source: "official" | "community"` alanı eklenir, eski script'ler default `official`.
4. **Yeni UI bölümü**: SKAPI platform ekranında "Topluluk" sekmesi/bölümü
   - Filtre: official / community / hepsi
   - Community script kartlarında `author` ve `version` rozeti
5. **Settings toggle**: "Topluluk script'lerini göster" (default OFF, kullanıcı bilinçli olarak açar)
6. **Cryptographic signing**:
   - SmartKraft tarafında bir Ed25519 private key (offline tutulur)
   - GitHub Actions onaylanan her script için imza üretir (`<script-id>.sig`)
   - SKAPP imzasız community script'i reddeder
   - Public key SKAPP içine embed edilir

### GitHub tarafında (Faz 2)

- **Workflow** `.github/workflows/build-catalog.yml`:
  - Trigger: main'e push
  - Adımlar:
    1. `catalog/` taranır, tüm script JSON'larından `community-index.json` oluşur
    2. Her script için SHA256 hash hesaplanır, manifest'e eklenir
    3. Ed25519 imza üretilir (signing key GitHub Secret'tan; daha güvenlisi: ayrı sign-only repo)
    4. Index + script'ler GitHub Pages'a (veya Cloudflare Pages'a) deploy edilir
- **CODEOWNERS** dosyası — security review zorunlu yapanları belirler.

### Faz 2 doğrulama

- SKAPP açılır, Settings'te "Topluluk göster" açılır, SKAPI'de community script'ler görünür.
- Yeni script GitHub'a eklenir, 5 dk içinde SKAPP'te güncelleme bildirimi gelir.
- Sahte imzalı script SKAPP tarafından reddedilir (test).

---

## Faz 3 — Discovery, güven, raporlama (3-6 ay sonra)

Topluluk büyüdükçe.

### Yapılacaklar (Faz 3)

- **Indirilme/kullanım telemetrisi** (opt-in): hangi script'ler popüler
- **Featured bölümü**: SmartKraft seçimi, manuel curation
- **User rating**: 1-5 yıldız (manipülasyona karşı: hesap başına 1 oy, sadece imzalı SKAPP install'lar)
- **Report mekanizması**: SKAPP UI'da "Bu script tehlikeli" butonu → GitHub'da issue açar, label `report`
- **Versiyon pinning**: kullanıcı bir script'in v1.2'sini kullanıyorsa otomatik güncelleme yapılmaz
- **Author profile**: GitHub OAuth ile bağlayıp profile sayfası (gönderdiği script'ler, toplam indirilme)

---

## Faz 4 — Sandbox + hesap sistemi (uzak gündem)

- SmartKraft hesap sistemi (OAuth + e-mail)
- Star/favorite community scripts
- PowerShell sandbox (constrained language mode, restricted execution policy)
- Per-script permission model (file access izni, network izni, vb.)

---

## Kritik güvenlik kuralları (her fazda geçerli)

1. **Otomatik onay YOK** — her script insan moderatöründen geçer
2. **Banlist** statik analiz: download+exec, registry HKLM yazımı, scheduled task, defender bypass, crypto wallet path, .NET eval, base64 decode + iex
3. **Author confirmation**: ilk submit'te author GitHub hesabıyla onaylar
4. **Cryptographic signing**: SmartKraft Ed25519 anahtarıyla; imzasız community script SKAPP'te çalışmaz
5. **Default OFF**: yeni kullanıcı kazara çalıştırmasın
6. **In-app uyarı**: ilk community script çalıştırılırken "community-sourced, kodu görüntüle" dialog'u
7. **Geri çekme**: gerektiğinde bir script index'ten silinir, SKAPP'te disable olur

---

## Bu hafta yapılabilecek minimum (Faz 0 — concrete)

Sırayla:

1. **GitHub'da repo aç**: `smartkraft/skapi-community-scripts` (public, MIT)
2. **README.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md, LICENSE** yaz
3. **ISSUE_TEMPLATE/script-submission.yml** GitHub Forms olarak ekle
4. **`_ContributeFooter` callback'ini düzenle**: snackbar yerine `SkCenteredDialog` aç, içinde GitHub link + mailto butonu
5. **L10n key'leri** ekle (4 anahtar her dilde)
6. `flutter analyze` + build, deploy

1 günlük iş. 5 işe yarar issue/email geldikten sonra Faz 1 form'una başlanır.

---

## Mevcut kod referansları

- [skapi_screen.dart `_ContributeFooter`](app/lib/features/skapi/skapi_screen.dart) — şu anki "yakında" footer
- [SkCenteredDialog](app/lib/core/ui/sk_centered_dialog.dart) — reusable popup, Faz 0 dialog'u için kullanılacak
- [app_en.arb](app/lib/l10n/app_en.arb) + [app_tr.arb](app/lib/l10n/app_tr.arb) — yeni l10n key'leri
- Memory: [project_branding_and_distribution](~/.claude/projects/.../memory/project_branding_and_distribution.md) — SKAPP kapalı kaynak, repo lokal; topluluk script kütüphanesi AYRI public repo olarak açılır
- Memory: [project_ota_plan](~/.claude/projects/.../memory/project_ota_plan.md) — hybrid OTA pattern (manifest smartkraft.ch + binary GitHub Releases); community katalog için de aynı pattern uygulanabilir
