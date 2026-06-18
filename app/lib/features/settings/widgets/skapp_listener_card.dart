import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/network/pairing_handshake_provider.dart';
import '../../../core/network/self_signed_cert.dart';
import '../../../core/network/skapp_http_server.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/sk_centered_dialog.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../core/network/skapp_listener_service.dart';
import '../../../core/network/skapp_peer_target.dart';
import '../../../core/system/network_identity_provider.dart';
import '../../../l10n/app_localizations.dart';

/// Body of the SKAPP Listener accordion in Settings → Advanced.
///
/// Outer card wrapper (SkCard + title + chevron) is provided by
/// [_DevCollapsibleCard] in `settings_screen.dart` (2026-05-14 accordion
/// reorganization). This widget renders the running-status row + Switch,
/// the action buttons (QR, rotate cert), and the LAN-visibility toggle.
///
/// Lifecycle:
///   - Mobile / web are gated out at the call site (`hostSkapiPlatformId
///     != null`); this card assumes desktop.
///   - Desktop sees a real start/stop switch driven by
///     `SkappListenerService` and a "Show pairing QR" action that
///     surfaces a sheet with the QR encoded `SkappPairingPayload`.
class SkappListenerCard extends ConsumerStatefulWidget {
  const SkappListenerCard({super.key});

  @override
  ConsumerState<SkappListenerCard> createState() => _SkappListenerCardState();
}

class _SkappListenerCardState extends ConsumerState<SkappListenerCard> {
  String? _error;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final identity = ref.watch(networkIdentityProvider);
    final running = ref.watch(skappHttpServerRunningProvider);
    final server = ref.watch(skappHttpServerProvider);
    final supported = server.supported;
    // Auto-start path (MainShell) is fire-and-forget; if the bind failed
    // its error lands in this provider. Surface it here so the user sees
    // "port 5000 in use" without having to manually toggle the switch.
    final autoStartError = ref.watch(skappListenerLastErrorProvider);

    // Defense-in-depth: Settings ekranı bu kartı zaten
    // `hostSkapiPlatformId() != null` guard'ıyla sarıyor; ama yanlış
    // yerden çağrılırsa mobile'da büyük "unsupported" kartı yerine
    // sessiz boşluk dönsün — Faz B mobile temizlik kuralı.
    if (!supported) return const SizedBox.shrink();

    final subtitle = running
        ? l.skappListenerCardSubtitleRunning(identity.port)
        : l.skappListenerCardSubtitleStopped;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                subtitle,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ),
            SkNeuSwitch(
              value: running,
              onChanged: !supported || _busy ? null : _onToggle,
            ),
          ],
        ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!,
                style: tt.bodySmall?.copyWith(color: cs.error)),
          ] else if (!running && autoStartError != null) ...[
            const SizedBox(height: 8),
            Text(
              _friendlyError(l, autoStartError, identity.port),
              style: tt.bodySmall?.copyWith(color: cs.error),
            ),
          ],
          if (running) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showPairingQr(context, identity),
                  icon: const Icon(Icons.qr_code_2_rounded),
                  label: const Text('QR'),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : () => _confirmRotateCert(identity),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l.skappListenerCardRotateCertButton),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SkColors.warnRed,
                    side: BorderSide(
                      color: SkColors.warnRed.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ],
            ),
            // Surface the current cert fingerprint so power users can
            // sanity-check what mobile would be pinning against.
            if (ref.watch(currentTlsCertProvider) case final cert?) ...[
              const SizedBox(height: 10),
              Text(
                l.skappListenerCardCertFingerprintLabel.toUpperCase(),
                style: tt.labelSmall?.copyWith(
                  letterSpacing: 1.0,
                  color: cs.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                cert.fingerprintHex,
                style: tt.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: cs.onSurface.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
            ],
          ],
          const SizedBox(height: 14),
          // LAN visibility switch — defense-in-depth knob inside Developer mode.
          // Default ON because BF webhooks require LAN reachability. When
          // turned OFF the listener binds to loopback only; we surface the
          // BF-break consequence explicitly. `watchProMode` will flip this
          // back to true if the user disables Developer mode while it was off,
          // so the user can't accidentally leave themselves stranded.
          // V2 tactile: SwitchListTile.adaptive → manuel Row + SkNeuSwitch.
          // Adaptive Material'a göre tasarlandı, tactile zemine yabancı.
          // `_busy` iken onChanged null → SkNeuSwitch otomatik disabled.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l.settingsLanVisibleTitle, style: tt.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        l.settingsLanVisibleSubtitle,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SkNeuSwitch(
                  value: identity.lanVisible,
                  onChanged: _busy ? null : _onToggleLanVisible,
                ),
              ],
            ),
          ),
          if (!identity.lanVisible)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l.settingsLanVisibleWarnBfBreaks,
                style: tt.labelSmall?.copyWith(color: cs.error),
              ),
            ),
        const SizedBox(height: 10),
        Text(
          l.skappListenerCardSecurityNote,
          style: tt.labelSmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.55),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmRotateCert(NetworkIdentity identity) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.skappListenerCardRotateCertConfirmTitle),
        content: Text(l.skappListenerCardRotateCertConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.skappListenerCardRotateCertConfirmCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: SkColors.warnRed),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.skappListenerCardRotateCertConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      // Issue + persist a fresh cert, publish it to the live provider,
      // then bounce the listener so `bindSecure` picks it up. Every
      // previously paired peer will fail TLS on the next request — UI
      // surfaces this through the snackbar so the user knows to re-pair.
      final fresh = await regenerateCert(uuid: identity.uuid);
      ref.read(currentTlsCertProvider.notifier).set(fresh);
      final svc = ref.read(skappListenerServiceProvider);
      await svc.setEnabled(false);
      await svc.setEnabled(true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.skappListenerCardRotateCertDoneSnack, textAlign: TextAlign.center),
      ));
  }

  Future<void> _onToggleLanVisible(bool visible) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(networkIdentityProvider.notifier).setLanVisible(visible);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _onToggle(bool enabled) async {
    final l = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final svc = ref.read(skappListenerServiceProvider);
      await svc.setEnabled(enabled);
    } catch (e) {
      final port = ref.read(networkIdentityProvider).port;
      setState(() => _error = _friendlyError(l, e.toString(), port));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Map a raw exception string to the localized listener-card message.
  /// Shared by the manual toggle path and the auto-start error surface so
  /// both render the same "port 5000 in use" copy when the bind fails.
  String _friendlyError(AppLocalizations l, String raw, int port) {
    final lower = raw.toLowerCase();
    if ((raw.contains('errno') && raw.contains('48')) ||
        lower.contains('address already in use')) {
      return l.skappListenerCardErrorPortInUse(port);
    }
    return l.skappListenerCardErrorGeneric(raw);
  }

  void _showPairingQr(BuildContext context, NetworkIdentity id) {
    showDialog<void>(
      context: context,
      builder: (_) => _PairingQrSheet(identity: id),
    );
  }
}

