# SKAPI — Linux (Debian Tabanlı) API Kontrol Listesi

Bu dosya, **Debian tabanlı** Linux dağıtımlarında (Debian, Ubuntu, Mint, Pop!_OS, Elementary, Kali, MX, Zorin) **API üzerinden uzaktan kontrol edilebilecek** tüm aksiyonların indeksidir.

> Her madde, ileride kendi `.md` dosyasında detaylandırılacak.
> Format her dosyada aynı olacak: **Ne yapar / Endpoint örneği / Kullanılan komut veya API / Gereken paket / X11 vs Wayland farkı / Örnek istek-cevap / Güvenlik notları**.
>
> Genel araçlar: `systemctl`, `loginctl`, `pactl/wpctl`, `nmcli`, `xdotool/ydotool`, `wmctrl`, `notify-send`, `playerctl`, `gsettings/dconf`, `xdg-*`.

---

## 0. X11 vs Wayland — Genel Not

Debian tabanlı sistemlerde:
- **Ubuntu 22.04+** → varsayılan Wayland (GNOME)
- **Ubuntu LTS eski sürümler** → X11
- **Mint, Pop!_OS, Elementary** → genelde X11
- **KDE Plasma** → her ikisi de seçilebilir
- **Sway, Hyprland** → sadece Wayland

Çoğu eski araç (xdotool, wmctrl, scrot) **sadece X11**'de çalışır. Wayland muadilleri: `ydotool/wtype`, `swaymsg`, `grim`. SKAPP **ilk açılışta oturum tipini tespit eder** (`echo $XDG_SESSION_TYPE`) ve uygun aracı kullanır.

Tablo:

| Görev | X11 aracı | Wayland aracı |
|---|---|---|
| Tuş simülasyonu | `xdotool` | `ydotool`, `wtype` |
| Mouse | `xdotool` | `ydotool` |
| Pencere yönetimi | `wmctrl`, `xdotool` | Compositor'a bağlı (`swaymsg`, `hyprctl`) |
| Ekran görüntüsü | `scrot`, `maim`, `gnome-screenshot` | `grim`, `gnome-screenshot` |
| Pano | `xclip`, `xsel` | `wl-clipboard` (`wl-copy`, `wl-paste`) |
| Ekran kapat | `xset dpms force off` | `wlr-randr --output X --off` |
| Resolution | `xrandr` | `wlr-randr` |

---

## 1. Güç Yönetimi (Power)

- [ ] **shutdown** — Cihazı belirlenen süre sonra kapatır. `shutdown -h +N` veya `systemctl poweroff`.
- [ ] **restart** — Yeniden başlatma. `systemctl reboot`.
- [ ] **sleep** — Uyku moduna alma. `systemctl suspend`.
- [ ] **hibernate** — Hazırda beklet. `systemctl hibernate`.
- [ ] **hybrid-sleep** — Karma uyku. `systemctl hybrid-sleep`.
- [ ] **logoff** — Aktif kullanıcı oturumunu kapat. `loginctl terminate-session $XDG_SESSION_ID`.
- [ ] **lock** — Ekranı kilitle. `loginctl lock-session` veya `xdg-screensaver lock`.
- [ ] **abort-shutdown** — Bekleyen kapatma'yı iptal. `shutdown -c`.
- [ ] **wake-on-lan** — Magic packet ile uyandır. `wakeonlan` paketi.
- [ ] **inhibit-sleep** — Uyku/idle/lock'ı geçici engelle. `systemd-inhibit` veya `caffeine` paketi.
- [ ] **release-inhibit** — Engellemeyi kaldır.
- [ ] **power-profile** — Güç profilini değiştir. `powerprofilesctl set performance|balanced|power-saver` (yeni dağıtımlar) veya `tlp`.
- [ ] **battery-info** — Şarj seviyesi, fişte mi, kalan süre. `upower -i $(upower -e | grep BAT)` veya `acpi -b`.

## 2. Sistem Bilgisi & İzleme

- [ ] **uptime** — Açık kalma süresi. `uptime`.
- [ ] **system-info** — Dağıtım, kernel, hostname, kullanıcı, mimari. `hostnamectl`, `lsb_release -a`, `uname -a`.
- [ ] **cpu-usage** — Anlık CPU yüzdesi. `mpstat`, `/proc/stat` parse.
- [ ] **cpu-temp** — CPU sıcaklığı. `sensors` (`lm-sensors` paketi), `/sys/class/thermal/thermal_zone*/temp`.
- [ ] **ram-usage** — Toplam/kullanılan/boş RAM. `free -h`, `/proc/meminfo`.
- [ ] **swap-usage** — Swap kullanımı.
- [ ] **disk-usage** — Disk başına alan. `df -h`, `du -sh`.
- [ ] **gpu-info** — NVIDIA: `nvidia-smi`, AMD: `radeontop`, Intel: `intel_gpu_top`.
- [ ] **network-info** — IP, MAC, Wi-Fi SSID, sinyal. `ip addr`, `nmcli`, `iwconfig`.
- [ ] **logged-users** — Aktif kullanıcılar. `who`, `w`.
- [ ] **process-count** — Çalışan process sayısı.
- [ ] **distro-info** — Dağıtım sürümü, kod adı. `lsb_release -d`.
- [ ] **package-count** — Yüklü paket sayısı. `dpkg -l | wc -l`.
- [ ] **updates-available** — Güncel paket sayısı. `apt list --upgradable`.
- [ ] **journal-tail** — `journalctl` son N satır.

