import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/skapp_http_client.dart';
import '../../core/network/skapp_peer_store.dart';
import '../../core/network/skapp_peer_target.dart';
import '../../core/system/network_identity_provider.dart';
import '../../core/theme/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;

// Conditional import: mobile_scanner is mobile-only, importing it on
// desktop / web throws plugin missing implementations. Wrapping is
// done at use-time instead of file scope to keep the file compilable
// across platforms.
import 'package:mobile_scanner/mobile_scanner.dart' as scanner;

/// Pairs the phone (or any client SKAPP) with a Desktop SKAPP. Two
/// tabs:
///   - "Scan QR" using `mobile_scanner` on Android/iOS.
///   - "Manual" form for hosts where camera scan is not available
///     (web, headless test, accessibility fallback).
///
/// On success, writes a `SkappPeerTarget` via [skappPeersProvider] and
/// pops with the new target as the route result.
class SkappPeerPairingScreen extends ConsumerStatefulWidget {
  const SkappPeerPairingScreen({super.key});

  @override
  ConsumerState<SkappPeerPairingScreen> createState() =>
      _SkappPeerPairingScreenState();
}

class _SkappPeerPairingScreenState
    extends ConsumerState<SkappPeerPairingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  bool get _scanSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this, initialIndex: _scanSupported ? 0 : 1);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Text(l.skappPeerPairingTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.skappPeerPairingTabScan),
            Tab(text: l.skappPeerPairingTabManual),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _scanSupported
              ? _ScanTab(onPair: _pair)
              : _UnsupportedScanTab(),
          _ManualTab(onPair: _pair),
        ],
      ),
    );
  }

  Future<void> _pair(SkappPairingPayload payload, {String? lastIp}) async {
    final l = AppLocalizations.of(context);
    // Resolve the host the redeem call should land on. Manual pairing
    // supplies `lastIp` directly; scan supplies the value baked into
    // the v:2 QR payload. v:1 doesn't redeem so the absence is ok.
    final host = lastIp ?? payload.ip;
    String token;
    if (payload.version == 2) {
      if (host == null || payload.handshakeToken == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(l
                .skappPeerPairingFailedToast('Missing host or handshake'), textAlign: TextAlign.center),
          ));
        return;
      }
      // The redeem call needs a stable identifier so the desktop's
      // per-peer token store has something to key on. We use this
      // SKAPP install's own UUID — every install has one, generated
      // by `NetworkIdentityNotifier` at first launch.
      final selfId = ref.read(networkIdentityProvider);
      try {
        final redeemed = await redeemPairing(
          host: host,
          port: payload.port,
          handshakeToken: payload.handshakeToken!,
          peerUuid: selfId.uuid,
          peerName: selfId.name,
          // Faz B step 4: pin the redeem TLS handshake against the
          // fingerprint baked into the QR. MITM with a different cert
          // fails the handshake before token negotiation even begins.
          expectedFingerprintHex: payload.certFingerprint,
        );
        token = redeemed.peerToken;
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(l.skappPeerPairingFailedToast(e.toString()), textAlign: TextAlign.center),
          ));
        return;
      }
    } else {
      // Legacy v:1 fallback. The bearer is baked into the QR, no
      // redeem step. Same shape as before this refactor.
      if (payload.bearerToken == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
                l.skappPeerPairingFailedToast('Missing bearer in v:1 QR'), textAlign: TextAlign.center),
          ));
        return;
      }
      token = payload.bearerToken!;
    }
    final peer = SkappPeerTarget(
      uuid: payload.uuid,
      name: payload.name,
      bearerToken: token,
      port: payload.port,
      pairedAt: DateTime.now().toUtc(),
      lastIp: host,
      lastSeen: host == null ? null : DateTime.now().toUtc(),
      // Faz B step 4: pin the cert seen during pairing so future
      // requests fail handshake against a MITM cert. v:1 payloads
      // don't carry a fingerprint; null falls through to the
      // backwards-compat "no pin, allow but warn" mode in the
      // mobile HTTP client.
      certFingerprint: payload.certFingerprint,
    );
    await ref.read(skappPeersProvider.notifier).add(peer);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.skappPeerPairingSavedToast(peer.name), textAlign: TextAlign.center),
      ));
    Navigator.of(context).maybePop(peer);
  }
}

class _ScanTab extends StatefulWidget {
  const _ScanTab({required this.onPair});
  final Future<void> Function(SkappPairingPayload, {String? lastIp}) onPair;

