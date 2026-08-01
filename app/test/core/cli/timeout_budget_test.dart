// Süre bütçesi invariantları: dış sarmalayıcı ≥ iç aşamaların toplamı.
// Eski TransportSelector.bleTimeout=15s, BleCliTransport'un ~41s'lik iç
// zincirini her yavaş bağlantıda ortadan kesiyor ve gerçek aşama bilgisini
// çıplak TimeoutException'a çeviriyordu (audit C11).

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/cli/ble_transport.dart';
import 'package:skapp/core/cli/transport_selector.dart';

void main() {
  test('outer BLE timeout covers the whole inner stage budget', () {
    expect(TransportSelector.bleTimeout > BleCliTransport.connectBudget, isTrue);
  });

  test('BLE connect budget equals the sum of its stages', () {
    final sum = BleCliTransport.kDisconnectTimeout +
        BleCliTransport.kConnectOuterTimeout +
        BleCliTransport.kDiscoverTimeout +
        BleCliTransport.kSubscribeTimeout +
        BleCliTransport.kChallengeSettle +
        BleCliTransport.kMtuTimeout +
        BleCliTransport.kAuthTimeout;
    expect(BleCliTransport.connectBudget, sum);
  });

  test('fresh TCP timeout covers connect+auth', () {
    // connect 5s + auth 10s
    expect(
        TransportSelector.tcpFreshTimeout >= const Duration(seconds: 15), isTrue);
  });

  test('cache TCP: fail-fast connect but full auth budget', () {
    expect(TransportSelector.tcpCacheConnectTimeout, const Duration(seconds: 3));
    expect(
        TransportSelector.tcpCacheTimeout >= const Duration(seconds: 13), isTrue);
  });

  test('chain worst case covers every step', () {
    final floor = TransportSelector.tcpCacheTimeout +
        TransportSelector.mdnsResolveTimeout +
        TransportSelector.tcpFreshTimeout * 2 +
        TransportSelector.bleTimeout;
    expect(TransportSelector.chainWorstCase >= floor, isTrue);
  });
}