## 3. Ekran & Görüntü

- [ ] **brightness** — Ekran parlaklığı. `brightnessctl set 50%` veya `light -S 50` (laptop dahili). `ddcutil setvcp 10 50` (DDC ile harici monitör).
- [ ] **monitor-off / on** — Ekranı kapat/aç. X11: `xset dpms force off`. Wayland: `wlr-randr --output X --off`.
- [ ] **resolution** — Çözünürlük değiştir. `xrandr` / `wlr-randr`.
- [ ] **rotate** — Ekranı döndür. `xrandr --rotate left/right/normal/inverted`.
- [ ] **night-light** — Mavi ışık filtresi. `redshift`, `gammastep`, GNOME Night Light (`gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true`).
- [ ] **screenshot** — Ekran görüntüsü al. X11: `scrot`/`maim`. Wayland: `grim`. Hepsi: `gnome-screenshot`, `flameshot`.
- [ ] **multi-monitor** — Bağlı ekranları listele, modu değiştir. `xrandr --listmonitors`.
- [ ] **wallpaper-set** — Duvar kağıdını değiştir. GNOME: `gsettings set org.gnome.desktop.background picture-uri "file://..."`. KDE: `qdbus`. XFCE: `xfconf-query`.
- [ ] **dark-mode-toggle** — GNOME: `gsettings set org.gnome.desktop.interface color-scheme prefer-dark`. KDE: `lookandfeeltool`.
- [ ] **theme-switch** — GTK tema değiştir. `gsettings set org.gnome.desktop.interface gtk-theme`.

## 4. Ses

- [ ] **volume-set** — Ana sesi ayarla. PulseAudio: `pactl set-sink-volume @DEFAULT_SINK@ 50%`. PipeWire: `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5`.
- [ ] **volume-up / down** — Adım adım. `pactl set-sink-volume @DEFAULT_SINK@ +5%`.
- [ ] **mute / unmute** — `pactl set-sink-mute @DEFAULT_SINK@ toggle`.
- [ ] **audio-device** — Aktif çıkış cihazını değiştir. `pactl set-default-sink`.
- [ ] **input-device** — Aktif mikrofonu değiştir. `pactl set-default-source`.
- [ ] **mic-mute** — Mikrofonu kapat/aç. `pactl set-source-mute @DEFAULT_SOURCE@ toggle`.
- [ ] **list-sinks** — Tüm ses çıkışlarını listele.
- [ ] **list-sources** — Tüm mikrofonları listele.
- [ ] **per-app-volume** — Belirli uygulamanın sesini ayarla (PulseAudio/PipeWire native!). `pactl list sink-inputs` + `pactl set-sink-input-volume`.
- [ ] **per-app-mute** — Belirli uygulamayı sustur.
- [ ] **play-sound** — Ses dosyası çal. `paplay file.wav`, `aplay file.wav`.
- [ ] **tts** — Metni sese çevir. `espeak`, `festival`, `mimic3` (Mycroft), `piper` (modern, kaliteli).
- [ ] **media-key** — Play/Pause/Next/Previous. `playerctl play-pause/next/previous` (MPRIS — Spotify, Firefox, VLC, mpv hepsi destekler).
- [ ] **playerctl-status** — Şu an çalan medya bilgisi. `playerctl metadata --format '{{ artist }} - {{ title }}'`.

## 5. Giriş Simülasyonu (Input)

- [ ] **send-keys** — Klavye tuşları gönder. X11: `xdotool key ctrl+s`. Wayland: `ydotool key`, `wtype`.
- [ ] **send-shortcut** — Kısayol gönder.
- [ ] **type-text** — Metin yaz. `xdotool type "hello"`, `wtype "hello"`.
- [ ] **mouse-move** — Fareyi belirli koordinata. `xdotool mousemove X Y`, `ydotool mousemove`.
- [ ] **mouse-click** — Sol/sağ/orta tıkla. `xdotool click 1`.
- [ ] **mouse-scroll** — Scroll simüle.
- [ ] **clipboard-get** — Pano oku. X11: `xclip -o -selection clipboard`. Wayland: `wl-paste`.
- [ ] **clipboard-set** — Panoya yaz. `xclip -selection clipboard`, `wl-copy`.
- [ ] **hide-cursor** — Cursor'u gizle. `unclutter` paketi.

