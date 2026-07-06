// DeviceCapabilities sürüm kapısı — sk_api payload eşiği 0.5.0.
//
// Eşik üç firmware ağacında ortak: BF/SD 0.3.0'dan, LS 0.4.0'dan
// (trigclass, payload'sız) 0.5.0'a birlikte atladı. atLeast() bu yüzden
// 0.4.0'ı payload-yok saymak ZORUNDA.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/cli/device_capabilities.dart';

void main() {
  test('supportsEndpointPayload true at exactly 0.5.0 and above', () {
    expect(
      const DeviceCapabilities({'sk_api': '0.5.0'}).supportsEndpointPayload,
      isTrue,
    );
    expect(
      const DeviceCapabilities({'sk_api': '0.6.1'}).supportsEndpointPayload,
      isTrue,
    );
    expect(
      const DeviceCapabilities({'sk_api': '1.0.0'}).supportsEndpointPayload,
      isTrue,
    );
  });

  test('older sk_api versions gate payload OFF (incl. LS trigclass 0.4.0)',
      () {
    expect(
      const DeviceCapabilities({'sk_api': '0.3.0'}).supportsEndpointPayload,
      isFalse,
    );
    expect(
      const DeviceCapabilities({'sk_api': '0.4.0'}).supportsEndpointPayload,
      isFalse,
    );
  });

  test('missing book or empty set gates OFF', () {
    expect(
      const DeviceCapabilities({'sk_core': '0.1.0'}).supportsEndpointPayload,
      isFalse,
    );
    expect(DeviceCapabilities.none.supportsEndpointPayload, isFalse);
  });

  test('atLeast handles short/malformed segments as zero', () {
    expect(const DeviceCapabilities({'x': '1'}).atLeast('x', '0.9.9'), isTrue);
    expect(const DeviceCapabilities({'x': 'abc'}).atLeast('x', '0.0.1'),
        isFalse);
  });
}
