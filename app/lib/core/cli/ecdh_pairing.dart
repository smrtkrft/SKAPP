// Curve25519 ECDH bonding helper.
//
// Mirrors sk_auth_ecdh.c on the device side:
//   * X25519 ephemeral keypair
//   * Shared secret computed by both parties
//   * Token = SHA256("sk_auth_token_v1" || shared_secret), 32 bytes
//
// Wire protocol (defined by sk_transport_ble_gatt.c::pairing_handle_line):
//   APP    → device: {"cmd":"pairing.ecdh.exchange","args":{"peer_pub":"<32hex>"}}
//   device → APP   : {"ok":true,"data":{"our_pub":"<32hex>"}}
// After the reply, the device closes the BLE link. APP reconnects with the
// derived token via the regular HMAC handshake.

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto_pkg;
import 'package:cryptography/cryptography.dart';

class EcdhBondResult {
  EcdhBondResult({required this.token, required this.peerPublic});

  /// Derived 32-byte session token. Persist this in BondStore.
  final Uint8List token;

  /// Device's public key (informational, we already used it to derive
  /// the token, but it can be useful for diagnostics or audit logs).
  final Uint8List peerPublic;
}

class EcdhPairing {
  EcdhPairing({X25519? algorithm}) : _x25519 = algorithm ?? X25519();

  final X25519 _x25519;

  /// Generates an ephemeral X25519 keypair. Returns the bond result by
  /// `complete(...)`-ing with the device's public key reply.
  Future<EphemeralPairing> begin() async {
    final keyPair = await _x25519.newKeyPair();
    final pub = await keyPair.extractPublicKey();
    return EphemeralPairing._(_x25519, keyPair, Uint8List.fromList(pub.bytes));
  }
}

class EphemeralPairing {
  EphemeralPairing._(this._x25519, this._keyPair, this.ourPublic);

  final X25519 _x25519;
  final SimpleKeyPair _keyPair;

  /// Our 32-byte X25519 public key. Send this to the device as the
  /// `peer_pub` arg of `pairing.ecdh.exchange`.
  final Uint8List ourPublic;

  /// Derive the session token from the device's public key. Mirrors the
  /// device-side derive_token(), SHA256(label || shared_secret).
  Future<EcdhBondResult> complete(Uint8List peerPublic) async {
    if (peerPublic.length != 32) {
      throw ArgumentError(
          'peer_pub must be 32 bytes (got ${peerPublic.length})');
    }

    final remote = SimplePublicKey(peerPublic, type: KeyPairType.x25519);
    final secret = await _x25519.sharedSecretKey(
      keyPair: _keyPair,
      remotePublicKey: remote,
    );
    final secretBytes =
        Uint8List.fromList(await secret.extractBytes());

    // SHA256("sk_auth_token_v1" || shared_secret)
    final input = BytesBuilder(copy: false)
      ..add(utf8.encode('sk_auth_token_v1'))
      ..add(secretBytes);
    final digest = crypto_pkg.sha256.convert(input.toBytes()).bytes;

    return EcdhBondResult(
      token: Uint8List.fromList(digest),
      peerPublic: peerPublic,
    );
  }
}
