// Eşleştirme akışının TÜM süre bütçeleri. Değerler gerekçeli: dağınık
// satır-içi literal'lerin (8 dosyada ~35 adet) tek toplama noktası.
// Invariant: bir dış sarmalayıcı, sardığı iç aşamaların toplamından KISA
// olamaz (test: timeout_budget_test.dart).

class PairingTimeouts {
  PairingTimeouts._();

  /// ECDH cevabı: ESP32 tarafında X25519 + NVS bond persist + notify
  /// gecikmesi. Eski 8 s yavaş-ama-sağlıklı cihazları kesiyordu (süre
  /// kısıtlaması kaynaklı eşleşme hatalarının ana sınıfı). Bonded-greeting
  /// atlama döngüsü de (TCP re-pair) aynı toplam bütçeyi paylaşır.
  static const replyDeadline = Duration(seconds: 20);

  /// pairing.passphrase.verify cevabı — iki taşıyıcıda da aynı (eski: BLE 8s,
  /// TCP 12s tutarsızdı).
  static const passphraseReply = Duration(seconds: 12);

  /// Yazma hatası affı: firmware cevabı gönderir göndermez linki
  /// kapatabildiği için havadaki GATT/TCP write, TESLİM EDİLMİŞ olsa bile
  /// exception fırlatır. Cevap bu pencere içinde gelirse yazma hatası
  /// zararsız sayılır.
  static const benignWriteGrace = Duration(milliseconds: 400);

  static const tcpConnect = Duration(seconds: 5);
  static const writeChunk = Duration(seconds: 5);

  // BLE bootstrap GATT aşamaları (pairing_screen._runFlow):
  static const bleDisconnect = Duration(seconds: 3);
  static const bleDisconnectSettle = Duration(milliseconds: 300);
  static const bleConnect = Duration(seconds: 10);
  static const bleConnectOuter = Duration(seconds: 12);
  static const bleMtu = Duration(seconds: 5);
  static const bleDiscover = Duration(seconds: 8);
  static const bleSubscribe = Duration(seconds: 5);

  /// NimBLE + Android link teardown payı (ampirik 800ms→1800ms; cihaz gatt
  /// logları "ECDH complete" → "advertising pairable=0" arası ~250 ms
  /// gösteriyor, Android'in kendi teardown'ı da pay ister).
  static const blePostPairSettle = Duration(milliseconds: 1800);
  static const tcpPostPairSettle = Duration(milliseconds: 600);
  static const reconnectDoneDwell = Duration(milliseconds: 350);
}
