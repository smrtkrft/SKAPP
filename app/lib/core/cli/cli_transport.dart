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
