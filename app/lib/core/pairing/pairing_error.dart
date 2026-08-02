// Tipli eşleştirme hata modeli. Eski substring sınıflandırması
// (e.toString().contains('err_') / 'reddedildi') locale'e bağımlıydı ve
// asıl sebebi yok ediyordu; artık her eşleştirme hatası aşama + kod +
// ham cihaz hatası + altta yatan cause ile taşınır. UI son anda locale'e
// çevirir, debug trail teknik detayı korur.

import '../cli/ble_transport.dart' show PairingRequiredException;
import '../cli/cli_session.dart' show BondMissingException;
import '../cli/cli_transport.dart' show AuthRejectedException;

enum PairingStage {
  connect,
  discover,
  keygen,
  exchange,
  awaitReply,
  passphrase,
  persist,
  session,
}

enum PairingErrorCode {
  pairingNotOpen('ERR_PAIRING_NOT_OPEN'),
  bondStoreFull('ERR_BOND_STORE_FULL'),
  passphraseIncorrect('ERR_PASSPHRASE_INCORRECT'),
  passphraseLockout(null),
  noPendingBond('ERR_NO_PENDING_BOND'),
  timeout(null),
  linkClosed(null),
  invalidReply(null),
  storage(null),
  cancelled(null),
  rejected(null);

  const PairingErrorCode(this.wire);

  /// Cihazın döndürdüğü ham ERR_* karşılığı (yoksa null).
  final String? wire;

  static PairingErrorCode fromWire(String? err) {
    if (err == null) return PairingErrorCode.rejected;
    for (final c in values) {
      if (c.wire == err) return c;
    }
    return PairingErrorCode.rejected;
  }
}

class PairingException implements Exception {
  PairingException(this.stage, this.code,
      {this.deviceErr, this.cause, this.stackTrace, this.params, this.detail});

  final PairingStage stage;
  final PairingErrorCode code;

  /// Cihazın ham ERR_* string'i (ok:false cevabından), varsa.
  final String? deviceErr;
  final Object? cause;
  final StackTrace? stackTrace;

  /// Cevap zarfındaki params (örn. bondStoreFull → peers listesi,
  /// passphrase → attempts_left).
  final Map<String, dynamic>? params;
  final String? detail;

  @override
  String toString() {
    final b = StringBuffer('PairingException(${stage.name}/${code.name}');
    if (deviceErr != null) b.write(', err=$deviceErr');
    if (detail != null) b.write(', $detail');
    if (cause != null) b.write(', cause=$cause');
    b.write(')');
    return b.toString();
  }
}

/// Cihazın mevcut bond'u AÇIKÇA reddettiğini gösterir (device.info ok:false
/// vb.). pairing_screen reconnect'i bunu görünce bond'u temizleyip
/// bootstrap'a düşer; transient hatalarda (timeout, link drop) bond korunur.
class BondRejectedError implements Exception {
  BondRejectedError(this.code);
  final String code;
  @override
  String toString() => 'bond reddedildi: $code';
}

/// Eski stringly-typed sınıflandırmanın tipli karşılığı. "Hard rejection" =
/// cihaz bond'u aktif reddetti → bond silinip yeniden eşleşme doğru tepki.
/// Diğer her şey transient sayılır: bond korunur, kullanıcıya retry sunulur.
bool isHardBondRejection(Object e) {
  return e is BondRejectedError ||
      e is PairingRequiredException ||
      e is AuthRejectedException ||
      // Bond hiç yoksa reconnect imkânsızdır; tek çıkış yeniden eşleşme.
      // Transient saymak, "cihaza ulaşılamadı, mevcut eşleşme korunuyor"
      // gibi iki yönden yanlış bir mesajla sonsuz retry döngüsü üretiyordu.
      e is BondMissingException ||
      (e is PairingException &&
          (e.code == PairingErrorCode.rejected ||
              e.code == PairingErrorCode.pairingNotOpen));
}
