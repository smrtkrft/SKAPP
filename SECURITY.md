# Security Policy

SKAPP is the configuration and control app for SmartKraft IoT devices. We take
security seriously; it gets stronger with the community's help.

## Reporting a vulnerability

If you have discovered a security vulnerability, **please do not open a GitHub
Issue.** Vulnerabilities are handled responsibly through coordinated disclosure:

- **Email:** code@smartkraft.ch
- **Subject line:** `[SECURITY] short summary`
- **Body:** the affected component, reproduction steps, and your assessment of
  the impact severity

### Response commitment

| Timeframe | Action |
|---|---|
| 24 hours | Acknowledgement that the report was received |
| 7 days | Initial analysis, severity assessment |
| 30 days | Remediation plan or release schedule |
| After the fix ships | Coordinated public disclosure (agreed with the reporter) |

## Scope

This security policy covers:

- SKAPP desktop app (Windows, macOS, Linux)
- SKAPP mobile app (iOS, Android)
- SmartKraft ESP32 device firmware (BF, LebensSpur and future devices)
- The SKAPP-to-device communication protocol (BLE, USB CLI, Wi-Fi)
- SKAPP-to-mobile-peer communication (HTTP/TLS, HMAC)

Out of scope:

- Third-party dependencies (please use their own disclosure channels)
- Physical security of your device (user responsibility)
- Social engineering attacks

## Threat model

The current threat model and mitigation layers are documented in
[`achtung.md`](./docs/achtung.md). If you discover a new threat, please report it
via the email above.

## Version support

| Version | Support status |
|---|---|
| Latest major.minor | Active security updates |
| Previous minor | Critical fixes only |
| Older versions | Unsupported, upgrade recommended |

## Hall of Fame

We credit researchers who responsibly report verified critical vulnerabilities
and honor the disclosure window — in the project README and in release notes
(unless you ask to remain anonymous).

Our bug bounty program is not active at this time; it may be considered in the
future.
