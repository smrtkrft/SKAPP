import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/cli/ble_transport.dart' show PairingRequiredException;
import 'package:skapp/core/cli/cli_session.dart' show BondMissingException;
import 'package:skapp/core/cli/cli_transport.dart' show AuthRejectedException;
import 'package:skapp/core/pairing/pairing_error.dart';

void main() {
  group('PairingErrorCode.fromWire', () {
    test('maps known ERR_* strings', () {
      expect(PairingErrorCode.fromWire('ERR_PAIRING_NOT_OPEN'),
          PairingErrorCode.pairingNotOpen);
      expect(PairingErrorCode.fromWire('ERR_BOND_STORE_FULL'),
          PairingErrorCode.bondStoreFull);
      expect(PairingErrorCode.fromWire('ERR_PASSPHRASE_INCORRECT'),
          PairingErrorCode.passphraseIncorrect);
      expect(PairingErrorCode.fromWire('ERR_NO_PENDING_BOND'),
          PairingErrorCode.noPendingBond);
    });
    test('unknown / null → rejected', () {
      expect(
          PairingErrorCode.fromWire('ERR_WHATEVER'), PairingErrorCode.rejected);
      expect(PairingErrorCode.fromWire(null), PairingErrorCode.rejected);
    });
  });

  group('isHardBondRejection', () {
    test('typed rejections are hard', () {
      expect(isHardBondRejection(BondRejectedError('device.info')), isTrue);
      expect(
          isHardBondRejection(const PairingRequiredException('no_bond')), isTrue);
      // Bond hiç yoksa reconnect matematiksel olarak imkânsızdır: tek çıkış
      // yeniden eşleşme. Transient saymak kullanıcıya "cihaza ulaşılamadı,
      // eşleşme korunuyor" gibi iki yönden yanlış bir mesaj gösteriyordu.
      expect(isHardBondRejection(BondMissingException('BF-TEST')), isTrue);
      expect(isHardBondRejection(const AuthRejectedException('mismatch')), isTrue);
      expect(
          isHardBondRejection(PairingException(
              PairingStage.awaitReply, PairingErrorCode.rejected,
              deviceErr: 'ERR_X')),
          isTrue);
    });
    test('transient errors are not', () {
      expect(isHardBondRejection(TimeoutException('t')), isFalse);
      expect(isHardBondRejection(StateError('CLI transport closed')), isFalse);
      expect(
          isHardBondRejection(PairingException(
              PairingStage.awaitReply, PairingErrorCode.timeout)),
          isFalse);
    });
  });

  test('PairingException toString carries stage/code/err', () {
    final e = PairingException(
        PairingStage.awaitReply, PairingErrorCode.timeout,
        detail: 'malformed=2');
    expect(e.toString(), contains('awaitReply'));
    expect(e.toString(), contains('timeout'));
    expect(e.toString(), contains('malformed=2'));
  });
}
