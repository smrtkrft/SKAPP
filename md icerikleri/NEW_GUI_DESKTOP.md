# SKAPP Desktop GUI · Yeniden Tasarim Plani

Bu dokuman SKAPP masaustu surumunun mevcut sayfa/buton/modal envanterini ve sifirdan yeniden
tasarim icin adim adim plani icerir. Cihaza ozgu ekranlar (BF/LS device home) bu kapsamin
disindadir; orada SKAPP cercevesi degil cihazin kendi paneli yer alir.

---

## 1. MEVCUT SISTEM ENVANTERI

### 1.1 Sayfalar (top-level routes)

| Sayfa | Dosya | Erisim | Aciklama |
|---|---|---|---|
| Splash | features/splash/splash_screen.dart |
           Acilis | 1.2s logo animasyon, sonra MainShell |

| Home / Anasayfa | features/home/home_screen.dart |
           Tab 0 | 3 stat (cihaz/online/uyari) + cihaz kartlari ya da bos hero |

| Devices / Cihazlarim | features/devices/devices_screen.dart |
           Tab 1 | Esli cihaz listesi + AppBar Add butonu |

| SKAPI / Aksiyonlarim | features/skapi/skapi_screen.dart |
           Tab 2 | SKAPI Library (4 platform karti), Starred, Contribute, My Actions |

| Settings / Ayarlar | features/settings/settings_screen.dart |
           Tab 3 | Card grid: Appearance, Connectivity, Updates, Advanced, Info |

| Device Shell | features/device_home/device_home_screen.dart |
           Cihaz karti tap | Cihaz tipine gore alt ekrana dispatch |

| About | features/about/about_screen.dart |
           Settings → About | Felsefe + sosyal kartlar |

| License | features/license/license_screen.dart |
           Settings → License | Lisans metni + 3rd-party link |

### 1.2 Bottom nav / Shell

`features/main_shell/main_shell.dart`:
- **Mobile:** alt sekme pill (4 tab, ikon + aktif label)
- **Desktop (≥expanded breakpoint):** sol sidebar, 220px genis, SKAPP basligi + 4 rail item

Sekmeler (her iki platformda da ayni sira):
1. Home — `Icons.home_outlined / home_rounded`
2. Devices — `Icons.devices_outlined / devices_rounded`
3. SKAPI — `Icons.extension_outlined / extension_rounded`
4. Settings — `Icons.tune_outlined / tune_rounded`

### 1.3 Butonlar → Modal / Popup / Dialog / BottomSheet / Push-route

**Home Screen**
- Bos hero "Cihaz Ekle" → `SetupChoiceScreen` (push)
- Cihaz karti tap → `DeviceHomeScreen` (push)
- Footer "Cihaz Ekle" → `SetupChoiceScreen` (push)

**Devices Screen**
- AppBar `+` ikonu → `SetupChoiceScreen` (push)
- Bos durum "Cihaz Ekle" → `SetupChoiceScreen` (push)
- Cihaz karti tap → `DeviceHomeScreen` (push)

**SKAPI Screen**
- AppBar `info` ikonu → `showSkapiHelpSheet` (modal bottom sheet, `widgets/skapi_help_sheet.dart`)
- Platform karti (mac/win/lx/other) → `SkapiPlatformScreen` (push)

**Settings Screen**
- Theme karti → in-place cycle (light/dark/system)
- Language karti → `showModalBottomSheet` (RadioGroup: System/EN/TR)
- Bluetooth permissions → `openAppSettings()` (sistem)
- Network identity (desktop):
  - Name edit → `showDialog` (TextField)
  - UUID copy → clipboard
  - Port edit → `showDialog` (TextField)
  - Token copy → clipboard
  - Token refresh → `showDialog` (regenerate confirm)
- SKAPP listener (desktop) → custom card; start/stop in-place
- Update channel → in-place cycle (stable/beta)
- Auto-check updates → toggle in-place
- Check updates → `showSnackBar` ("not wired yet")
- Developer mode → toggle in-place
- USB Console (dev mod ON, Android/Win/Mac/Linux) → `UsbConsoleScreen` (push)
- About → `AboutScreen` (push)
- License → `LicenseScreen` (push)

**About Screen**
- GitHub / Website / YouTube / X / Email kartlari → `launchUrl` (harici)

**License Screen**
- "Third-party licenses" → `showLicensePage` (Flutter built-in dialog)

**Setup Choice Screen** (cihaz ekleme akisi giris)
- "Fresh device" → `DiscoveryScreen` (pushReplacement)
- "Existing device" → `WifiDiscoveryScreen` (pushReplacement)

