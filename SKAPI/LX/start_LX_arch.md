# SKAPI — Linux (Arch Tabanlı) API Kontrol Listesi

Bu dosya, **Arch tabanlı** Linux dağıtımlarında (Arch, Manjaro, EndeavourOS, Garuda, CachyOS, Artix) **API üzerinden uzaktan kontrol edilebilecek** tüm aksiyonların indeksidir.

> Her madde, ileride kendi `.md` dosyasında detaylandırılacak.
> Format her dosyada aynı olacak: **Ne yapar / Endpoint örneği / Kullanılan komut veya API / Gereken paket / WM/DE notu / Örnek istek-cevap / Güvenlik notları**.
>
> Genel araçlar: `systemctl`, `loginctl`, `wpctl/pactl`, `nmcli`, `xdotool/ydotool`, `wmctrl`/`hyprctl`/`swaymsg`/`i3-msg`/`bspc`, `notify-send`, `playerctl`, `gsettings/dconf`, `xdg-*`.

---

## 0. Arch Ekosistemi — Genel Notlar

### Paket yönetimi
- Resmi: `pacman -S paket`
- AUR (Arch User Repository): `yay -S paket` veya `paru -S paket`
- Manjaro'da: `pamac install paket` (GUI/CLI), AUR opsiyonel etkinleşir
- AUR sayesinde **neredeyse her açık kaynak yazılım yüklenebilir** — SKAPI için büyük avantaj

### Rolling release
- LTS yok, sürekli güncelleme
- Yeni kernel, yeni sistem araçları (PipeWire varsayılan, Wayland yaygın)
- SKAPI: en yeni API'leri kullanabilir, eski uyumluluğa takılmaz

### Init sistemi
- Çoğu dağıtım: **systemd** (varsayılan)
- **Artix** istisna: openrc, runit, s6, dinit — `systemctl` yerine bu init'in komutları
- SKAPI servisi systemd-only başlangıçta kabul edilebilir, Artix için sonradan eklenir

### Display server
- Wayland adoption Debian'dan **çok daha yüksek**
- Hyprland (popüler), Sway, GNOME Wayland, KDE Wayland yaygın
- X11 hâlâ destekleniyor ama tiling WM çoğunluğu Wayland'a kaydı

---

## 1. Pencere Yöneticisi / Masaüstü Ortamı Tespiti — Arch'ın Özel Durumu

Arch kullanıcılarının önemli kısmı **tiling WM** kullanır. Bu, SKAPI için **avantaj**: tiling WM'lerin **zengin IPC (Inter-Process Communication)** API'si vardır — GNOME/KDE'den çok daha güçlü programmatik kontrol.

| WM / DE | IPC Aracı | Komut örneği |
|---|---|---|
| **Hyprland** (Wayland) | `hyprctl` | `hyprctl dispatch togglefloating` |
| **Sway** (Wayland, i3 uyumlu) | `swaymsg` | `swaymsg "workspace 2"` |
| **i3** (X11) | `i3-msg` | `i3-msg "workspace 3"` |
| **bspwm** (X11) | `bspc` | `bspc desktop -f next` |
| **dwm** (X11) | `dwm-msg` (patch ile) | sınırlı |
| **awesome** (X11) | `awesome-client` | Lua kod gönder |
| **Qtile** (her ikisi) | `qtile cmd-obj` | Python tabanlı IPC |
| **Hyprland'ın IPC socket'i** | `hyprctl -j` (JSON) | scripting için ideal |
| **GNOME** | D-Bus + Shell extension | `dbus-send` |
| **KDE Plasma** | `qdbus`, `kquitapp5` | KWin scripting |
| **XFCE** | `wmctrl`, `xdotool` | klasik X11 |

> **SKAPI ilk açılışta** `$XDG_CURRENT_DESKTOP` ve `$XDG_SESSION_TYPE` ile WM'i tespit edip uygun adapter'ı yükler.

---

## 2. Güç Yönetimi (Power)