> **Wayland notu:** `ydotool` için **uinput** modülü ve daemon gerekir (`sudo systemctl enable --now ydotoold`). Kullanıcının `input` grubunda olması veya udev rule yazılması gerekebilir.

## 6. Pencere & Uygulama Yönetimi

- [ ] **list-windows** — Açık pencereleri listele. X11: `wmctrl -l`. Wayland: compositor'a bağlı (`swaymsg -t get_tree`, `hyprctl clients`).
- [ ] **focus-window** — Pencereyi öne getir. `wmctrl -a "title"` veya `wmctrl -i -a "0xWINDOWID"`.
- [ ] **minimize / maximize / restore / close** — `wmctrl -i -r ID -b add,maximized_vert,maximized_horz`, `wmctrl -c "title"`.
- [ ] **move-resize** — `wmctrl -r "title" -e gravity,x,y,w,h`.
- [ ] **virtual-desktop** — Sanal masaüstü değiştir. `wmctrl -s N`. GNOME: `wmctrl` sınırlı, Shell extension daha güvenilir.
- [ ] **virtual-desktop-create** — Yeni workspace.
- [ ] **show-desktop** — Tüm pencereleri minimize. `wmctrl -k on`.
- [ ] **always-on-top** — Pencereyi her zaman üstte tut. `wmctrl -i -r ID -b add,above`.
- [ ] **launch-app** — Uygulama başlat. `gtk-launch app.desktop`, `xdg-open file`, doğrudan binary çalıştır.
- [ ] **kill-app** — Graceful kapat. `wmctrl -c "title"` veya `kill PID` (SIGTERM).
- [ ] **force-quit** — `kill -9 PID` veya `killall -9 process`.
- [ ] **list-desktop-files** — `/usr/share/applications/`, `~/.local/share/applications/` listele.

## 7. Servisler & Process

- [ ] **list-processes** — `ps aux`, `htop` parse.
- [ ] **process-info** — Belirli process'in CPU/RAM/uptime. `ps -p PID -o ...`.
- [ ] **kill-process** — `kill PID` (SIGTERM), `kill -9` (SIGKILL).
- [ ] **suspend-process** — `kill -STOP PID` (donmak, kapatmadan).
- [ ] **resume-process** — `kill -CONT PID`.
- [ ] **process-priority** — `renice -n N -p PID`.
- [ ] **list-services-system** — Sistem servisleri. `systemctl list-units --type=service`.
- [ ] **list-services-user** — Kullanıcı servisleri. `systemctl --user list-units`.
- [ ] **start / stop / restart-service** — `systemctl --user start X`.
- [ ] **service-status** — `systemctl status X`.
- [ ] **enable / disable-service** — Boot otomatik başlatma.
- [ ] **list-timers** — systemd timer'ları (cron benzeri). `systemctl list-timers`.

## 8. Ağ

- [ ] **wifi-toggle** — Wi-Fi adaptörünü aç/kapat. `nmcli radio wifi on/off`.
- [ ] **wifi-connect** — SSID'ye bağlan. `nmcli device wifi connect SSID password PASSWORD`.
- [ ] **wifi-disconnect** — `nmcli device disconnect wlp2s0`.
- [ ] **wifi-scan** — `nmcli device wifi list`.
- [ ] **wifi-saved** — Kayıtlı ağları listele. `nmcli connection show`.
- [ ] **bluetooth-toggle** — `bluetoothctl power on/off` veya `rfkill`.
- [ ] **bluetooth-pair / connect / disconnect** — `bluetoothctl`.
- [ ] **bluetooth-list-devices** — Eşli cihazlar.
- [ ] **vpn-connect / disconnect** — NetworkManager VPN profili. `nmcli connection up id "VPN_NAME"`.
- [ ] **vpn-status** — Aktif VPN bağlantıları.
- [ ] **firewall-toggle** — `sudo ufw enable/disable`.
- [ ] **firewall-rule-add** — `sudo ufw allow PORT`.
- [ ] **proxy-set** — GNOME: `gsettings set org.gnome.system.proxy mode 'manual'`.
- [ ] **ping / traceroute** — Ağ teşhisi.
- [ ] **flush-dns** — `sudo resolvectl flush-caches`.
- [ ] **list-open-ports** — `ss -tlnp`.

## 9. Bildirim & Diyalog

- [ ] **toast** — Bildirim gönder. `notify-send "title" "msg" -i icon`.
- [ ] **toast-with-action** — Tıklanabilir aksiyon ile (D-Bus).
- [ ] **dialog** — Modal diyalog. `zenity --info --text="..."`, `kdialog --msgbox`, `yad`.
- [ ] **input-dialog** — Kullanıcıdan input al. `zenity --entry`.
- [ ] **progress-dialog** — İlerleme çubuğu. `zenity --progress`.
- [ ] **tray-icon** — System tray. AppIndicator (Ayatana). DE'ye bağlı (GNOME eklenti gerekir).
- [ ] **dunst-notification** — `dunst` kullanılıyorsa özel kurallarla bildirim.

