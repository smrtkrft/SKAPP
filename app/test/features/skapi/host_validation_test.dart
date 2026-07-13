// isValidHostOrIp — type:"host" param'larının IP/hostname doğrulaması
// (0.4.15 form-önce işi). Bariz-hatalı girişi formda yakalar; son söz firmware.
import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/skapi_template_detail_screen.dart';

void main() {
  group('isValidHostOrIp — geçerli', () {
    for (final v in const [
      '10.212.96.206',
      '192.168.1.1',
      '0.0.0.0',
      '255.255.255.255',
      'SD-BNBWT4RDP.local',
      'shelly.local',
      'homeassistant',
      'my-device.lan',
    ]) {
      test(v, () => expect(isValidHostOrIp(v), isTrue));
    }
  });

  group('isValidHostOrIp — geçersiz', () {
    for (final v in const [
      '',
      '   ',
      '256.1.1.1', // oktet > 255
      '10.212.96', // eksik oktet
      '10.212.96.206.7', // fazla oktet
      'http://10.0.0.5', // şema
      '10.0.0.5:8080', // port ekli
      'iki kelime',
      '-baştan-tire',
      'nokta..çift',
    ]) {
      test("'$v'", () => expect(isValidHostOrIp(v), isFalse));
    }
  });
}
