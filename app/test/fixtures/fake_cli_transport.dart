// Scriptable [CliTransport] double for tests (Faz 0 test altyapısı).
//
// Lets a test drive the connect outcome (succeed / throw / delay) and feed
// arbitrary incoming NDJSON lines, without opening a real socket or BLE
// link. Sent lines are recorded for assertions. Used by the TransportSelector
// fallback tests (Faz 2) and any CliClient-level unit test.

import 'dart:async';

import 'package:skapp/core/cli/cli_transport.dart';

class FakeCliTransport implements CliTransport {
  FakeCliTransport({
    this.connectError,
    this.connectDelay = Duration.zero,
    this.kind = CliTransportKind.tcp,
  });

  /// When non-null, [connect] throws this after [connectDelay]. Use to
  /// simulate a refused socket, failed handshake, or timeout source.
  final Object? connectError;

  /// Artificial latency before [connect] resolves/throws. Pair with
  /// `fakeAsync` or a real timeout to exercise timeout branches.
  final Duration connectDelay;

  /// Advertised transport kind (purely informational for the fake).
  final CliTransportKind kind;

  final _incoming = StreamController<String>.broadcast();
  final List<String> sentLines = <String>[];

  bool _authenticated = false;
  bool connectCalled = false;
  bool closeCalled = false;

  @override
  Stream<String> get incoming => _incoming.stream;

  @override
  bool get authenticated => _authenticated;

  @override
  Future<void> connect() async {
    connectCalled = true;
    if (connectDelay > Duration.zero) {
      await Future<void>.delayed(connectDelay);
    }
    if (connectError != null) {
      throw connectError!;
    }
    _authenticated = true;
  }

  @override
  Future<void> sendLine(String line) async {
    sentLines.add(line);
  }

  @override
  Future<void> close() async {
    closeCalled = true;
    _authenticated = false;
    if (!_incoming.isClosed) await _incoming.close();
  }

  /// Push a raw NDJSON line as if the device emitted it (response or event).
  void emit(String line) {
    if (!_incoming.isClosed) _incoming.add(line);
  }
}