- [ ] **shutdown** — `systemctl poweroff` (Artix: `loginctl poweroff` veya init'e özel).
- [ ] **restart** — `systemctl reboot`.
- [ ] **sleep** — `systemctl suspend`.
- [ ] **hibernate** — `systemctl hibernate` (swap partition gerekli).
- [ ] **hybrid-sleep** — `systemctl hybrid-sleep`.
- [ ] **logoff** — `loginctl terminate-session $XDG_SESSION_ID`.
- [ ] **lock** — `loginctl lock-session`.
- [ ] **abort-shutdown** — `shutdown -c`.
- [ ] **wake-on-lan** — `wol` veya `wakeonlan` paketi (AUR/repo).
- [ ] **inhibit-sleep** — `systemd-inhibit --what=idle --who=skapp --why="Focus" sleep N`.
- [ ] **release-inhibit** — Inhibit lock'u kaldır.
- [ ] **power-profile** — `powerprofilesctl set performance|balanced|power-saver` veya `tlp` veya `auto-cpufreq`.
- [ ] **battery-info** — `upower -i $(upower -e | grep BAT)` veya `acpi -b`.
- [ ] **cpu-governor** — CPU governor değiştir. `cpupower frequency-set -g performance`.

## 3. Sistem Bilgisi & İzleme

- [ ] **uptime** — `uptime`.
- [ ] **system-info** — `hostnamectl`, `uname -a`, `/etc/os-release`.
- [ ] **cpu-usage** — `mpstat`, `/proc/stat`.
- [ ] **cpu-temp** — `sensors` (`lm_sensors` paketi). Apple Silicon kart? `iio-sensor-proxy`.
- [ ] **ram-usage** — `free -h`.
- [ ] **swap-usage** — `swapon --show`.
- [ ] **disk-usage** — `df -h`, `btrfs filesystem usage` (BTRFS için).
- [ ] **gpu-info** — NVIDIA: `nvidia-smi`, AMD: `radeontop`, Intel: `intel_gpu_top`.
- [ ] **network-info** — `ip addr`, `nmcli` veya `iwd` kullanılıyorsa `iwctl`.
- [ ] **logged-users** — `who`, `loginctl list-sessions`.
- [ ] **distro-info** — `/etc/os-release` parse — Arch / Manjaro / EndeavourOS / Garuda ayrımı.
- [ ] **kernel-version** — `uname -r` (Arch'ta sık değişir, rolling).
- [ ] **package-count** — `pacman -Q | wc -l` (resmi), `pacman -Qm | wc -l` (AUR).
- [ ] **updates-available** — `checkupdates` (resmi), `yay -Qua` (AUR).
- [ ] **last-update** — `/var/log/pacman.log` parse, son `pacman -Syu` zamanı.
- [ ] **journal-tail** — `journalctl` son N satır.
- [ ] **service-failures** — `systemctl --failed`.

## 4. Ekran & Görüntü

- [ ] **brightness** — `brightnessctl set 50%` (kernel sysfs). External için `ddcutil setvcp 10 50`.
- [ ] **monitor-off / on** — X11: `xset dpms force off`. Wayland: `wlr-randr --output X --off`. Hyprland: `hyprctl dispatch dpms off`.
- [ ] **resolution** — X11: `xrandr`. Hyprland: `hyprctl keyword monitor "X,WIDTHxHEIGHT@RATE,POS,SCALE"`. Sway: `swaymsg output ...`.
- [ ] **rotate** — Hyprland: `hyprctl keyword monitor "X,...,transform,1"`. Sway: `swaymsg output X transform 90`.
- [ ] **night-light** — `gammastep` (Wayland önerilen), `redshift`. Hyprland: `hyprsunset` (yeni). GNOME: `gsettings`.
- [ ] **screenshot** — `grim` (Wayland), `scrot/maim` (X11), `flameshot`, `swappy` (annotation).
- [ ] **multi-monitor** — `wlr-randr`, `hyprctl monitors -j`, `xrandr --listmonitors`.
- [ ] **wallpaper-set** — Wayland: `swww`, `hyprpaper`, `wbg`. X11: `feh --bg-fill`. GNOME: `gsettings`.
- [ ] **dark-mode-toggle** — GNOME: `gsettings set org.gnome.desktop.interface color-scheme prefer-dark`. KDE: `lookandfeeltool`. Tiling WM: GTK theme env.
- [ ] **theme-switch** — GTK theme: `gsettings`. Qt theme: `qt5ct`/`qt6ct`. Tiling WM kullanıcısı genelde `pywal` ile dinamik tema.

## 5. Ses

- [ ] **volume-set** — PipeWire (varsayılan): `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.5`. PulseAudio: `pactl set-sink-volume @DEFAULT_SINK@ 50%`.
- [ ] **volume-up / down** — `wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+`.
- [ ] **mute / unmute** — `wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle`.
- [ ] **audio-device** — `wpctl set-default ID`.
- [ ] **input-device** — Aktif mikrofonu değiştir.
- [ ] **mic-mute** — `wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle`.
- [ ] **list-sinks** — `wpctl status` veya `pactl list short sinks`.
- [ ] **list-sources** — Tüm mikrofonlar.
- [ ] **per-app-volume** — `pactl list sink-inputs` + `pactl set-sink-input-volume INPUT_ID 0.5` (PipeWire da `pactl` arayüzünü destekler).
- [ ] **per-app-mute** — Belirli uygulamayı sustur.
- [ ] **play-sound** — `paplay file.wav`, `mpv --no-video file.wav`.
- [ ] **tts** — `espeak-ng`, `piper` (modern, kaliteli — AUR), `mimic3`.
- [ ] **media-key** — `playerctl play-pause/next/previous` (MPRIS).
- [ ] **playerctl-status** — `playerctl metadata --format '{{ artist }} - {{ title }}'`.
- [ ] **easyeffects-preset** — EasyEffects (PipeWire equalizer/compressor) preset değiştir.
- [ ] **noise-suppression-toggle** — `noise-suppression-for-voice` (RNNoise) açma kapama.

## 6. Giriş Simülasyonu (Input)

- [ ] **send-keys** — X11: `xdotool key ctrl+s`. Wayland: `ydotool key`, `wtype`.
- [ ] **send-shortcut** — Kısayol gönder.
- [ ] **type-text** — `xdotool type "..."`, `wtype "..."`.
- [ ] **mouse-move** — `xdotool mousemove`, `ydotool mousemove`.
- [ ] **mouse-click** — `xdotool click 1`, `ydotool click`.
- [ ] **mouse-scroll** — Scroll simüle.
- [ ] **clipboard-get** — X11: `xclip -o -selection clipboard`. Wayland: `wl-paste`.
- [ ] **clipboard-set** — `xclip -selection clipboard`, `wl-copy`.
- [ ] **hide-cursor** — `unclutter` (X11), Hyprland: `hyprctl keyword cursor:hide_on_key_press true`.

> **Wayland notu:** `ydotool` için `ydotoold` daemon ve uinput kernel modülü gerekir. Arch'ta:
> `sudo pacman -S ydotool && sudo systemctl enable --now ydotoold`
> Kullanıcı `input` grubunda olmalı veya udev kuralı yazılmalı.

## 7. Pencere & Uygulama Yönetimi

> Arch'ın gücü burada parlar — tiling WM IPC'leri çok güçlü.

### Hyprland (Wayland, Arch'ta çok popüler)
- [ ] **hypr-list-clients** — `hyprctl clients -j` (JSON, scripting için harika).
- [ ] **hypr-active-window** — `hyprctl activewindow -j`.
- [ ] **hypr-workspace-switch** — `hyprctl dispatch workspace N`.
- [ ] **hypr-move-window** — `hyprctl dispatch movetoworkspace N`.
- [ ] **hypr-toggle-floating** — `hyprctl dispatch togglefloating`.
- [ ] **hypr-fullscreen** — `hyprctl dispatch fullscreen`.
- [ ] **hypr-special-workspace** — Scratchpad benzeri özel workspace.
- [ ] **hypr-set-window-rule** — Çalışma anında window rule ekle.

### Sway (Wayland, i3 uyumlu)
- [ ] **sway-tree** — `swaymsg -t get_tree -p`.
- [ ] **sway-workspace** — `swaymsg "workspace N"`.
- [ ] **sway-focus-by-criteria** — `swaymsg '[app_id="firefox"] focus'`.

### i3 (X11)
- [ ] **i3-msg** — `i3-msg "workspace N"`.
- [ ] **i3-tree** — `i3-msg -t get_tree`.

### bspwm (X11)
- [ ] **bspc-desktop** — `bspc desktop -f next`.
- [ ] **bspc-node** — `bspc node -t floating`.

### Genel (her WM)
- [ ] **list-windows** — WM'e göre adapter (Hyprland/Sway/i3/wmctrl).
- [ ] **focus-window** — Pencere öne getir.
- [ ] **minimize / maximize / restore / close** — Pencere kontrolü.
- [ ] **move-resize** — Pencere konum/boyut.
- [ ] **virtual-desktop** — Workspace değiştir.
- [ ] **always-on-top** — Hyprland: `hyprctl dispatch pin`. Sway: `floating enable`.
- [ ] **launch-app** — Doğrudan binary, `gtk-launch`, `xdg-open`, Hyprland: `hyprctl dispatch exec`.
- [ ] **kill-app** — `wmctrl -c` veya WM'e özel.
- [ ] **force-quit** — `kill -9`, `killall -9`.

## 8. Servisler & Process

- [ ] **list-processes** — `ps aux`, `htop`, `btop`.
- [ ] **process-info** — `ps -p PID -o ...`.
- [ ] **kill-process** — `kill PID`.
- [ ] **suspend-process** — `kill -STOP PID`.
- [ ] **resume-process** — `kill -CONT PID`.
- [ ] **process-priority** — `renice`.
- [ ] **process-cgroup** — Process'i belirli cgroup'a koy (kaynak limit).
- [ ] **list-services-system** — `systemctl list-units --type=service` (Artix: `rc-status`).
- [ ] **list-services-user** — `systemctl --user list-units`.
- [ ] **start / stop / restart-service** — `systemctl --user start X`.
- [ ] **service-status** — `systemctl status X`.
- [ ] **enable / disable-service** — Boot otomatik başlatma.
- [ ] **list-timers** — `systemctl list-timers`.
- [ ] **uwsm-status** — Wayland session manager (Hyprland kullanıcılarında popüler).

## 9. Ağ

- [ ] **wifi-toggle** — `nmcli radio wifi on/off`. iwd kullanıyorsa `iwctl`.
- [ ] **wifi-connect** — `nmcli device wifi connect SSID password PASS`.
- [ ] **wifi-disconnect** — `nmcli device disconnect`.
- [ ] **wifi-scan** — `nmcli device wifi list`.
- [ ] **wifi-saved** — Kayıtlı ağlar.
- [ ] **bluetooth-toggle** — `bluetoothctl power on/off` veya `rfkill`.
- [ ] **bluetooth-pair / connect / disconnect** — `bluetoothctl`.
- [ ] **bluetooth-list-devices** — Eşli cihazlar.
- [ ] **vpn-connect / disconnect** — NetworkManager VPN. Bonus: Wireguard direkt `wg-quick`.
- [ ] **wg-quick-up / down** — Wireguard tüneli aç/kapat.
- [ ] **vpn-status** — Aktif VPN bağlantıları.
- [ ] **firewall-toggle** — `ufw` (yüklüyse) veya `iptables`/`nftables` doğrudan.
- [ ] **firewall-rule-add** — Port izni ekle.
- [ ] **proxy-set** — GNOME: `gsettings`. Tiling WM: env vars.
- [ ] **ping / traceroute** — Ağ teşhisi.
- [ ] **flush-dns** — `sudo resolvectl flush-caches`.
- [ ] **list-open-ports** — `ss -tlnp`.

## 10. Bildirim & Diyalog

- [ ] **toast** — `notify-send "title" "msg"`.
- [ ] **toast-with-action** — D-Bus aksiyonları (notification daemon'a göre).
- [ ] **dialog** — `zenity`, `kdialog`, `yad` (AUR'da rofi-dialog tarzı çözümler).
- [ ] **input-dialog** — `zenity --entry`, `rofi -dmenu`.
- [ ] **rofi-dmenu-prompt** — Rofi ile özel prompt göster (tiling WM'lerde standart).
- [ ] **fuzzel-prompt** — Fuzzel (Wayland-native dmenu) ile prompt.
- [ ] **wofi-prompt** — Wofi (Wayland) launcher.
- [ ] **walker-prompt** — Walker (yeni Wayland launcher).
- [ ] **dunst-notification** — `dunst` özel ID + replace ile bildirim güncelle (Hyprland/Sway/i3 standart).
- [ ] **mako-notification** — `mako` (Wayland notification daemon) ile bildirim.
- [ ] **swaync-notification** — SwayNC notification merkezi.
- [ ] **tray-icon** — Wayland: `waybar` custom module, X11: AppIndicator.

---

## 11. Görsel Uyarı (Mola asistanı)

- [ ] **fade-screen** — Brightness döngüsü.
- [ ] **grayscale** — Hyprland: shader yüklenebilir. GNOME: `gsettings set org.gnome.desktop.a11y.applications screen-magnifier-...`.
- [ ] **blur-screen** — Hyprland yerel blur destekler. picom (X11) blur backend.
- [ ] **night-light-force** — `gammastep -O 3500K` veya `hyprsunset`.
- [ ] **wallpaper-break** — `swww img path/to/break.png`, `hyprpaper`.
- [ ] **vignette** — Tam ekran overlay window.
- [ ] **pulse-brightness** — Brightness döngüsü.
- [ ] **color-temp-shift** — `gammastep -O 4500K`.
- [ ] **eye-rest-image** — Tam ekran image overlay.
- [ ] **invert-colors** — Hyprland: shader ile. GNOME: `gsettings`.

## 12. Tam Ekran Müdahale (Mola asistanı)

- [ ] **break-overlay** — Tam ekran always-on-top "MOLA ZAMANI" overlay penceresi. Hyprland'da `windowrule = float, ...` ile.
- [ ] **break-curtain** — Yarı saydam siyah perde (compositor şeffaflık).
- [ ] **show-desktop** — Hyprland: `hyprctl dispatch togglespecialworkspace`. Sway: scratchpad. i3: `i3-msg`.
- [ ] **dim-all-screens** — Tüm bağlı monitörleri karart.
- [ ] **breathing-exercise** — 4-7-8 nefes egzersizi animasyonlu overlay.
- [ ] **stretch-overlay** — Esneme animasyonu/videosu.
- [ ] **eye-exercise** — Hareket eden noktayı takip.
- [ ] **lock-with-message** — `swaylock`/`hyprlock` + lock screen mesajı.

## 13. Sesli Uyarı (Mola asistanı)

- [ ] **chime** — `paplay /path/to/chime.wav`.
- [ ] **gradual-volume-up** — Sesi yavaşça yükselt.
- [ ] **break-music** — `mpv --no-video --loop file` veya `playerctl` ile mevcut player'a komut.
- [ ] **fade-music-out** — Çalan medyanın sesini yavaşça kıs.
- [ ] **binaural-beats** — Binaural beat dosyası çal.
- [ ] **breathing-audio** — Sesli nefes rehberi.
- [ ] **white-pink-noise** — Beyaz/pembe gürültü loop.
- [ ] **ambient-sound** — Yağmur / cafe / şömine.
- [ ] **mindfulness-bell** — Periyodik çan (systemd timer + paplay).
- [ ] **say-message** — `piper` (kaliteli, modern), `espeak-ng`.

## 14. Davranışsal Programlar (Hatırlatıcı döngüler)

- [ ] **focus-cycle-start** — 25/5 odak/mola döngüsü.
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

## 15. Aktivite İzleme (Read-only)

- [ ] **idle-time** — X11: `xprintidle`. Wayland: Hyprland'ın idle event'leri, Sway: `swayidle`. GNOME: D-Bus.
- [ ] **active-time-today** — Bugün toplam aktif süre.
- [ ] **session-duration** — Login'den beri geçen süre.
- [ ] **continuous-work** — Son moladan beri kesintisiz süre.
- [ ] **last-break** — Son mola zamanı + süresi.
- [ ] **typing-intensity** — Tuş basma yoğunluğu.
- [ ] **break-history** — Bugün verilen mola listesi.
- [ ] **app-usage-stats** — Uygulama bazlı kullanım süresi.
- [ ] **distraction-score** — Pencere değiştirme sıklığı (Hyprland event socket bunu trivial yapar).
- [ ] **focus-quality** — Tek pencerede geçen kesintisiz süre.

## 16. Yumuşak Engelleme (Sudo'suz, geri alınabilir)

- [ ] **soft-input-block** — Tam ekran overlay.
- [ ] **slow-cursor** — `xinput set-prop` (X11), Wayland: compositor-spesifik.
- [ ] **hide-cursor** — `unclutter` (X11), `hyprctl keyword cursor:hide_on_key_press` (Hyprland).
- [ ] **steal-focus** — Aktif pencerenin focus'unu çal.
- [ ] **disable-keyboard** — `xinput disable` (X11). Wayland'da overlay yöntemi.

## 17. Mola Sonrası Geri Alma (State Restore)

- [ ] **restore-state** — Mola öncesi state geri yükle.
- [ ] **welcome-back** — `notify-send "İyi mola, hoş geldin"`.
- [ ] **break-completed** — Mola tamamlandı eventi (log + MQTT publish).
- [ ] **session-reset** — Çalışma sayacını sıfırla.

## 18. Belirli Program Kontrolü (App-spesifik)

- [ ] **launch-app-by-name** — Doğrudan binary, `gtk-launch`, `hyprctl dispatch exec`.
- [ ] **launch-app-with-args** — Argümanla başlat.
- [ ] **close-app-by-name** — `wmctrl -c`, Hyprland: `hyprctl dispatch closewindow`.
- [ ] **close-app-with-save** — Önce Ctrl+S, sonra kapat.
- [ ] **restart-app** — Kapat ve yeniden başlat.
- [ ] **focus-app** — Hyprland: `hyprctl dispatch focuswindow`. Sway: `[app_id="X"] focus`.
- [ ] **minimize-app** — Pencerelerini minimize.
- [ ] **hide-app** — Hyprland: special workspace'e gönder.
- [ ] **close-all-instances** — `killall name`.
- [ ] **suspend-app** — `kill -STOP PID`.
- [ ] **resume-app** — `kill -CONT PID`.
- [ ] **send-key-to-app** — `xdotool key --window WINDOWID space` (X11), Wayland'da daha kısıtlı.
- [ ] **per-app-volume** — `pactl set-sink-input-volume INPUT_ID 0.5` (PipeWire da pactl uyumlu).
- [ ] **per-app-mute** — Belirli uygulamayı sustur.
- [ ] **wait-for-app** — Uygulama hazır olunca aksiyon (polling veya Hyprland event socket).
- [ ] **is-app-running** — `pgrep -x firefox`.
- [ ] **app-window-count** — Uygulamanın açık penceresi.

## 19. Arch / Wayland Yerel Özellik Entegrasyonu

- [ ] **systemd-inhibit** — Uyku/idle/lock geçici engelle.
- [ ] **uwsm-control** — UWSM (Universal Wayland Session Manager) ile session kontrolü.
- [ ] **hyprland-event-socket** — Hyprland'ın event socket'ine bağlan, gerçek zamanlı pencere/workspace event'leri al. **Çok güçlü** — distraction tracking için ideal.
- [ ] **sway-event-subscribe** — Sway IPC event subscribe (`swaymsg -t subscribe`).
- [ ] **i3-event-subscribe** — i3 IPC event subscribe.
- [ ] **dbus-monitor** — D-Bus event'lerini dinle (sistem ölçekli event-driven).
- [ ] **gsettings-set** — Herhangi bir GNOME ayarını değiştir.
- [ ] **dconf-write** — Düşük seviye dconf değer yaz.
- [ ] **kwriteconfig** — KDE config yazma.
- [ ] **xdg-open** — Varsayılan uygulamada aç.
- [ ] **xdg-mime** — MIME tipi varsayılan uygulamasını ayarla.
- [ ] **flatpak-run** — Flatpak app çalıştır.
- [ ] **systemd-timer-create** — Cron yerine systemd timer oluştur.
- [ ] **portal-screenshot** — XDG desktop portal üzerinden screenshot (sandbox-uyumlu).

## 20. Arch Power Tools (AUR'un gücü)

> Arch'ın AUR ekosistemi çok zengin. Kullanıcı yüklemişse SKAPI tetikleyebilir.

- [ ] **rofi-script** — Rofi'ye custom script bağla.
- [ ] **fuzzel-trigger** — Fuzzel launcher tetikle (Wayland).
- [ ] **wofi-trigger** — Wofi launcher tetikle.
- [ ] **walker-trigger** — Walker launcher tetikle.
- [ ] **anyrun-trigger** — Anyrun (Wayland Rust launcher) tetikle.
- [ ] **espanso-trigger** — Espanso text expander.
- [ ] **autokey-trigger** — AutoKey script (X11).
- [ ] **conky-update** — Conky widget güncelle.
- [ ] **eww-widget** — Elkowar's Wacky Widgets (eww) — Hyprland/Sway için zengin widget.
- [ ] **waybar-message** — Waybar custom module mesaj.
- [ ] **polybar-hook** — Polybar IPC hook (X11).
- [ ] **i3blocks-hook** — i3blocks signal.
- [ ] **dunst-pause / resume** — `dunstctl set-paused true` (mola sırasında bildirimleri sustur).
- [ ] **swaync-toggle-dnd** — SwayNC do not disturb modu.
- [ ] **mako-mode** — Mako notification mode değiştir.
- [ ] **copyq-action** — CopyQ pano yöneticisi action.
- [ ] **clipman-action** — Clipman (Wayland clipboard manager).
- [ ] **pywal-update** — Pywal'i yeni resimle çalıştır → tüm uygulamalar yeni renk şeması alır.
- [ ] **wal-trigger** — `wal -i image` ile dinamik tema (Hyprland kullanıcılarında popüler).

## 21. Durum / Presence Senkronizasyonu

- [ ] **teams-status** — Microsoft Teams durumu.
- [ ] **teams-status-message** — Durum mesajı.
- [ ] **slack-status** — Slack durumu + emoji.
- [ ] **discord-presence** — Discord durumu.
- [ ] **discord-mute-toggle** — Ses/mikrofon.
- [ ] **zoom-mute-toggle** — Zoom mikrofon (Alt+A).
- [ ] **zoom-camera-toggle** — Zoom kamera.
- [ ] **meet-mute-toggle** — Google Meet mikrofon.
- [ ] **set-status-everywhere** — Tek komutla tüm chat uygulamalarında "molada".
- [ ] **mpris-status-publish** — `playerctl status` → "şu an müzik/video çalıyor mu" yayını.

## 22. Görsel Kişiselleştirme (Mola sinyali)

- [ ] **gtk-theme-switch** — GTK temasını geçici değiştir.
- [ ] **icon-theme-switch** — İkon teması.
- [ ] **cursor-theme** — Cursor teması.
- [ ] **cursor-size** — Boyut.
- [ ] **accent-color** — Yeni GNOME / KDE.
- [ ] **dynamic-wallpaper** — Saate göre değişen wallpaper.
- [ ] **wallpaper-rotation** — `swww` ile rotasyon.
- [ ] **panel-autohide-toggle** — Panel/taskbar otomatik gizle aç/kapat.
- [ ] **pywal-recolor** — Tüm sistem renklerini bir resimden yeniden hesaplat (Hyprland setup'larının sevgilisi).
- [ ] **hyprland-blur-toggle** — Hyprland blur efekti aç/kapat.
- [ ] **hyprland-animation-speed** — Animasyon hızı değiştir.

## 23. Akıllı Bağlam Algısı (Linux/Arch-spesifik)

- [ ] **meeting-detect** — Process check ile Teams/Zoom/Meet aktif mi?
- [ ] **fullscreen-app-detect** — Hyprland: `hyprctl activewindow -j | jq .fullscreen`.
- [ ] **presentation-mode-detect** — LibreOffice Impress / OBS sahne aktif mi?
- [ ] **playerctl-active** — Şu an medya çalıyor mu?
- [ ] **headphones-connected** — Bluetooth ses cihazı bağlı mı?
- [ ] **bluetooth-devices** — Bağlı tüm Bluetooth cihazları.
- [ ] **active-window-info** — Hyprland: `hyprctl activewindow -j`. Sway: `swaymsg -t get_tree`.
- [ ] **active-process-uptime** — Aktif uygulama uptime.
- [ ] **session-type** — `$XDG_SESSION_TYPE`.
- [ ] **desktop-environment** — `$XDG_CURRENT_DESKTOP`.
- [ ] **wm-detect** — Hyprland / Sway / i3 / bspwm ayrımı (env veya socket varlığı).
- [ ] **distro-info** — Arch / Manjaro / EndeavourOS ayrımı.
- [ ] **external-display-connected** — `hyprctl monitors`, `xrandr | grep " connected"`.
- [ ] **ac-power-connected** — `/sys/class/power_supply/AC/online`.
- [ ] **night-light-active** — Gammastep çalışıyor mu? `pgrep gammastep`.
- [ ] **dnd-active** — Notification daemon DND modunda mı? (`dunstctl is-paused`, `swaync` query, `makoctl mode`).

## 24. Mola Öncesi Veri Koruması (Otomatik kayıt)

- [ ] **save-active-window** — `xdotool key ctrl+s` (X11), `wtype` veya app-spesifik shortcut (Wayland).
- [ ] **save-all-open** — Tüm pencerelere sırayla Ctrl+S.
- [ ] **pin-current-window** — Hyprland: `hyprctl dispatch pin`. Sway: `floating enable`.
- [ ] **snapshot-windows** — Hyprland: `hyprctl clients -j > snapshot.json`.
- [ ] **restore-windows-snapshot** — Pencereleri eski yerlerine koy.
- [ ] **snapper-snapshot** — BTRFS Snapper snapshot oluştur (Garuda/Manjaro'da popüler).
- [ ] **timeshift-snapshot** — Timeshift snapshot.
- [ ] **rsync-trigger** — Önceden tanımlı rsync senaryosu.
- [ ] **autosave-trigger** — Auto-save destekli uygulamalarda kaydı zorla.

## 25. Koşullu Mantık (If / Then — SKAPP action chain motoru için)

> Read-only sorgu endpoint'leri. SKAPP if/else zincirleri için kullanır.

### Pencere / Uygulama
- [ ] **if-app-running** — Belirli uygulama açık mı? (`pgrep`).
- [ ] **if-window-active** — Aktif pencere kalıbına uyuyor mu?
- [ ] **if-process-cpu-greater-than** — Process CPU > X%?
- [ ] **if-process-memory-greater-than** — Process RAM > X MB?
- [ ] **if-fullscreen-app** — Tam ekran uygulama açık mı?
- [ ] **if-workspace-equals** — Hangi workspace'desin? (Hyprland/Sway'de yaygın)

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
- [ ] **if-updates-available** — Güncel paket var mı?

### Bağlam
- [ ] **if-meeting-active** — Aktif toplantı var mı?
- [ ] **if-headphones-connected** — Kulaklık bağlı mı?
- [ ] **if-vpn-connected** — VPN açık mı?
- [ ] **if-external-display** — Harici ekran bağlı mı?
- [ ] **if-night-light-active** — Night light açık mı?
- [ ] **if-dnd-active** — DND aktif mi?

### Oturum / Sistem profili
- [ ] **if-session-type** — X11 mi Wayland mı?
- [ ] **if-wm-equals** — Hyprland / Sway / i3 / bspwm?
- [ ] **if-desktop-environment** — GNOME / KDE / XFCE / ...?
- [ ] **if-distro** — Arch / Manjaro / EndeavourOS / Garuda?
- [ ] **if-kernel-version-greater-than** — Belirli kernel sürümü?

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

## 26. Smart Home / IoT Hooks

- [ ] **mqtt-publish** — `mosquitto_pub` ile MQTT yayını.
- [ ] **mqtt-subscribe** — Topic dinle.
- [ ] **work-state-publish** — `active / idle / on-break` MQTT yayını.
- [ ] **homeassistant-trigger** — HA REST API'sine direkt POST.
- [ ] **node-red-webhook** — Node-RED HTTP-in tetikleyici.
- [ ] **zigbee2mqtt-trigger** — z2m ile cihaz tetikle.
- [ ] **esphome-trigger** — ESPHome cihazına direkt API.

## 27. Erişilebilirlik (a11y)

- [ ] **screen-reader-toggle** — Orca aç/kapat.
- [ ] **zoom-toggle** — Magnifier zoom.
- [ ] **invert-colors** — Renk inversiyonu.
- [ ] **color-filter** — Color filter tipi.
- [ ] **reduce-motion** — Hareket azaltma. Hyprland'da animasyonları kapat.
- [ ] **high-contrast** — Yüksek kontrast tema.
- [ ] **mouse-pointer-find** — Cursor sallayınca büyüt.
- [ ] **typing-feedback** — Tuş bastıkça sesli okuma.
- [ ] **sticky-keys** — Sticky keys.
- [ ] **slow-keys** — Slow keys.

## 28. Arch'a Özgü Eğlenceli / Ekstra Özellikler

- [ ] **figlet-message** — ASCII art mesaj.
- [ ] **caps-num-scroll-led** — Klavye LED kontrolü (sessiz görsel sinyal). `xset led` (X11).
- [ ] **terminal-bell** — `paplay /usr/share/sounds/freedesktop/stereo/bell.oga`.
- [ ] **journal-message** — `logger "skapp: mola başladı"`.
- [ ] **shell-script-exec** — Önceden tanımlı/onaylı bash scripti çalıştır.
- [ ] **hyprland-windowrule-temp** — Geçici window rule ekle (mola süresince).
- [ ] **pywal-flash** — Renk şemasını mola için flash'la, sonra geri al.
- [ ] **rgb-keyboard-color** — RGB klavye rengini değiştir (`OpenRGB` AUR paketi). Mola sırasında klavye kırmızıya dönsün.
- [ ] **rgb-fan-color** — RGB fan/case rengini değiştir.
- [ ] **vrr-toggle** — Variable Refresh Rate (FreeSync/G-Sync) aç/kapat (gaming için).

---

## API Tasarım Notları (her endpoint için ortak — architecture.md ile uyumlu)

- **Auth:** Token tabanlı (Bearer). Whitelist IP opsiyonu.
- **Transport:** HTTP REST + opsiyonel MQTT publisher.
- **Servis:** SKAPP Desktop içine gömülü (ek install yok). Kullanıcı oturumunda çalışır. Autostart için `~/.config/autostart/skapp.desktop` veya `systemctl --user enable`. Hyprland kullanıcıları `exec-once = skapp --tray` ile başlatabilir.
- **Yetki:**
  - **sudo gerektirmemeli** — kullanıcı oturumunda çalışsın.
  - Bazı işlemler grup üyeliği gerektirir (`video` for brightness, `input` for ydotool).
  - Wayland için `ydotoold` daemon kurulumu (kullanıcı seviyesi).
- **Logging:** `journalctl --user -u skapp`.
- **Rate limit:** Endpoint başına saniyede X istek.
- **Health check:** `/api/health`, `/api/version`.
- **Discovery:** mDNS (`_skapp._tcp.local`) — `avahi` paketinden `avahi-daemon` aktif olmalı (`sudo systemctl enable --now avahi-daemon`).

---

## Arch'ın Debian'dan Önemli Farkları (SKAPI için)

| Konu | Debian Tabanlı | Arch Tabanlı |
|---|---|---|
| Paket yöneticisi | `apt`, `dpkg` | **`pacman`, `yay`/`paru`** (AUR) |
| Sürüm modeli | LTS + sabit sürüm | **Rolling release** |
| Wayland adoption | Ubuntu 22.04+ varsayılan, diğerleri X11 | **Çok yüksek** — Hyprland, Sway, GNOME/KDE Wayland yaygın |
| Tiling WM popülaritesi | Düşük | **Çok yüksek** — Hyprland/Sway/i3/bspwm/dwm |
| Ses katmanı | PA → PW geçiş | **PipeWire varsayılan** |
| Init sistemi | systemd | systemd (Artix istisna: openrc/runit/s6) |
| AUR / topluluk paketleri | PPA, OBS | **AUR** — neredeyse her yazılım |
| Kullanıcı profili | Standart kullanıcı | Daha teknik, scripting odaklı |
| Compositor seçenekleri | Az | **Çok** — Hyprland, Sway, river, niri, Mutter, KWin |
| Default tools | Standart | Bleeding edge (`piper` TTS, `swww`, `hyprpaper`, `fuzzel`) |

---

## Arch Ailesinin Güçlü Yanları (SKAPI için)

1. **Hyprland event socket** — gerçek zamanlı pencere/workspace event akışı, distraction tracking için ideal
2. **Tiling WM IPC'leri** — `hyprctl`/`swaymsg`/`i3-msg`/`bspc` programmatik kontrol için Win/Mac'ten **çok daha güçlü**
3. **AUR** — Hammerspoon benzeri her power-user aracı tek komutla yüklenir
4. **PipeWire varsayılan** — modern ses, per-app kontrol native
5. **Pywal entegrasyonu** — dinamik tema sisteminin kalbi
6. **MQTT/Home Assistant** — Linux ev sunucularıyla doğal eşleşme
7. **Rolling release** — yeni API'leri hemen kullanabilir
8. **Daha teknik kullanıcı profili** — "tek tıkla install" gerek yok, CLI-friendly olabilir

## Arch Ailesinin Zayıf Yanları (SKAPI için dikkat)

1. **Fragmentasyon büyük** — WM/DE sayısı çok, her birine adapter yazmak zor
2. **Wayland tooling olgun değil** — bazı işlemler X11'den daha karmaşık
3. **GNOME tray yine sorun** — Wayland'da daha da kötü
4. **Manjaro/EndeavourOS/Garuda farklı varsayılanlar** — test matrisi büyür
5. **Bleeding edge → kırılma riski** — kernel/PipeWire güncellemesi sonrası API değişebilir
6. **Artix systemd-less** — ayrı code path'ı (init agnostik tasarım gerek)

---

## Sonraki Adım

Bu listeyi onayladıktan sonra her madde için ayrı bir `.md` dosyası açılacak. Önerilen başlama sırası (Arch için):

1. `power-shutdown.md` — `systemctl poweroff`
2. `volume.md` — `wpctl` (PipeWire), `pactl` fallback
3. `brightness.md` — `brightnessctl`
4. `notification-toast.md` — `notify-send` (dunst/mako/swaync uyumlu)
5. `tts.md` — `piper` (Arch'ta AUR'dan tek komut)
6. `playerctl-media.md` — MPRIS, çoklu player
7. `systemd-inhibit.md` — uyku engelleme
8. `hypr-event-socket.md` — Hyprland real-time event tracking (Arch'ın hidden gem'i)
9. `wm-adapter.md` — WM detection + adapter pattern (Hyprland/Sway/i3/wmctrl)

Devamı senin önceliğine göre.
