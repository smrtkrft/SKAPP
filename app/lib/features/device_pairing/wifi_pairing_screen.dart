// WiFi-based ECDH pairing, pairing_screen.dart'ın TCP versiyonu.
//
// Akış:
//   1. Kullanıcıya "Cihazdaki kontrol butonuna kısa bas" prompt'u
//      (cihaz pairing modunu fiziksel onayla açar, bu yeterli güvenlik)
//   2. SKAPP TCP socket açar (mDNS'ten alınan host:port'a)
//   3. Cihaz bond kontrolü: bond yok + pairing açık → pairing-mode line
//   4. SKAPP `pairing.ecdh.exchange { peer_pub }` gönderir
//   5. Cihaz ECDH yapar, bond persist eder, `our_pub` döner
//   6. SKAPP shared secret'tan token türetir, BondStore'a kaydeder
//   7. PairedDevice upsert → home/devices listesinde görünür
//   8. Cihaz socket'i kapatır, SKAPP DeviceHomeScreen'e geçer
//      (bonded artık → cli_providers TCP cache fast-path ile bağlanır)

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart' as cvt;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_model.dart';
import '../../core/cli/bond_store.dart';
import '../../core/cli/ecdh_pairing.dart';
import '../../core/cli/mdns_discovery.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/system/network_identity_provider.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import '../device_home/device_home_screen.dart';
import 'pairing_helpers.dart';

enum _Stage {
  awaitingButton,    // kullanıcıya prompt; "Eşleştir" butonuna basana kadar bekle
  connecting,        // TCP socket connect
  exchanging,        // pairing.ecdh.exchange gönderildi, cevap bekleniyor
  done,              // bond saved, dashboard'a geçiş
  failed,
}

class WifiPairingScreen extends ConsumerStatefulWidget {
  const WifiPairingScreen({super.key, required this.endpoint});
  final MdnsDeviceEndpoint endpoint;

  @override
  ConsumerState<WifiPairingScreen> createState() => _WifiPairingScreenState();
}

class _WifiPairingScreenState extends ConsumerState<WifiPairingScreen> {
  _Stage _stage = _Stage.awaitingButton;
  String? _errorMsg;
  Socket? _socket;
  final List<String> _trail = [];

  @override
  void dispose() {
    _socket?.destroy();
    super.dispose();
  }

  void _trace(String s) {
    final ts = DateTime.now();
    final line =
        '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}:${ts.second.toString().padLeft(2, '0')}.${ts.millisecond.toString().padLeft(3, '0')}  $s';
    if (mounted) {
      setState(() {
        _trail.add(line);
        if (_trail.length > 20) _trail.removeAt(0);
      });
    }
  }

  void _set(_Stage s, {String? err}) {
    if (!mounted) return;
    setState(() {
      _stage = s;
      _errorMsg = err;
    });
  }

