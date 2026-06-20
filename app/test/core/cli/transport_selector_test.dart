// Faz 2 — TransportSelector fallback zinciri testleri.
//
// ProviderContainer + FakePairedDevicesNotifier + MockBondStore ile
// gerçek socket/BLE açmadan fallback mantığı test edilir.
//
// Riverpod 3'te FutureProvider hataları provider.future üzerinden
// iletilmiyor; c.listen() onError callback'i ile yakalanıyor.
// _run() helper'ı bu davranışı soyutlar: subscriber oluşturarak
// provider'ı canlı tutar, hem data hem error durumunu propagate eder.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skapp/core/cli/ble_transport.dart';
import 'package:skapp/core/cli/bond_store.dart';
import 'package:skapp/core/cli/cli_client.dart';
import 'package:skapp/core/cli/cli_session.dart';
import 'package:skapp/core/cli/cli_transport.dart';
import 'package:skapp/core/cli/mdns_discovery.dart';
import 'package:skapp/core/cli/transport_selector.dart';
import 'package:skapp/core/storage/paired_devices_store.dart';

import '../../fixtures/fake_cli_transport.dart';

// ---------------------------------------------------------------------------
// Test doubles

class MockBondStore extends Mock implements BondStore {}

/// Lightweight PairedDevicesNotifier that skips SharedPreferences by
/// overriding build() to return a fixed list. touch() and
/// clearLastEndpoint() are no-ops (calls inside TransportSelector are
/// wrapped in try/catch so exceptions are silently dropped).
class FakePairedDevicesNotifier extends PairedDevicesNotifier {
  FakePairedDevicesNotifier(this._devices);
  final List<PairedDevice> _devices;

  @override
  List<PairedDevice> build() => _devices;

  @override
  Future<void> touch(String id, {String? lastIp, int? lastPort}) async {}

  @override
  Future<void> clearLastEndpoint(String id) async {}
}

// ---------------------------------------------------------------------------
// Fixtures

const _kDeviceId = 'BF-TEST';
final _kToken = Uint8List.fromList(List.generate(32, (i) => i));

PairedDevice _device({String? lastIp, int? lastPort}) => PairedDevice(
      id: _kDeviceId,
      name: _kDeviceId,
      prefix: 'BF',
      pairedAt: DateTime(2025),
      lastIp: lastIp,
      lastPort: lastPort,
    );

// ---------------------------------------------------------------------------
// Helpers

ProviderContainer _container(
  MockBondStore bondStore,
  List<PairedDevice> devices,
) =>
    ProviderContainer(
      // Riverpod 3 defaults to exponential-backoff retry for all Exception
      // subclasses (up to 10 attempts). Disable it here so error tests resolve
      // immediately instead of timing out after ~38 seconds.
      retry: (_, _) => null,
      overrides: [
        bondStoreProvider.overrideWithValue(bondStore),
        pairedDevicesProvider
            .overrideWith(() => FakePairedDevicesNotifier(devices)),
      ],
    );

FutureProvider<DeviceSession> _makeProvider({
  CliClient Function(String host, int port, List<int> token)? tcpFactory,
  CliClient Function(String deviceId, List<int> token)? bleFactory,
  Future<MdnsDeviceEndpoint?> Function(String, Duration)? mdns,
}) =>
    FutureProvider<DeviceSession>((ref) {
      return TransportSelector(
        ref: ref,
        tcpClientFactory: tcpFactory,
        bleClientFactory: bleFactory,
        mdnsResolver: mdns != null
            ? (instance, {timeout}) =>
                mdns(instance, timeout ?? const Duration(seconds: 3))
            : null,
      ).selectAndConnect(_kDeviceId);
    });

/// Runs a FutureProvider and propagates both data and error.
///
/// In Riverpod 3, FutureProvider errors do NOT arrive as AsyncError state
/// in the listener callback; they arrive via the onError callback of
/// listen(). The subscription keeps the provider alive (prevents auto-
/// dispose from tearing down mid-flight). The completer bridges the Riverpod
/// state machine back into a plain Dart Future.
Future<DeviceSession> _run(
  ProviderContainer c,
  FutureProvider<DeviceSession> p,
) {
  final completer = Completer<DeviceSession>();

  ProviderSubscription<AsyncValue<DeviceSession>>? sub;
  sub = c.listen<AsyncValue<DeviceSession>>(
    p,
    (_, next) {
      if (completer.isCompleted) return;
      if (next is AsyncData<DeviceSession>) {
        sub?.close();
        completer.complete(next.value);
      } else if (next is AsyncError) {
        // fallback path — some Riverpod builds may reach here
        sub?.close();
        completer.completeError(next.error!, next.stackTrace);
      }
    },
    fireImmediately: true,
    onError: (error, stack) {
      // Primary error path in Riverpod 3: provider errors arrive here
      if (!completer.isCompleted) {
        sub?.close();
        completer.completeError(error, stack);
      }
    },
  );

  return completer.future;
}

// ---------------------------------------------------------------------------
// Tests