**Discovery Screen** (BLE + mDNS)
- Filter toggle, Refresh ikonu — in-place
- SmartKraft cihaz tap → `PairingScreen` (push)
- mDNS-only tap → `showSnackBar` ("WiFi pairing not active yet")

**Pairing Screen**
- Passphrase gate → `promptPairingPassphrase` (AlertDialog with TextField)
- Basari → `WifiScanScreen` ya da `WifiSuccessScreen` (push)
- Hata → Retry butonu (state reset)

**WiFi Scan Screen**
- Network tap → `WifiPasswordScreen` (push)
- Retry → in-place rescan

**Device Home Shell**
- Cihaz tipine gore dispatch (BfHomeScreen, vs.)

**Skapi Sub-Screens**
- `SkapiPlatformScreen` group tile → `SkapiGroupScreen`
- `SkapiGroupScreen` script tile → `SkapiScriptDetailScreen`
- `SkapiScriptDetailScreen`:
  - Edit → `SkapiScriptEditorScreen` (push)
  - Run Now → `showModalBottomSheet` (`skapi_run_sheet.dart`)
  - Run Remote → `showModalBottomSheet` (`skapi_run_remote_sheet.dart`)
  - Bind to Action → `SkapiBindScreen` (push)
- `SkapiBindScreen` Save/Delete/Cancel → in-place + pop

**USB Console Screen** (dev mode)
- Port karti tap → console asamasi
- Clear, Disconnect → in-place
- Send butonu → komut gonder, sonucu listeye ekle

**Skapp Peer Pairing Screen** (telefon ↔ desktop)
- QR scan tab (mobile only) — auto-pair
- Manual tab — host/port/token form, "Pair" → kaydet

### 1.4 Alt icerik sayfalari (push-route, bottom nav disi)

| Dosya | Amac | Erisim |
|---|---|---|
| skapi_platform_screen.dart | Platform detayi (Mac/Win/Lx/Other) | SKAPI > Platform karti |

| skapi_group_screen.dart | Grup detayi + script listesi | Platform > Group |

| skapi_script_detail_screen.dart | Script detay + edit/run/bind | Group > Script |


| skapi_script_editor_screen.dart | Script kaynak editoru (Faz F stub) | Detail > Edit |

| skapi_bind_screen.dart | ActionBinding form | Detail > Bind |

| skapp_peer_pairing_screen.dart | Telefon-desktop pairing | (henuz wire-up yok) |

| usb_console_screen.dart | USB CLI konsol | Settings > USB Console |

| setup_choice_screen.dart | Pairing akisi giris | Add cihaz butonu |

| discovery_screen.dart | BLE+mDNS tarama | SetupChoice > Fresh |

| pairing_screen.dart | ECDH/HMAC pairing | Discovery > Cihaz |

| wifi_scan_screen.dart | WiFi taramasi | Pairing basari |

| wifi_password_screen.dart | SSID parolasi | WifiScan > Network |

| wifi_success_screen.dart | WiFi onay + cihaza dis | Password > OK |


### 1.5 Settings alt-sayfa envanteri

1. Theme — cycle in-place
2. Language — modal bottom sheet
3. Bluetooth status — read-only
4. WiFi status — read-only
5. Bluetooth permissions — sistem ayarlarini ac
6. Network identity (desktop): name/uuid/port/token/regenerate — dialog
7. SKAPP listener (desktop) — custom card
8. Update channel — cycle in-place
9. Auto-check updates — toggle
10. Check updates — snackbar (placeholder)
11. Developer mode — toggle
12. USB Console (dev + desteklenen platform) — push
13. About — push
14. License — push
15. Version — read-only

### 1.6 SKAPI alt sayfa envanteri

1. SkapiPlatformScreen × 4 (Mac/Win/Lx/Other)
2. SkapiGroupScreen
3. SkapiScriptDetailScreen
4. SkapiScriptEditorScreen (stub)
5. SkapiBindScreen
6. SkappPeerPairingScreen

### 1.7 About alt sayfa envanteri

Tek sayfa, bolumler: cihaz felsefesi, SKAPP rolu, maker showcase (placeholder), 5 sosyal link kart, version. Alt sayfa yok; tum baglantilar `launchUrl`.

### 1.8 Cihaz ekleme akisi (pairing wizard) sirasi

1. SetupChoiceScreen → 2 secim
2. DiscoveryScreen (fresh) → BLE/mDNS tarama
3. PairingScreen → ECDH bootstrap veya HMAC reconnect (passphrase opsiyonel)
4. WifiScanScreen → cihaz uzerinden WiFi tarama
5. WifiPasswordScreen → SSID parolasi
6. WifiSuccessScreen → onay, time.set, device.info, manifest, DeviceHomeScreen