class _PairingQrSheet extends ConsumerStatefulWidget {
  const _PairingQrSheet({required this.identity});
  final NetworkIdentity identity;

  @override
  ConsumerState<_PairingQrSheet> createState() => _PairingQrSheetState();
}

class _PairingQrSheetState extends ConsumerState<_PairingQrSheet> {
  /// Handshake token minted when the sheet opens. Single-use, expires
  /// after 60 s. Cancelled in dispose so a closed sheet can never be
  /// redeemed even if the QR was photographed mid-flight.
  late final PairingHandshake _handshake;

  /// Best-guess LAN IPv4 baked into the QR so the mobile scanner can
  /// reach the redeem endpoint without an mDNS browse. Resolves to null
  /// briefly during async discovery; QR shows the host name only until
  /// the IP lands. Manual pairing ignores this value entirely.
  String? _lanIp;

  @override
  void initState() {
    super.initState();
    _handshake = ref.read(pairingHandshakeProvider.notifier).mint();
    _discoverLanIp();
  }

  Future<void> _discoverLanIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLinkLocal: false,
        type: InternetAddressType.IPv4,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback && !addr.isMulticast) {
            if (mounted) setState(() => _lanIp = addr.address);
            return;
          }
        }
      }
    } catch (_) {
      // Network interface enumeration can fail on locked-down
      // platforms; the QR still works as long as the mobile knows
      // the host by mDNS or manual entry.
    }
  }

  @override
  void dispose() {
    ref.read(pairingHandshakeProvider.notifier).cancel(_handshake.token);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cert = ref.watch(currentTlsCertProvider);
    final payload = SkappPairingPayload(
      uuid: widget.identity.uuid,
      name: widget.identity.name,
      port: widget.identity.port,
      handshakeToken: _handshake.token,
      ip: _lanIp,
      // Faz B step 4: pin the TLS cert at pairing time. Null only while
      // the listener is mid-restart; the QR is unusable in that window
      // anyway because the server isn't accepting connections.
      certFingerprint: cert?.fingerprintHex,
    );
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final qrData = _encodePayload(payload);
    // UUID last-4 trust anchor for the manual pairing flow. Mobile asks
    // the user to retype these 4 chars before saving the peer; an mDNS
    // spoofer can't see this desktop's screen so they can't get the
    // user to confirm against the attacker's UUID.
    final uuidNoDashes = payload.uuid.replaceAll('-', '');
    final uuidTail = uuidNoDashes.length >= 4
        ? uuidNoDashes.substring(uuidNoDashes.length - 4).toUpperCase()
        : uuidNoDashes.toUpperCase();
    return SkCenteredDialog(
      title: l.skappPeerPairingShowQrTitle,
      icon: Icons.qr_code_2_rounded,
      maxWidth: 460,
      maxHeight: 620,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(l.skappPeerPairingShowQrCloseButton),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.skappPeerPairingShowQrBody,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F2EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 220,
                backgroundColor: const Color(0xFFF5F2EC),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  l.skappListenerCardUuidLast4Label.toUpperCase(),
                  style: tt.labelSmall?.copyWith(
                    letterSpacing: 1.2,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  uuidTail,
                  style: tt.displaySmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w800,
                    letterSpacing: 6,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.skappListenerCardUuidLast4Hint,
                  textAlign: TextAlign.center,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Encode the pairing payload as a JSON string so QR scanners on both
/// sides see a single self-describing blob (no out-of-band shape).
String _encodePayload(SkappPairingPayload p) => jsonEncode(p.toJson());