---

## 10. Görsel Uyarı (Mola asistanı)

- [ ] **fade-screen** — Ekranı yavaşça karart (brightnessctl ile döngü).
- [ ] **grayscale** — Gri filtre. X11: `xrandr --output X --gamma 1:1:1` + custom shader, GNOME Accessibility > Color Filters.
- [ ] **blur-screen** — Bulanıklık (compositor'a bağlı, picom blur, KWin effect).
- [ ] **night-light-force** — Night light zorla aç (`redshift -O 3500K`).
- [ ] **wallpaper-break** — "MOLA" görseliyle değiştir, sonra geri al.
- [ ] **vignette** — Ekran kenarlarına koyu gradyan (overlay).
- [ ] **pulse-brightness** — Parlaklığı nabız gibi titret.
- [ ] **color-temp-shift** — `redshift -O 4500K`.
- [ ] **eye-rest-image** — Tam ekran doğa görseli (overlay window).
- [ ] **invert-colors** — Renk inversiyonu. GNOME: `gsettings set org.gnome.desktop.a11y.magnifier invert-lightness true`.

## 11. Tam Ekran Müdahale (Mola asistanı)

- [ ] **break-overlay** — Tam ekran always-on-top "MOLA ZAMANI" + geri sayım. GTK/Qt tam ekran pencere.
- [ ] **break-curtain** — Yarı saydam siyah perde (compositor şeffaflık desteklerse).
- [ ] **show-desktop** — Win+D benzeri. `wmctrl -k on`.
- [ ] **dim-all-screens** — Tüm bağlı monitörleri karart.
- [ ] **breathing-exercise** — 4-7-8 nefes egzersizi animasyonlu overlay.
- [ ] **stretch-overlay** — Esneme animasyonu/videosu.
- [ ] **eye-exercise** — Hareket eden noktayı takip.
- [ ] **lock-with-message** — `loginctl lock-session` + lock screen mesajı.

## 12. Sesli Uyarı (Mola asistanı)

- [ ] **chime** — `paplay /path/to/chime.wav`.
- [ ] **gradual-volume-up** — Sesi yavaşça yükselt (loop ile pactl).
- [ ] **break-music** — Sakin müzik / nature sound başlat (`mpv`, `paplay` loop).
- [ ] **fade-music-out** — Çalan medyanın sesini yavaşça kıs.
- [ ] **binaural-beats** — Binaural beat dosyası çal.
- [ ] **breathing-audio** — Sesli nefes rehberi (önceden hazır wav).
- [ ] **white-pink-noise** — Beyaz/pembe gürültü dosyası loop.
- [ ] **ambient-sound** — Yağmur / cafe / şömine ses dosyası.
- [ ] **mindfulness-bell** — Periyodik farkındalık çanı (cron / systemd timer + paplay).
- [ ] **say-message** — `espeak "message"`, `piper` ile daha doğal TTS.

## 13. Davranışsal Programlar (Hatırlatıcı döngüler)

- [ ] **focus-cycle-start** — 25/5 odak/mola döngüsü. SKAPP içi timer + notify-send.
- [ ] **20-20-20** — Göz dinlendirme.
- [ ] **stretch-reminder** — Esneme.
- [ ] **water-reminder** — Su iç + sayaç.
- [ ] **stand-up** — Ayağa kalk.
- [ ] **blink-reminder** — Göz kırpma.
- [ ] **posture-reminder** — Duruş.
- [ ] **meal-snack** — Öğün/atıştırma.
- [ ] **medication-reminder** — İlaç.
- [ ] **mindfulness-moment** — Pozitif düşünce.
- [ ] **end-of-day** — Günü kapatma.
- [ ] **journal-prompt** — Gün sonu günlük sorusu.
- [ ] **daily-quote** — Günlük motivasyon.

## 14. Aktivite İzleme (Read-only)

- [ ] **idle-time** — Kaç saniyedir input yok. X11: `xprintidle`. Wayland: `swayidle` veya GNOME `dbus-send` ile `Mutter.IdleMonitor`.
- [ ] **active-time-today** — Bugün toplam aktif süre.
- [ ] **session-duration** — Oturum açıldığından beri geçen süre. `loginctl show-session`.
- [ ] **continuous-work** — Son moladan beri kesintisiz süre.
- [ ] **last-break** — Son mola zamanı + süresi.
- [ ] **typing-intensity** — Tuş basma yoğunluğu (libinput-debug-events parse veya keylogger benzeri — gizlilik dikkat).
- [ ] **break-history** — Bugün verilen mola listesi.
- [ ] **app-usage-stats** — Uygulama bazlı kullanım süresi (active window log + zaman damgası).
- [ ] **distraction-score** — Pencere değiştirme sıklığı.
- [ ] **focus-quality** — Tek pencerede geçen kesintisiz süre.

## 15. Yumuşak Engelleme (Sudo'suz, geri alınabilir)

- [ ] **soft-input-block** — Tam ekran overlay ile pratikte input bloke.
- [ ] **slow-cursor** — Mouse hızını yavaşlat. `xinput set-prop` (X11), libinput config.
- [ ] **hide-cursor** — `unclutter`.
- [ ] **steal-focus** — Aktif pencerenin focus'unu çal (wmctrl periyodik).
- [ ] **disable-keyboard** — `xinput disable` (X11), `ydotool` ile mümkün değil — sadece overlay yöntemi.

## 16. Mola Sonrası Geri Alma (State Restore)

- [ ] **restore-state** — Mola öncesi parlaklık/ses/duvar kağıdı/renk filtresi geri yükle.
- [ ] **welcome-back** — `notify-send "İyi mola, hoş geldin"`.
- [ ] **break-completed** — Mola tamamlandı eventi (log + MQTT publish).
- [ ] **session-reset** — Çalışma sayacını sıfırla.

## 17. Belirli Program Kontrolü (App-spesifik)

- [ ] **launch-app-by-name** — `gtk-launch firefox.desktop` veya doğrudan binary.
- [ ] **launch-app-with-args** — `firefox --new-window https://...`.
- [ ] **close-app-by-name** — Graceful: `wmctrl -c "title"` veya `kill PID`.
- [ ] **close-app-with-save** — Önce `xdotool key ctrl+s` (aktif pencereye), sonra kapat.
- [ ] **restart-app** — Kapat ve yeniden başlat.
- [ ] **focus-app** — `wmctrl -a "title"` veya `xdotool windowactivate`.
- [ ] **minimize-app** — Pencerelerini minimize.
- [ ] **hide-app** — Sistemli olarak unmap (X11: `xdotool windowunmap`).
- [ ] **close-all-instances** — `killall firefox`.
- [ ] **suspend-app** — `kill -STOP PID` (process'i dondur, RAM'de kalır).
- [ ] **resume-app** — `kill -CONT PID`.
- [ ] **send-key-to-app** — `xdotool key --window WINDOWID space` (Spotify'a Space).
- [ ] **per-app-volume** — `pactl set-sink-input-volume INPUT_ID VOLUME` (PipeWire/PA native, çok temiz!).
- [ ] **per-app-mute** — `pactl set-sink-input-mute INPUT_ID toggle`.
- [ ] **wait-for-app** — Uygulama hazır olunca aksiyon yap (polling veya inotify).
- [ ] **is-app-running** — `pgrep -x firefox` (true/false).
- [ ] **app-window-count** — `wmctrl -lp | grep PID | wc -l`.

## 18. Linux/Debian Yerel Özellik Entegrasyonu

- [ ] **systemd-inhibit** — Uyku/idle/lock'ı belirli süre engelle. `systemd-inhibit --what=idle --who=skapp --why="Focus" sleep 1500`.
- [ ] **gnome-shell-extension-trigger** — D-Bus üzerinden GNOME Shell extension komutu çağır.
- [ ] **gnome-activities-toggle** — Activities overview aç/kapat. `dbus-send --session --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'Main.overview.toggle()'`.
- [ ] **kde-krunner-trigger** — KDE KRunner aç (Alt+Space). `qdbus org.kde.krunner /App display`.
- [ ] **launcher-trigger** — Rofi/dmenu/Ulauncher/Albert tetikle.
- [ ] **gsettings-set** — Herhangi bir GNOME ayarını değiştir. `gsettings set SCHEMA KEY VALUE`.
- [ ] **dconf-write** — Düşük seviye dconf değer yaz.
- [ ] **dconf-read** — Mevcut değer oku.
- [ ] **xdg-open** — Dosya/URL'i varsayılan uygulamada aç.
- [ ] **xdg-mime** — MIME tipi varsayılan uygulamasını ayarla.
- [ ] **flatpak-run** — Flatpak app çalıştır. `flatpak run org.mozilla.firefox`.
- [ ] **snap-run** — Snap app çalıştır.
- [ ] **systemd-timer-create** — Cron yerine systemd timer oluştur.
- [ ] **dunstify** — `dunst` kullanıyorsanız özel ID + replace ile bildirim güncelle.

## 19. Linux Power Tools (Linux'un PowerToys ekosistemi)

> Mac'in Hammerspoon/Raycast/Alfred ekosistemi gibi, Linux'un kendi araçları:

- [ ] **autokey-trigger** — AutoKey (Python tabanlı AutoHotkey muadili) script çağır.
- [ ] **espanso-trigger** — Espanso text expander tetikle.
- [ ] **rofi-script** — Rofi'ye custom script bağla.
- [ ] **ulauncher-extension** — Ulauncher extension komutu.
- [ ] **albert-trigger** — Albert komutu.
- [ ] **xbindkeys-reload** — Global hotkey reload.
- [ ] **sxhkd-reload** — sxhkd reload.
- [ ] **conky-update** — Conky widget güncelle.
- [ ] **variety-next** — Variety wallpaper changer'a "next" gönder.
- [ ] **copyq-action** — CopyQ pano yöneticisi action.

## 20. Durum / Presence Senkronizasyonu

- [ ] **teams-status** — Microsoft Teams durumu (Available/Busy/Away/DND/BRB).
- [ ] **teams-status-message** — Durum mesajı.
- [ ] **slack-status** — Slack durumu + emoji + süre.
- [ ] **discord-presence** — Discord durumu (Linux client).
- [ ] **discord-mute-toggle** — Ses/mikrofon.
- [ ] **zoom-mute-toggle** — Zoom mikrofon (Alt+A).
- [ ] **zoom-camera-toggle** — Zoom kamera.
- [ ] **meet-mute-toggle** — Google Meet mikrofon.
- [ ] **set-status-everywhere** — Tek komutla tüm chat uygulamalarında "molada".
- [ ] **mpris-status-publish** — `playerctl status` → "şu an müzik/video çalıyor mu" yayını.

## 21. Görsel Kişiselleştirme (Mola sinyali)

- [ ] **gtk-theme-switch** — GTK temasını geçici değiştir.
- [ ] **icon-theme-switch** — İkon temasını değiştir.
- [ ] **cursor-theme** — Cursor temasını değiştir. `gsettings set org.gnome.desktop.interface cursor-theme`.
- [ ] **cursor-size** — Cursor boyutu.
- [ ] **accent-color** — Accent color (yeni GNOME / KDE).
- [ ] **dynamic-wallpaper** — Saate göre değişen wallpaper (hazır araçlar: `dynamic-wallpaper`).
- [ ] **wallpaper-rotation** — Variety / wallch ile rotasyon.
- [ ] **panel-autohide-toggle** — Panel/taskbar otomatik gizle aç/kapat.

## 22. Akıllı Bağlam Algısı (Linux-spesifik)

- [ ] **meeting-detect** — Process check ile Teams/Zoom/Meet/Webex aktif mi? `pgrep -x zoom`.
- [ ] **fullscreen-app-detect** — Aktif pencere tam ekran mı? (X11: `_NET_WM_STATE_FULLSCREEN` propertysi).
- [ ] **presentation-mode-detect** — LibreOffice Impress / OBS sahne aktif mi?
- [ ] **playerctl-active** — Şu an medya çalıyor mu? Hangi uygulama?
- [ ] **headphones-connected** — Bluetooth ses cihazı bağlı mı? `bluetoothctl info`, `pactl list sinks`.
- [ ] **bluetooth-devices** — Bağlı tüm Bluetooth cihazları.
- [ ] **active-window-info** — Şu an hangi uygulama / pencere odakta. `xdotool getactivewindow getwindowname`.
- [ ] **active-process-uptime** — Aktif uygulama ne kadar süredir açık.
- [ ] **session-type** — `$XDG_SESSION_TYPE` (x11/wayland/tty).
- [ ] **desktop-environment** — `$XDG_CURRENT_DESKTOP` (GNOME/KDE/XFCE/...).
- [ ] **external-display-connected** — Harici ekran bağlı mı? `xrandr | grep " connected"`.
- [ ] **ac-power-connected** — Fişte mi? `/sys/class/power_supply/AC/online`.
- [ ] **night-light-active** — Night light açık mı?
- [ ] **dnd-active** — Do Not Disturb açık mı? GNOME: `gsettings get org.gnome.desktop.notifications show-banners`.

## 23. Mola Öncesi Veri Koruması (Otomatik kayıt)

- [ ] **save-active-window** — Aktif pencereye Ctrl+S gönder. `xdotool key ctrl+s`.
- [ ] **save-all-open** — Tüm açık pencerelere sırayla Ctrl+S.
- [ ] **pin-current-window** — Always-on-top yap. `wmctrl -i -r ID -b add,above`.
- [ ] **snapshot-windows** — Açık pencerelerin listesini ve konumunu sakla. `wmctrl -lG > snapshot.txt`.
- [ ] **restore-windows-snapshot** — Pencereleri eski yerlerine koy.
- [ ] **timeshift-snapshot** — Timeshift snapshot oluştur (sistem yedek).
- [ ] **deja-dup-trigger** — Déjà Dup yedekleme tetikle.
- [ ] **rsync-trigger** — Önceden tanımlı rsync senaryosu çalıştır.
- [ ] **autosave-trigger** — Auto-save destekli uygulamalarda kaydı zorla.

## 24. Koşullu Mantık (If / Then — SKAPP action chain motoru için)

> Read-only sorgu endpoint'leri. SKAPP if/else zincirleri için kullanır.

### Pencere / Uygulama
- [ ] **if-app-running** — Belirli uygulama açık mı? (`pgrep`).
- [ ] **if-window-active** — Aktif pencere kalıbına uyuyor mu?
- [ ] **if-process-cpu-greater-than** — Process CPU > X%?
- [ ] **if-process-memory-greater-than** — Process RAM > X MB?

### Kullanıcı durumu
- [ ] **if-idle-greater-than** — X saniyedir hareketsiz mi?
- [ ] **if-active-time-greater-than** — Bugün X dakikadan fazla aktif?
- [ ] **if-continuous-work-greater-than** — Son moladan beri X dakika geçti mi?

### Sistem
- [ ] **if-volume-greater-than** — Ana ses > X?
- [ ] **if-volume-muted** — Ses kapalı mı?
- [ ] **if-battery-less-than** — Şarj < %X?
- [ ] **if-on-battery** — Fişten çekik mi?
- [ ] **if-monitor-on** — Monitör açık mı?
- [ ] **if-cpu-temp-greater-than** — CPU sıcaklık > X°C?
- [ ] **if-disk-free-less-than** — Disk boş alan < X GB?

### Bağlam
- [ ] **if-meeting-active** — Aktif toplantı var mı? (process check)
- [ ] **if-fullscreen-app** — Tam ekran uygulama açık mı?
- [ ] **if-headphones-connected** — Kulaklık bağlı mı?
- [ ] **if-vpn-connected** — VPN açık mı?
- [ ] **if-external-display** — Harici ekran bağlı mı?
- [ ] **if-night-light-active** — Night light açık mı?
- [ ] **if-dnd-active** — DND aktif mi?

### Oturum
- [ ] **if-session-type** — X11 mi Wayland mı?
- [ ] **if-desktop-environment** — GNOME / KDE / XFCE / ...?
- [ ] **if-distro** — Debian / Ubuntu / Mint / ...?

### Zaman / takvim
- [ ] **if-time-between** — Saat X-Y arasında mı?
- [ ] **if-day-of-week** — Hafta içi/sonu?
- [ ] **if-uptime-greater-than** — Sistem X dakikadır açık mı?

### Birleşik mantık (SKAPP tarafında)
- AND / OR / NOT
- else dalı
- wait (bekle, sonra devam)
- stop-chain (kalan aksiyonları iptal)
- goto-action (zincirde başka adıma atla)

---

## 25. Linux'a Özgü Eğlenceli / Ekstra Özellikler

- [ ] **figlet-message** — ASCII art mesaj (terminal'e veya overlay'e).
- [ ] **caps-num-scroll-led** — Klavye LED'lerini kontrol et (sessiz görsel sinyal). `xset led named "Scroll Lock"`.
- [ ] **terminal-bell** — `echo -e "\a"` veya `paplay /usr/share/sounds/freedesktop/stereo/bell.oga`.
- [ ] **journal-message** — `journalctl`'e log düş (`logger "skapp: mola başladı"`).
- [ ] **shell-script-exec** — Önceden tanımlı/onaylı bash scripti çalıştır (kullanıcı yazdığı kendi otomasyonları).
- [ ] **systemctl-trigger** — Kullanıcı kendi systemd unit'ini start eder (extreme power user).
- [ ] **conky-message** — Conky widget'a mesaj.
- [ ] **kdialog-passive-popup** — KDE pasif popup (geçici, üst sağda).
- [ ] **lightspeed-banner** — Tam ekran üst banner (top-bar overlay).

## 26. Smart Home / IoT Hooks (Linux-spesifik)

- [ ] **mqtt-publish** — MQTT broker'a publish (mosquitto-clients: `mosquitto_pub`).
- [ ] **mqtt-subscribe** — Topic dinle, gelen mesajla aksiyon tetikle.
- [ ] **work-state-publish** — `active / idle / on-break` durumu MQTT yayını.
- [ ] **homeassistant-trigger** — HA REST API'sine direkt POST (yerel ağda).
- [ ] **node-red-webhook** — Node-RED HTTP-in node'una tetikleyici gönder.
- [ ] **zigbee2mqtt-trigger** — z2m ile cihaz tetikle.

## 27. Erişilebilirlik (a11y)

- [ ] **screen-reader-toggle** — Orca ekran okuyucu aç/kapat.
- [ ] **zoom-toggle** — Magnifier zoom. GNOME: `gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled true`.
- [ ] **invert-colors** — Renk inversiyonu.
- [ ] **color-filter** — Color filter tipi (grayscale, etc.).
- [ ] **reduce-motion** — Hareket azaltma. `gsettings set org.gnome.desktop.interface enable-animations false`.
- [ ] **high-contrast** — Yüksek kontrast tema.
- [ ] **mouse-pointer-shake-find** — Cursor sallayınca büyüt (GNOME ayarı).
- [ ] **typing-feedback** — Tuş bastıkça sesli okuma.
- [ ] **sticky-keys** — Sticky keys aç/kapat.
- [ ] **slow-keys** — Slow keys.

---

## API Tasarım Notları (her endpoint için ortak — architecture.md ile uyumlu)

- **Auth:** Token tabanlı (Bearer). Whitelist IP opsiyonu.
- **Transport:** HTTP REST + opsiyonel MQTT publisher.
- **Servis:** SKAPP Desktop içine gömülü (ek install yok). Kullanıcı oturumunda çalışır. Autostart için `~/.config/autostart/skapp.desktop` veya `systemctl --user enable`.
- **Yetki:**
  - **sudo gerektirmemeli** — kullanıcı oturumunda çalışsın.
  - Bazı işlemler için kullanıcının özel grupta olması gerekir (`video` for brightness, `input` for ydotool).
  - Wayland için `ydotoold` daemon gerekir (kullanıcı seviyesi).
- **Logging:** Her isteği `journalctl --user -u skapp` ile loglanır.
- **Rate limit:** Endpoint başına saniyede X istek.
- **Health check:** `/api/health`, `/api/version`.
- **Discovery:** mDNS (`_skapp._tcp.local`) — `avahi-daemon` çalışıyor olmalı (Debian'da varsayılan).

---

## Debian Tabanlı Sistemlerin Win/Mac'ten Önemli Farkları

| Konu | Windows | macOS | Debian Linux |
|---|---|---|---|
| Otomasyon dili | PowerShell, COM | AppleScript, Shortcuts | bash + `xdotool/wmctrl/gsettings/dbus-send` |
| Servis sistemi | Services / Task Scheduler | launchd | **systemd** (system + user) |
| Paket yönetimi | MSI / EXE | DMG / Homebrew | **apt / dpkg** (+ snap, flatpak, AppImage) |
| Yetki modeli | UAC | TCC (Privacy) | sudo + groups + polkit |
| Sanal masaüstleri | Virtual Desktops | Spaces | Workspaces (DE'ye bağlı) |
| Display server | DWM | Quartz | **X11 ↔ Wayland** (sürüme bağlı) |
| Ses katmanı | WASAPI | CoreAudio | **PulseAudio / PipeWire** |
| Bildirim | Toast | NotificationCenter | libnotify / dunst |
| Tray | Native | Menu bar | DE'ye bağlı (GNOME → eklenti gerekir) |
| TTS | SAPI | `say` (mükemmel) | `espeak`, `festival`, **`piper`** (modern, kaliteli) |
| Per-app volume | Mixer | 3. parti gerekir | **PA/PW yerel** (en güçlü, native) |
| Smart home | — | HomeKit | MQTT + Home Assistant + ESPHome (yerel) |
| Yedekleme | File History | Time Machine | Timeshift / Déjà Dup / rsync |

---

## Debian Ailesinin Güçlü Yanları (SKAPI için)

1. **Systemd timer'lar** — cron'dan daha güçlü, periyodik mola hatırlatıcıları için ideal
2. **PipeWire/PulseAudio per-app ses kontrolü** — Mac'te 3. parti gerek, Linux'ta yerel
3. **MPRIS via playerctl** — tüm medya oynatıcıları (Spotify, VLC, Firefox, mpv) tek API
4. **D-Bus** — sistem ve kullanıcı arası iletişim için zengin API
5. **gsettings/dconf** — herhangi bir GNOME ayarı script'lenebilir
6. **systemd-inhibit** — uyku/idle/lock'ı zarif şekilde engelle
7. **MQTT/Home Assistant entegrasyonu** — Linux ev sunucularıyla doğal uyum
8. **Açık kaynak araç çeşitliliği** — autokey, espanso, dunst, rofi gibi kombinable parçalar

## Debian Ailesinin Zayıf Yanları (SKAPI için dikkat)

1. **X11 vs Wayland fragmentasyonu** — her komutu iki şekilde yazmak gerekiyor
2. **Tray ikonu desteği DE'ye bağlı** — özellikle GNOME'da eklenti gerekir
3. **Pencere yönetimi Wayland'da kısıtlı** — compositor'a bağımlı
4. **Bazı komutlar grup üyeliği gerektirir** (`video`, `input`)
5. **Bildirim D-Bus aktif olmayan ortamda çalışmaz** (TTY oturumu)

---

## Sonraki Adım

Bu listeyi onayladıktan sonra her madde için ayrı bir `.md` dosyası açılacak. Önerilen başlama sırası (Debian/Ubuntu için):

1. `power-shutdown.md` — `systemctl poweroff`
2. `volume.md` — `pactl/wpctl`, basit
3. `brightness.md` — `brightnessctl`
4. `notification-toast.md` — `notify-send`
5. `tts.md` — `piper` veya `espeak`
6. `playerctl-media.md` — MPRIS, çoklu player desteği (Linux'un hidden gem'i)
7. `systemd-inhibit.md` — uyku engelleme (focus session için)
8. `gsettings-dark-mode.md` — tema değişimi

Devamı senin önceliğine göre.
