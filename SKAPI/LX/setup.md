# Linux Kurulumu

Bu rehber, Linux bilgisayarınızı **SKAPP** ile kontrol edilebilir hale getirmek için adımları anlatır.

> **Önemli:** Ekstra bir program yüklemenize gerek yok. SKAPP Desktop'ı kurduğunuzda, içindeki API sunucusu otomatik olarak çalışmaya başlar.

---

## 1. SKAPP Desktop'ı İndir ve Kur

Linux için 3 dağıtım formatı sunulur:

### a) Debian / Ubuntu / Mint (.deb)
```bash
sudo dpkg -i SKAPP_x.y.z_amd64.deb
sudo apt-get install -f   # bağımlılıkları tamamla
```

### b) Fedora / RHEL / openSUSE (.rpm)
```bash
sudo rpm -i SKAPP-x.y.z.x86_64.rpm
# veya
sudo dnf install ./SKAPP-x.y.z.x86_64.rpm
```

### c) AppImage (tüm dağıtımlar)
```bash
chmod +x SKAPP-x.y.z.AppImage
./SKAPP-x.y.z.AppImage
```

### d) Flatpak (yakında)
```bash
flatpak install flathub com.smartkraft.SKAPP
```

---

## 2. Bağımlılıklar

SKAPP'in çalışması için gereken sistem paketleri:

### Debian / Ubuntu
```bash
sudo apt install libayatana-appindicator3-1 libnotify4 libsecret-1-0
```

### Fedora
```bash
sudo dnf install libayatana-appindicator-gtk3 libnotify libsecret
```

### Aksiyon-spesifik araçlar (opsiyonel)
İhtiyacınız olan aksiyona göre:

| Aksiyon | Gerekli paket |
|---|---|
| Sesi kontrol et | `pulseaudio-utils` veya `pipewire` |
| Parlaklık ayarla | `brightnessctl` veya `light` |
| Bildirim göster | `libnotify` (`notify-send`) |
| Ekran kilitle | `xdg-screensaver` veya `loginctl` |
| Pencere yönetimi | `wmctrl` (X11) veya `wlr-randr` (Wayland) |

SKAPP, ihtiyaç duyduğu paket eksikse hangi paketi yüklemeniz gerektiğini söyler.

---

## 3. İlk Açılış Sihirbazı

### a) Cihaz İsmi
```
Örnek: "Cem'in masaüstü Linux"
       "Sunucu — odam"
       "Pop!_OS Laptop"
```

### b) API Sunucu Portu
Varsayılan: **5000**

### c) API Token
Otomatik üretilir. ESP32'ye yüklerken kullanacaksınız.

> **Önemli:** Token'ı kimseyle paylaşmayın.

---

## 4. Otomatik Başlangıç (systemd user service)

SKAPP'i her oturum açılışında otomatik başlatmak için iki yol:

### a) GUI ile (kolay)
SKAPP ilk açılışta "Login'de otomatik başlasın mı?" diye sorar → **Evet** deyin.
Bu, masaüstü ortamınızın **Autostart** mekanizmasını kullanır:
- GNOME / KDE / XFCE: `~/.config/autostart/skapp.desktop` oluşturulur

### b) systemd user service ile (sağlam)
Daha güvenilir bir yöntem:

```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/skapp.service
```