### 1.9 Bos durumlar / placeholder ekranlar

- Home (cihaz yok) — full-bleed hero
- Devices (cihaz yok) — center kolon + buton
- SKAPI Starred — placeholder kart
- SKAPI My Actions (cihaz yok) — "once cihaz esle"
- SKAPI My Actions (cihaz var) — "Action olusturma henuz wire degil"
- SKAPI platform group bos — _PlatformEmpty
- Discovery scanning — spinner + "Searching for devices…"
- Discovery BLE off — Enable Bluetooth + Open Settings
- Discovery permission denied — Retry + Open Settings
- USB Console port yok — "No USB ports connected"
- Pairing failed — error card + debug log + Retry

### 1.10 Yarim / TODO / dead UI (2026-05-07 guncellendi)

- Language: sadece TR/EN (8 dil planli, henuz yok)
- ~~WiFi pairing (existing path): "planned but not active"~~ → ✅ [wifi_discovery_screen.dart](app/lib/features/device_discovery/wifi_discovery_screen.dart) + [wifi_pairing_screen.dart](app/lib/features/device_pairing/wifi_pairing_screen.dart) wire edildi
- ~~mDNS-only cihaz pairing: "snackbar explains, can't pair"~~ → ✅ TCP ECDH pairing aktif
- SKAPI script editor: Phase F stub (hala stub)
- ~~SKAPI run remote sheet: layout var execution wire yok~~ → ✅ skapi_run_remote_sheet calisiyor (peer'a HTTP POST)
- OTA: "service not wired yet" snackbar, manifest URL null
- Update channel cycling: hicbir efekti yok
- ~~Listener: "Server not running yet" notice (Phase 2)~~ → ✅ [skapp_http_server.dart](app/lib/core/network/skapp_http_server.dart) + [skapp_listener_service.dart](app/lib/core/network/skapp_listener_service.dart) calisiyor
- ~~Action bindings: in-memory, persistence Phase 2~~ → ✅ [bindings_store.dart](app/lib/features/skapi/data/bindings_store.dart) ile SharedPreferences persistans
- ~~Starred APIs: placeholder, favoriting yok~~ → ✅ [skapi_providers.dart](app/lib/features/skapi/data/skapi_providers.dart) + skapi_screen.dart wire + SharedPreferences persist
- ~~LS device dispatch: `_UnsupportedDevice` mesaji~~ → ✅ [lebensspur/](app/lib/features/devices/lebensspur/) tam ekran seti
- ~~Skapp peer pairing: ekran var ama akisin tetigi henuz wire degil~~ → ✅ QR + manuel pairing aktif

---

## 2. YENI DESKTOP TASARIMI · ADIM ADIM PLAN

### 2.1 Tasarim ilkeleri (kullanicidan dogrulanan tercihler)

- Renk paleti sabit: krem / siyah / beyaz + hardal sari (uyari icin kirmizi, dikkat icin hardal)
- Em-dash YASAK; "Pomodoro" yasak
- Cihaz isimi monolitik (modular manifest yok), her cihaz APP icinde tam tanimli
- "Esli" yerine "bagli cihaz" terminolojisi (S2.html'de uygulandi)
- Desktop'ta uzaysal/network metaforlar (Constellation Atlas, Orbital Nest) kullanici tarafindan onaylandi

### 2.2 Faz 1 · Shell ve navigasyon

**Yeni Shell (main_shell.dart):**
- Sol sidebar 220 → 80px (icon-only) varsayilan, hover'da 240px expand (ipucu: VSCode/Linear pattern)
- Ust bar yeni: sol "SKAPP" wordmark, ortada cihaz status pill (X bagli / Y aktif), sag profile/notif ikonu (placeholder)
- Sidebar 4 ana sekme + alt segment "Quick" (komut paleti CMD+K, recently opened device)
- Desktop'a ozel: sol sidebar bottom'unda "+ Cihaz ekle" hizli buton (her ekrandan erisim)

### 2.3 Faz 2 · Home (Anasayfa)

**Mevcut:** stat header + cihaz kartlari, ya da bos hero

**Yeni (orbital nest tabanli):**
- Merkez SKAPP wordmark + meta sayilar (5/7 bagli, 42 script, v0.1)
- Etrafinda fizik motorlu cihaz kartlari (laptop.html design 2 stili, son test surumu hazir)
- Sol-ust kume: 3 hizli sekme/eylem (Cihazlarim, SKAPI, Ayarlar) gercek navigasyon noktalari
- Sag-ust: tarih + saat + sistem durumu
- Sag-alt: son aktivite akisi (kucuk timeline)
- Cevrimdisi cihaz: opacity .55, dashed kenar, tiklanamaz (S2.html cizgisi)
- Animasyon hizi yarida (laptop.html son ayarlari ile uyumlu)

### ~~2.4 Faz 3 · Cihazlarim~~ ✅ TAMAMLANDI

**Mevcut:** liste + AppBar add

**Yeni (Constellation Atlas):** → **UYGULANDI** ([constellation_view.dart](app/lib/features/devices/widgets/constellation_view.dart))
- ~~Tum sayfa ag haritasi: SKAPP merkezi hub, 5 cihaz nod (S2.html son surumu)~~ ✅
- ~~Hub-node arasi canli kesik baglanti (aktif hardal, offline silik dashed)~~ ✅
- ~~Sag-ust "Yeni node" → modal eslestirme akisi~~ ✅ (Add pill ile push)
- ~~Sol-alt legend + sag-alt istatistik~~ ✅ ([devices_legend.dart](app/lib/features/devices/widgets/devices_legend.dart) + [devices_stats_card.dart](app/lib/features/devices/widgets/devices_stats_card.dart))
- ~~Cevrimdisi node tiklanamaz~~ ✅
- Eklendiginde toast + haritada dinamik nod yerlestirme (animasyon ileride)

### 2.5 Faz 4 · SKAPI

**Mevcut:** Platform > Group > Script > Detail (tum push route, mobil sirali)

**Yeni (master-detail 3 panel):**
- Sol panel (240px): Platform agaci (Mac/Win/Linux/Other) ve altinda gruplar (collapse)
- Orta panel (~340px): script listesi (secili gruba ait) + arama bari
- Sag panel (esnek): script detay (meta, kaynak, edit, run, bind)
- Inline edit (ayri push route degil), inline run (modal sheet hala kullanilabilir ama shell icinde ust panel olarak)
- "My Actions" sekmesi ust segment olarak (Library / My Actions / Starred / Contribute)
- Eklenebilir: **Komut paleti** (CMD+K) hizli script arama + run (yeni)

### 2.6 Faz 5 · Ayarlar

**Mevcut:** card grid (Appearance/Connectivity/Updates/Advanced/Info)

**Yeni (master-detail 2 panel):**
- Sol panel (240px): kategori listesi (Appearance, Connectivity, Updates, Advanced, Network identity, Listener, About, License, Version)
- Sag panel: secili kategorinin tum kontrolleri tek sayfada
- Eklenebilir: **Search bar** ust kisimda, ayar adina gore filtre
- Theme/Language inline RadioGroup (cycle ya da bottom sheet yerine), ayni panelde
- Network identity butun field'lar tek formda inline edit (her field icin ayri dialog yerine)
- Token regenerate hala confirm dialog

### 2.7 Faz 6 · Cihaz ekleme akisi (Pairing Wizard)

**Mevcut:** push-route zinciri (SetupChoice > Discovery > Pairing > WifiScan > Password > Success)

**Yeni (modal-shell wizard):**
- Tum akis SHELL ICINDE sag-asagidan acilan modal panel (overlay), arkada Constellation Atlas blur'lu gorunur
- Step indicator ust: 1 Tara → 2 Sec → 3 Eslestir → 4 WiFi → 5 Tamam
- Geri/Iptal her zaman ust-sol; ESC ile kapanir
- Akis tamamlanunca panel kapanir, yeni nod haritaya animate olarak yerlesir (S2.html'de test edilen pattern)

### 2.8 Faz 7 · About / License / Splash / USB Console

- **About:** masaustu icin 2 kolon, sol felsefe metni, sag sosyal link grid + version (kart grid yerine)
- **License:** ust-sag "third-party" buton inline panel acsin, ayri sayfa olmasin
- **Splash:** sadece desktop variant, daha kucuk wordmark, wordmark altinda yumusak yukleme cubukcugu (1.2s mevcut sure korunur)
- **USB Console:** mevcut hali iyi (terminal odakli), yalnizca shell content alanina merkezli

### 2.9 Faz 8 · Yeni eklenebilirler

Yeni desktop ile firsata cevirilebilir:
- **Komut paleti (CMD+K)** sayfa atlama, script run, cihaz acma
- **Notification center** ust bar saginda (pil dustu, OTA hazir, action calisti vb)
- **Recent activity drawer** sol sidebar bottom'unda son 5 olay
- **Multi-window** ileride: bir cihaz penceresi ayri acilsin, ana SKAPP penceresi eslek
- **Klavye kisayollari** `1-4` tab atlama, `Cmd+,` settings, `Cmd+K` palette, `Cmd+N` new device, `Esc` kapat
- **Device sheet preview** Constellation Atlas'ta nod'a hover'da yan minicik panel cik (battery, last seen, hizli "ac" butonu)
- **Listener mini-status** sidebar bottom'unda kucuk LED + "X requests today"
- **Pin sayfa** sik kullanilan SKAPI scripti'ni Home'da Orbital Nest'e ekstra "uydu" olarak pinleme

### 2.10 Faz 9 · Degismemesi gereken sayfalar

- **Splash animasyonu** sure ve markalama korunur (sadece desktop boyut)
- **Pairing teknik adimlari** ECDH bootstrap mantigi (UI shell degisir, akis ayni)
- **About icerigi** felsefe metinleri, sosyal linkler ayni
- **License metni** degismez
- **USB Console** terminal davranisi (input/history/clear/disconnect) ayni
- **Network identity backend** UUID/port/token uretimi ayni, sadece UI form yenilenir
- **Listener davranisi** start/stop API ayni
- **Settings persistence** SharedPreferences key'leri ayni
- **Bond store / paired devices store** veri katmani degismez
- **Cihaza ozgu sayfalar** (BfHomeScreen, LebensspurScreens, BF widget'lari) kapsam disi
- **Pairing veri akislari** (CLI komut isimleri, NDJSON formati) protokol ayni
- **Update channel ve auto-check** mantigi (henuz wire degil zaten)

### 2.11 Migration sirasi (oneri)

1. Faz 1 (Shell) yeni sidebar/topbar; eski sayfalar asilirken degil
2. Faz 9 (degismeyenler test) splash, about, license, usb console aynen calistir
3. Faz 2 (Home) orbital nest implementasyonu
4. Faz 3 (Devices) constellation atlas implementasyonu
5. Faz 6 (Pairing wizard) modal-shell varianti
6. Faz 5 (Settings) master-detail
7. Faz 4 (SKAPI) 3 panel master-detail
8. Faz 8 (eklenebilirler) komut paleti, kisayollar, notif center

---

## 3. EKSIK NOKTALAR

- **Mobile davranis:** Bu desktop tasarim. Telefon (Android/iOS) icin mevcut UI korunacak mi yoksa unify mi? `main_shell.dart` zaten breakpoint'le ayriliyor; desktop dali ayri yazilirsa mobile etkilenmez.
- **Tema (light/dark):** Mevcut sistem ikisini de destekliyor; yeni tasarim hangisini varsayilan tutacak? Memory'de "krem/siyah/beyaz + hardal" var. Light icin krem-base; dark icin koyu-base ayri renk haritasi gerekli mi yoksa light'a ankaj mi?
- **Window controls:** Windows'ta title bar custom mu olacak (frameless + custom min/max/close butonlari)? Mevcut `bitsdojo_window` kullaniliyor mu, kontrol gerek.
- **Multi-window stratejisi:** Faz 8'de "ayri cihaz penceresi" oneriliyor; gerekli mi yoksa overkill mi?
- **Komut paleti scope:** sadece SKAPP-ici navigasyon mu, yoksa SKAPI script run da olmali mi?
- **Notification center:** plansiz; eklemek istenirse kaynak (toast bus) tasarlamak gerek
- **Cihaz ekleme dialog'u full-screen mi yoksa modal mi:** kucuk ekranli laptop'lar (1366×768) icin modal kucuk kalir; full-screen overlay daha guvenli olabilir

---

## 4. SORULAR

1. Desktop yeniden tasarimi mobile'i etkilemesin diye `main_shell` icinde sade desktop dali mi yoksa tamamen ayri `desktop_shell.dart` mi olusturalim?
2. Light/Dark icinde hangisini varsayilan istiyorsun?
3. Komut paleti (CMD+K) MVP'de mi yoksa Faz 8 ileri mi?
4. Constellation Atlas ile Orbital Nest ikisini de seviyorsun: biri Home, biri Devices olarak ayri kalsin mi yoksa tek ekran (Home = Devices) mi?
5. Pairing akisi modal-overlay mi yoksa hala tam ekran sayfa mi olsun?
6. Cihaz ekleme akisindaki mDNS ve "existing device" pathleri henuz wire degil; yeni tasarima dahil edelim mi yoksa wire edilince ekleyelim mi?
7. Splash sirasinda yeni desktop window kararti efekti (mac-style fade) istiyor musun?
8. Settings'te search bar onerisi var; gerekli mi yoksa az sekme oldugu icin gereksiz mi?
