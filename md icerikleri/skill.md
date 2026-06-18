# Skill Listesi (Tam)

Bu dosya, bu kurulumda kullanılabilen tüm skill'leri ve ne işe yaradıklarını Türkçe olarak özetler. Hem global Claude Code skill'leri hem de gstack eklenti skill'leri dahildir.

---

# Global Claude Code Skill'leri

## Kod İnceleme ve Kalite

- **code-review**: Mevcut diff'i hata ve sadeleştirme açısından inceler; effort seviyesine göre kapsam değişir (low/medium az ama yüksek güvenli bulgu, high/max geniş kapsam). `--comment` ile PR'a inline yorum, `--fix` ile düzeltmeleri uygular. `ultra` modu bulutta çok-ajanlı derin inceleme yapar.
- **simplify**: Değişen kodu yeniden kullanım, sadeleştirme, verimlilik ve seviye açısından inceler ve düzeltmeleri uygular. Hata avı yapmaz, sadece kalite.
- **review**: Bir pull request'i inceler.
- **security-review**: Mevcut branch'teki bekleyen değişikliklerin tam güvenlik incelemesini yapar.

## Çalıştırma ve Doğrulama

- **run**: Projenin uygulamasını başlatır ve sürer; bir değişikliğin gerçek uygulamada çalıştığını görmek için.
- **verify**: Bir kod değişikliğinin gerçekten amacına uygun çalıştığını uygulamayı çalıştırıp davranışı gözlemleyerek doğrular.

## Araştırma

- **deep-research**: Derin, çok kaynaklı, doğrulanmış araştırma raporu üretir. Web aramalarını dağıtır, kaynakları çeker, iddiaları çapraz doğrular ve kaynaklı bir rapor sentezler.

## Claude API Geliştirme

- **claude-api**: Claude API / Anthropic SDK uygulamaları geliştirir, debug eder ve optimize eder. Prompt caching dahil eder; mevcut kodu model sürümleri arasında migrate eder.

## Harness ve Yapılandırma

- **init**: Kod tabanı dokümantasyonu ile yeni bir CLAUDE.md dosyası başlatır.
- **update-config**: settings.json üzerinden harness yapılandırması; otomatik davranışlar için hook, izinler, env var ayarları ve hook sorun giderme.
- **keybindings-help**: Klavye kısayollarını özelleştirir; tuş yeniden atama, chord kısayolları, ~/.claude/keybindings.json düzenleme.
- **fewer-permission-prompts**: Transcript'leri tarar, sık kullanılan salt-okunur komutlar için izin listesi ekleyerek izin pop-up'larını azaltır.

## Otomasyon ve Zamanlama

- **loop**: Bir prompt veya slash komutunu tekrarlı aralıkla çalıştırır (ör. `/loop 5m /foo`). Aralık verilmezse model kendi hızını ayarlar.
- **schedule**: Cron zamanlamasıyla çalışan uzak ajanları (routine) oluşturur, günceller, listeler veya çalıştırır. Tek seferlik zamanlanmış çalıştırma da yapar.

## Firmware

- **esp-idf-helper**: Espressif ESP-IDF ile ESP32/ESP8266 firmware geliştirme, build, flash ve debug yardımı (Linux/WSL).

## Skill Keşfi

- **find-skills**: "Bunu nasıl yaparım", "X için bir skill var mı" gibi sorularda yüklenebilir skill'leri keşfetmeye ve kurmaya yardım eder.

---

# gstack Eklenti Skill'leri

## Planlama

- **office-hours**: YC tarzı ofis saati. Fikrini zorlayıcı sorularla sorgular, iki çalışma modu sunar.
- **spec**: Belirsiz bir fikri 5 fazda kesin, uygulanabilir bir şartnameye dönüştürür.
- **autoplan**: CEO, tasarım, mühendislik ve DX review skill'lerini sırayla, 6 karar prensibiyle otomatik zincirleyen plan inceleme hattı.
- **plan-ceo-review**: Plana kurucu/CEO gözüyle bakar; ürün ve iş açısından inceleme.
- **plan-eng-review**: Plana mühendislik yöneticisi gözüyle bakar; mimari, fizibilite ve risk.
- **plan-design-review**: Plana tasarımcı gözüyle interaktif inceleme yapar.
- **plan-devex-review**: Plana geliştirici deneyimi (DX) açısından interaktif inceleme yapar.
- **plan-tune**: gstack için soru hassasiyetini ve geliştirici psikografisini kendi kendine ayarlar.

## Tasarım