void main() {
  late MockBondStore bond;

  setUp(() {
    bond = MockBondStore();
    when(() => bond.tokenFor(any())).thenAnswer((_) async => _kToken);
  });

  group('BondMissingException', () {
    test('bond bulunamadığında fırlatılır', () async {
      when(() => bond.tokenFor(any())).thenAnswer((_) async => null);
      final p = _makeProvider();
      final c = _container(bond, []);
      addTearDown(c.dispose);

      await expectLater(_run(c, p), throwsA(isA<BondMissingException>()));
    });
  });

  group('TCP cache fast-path', () {
    test('lastIp mevcutsa TCP ile bağlanır, mDNS ve BLE denenmez', () async {
      var mdnsCalled = false;
      var bleCalled = false;
      final p = _makeProvider(
        tcpFactory: (_, _, _) => CliClient(FakeCliTransport()),
        mdns: (_, _) async {
          mdnsCalled = true;
          return null;
        },
        bleFactory: (_, _) {
          bleCalled = true;
          return CliClient(FakeCliTransport());
        },
      );
      final c =
          _container(bond, [_device(lastIp: '192.168.1.1', lastPort: 8080)]);
      addTearDown(c.dispose);

      final session = await _run(c, p);
      expect(session.transportKind, CliTransportKind.tcp);
      expect(mdnsCalled, isFalse);
      expect(bleCalled, isFalse);
    });

    test('TCP cache başarısız → mDNS yoluna düşer', () async {
      var mdnsCalled = false;
      final p = _makeProvider(
        tcpFactory: (host, _, _) {
          if (host == '192.168.1.1') {
            return CliClient(
                FakeCliTransport(connectError: Exception('refused')));
          }
          return CliClient(FakeCliTransport());
        },
        mdns: (_, _) async {
          mdnsCalled = true;
          return MdnsDeviceEndpoint(
              instance: _kDeviceId, host: '10.0.0.5', port: 8080);
        },
      );
      final c =
          _container(bond, [_device(lastIp: '192.168.1.1', lastPort: 8080)]);
      addTearDown(c.dispose);

      final session = await _run(c, p);
      expect(session.transportKind, CliTransportKind.tcp);
      expect(mdnsCalled, isTrue);
    });
  });

  group('mDNS yolu (cache yok)', () {
    test('mDNS başarılı → TCP bağlantısı açılır', () async {
      final p = _makeProvider(
        tcpFactory: (_, _, _) => CliClient(FakeCliTransport()),
        mdns: (_, _) async => MdnsDeviceEndpoint(
            instance: _kDeviceId, host: '10.0.0.5', port: 8080),
      );
      final c = _container(bond, [_device()]);
      addTearDown(c.dispose);

      final session = await _run(c, p);
      expect(session.transportKind, CliTransportKind.tcp);
    });

    test('mDNS cevap vermez → BLE fallback\'a düşer', () async {
      var bleCalled = false;
      final p = _makeProvider(
        mdns: (_, _) async => null,
        bleFactory: (_, _) {
          bleCalled = true;
          return CliClient(FakeCliTransport());
        },
      );
      final c = _container(bond, [_device()]);
      addTearDown(c.dispose);

      final session = await _run(c, p);
      expect(session.transportKind, CliTransportKind.ble);
      expect(bleCalled, isTrue);
    });
  });

  group('BLE fallback', () {
    test('TCP ve mDNS başarısız → BLE ile bağlanır', () async {
      final p = _makeProvider(
        tcpFactory: (_, _, _) =>
            CliClient(FakeCliTransport(connectError: Exception('no route'))),
        mdns: (_, _) async => MdnsDeviceEndpoint(
            instance: _kDeviceId, host: '10.0.0.5', port: 8080),
        bleFactory: (_, _) => CliClient(FakeCliTransport()),
      );
      final c = _container(bond, [_device(lastIp: '192.168.1.1')]);
      addTearDown(c.dispose);

      final session = await _run(c, p);
      expect(session.transportKind, CliTransportKind.ble);
    });

    test('hepsi başarısız → DeviceUnreachableException', () async {
      final p = _makeProvider(
        mdns: (_, _) async => null,
        bleFactory: (_, _) =>
            CliClient(FakeCliTransport(connectError: Exception('BLE failed'))),
      );
      final c = _container(bond, [_device()]);
      addTearDown(c.dispose);

      await expectLater(
          _run(c, p), throwsA(isA<DeviceUnreachableException>()));
    });

    test('DeviceUnreachableException attempts listesi dolu', () async {
      final p = _makeProvider(
        mdns: (_, _) async => null,
        bleFactory: (_, _) => CliClient(
            FakeCliTransport(connectError: Exception('adapter off'))),
      );
      final c = _container(bond, [_device()]);
      addTearDown(c.dispose);

      try {
        await _run(c, p);
        fail('exception bekleniyor');
      } on DeviceUnreachableException catch (e) {
        expect(e.attempts, isNotEmpty);
        expect(e.attempts.any((a) => a.contains('BLE')), isTrue);
      }
    });

    test('PairingRequiredException doğrudan iletilir (sarmalanmaz)', () async {
      final p = _makeProvider(
        mdns: (_, _) async => null,
        bleFactory: (_, _) => CliClient(
          FakeCliTransport(
              connectError: const PairingRequiredException('needs_pairing')),
        ),
      );
      final c = _container(bond, [_device()]);
      addTearDown(c.dispose);

      await expectLater(
          _run(c, p), throwsA(isA<PairingRequiredException>()));
    });
  });

  group('paired device eşleşmesi yok', () {
    test('paired null iken mDNS instance deviceId olarak kullanılır',
        () async {
      String? capturedInstance;
      final p = _makeProvider(
        mdns: (instance, _) async {
          capturedInstance = instance;
          return null;
        },
        bleFactory: (_, _) => CliClient(FakeCliTransport()),
      );
      final c = _container(bond, []);
      addTearDown(c.dispose);

      await _run(c, p);
      expect(capturedInstance, _kDeviceId);
    });
  });
}