  @override
  State<_ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<_ScanTab> {
  final scanner.MobileScannerController _controller =
      scanner.MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(scanner.BarcodeCapture capture) async {
    if (_handled) return;
    final raw = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
    if (raw == null) return;
    final l = AppLocalizations.of(context);
    try {
      final json = jsonDecode(raw) as Map<String, Object?>;
      final payload = SkappPairingPayload.fromJson(
          json.map((k, v) => MapEntry(k, v as dynamic)));
      _handled = true;
      await _controller.stop();
      if (!mounted) return;
      await widget.onPair(payload);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.skappPeerPairingFailedToast(e.toString()), textAlign: TextAlign.center),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: scanner.MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                l.skappPeerPairingScanHint,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UnsupportedScanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.skappPeerPairingScanCameraDeniedTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(l.skappPeerPairingScanCameraDeniedBody),
        ],
      ),
    );
  }
}

class _ManualTab extends StatefulWidget {
  const _ManualTab({required this.onPair});
  final Future<void> Function(SkappPairingPayload, {String? lastIp}) onPair;

  @override
  State<_ManualTab> createState() => _ManualTabState();
}

class _ManualTabState extends State<_ManualTab> {
  final _hostCtrl = TextEditingController();
  final _portCtrl = TextEditingController(text: '5000');
  final _tokenCtrl = TextEditingController();
  final _uuidCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _uuidConfirmCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _hostCtrl.dispose();
    _portCtrl.dispose();
    _tokenCtrl.dispose();
    _uuidCtrl.dispose();
    _nameCtrl.dispose();
    _uuidConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final port = int.tryParse(_portCtrl.text.trim());
    if (port == null || port <= 0 || port > 65535) {
      setState(() => _error = 'port');
      return;
    }
    if (_uuidCtrl.text.trim().isEmpty ||
        _tokenCtrl.text.trim().isEmpty ||
        _hostCtrl.text.trim().isEmpty) {
      setState(() => _error = 'required');
      return;
    }
    // UUID confirmation: case-insensitive match of the last 4 characters.
    // Desktop displays them in bold on the pairing QR sheet so a mDNS
    // spoofer can't redirect a manual pairing without seeing the actual
    // desktop screen. Strip dashes so users who copy from a UI element
    // that hides them still succeed.
    final uuid = _uuidCtrl.text.trim().replaceAll('-', '');
    if (uuid.length < 4) {
      setState(() => _error = 'uuid_confirm');
      return;
    }
    final expectedTail = uuid.substring(uuid.length - 4).toLowerCase();
    final typedTail =
        _uuidConfirmCtrl.text.trim().replaceAll('-', '').toLowerCase();
    if (typedTail != expectedTail) {
      setState(() => _error = 'uuid_confirm');
      return;
    }

    final payload = SkappPairingPayload(
      uuid: _uuidCtrl.text.trim(),
      name: _nameCtrl.text.trim().isEmpty
          ? _hostCtrl.text.trim()
          : _nameCtrl.text.trim(),
      bearerToken: _tokenCtrl.text.trim(),
      port: port,
    );
    try {
      await widget.onPair(payload, lastIp: _hostCtrl.text.trim());
    } catch (e) {
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.skappPeerPairingFailedToast(e.toString()), textAlign: TextAlign.center),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 60),
      children: [
        SkContent(
          horizontalPadding: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.skappPeerPairingSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 18),
              _Field(
                  label: l.skappPeerPairingManualHostLabel,
                  controller: _hostCtrl,
                  invalid: _error == 'required' && _hostCtrl.text.trim().isEmpty),
              const SizedBox(height: 12),
              _Field(
                  label: l.skappPeerPairingManualPortLabel,
                  controller: _portCtrl,
                  invalid: _error == 'port',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _Field(
                  label: l.skappPeerPairingManualUuidLabel,
                  controller: _uuidCtrl,
                  invalid: _error == 'required' && _uuidCtrl.text.trim().isEmpty),
              const SizedBox(height: 12),
              _Field(
                  label: l.skappPeerPairingManualTokenLabel,
                  controller: _tokenCtrl,
                  invalid:
                      _error == 'required' && _tokenCtrl.text.trim().isEmpty,
                  obscureText: true),
              const SizedBox(height: 12),
              _Field(
                  label: l.skappPeerPairingManualNameLabel,
                  controller: _nameCtrl,
                  invalid: false),
              const SizedBox(height: 12),
              // UUID-last-4 confirmation. Desktop shows the same 4 chars in
              // large font on its pairing QR sheet so a mDNS-spoofing attacker
              // can't get the user to type junk that aligns with the attacker's
              // UUID. Required regardless of whether the UUID field above was
              // typed or pasted — both come from the same untrusted input,
              // only the desktop screen is the trust anchor.
              _Field(
                  label: l.skappPeerPairingManualUuidConfirmLabel,
                  controller: _uuidConfirmCtrl,
                  invalid: _error == 'uuid_confirm',
                  keyboardType: TextInputType.visiblePassword),
              if (_error == 'uuid_confirm')
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    l.skappPeerPairingManualUuidConfirmError,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    l.skappPeerPairingManualUuidConfirmHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _submit,
                child: Text(l.skappPeerPairingManualSubmit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.invalid,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final bool invalid;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: invalid ? '!' : null,
      ),
    );
  }
}