İçerik:
```ini
[Unit]
Description=SKAPP Desktop API Server
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/skapp --tray
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

Etkinleştir:
```bash
systemctl --user daemon-reload
systemctl --user enable --now skapp.service
```

Durumu kontrol:
```bash
systemctl --user status skapp.service
```

---

## 5. Tray İkonu

SKAPP, masaüstü ortamına göre tray (system indicator) alanına yerleşir:

```
🟢 Yeşil ikon  → API sunucusu çalışıyor
🔴 Kırmızı ikon → Sunucu durduruldu
🟡 Sarı ikon   → Bağlantı sorunu
```

**Tray menüsü:**
- **SKAPP'i Aç** → ana arayüz
- **Sunucuyu Duraklat / Başlat**
- **Ayarlar**
- **Çıkış**

### Masaüstü ortamına göre tray desteği

| DE | Tray desteği | Notlar |
|---|---|---|
| KDE Plasma | ✅ Yerel | Sorunsuz |
| Cinnamon | ✅ Yerel | Sorunsuz |
| XFCE | ✅ Yerel | Sorunsuz |
| Mate | ✅ Yerel | Sorunsuz |
| **GNOME** | ⚠️ Eklenti gerekir | `AppIndicator and KStatusNotifierItem Support` eklentisi |
| Sway / Hyprland | ⚠️ Waybar config | Status modülü gerekir |

GNOME için:
```bash
# extensions.gnome.org sitesinden "AppIndicator Support" eklentisini yükleyin
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
```

---

## 6. Firewall

### UFW (Ubuntu, Mint, vb.)
```bash
sudo ufw allow from 192.168.0.0/16 to any port 5000
```

### firewalld (Fedora, RHEL)
```bash
sudo firewall-cmd --permanent --add-port=5000/tcp --zone=home
sudo firewall-cmd --reload
```

### iptables (manuel)
```bash
sudo iptables -A INPUT -p tcp --dport 5000 -s 192.168.0.0/16 -j ACCEPT
```

> **Not:** Sadece **yerel ağdan** (192.168.x.x veya 10.x.x.x) gelen istekleri kabul ettiğinizden emin olun. Internet'e açmayın.

---

## 7. Çalışıp Çalışmadığını Test Etme

```bash
curl http://localhost:5000/api/health
```

Görmeniz gereken cevap:
```json
{
  "status": "ok",
  "device_id": "7f3a-9b21-4c08-...",
  "name": "Cem'in masaüstü Linux",
  "version": "1.0.0"
}
```

Bu cevabı görüyorsanız → **API çalışıyor.**

---

## 8. ESP32 Cihazınızı Bağlama

1. SKAPP'tan ESP32 cihazınızı eşleştirin
2. Yeni aksiyon oluştururken **"Hedef Cihaz"** dropdown'ından Linux makinenizi seçin
   - mDNS sayesinde otomatik görünür (`avahi-daemon` çalışıyor olmalı)
3. Şablon kütüphanesinden aksiyon seçin
4. ESP32'ye yükle

### Avahi (mDNS) çalışıyor mu kontrol
```bash
systemctl status avahi-daemon
# çalışmıyorsa:
sudo systemctl enable --now avahi-daemon
```

---

## 9. X11 vs Wayland Notları

Bazı aksiyonlar oturum tipinize göre farklı çalışır:

| Aksiyon | X11 | Wayland |
|---|---|---|
| Pencere yönetimi | `wmctrl` | Sınırlı (compositor'a bağlı) |
| Klavye/mouse simülasyonu | `xdotool` | `ydotool` veya `wtype` |
| Ekran görüntüsü | `scrot`, `maim` | `grim` |
| Mola overlay | Tam ekran X pencere | Layer-shell protocol |

SKAPP, oturum tipinizi otomatik tespit eder ve uygun aracı kullanır. Eksik araç varsa kurulum komutunu önerir.

Oturum tipinizi öğrenmek için:
```bash
echo $XDG_SESSION_TYPE
```

---

## 10. Sorun Giderme

### "Linux makinem ESP32'ye görünmüyor"
- `avahi-daemon` çalışıyor mu? `systemctl status avahi-daemon`
- Firewall portu açık mı?
- Aynı Wi-Fi ağında mı?

### "Port 5000 kullanılıyor" hatası
```bash
# Hangi process kullanıyor:
sudo ss -tlnp | grep 5000
# veya
sudo lsof -i :5000
```
SKAPP Settings'ten farklı port seçin.

### "Tray ikonu görünmüyor"
- GNOME kullanıyorsanız → AppIndicator eklentisi yüklü ve aktif mi?
- KDE/Plasma → "Gizli simgeler" panelinde olabilir, açık görünür yapın

### "Sesi kıs çalışmıyor"
PulseAudio/PipeWire yüklü mü?
```bash
which pactl
```
Yoksa: `sudo apt install pulseaudio-utils` veya `pipewire-pulse`

### "Parlaklık değişmiyor"
```bash
which brightnessctl
```
Yoksa: `sudo apt install brightnessctl`

Bazı dağıtımlarda `brightnessctl`'ın çalışması için kullanıcı `video` grubunda olmalı:
```bash
sudo usermod -a -G video $USER
# çıkış-giriş yapın
```

### systemd service başlamıyor
```bash
journalctl --user -u skapp.service -f
```
Hata mesajına göre düzeltin.

---

## 11. Güvenlik Önerileri

- ✅ Token'ı periyodik olarak yenileyin (Settings → Yeni Token Üret)
- ✅ Firewall kuralı sadece yerel ağdan gelen istekleri kabul etsin
- ✅ Misafir Wi-Fi'sinde SKAPP'i `systemctl --user stop skapp` ile durdurun
- ❌ Token'ı paylaşmayın
- ❌ Portu router'da internete açmayın
- ❌ SKAPP'i `root` olarak çalıştırmayın — kullanıcı oturumunda yeterli

---

## 12. Sonraki Adım

Linux makineniz artık SKAPI komutlarını dinliyor. Şimdi:

1. ESP32 cihazınızı eşleştirin (henüz yapmadıysanız)
2. SKAPP içinden bir aksiyon şablonu seçin
3. ESP32'ye yükleyin

Linux için kullanılabilir aksiyonların listesi: `start.md` (yakında)