- **design-consultation**: Ürünü anlar, pazarı araştırır, eksiksiz bir tasarım sistemi önerir ve font + renk önizlemeleri üretir.
- **design-shotgun**: Birden çok AI tasarım varyantı üretir, karşılaştırma panosu açar, yapılandırılmış geri bildirim toplar.
- **design-html**: Tasarımı sonlandırır; üretim kalitesinde, Pretext'e uygun HTML/CSS üretir.
- **design-review**: Tasarımcı gözüyle QA. Görsel tutarsızlık, boşluk, hiyerarşi ve AI slop kalıplarını bulur ve düzeltir.

## Build ve İnceleme

- **review** (gstack): Land öncesi PR incelemesi (staff-engineer seviyesi).
- **investigate**: Kök neden odaklı sistematik hata ayıklama.
- **codex**: OpenAI Codex CLI sarmalayıcısı; bağımsız ikinci göz, üç mod.
- **health**: Kod kalitesi panosu (type-check + lint + test + ölü kod).
- **devex-review**: Canlı geliştirici deneyimi denetimi.
- **retro**: Haftalık mühendislik retrospektifi.

## Test ve İzleme

- **qa**: Bir web uygulamasını sistematik QA test eder ve bulunan hataları düzeltir.
- **qa-only**: Sadece rapor üreten QA testi (düzeltme yapmaz).
- **benchmark**: Browse daemon ile performans regresyon tespiti.
- **benchmark-models**: gstack skill'leri için modeller arası benchmark.
- **canary**: Deploy sonrası canary izleme.

## Güvenlik ve Güvenli Komut

- **careful**: Yıkıcı komutlar için güvenlik korkulukları (uyarı).
- **freeze**: Oturum boyunca düzenlemeleri tek bir klasöre kısıtlar.
- **unfreeze**: freeze ile konan klasör kilidini açar.
- **guard**: Tam güvenlik modu; yıkıcı komut uyarıları + dizine kilitli düzenleme.
- **cso**: Chief Security Officer modu (OWASP + STRIDE güvenlik denetimi).

## Hafıza ve Çok-Cihaz Süreklilik

- **learn**: Projeye özel öğrenilenleri yönetir.
- **setup-gbrain**: Bu ajan için gbrain kurar; CLI yükler, yerel PGLite/Supabase brain başlatır, MCP kaydı yapar.
- **sync-gbrain**: gbrain'i repo koduyla güncel tutar; CLAUDE.md arama rehberini tazeler.
- **context-save**: Çalışma bağlamını kaydeder.
- **context-restore**: context-save ile kaydedilmiş bağlamı geri yükler.

## Tarayıcı ve Web

- **browse**: Gerçek Chromium ile hızlı headless tarayıcı; QA testi ve site dogfooding.
- **gstack**: Hızlı headless tarayıcı (browse ile aynı çekirdek).
- **open-gstack-browser**: GStack Browser'ı başlatır; sidebar uzantısı gömülü AI kontrollü Chromium.
- **setup-browser-cookies**: Gerçek Chromium çerezlerini headless browse oturumuna aktarır.
- **pair-agent**: Uzak bir AI ajanını tarayıcınla eşler.
- **scrape**: Bir web sayfasından veri çeker.
- **skillify**: En son başarılı /scrape akışını kalıcı bir tarayıcı skill'ine dönüştürür.
- **_gstack-command**: gstack için dahili komut sarmalayıcı (headless tarayıcı altyapısı).

## Doküman

- **document-generate**: Bir özellik, modül veya tüm proje için eksik dokümanı sıfırdan üretir (Diataxis).
- **document-release**: Ship sonrası eskiyen dokümanı günceller.
- **make-pdf**: Herhangi bir markdown dosyasını yayın kalitesinde PDF'e çevirir.

## Ship ve Deploy

- **ship**: Ship akışı; base branch tespit/merge, test, diff inceleme, VERSION bump, CHANGELOG, commit, push, PR.
- **land-and-deploy**: Land ve deploy akışı.
- **landing-report**: Workspace-aware ship için salt-okunur kuyruk panosu.
- **setup-deploy**: /land-and-deploy için deploy ayarlarını yapılandırır.

## iOS

- **ios-qa**: SwiftUI uygulamaları için gerçek cihazda canlı QA.
- **ios-fix**: Gerçek iPhone'da otonom hata düzeltici.
- **ios-design-review**: Gerçek donanımda iOS uygulamaları için görsel tasarım denetimi (Apple HIG).
- **ios-clean**: Release build'den DebugBridge SPM paketini ve `#if DEBUG` bağlantılarını temizler.
- **ios-sync**: iOS debug bridge'i en güncel upstream gstack şablonlarına göre yeniden üretir.

## Bakım

- **gstack-upgrade**: gstack'i en güncel sürüme yükseltir.
