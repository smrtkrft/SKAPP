// SKAPP CLI transport abstraction.
//
// Any transport (BLE, TCP, USB) implements this interface so the command
// client and event stream don't care about the underlying channel.

import 'dart:async';

abstract class CliTransport {
  /// Line-delimited NDJSON output from the device (responses + events).
  Stream<String> get incoming;

  /// True once the Mutual Challenge-Response handshake has completed.
  bool get authenticated;

  /// Open the channel and run the handshake. Completes when the channel is
  /// ready for command traffic. Throws on failure.
  Future<void> connect();

  /// Send a single NDJSON line (newline auto-appended if missing).
  Future<void> sendLine(String line);

  /// Graceful shutdown.
  Future<void> close();
}

/// Common transport kinds advertised in the discovery UI.
enum CliTransportKind { ble, tcp, usb }

/// Cihaz mutual-auth el sıkışmasını aktif reddetti (token uyuşmazlığı veya
/// auth sırasında açık hata zarfı). Transient timeout'lardan ayrı tutulur;
/// pairing_screen bunu "bond çürümüş" sinyali sayar.
class AuthRejectedException implements Exception {
  const AuthRejectedException(this.detail);
  final String detail;
  @override
  String toString() => 'AuthRejectedException($detail)';
}

/// Transport düştüğünde bekleyen CLI isteklerine verilen hata. [reason]
/// düşüşe yol açan alt hata (socket reset, stream error); temiz lokal
/// stop()'ta null. Eski çıplak StateError('CLI transport closed') sebebi
/// yok ediyordu — "cihaz reboot" ile "auth iptal" ayırt edilemiyordu.
class TransportClosedException implements Exception {
  const TransportClosedException([this.reason]);
  final Object? reason;
  @override
  String toString() => reason == null
      ? 'TransportClosedException(clean close)'
      : 'TransportClosedException($reason)';
}
