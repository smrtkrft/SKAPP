<div align="center">

# SKAPP

**SmartKraft device configuration app** — device pairing, management, OTA and
SKAPI script automation over BLE / WiFi. 100% P2P: no server, no telemetry,
no account.

[![Latest release](https://img.shields.io/github/v/release/smrtkrft/SKAPP?include_prereleases&label=download)](https://github.com/smrtkrft/SKAPP/releases/latest)
[![License: AGPL v3](https://img.shields.io/badge/license-AGPLv3-blue)](LICENSE)

</div>

> ⚠️ **Public beta / early access.** Some features may be incomplete or
> unstable. Report problems via [Issues](https://github.com/smrtkrft/SKAPP/issues) —
> you can attach your log file from inside the app via **Settings → Diagnostics →
> Share/Copy logs**.

## Download

| Platform | File |
|---|---|
| macOS | [`SKAPP-macos.dmg`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-macos.dmg) |
| Windows | [`SKAPP-windows-setup.exe`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-windows-setup.exe) |
| Linux (AppImage) | [`SKAPP-linux-x86_64.AppImage`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-linux-x86_64.AppImage) |
| Linux (Debian/Ubuntu) | [`SKAPP-linux-amd64.deb`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-linux-amd64.deb) |
| Android | [`SKAPP-android.apk`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-android.apk) |

> iOS is not included in this release. Because the beta builds are unsigned/ad-hoc,
> the operating system may show a warning on first launch — installation
> instructions are in every release note.

## Installation notes (beta)

- **macOS:** Open the DMG and drag the app into Applications. On first launch,
  right-click → **Open** → **Open**. If it gets stuck: `xattr -dr com.apple.quarantine /Applications/skapp.app`
- **Windows:** If SmartScreen appears, **More info → Run anyway**.
- **Linux (AppImage):** `chmod +x SKAPP-linux-x86_64.AppImage && ./SKAPP-linux-x86_64.AppImage`
- **Android:** Allow "install from unknown sources" for your browser/file
  manager, then open the APK.

## License

[GNU AGPL v3](LICENSE). The corresponding source code for each release is the
commit at the same git tag.