  Future<void> _start() async {
    final l = AppLocalizations.of(context);
    _set(_Stage.connecting);
    _trace('connect ${widget.endpoint.host}:${widget.endpoint.port}');

    Socket socket;
    try {
      socket = await Socket.connect(
        widget.endpoint.host,
        widget.endpoint.port,
        timeout: const Duration(seconds: 5),
      );
    } catch (e) {
      _set(_Stage.failed, err: l.wifiPairingConnectFailed(e.toString()));
      return;
    }
    _socket = socket;
    _trace('socket open');

    // Re-armable reply pump: the bootstrap may need >1 reply because of
    // the optional pairing.passphrase.verify follow-up. Each turn we set
    // `armed` to a fresh completer just before the corresponding write.
    Completer<Map<String, dynamic>>? armed;
    final buffer = StringBuffer();
    final sub = utf8.decoder.bind(socket).listen(
      (chunk) {
        buffer.write(chunk);
        while (true) {
          final s = buffer.toString();
          final nl = s.indexOf('\n');
          if (nl < 0) break;
          final line = s.substring(0, nl).trim();
          buffer
            ..clear()
            ..write(s.substring(nl + 1));
          if (line.isEmpty) continue;
          _trace('rx: $line');
          final c = armed;
          if (c == null || c.isCompleted) continue;
          try {
            final json = jsonDecode(line) as Map<String, dynamic>;
            c.complete(json);
          } catch (e) {
            c.completeError(l.wifiPairingInvalidJson(e.toString()));
          }
        }
      },
      onError: (Object e) {
        final c = armed;
        if (c != null && !c.isCompleted) c.completeError(e);
      },
      onDone: () {
        final c = armed;
        if (c != null && !c.isCompleted) {
          c.completeError(l.wifiPairingClosedEarly);
        }
      },
    );

    Future<void> writeLine(Map<String, dynamic> obj) async {
      socket.add(utf8.encode('${jsonEncode(obj)}\n'));
      await socket.flush();
    }

    _set(_Stage.exchanging);

    final ephemeral = await EcdhPairing().begin();
    final peerPubHex = cvt.hex.encode(ephemeral.ourPublic);
    final store = ref.read(bondStoreProvider);
    final ourPeerId = await store.appPeerId();
    final peerIdHex = cvt.hex.encode(ourPeerId);
    // `identity` cihazın adı (örn. "BF-A06TMFSQT") — daha aşağıda
    // PairedDevice + BondStore.upsert için gerekli, dokunmuyoruz.
    // `label` ise bond slot'unda peer'i (yani BU SKAPP'i) tanıtmak için;
    // cihazın değil, kendi NetworkIdentity ismimizden okunur.
    final identity = widget.endpoint.instance;
    final label =
        shortPairingLabel(ref.read(networkIdentityProvider).name);

    armed = Completer<Map<String, dynamic>>();
    _trace('tx: pairing.ecdh.exchange (peer_id=${peerIdHex.substring(0, 8)}…)');
    try {
      await writeLine({
        'cmd': 'pairing.ecdh.exchange',
        'args': {
          'peer_pub': peerPubHex,
          'peer_id':  peerIdHex,
          'label':    label,
        },
      });
    } catch (e) {
      await sub.cancel();
      _set(_Stage.failed, err: l.wifiPairingSendFailed(e.toString()));
      return;
    }

    Map<String, dynamic> reply;
    try {
      reply = await armed.future.timeout(const Duration(seconds: 12));
    } on TimeoutException {
      await sub.cancel();
      _set(_Stage.failed, err: l.wifiPairingTimeout);
      return;
    } catch (e) {
      await sub.cancel();
      _set(_Stage.failed, err: '$e');
      return;
    }

    // Firmware quirk (sk_transport_tcp.c:114-135): pairing-mode fallback
    // is only entered when `sk_secure_session_begin` returns non-OK, i.e.
    // when the device has ZERO bonds stored. As soon as the device has
    // any bond at all, every TCP connection is greeted with
    // `auth.challenge` and the bootstrap path is unreachable. We can't
    // answer that challenge here (we don't have a token yet), so the
    // honest move is to surface a clear error and steer the user to the
    // BLE flow.
    final evt = reply['evt'];
    if (evt == 'auth.challenge') {
      await sub.cancel();
      _set(_Stage.failed, err: l.wifiPairingDeviceAlreadyBonded);
      return;
    }

    if (reply['ok'] != true) {
      final err = reply['err']?.toString() ?? 'ERR_UNKNOWN';
      String msg;
      if (err == 'ERR_PAIRING_NOT_OPEN') {
        msg = l.wifiPairingNotOpen;
      } else if (err == 'ERR_BOND_STORE_FULL') {
        final params = reply['params'] as Map<String, dynamic>?;
        final peers  = (params?['peers'] as List?) ?? const [];
        msg = mounted
            ? bondStoreFullMessage(context, peers)
            : 'BOND_STORE_FULL';
      } else {
        msg = l.wifiPairingRejected(err);
      }
      await sub.cancel();
      _set(_Stage.failed, err: msg);
      return;
    }

    final data = reply['data'] as Map?;
    final ourPub = data?['our_pub']?.toString();
    if (ourPub == null || ourPub.length != 64) {
      await sub.cancel();
      _set(_Stage.failed, err: l.wifiPairingMissingPub);
      return;
    }

    Uint8List devicePub;
    try {
      devicePub = Uint8List.fromList(cvt.hex.decode(ourPub));
    } catch (e) {
      await sub.cancel();
      _set(_Stage.failed, err: l.wifiPairingHexError(e.toString()));
      return;
    }

    final bond = await ephemeral.complete(devicePub);
    _trace('bond derived (${bond.token.length}B token)');

    int? assignedSlot = (data?['slot'] as num?)?.toInt();

    // Pairing-time passphrase gate (same flow as BLE pairing screen).
    if (data?['need_passphrase'] == true) {
      int attemptsLeft =
          (data?['attempts_left'] as num?)?.toInt() ?? 10;
      bool unlocked = false;
      while (!unlocked) {
        final plain = !mounted
            ? null
            : await promptPairingPassphrase(context, attemptsLeft: attemptsLeft);
        if (plain == null) {
          await sub.cancel();
          _set(_Stage.failed, err: l.pairingPassphraseCancelled);
          return;
        }
        armed = Completer<Map<String, dynamic>>();
        try {
          await writeLine({
            'cmd':  'pairing.passphrase.verify',
            'args': {'plain': plain},
          });
        } catch (e) {
          await sub.cancel();
          _set(_Stage.failed,
              err: l.wifiPairingSendFailed(e.toString()));
          return;
        }

        Map<String, dynamic> vr;
        try {
          vr = await armed.future.timeout(const Duration(seconds: 12));
        } on TimeoutException {
          await sub.cancel();
          _set(_Stage.failed, err: l.wifiPairingTimeout);
          return;
        } catch (e) {
          await sub.cancel();
          _set(_Stage.failed, err: '$e');
          return;
        }

        if (vr['ok'] == true) {
          unlocked = true;
          assignedSlot = (vr['data']?['slot'] as num?)?.toInt() ?? assignedSlot;
        } else {
          final code = vr['err']?.toString() ?? '';
          if (code == 'ERR_PASSPHRASE_INCORRECT') {
            attemptsLeft = (vr['params']?['attempts_left'] as num?)?.toInt()
                ?? (attemptsLeft > 0 ? attemptsLeft - 1 : 0);
            if (attemptsLeft <= 0) {
              await sub.cancel();
              _set(_Stage.failed, err: l.passphraseLockoutTriggered);
              return;
            }
          } else if (code == 'ERR_NO_PENDING_BOND') {
            await sub.cancel();
            _set(_Stage.failed, err: l.pairingWindowClosedRetry);
            return;
          } else {
            await sub.cancel();
            _set(_Stage.failed, err: l.pairingPassphraseFailed(code));
            return;
          }
        }
      }
    }

    // Persist: bond key + paired metadata. Bond store BLE remoteId
    // formatını bekliyor; mDNS-only akışta BLE MAC bilinmiyor, instance
    // adını id olarak kullanıyoruz, cli_providers da bunu kullanır.
    // Defensive: also save under lowercase variant in case BF firmware
    // ever returns the SmartKraft id with different casing in webhook
    // headers — BondStore lookup is case-sensitive otherwise.
    final prefix = identity.length >= 2 ? identity.substring(0, 2) : '??';
    final aliases = <String>{
      identity.toLowerCase(),
      identity.toUpperCase(),
    }..remove(identity);
    await store.save(
      identity,
      bond.token,
      peerId: ourPeerId,
      slot: assignedSlot,
      aliasIds: aliases.toList(),
    );
    await ref.read(pairedDevicesProvider.notifier).upsert(PairedDevice(
          id: identity,
          name: identity,
          prefix: prefix,
          pairedAt: DateTime.now(),
          lastIp: widget.endpoint.host,
          lastPort: widget.endpoint.port,
        ));

    // Cihaz socket'i kapatıyor; biz de kendi tarafımızdan kapatalım.
    await sub.cancel();
    try {
      await socket.close();
    } catch (_) {/* already gone */}
    _socket = null;

    _set(_Stage.done);

    // Cihazın yeni bonded TCP'yi açabilmesi için kısa bir nefes payı
    // sk_auth_close_pairing_mode + listener'ın yeniden ready olması
    // ~250ms sürer. SKAPP hemen reconnect denerse bind yarış olabilir.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    // Direkt cihaz home'a geç: cli_providers TCP cache fast-path ile
    // bonded TCP açar, secure session handshake yapar, dashboard render.
    final dd = DiscoveredDevice(id: identity, name: identity, rssi: 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DeviceHomeScreen(device: dd)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.wifiPairingTitle),
      ),
      body: SafeArea(
        child: SkContent(
          maxWidth: SkBreakpoints.maxContentWidth,
          horizontalPadding: 24,
          child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(endpoint: widget.endpoint),
              const SizedBox(height: 24),
              Expanded(child: _StageView(stage: _stage, errorMsg: _errorMsg)),
              if (_trail.isNotEmpty)
                _DebugPanel(trail: _trail),
              const SizedBox(height: 16),
              _BottomAction(
                stage: _stage,
                onStart: _start,
                onRetry: () {
                  setState(() {
                    _trail.clear();
                  });
                  _start();
                },
                onCancel: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.endpoint});
  final MdnsDeviceEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          SkNeuIconSlot(
            icon: Icons.wifi_tethering,
            size: 40,
            iconSize: 20,
            iconColor: cs.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(endpoint.instance,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontFamily: 'monospace',
                        )),
                Text('${endpoint.host}:${endpoint.port}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontFamily: 'monospace',
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageView extends StatelessWidget {
  const _StageView({required this.stage, this.errorMsg});
  final _Stage stage;
  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          switch (stage) {
            _Stage.awaitingButton => Icon(Icons.touch_app,
                size: 72, color: cs.primary),
            _Stage.connecting => SizedBox.square(
                dimension: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: cs.primary,
                  backgroundColor: cs.primary.withValues(alpha: 0.18),
                ),
              ),
            _Stage.exchanging => SizedBox.square(
                dimension: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: cs.primary,
                  backgroundColor: cs.primary.withValues(alpha: 0.18),
                ),
              ),
            _Stage.done => const Icon(Icons.check_circle,
                size: 72, color: Color(0xFF2E7D32)),
            _Stage.failed => Icon(Icons.error_outline,
                size: 72, color: cs.error),
          },
          const SizedBox(height: 20),
          Text(
            switch (stage) {
              _Stage.awaitingButton => l.wifiPairingStageAwaiting,
              _Stage.connecting => l.wifiPairingStageConnecting,
              _Stage.exchanging => l.wifiPairingStageExchanging,
              _Stage.done => l.wifiPairingStageDone,
              _Stage.failed => l.wifiPairingStageFailed,
            },
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              switch (stage) {
                _Stage.awaitingButton => l.wifiPairingStageAwaitingHelp,
                _Stage.connecting => l.wifiPairingStageConnectingHelp,
                _Stage.exchanging => l.wifiPairingStageExchangingHelp,
                _Stage.done => l.wifiPairingStageDoneHelp,
                _Stage.failed => errorMsg ?? '',
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({
    required this.stage,
    required this.onStart,
    required this.onRetry,
    required this.onCancel,
  });

  final _Stage stage;
  final VoidCallback onStart;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return switch (stage) {
      _Stage.awaitingButton => FilledButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.bolt),
          label: Text(l.wifiPairingStartCta),
          style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52)),
        ),
      _Stage.connecting || _Stage.exchanging || _Stage.done =>
        const SizedBox.shrink(),
      _Stage.failed => Column(
          children: [
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l.commonRetry),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onCancel,
              child: Text(l.commonCancel),
            ),
          ],
        ),
    };
  }
}

class _DebugPanel extends StatelessWidget {
  const _DebugPanel({required this.trail});
  final List<String> trail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxHeight: 140),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant, width: 0.5),
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: SelectableText(
          trail.join('\n'),
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
