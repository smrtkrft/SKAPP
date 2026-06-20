// Faz 1 — saf-mantık testi: HMAC imzalama/doğrulama.
//
// hmac_signer.dart ([lib/core/network/hmac_signer.dart]) SKAPP HTTP
// listener trafiğinin imza/doğrulama çekirdeği. computeSignature kanonik
// biçimin tek kaynağı; HmacRequestVerifier zaman penceresi + nonce replay
// korumasını uygular. Bu testler davranışı kilitler.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/network/hmac_signer.dart';

void main() {
  const token = 'test-secret-token';
  const method = 'POST';
  const path = '/api/scripts/win/toast/run';
  const body = '{"params":{}}';

  group('computeSignature', () {
    test('deterministik: aynı girdi aynı imza', () {
      final a = computeSignature(
          token: token, method: method, path: path, unixMillis: 1000, body: body);
      final b = computeSignature(
          token: token, method: method, path: path, unixMillis: 1000, body: body);
      expect(a, equals(b));
      expect(a.length, 64); // hex SHA-256
    });

    test('method büyük harfe normalize edilir', () {
      final lower = computeSignature(
          token: token, method: 'post', path: path, unixMillis: 1, body: body);
      final upper = computeSignature(
          token: token, method: 'POST', path: path, unixMillis: 1, body: body);
      expect(lower, equals(upper));
    });

    test('token / ts / body değişince imza değişir', () {
      final base = computeSignature(
          token: token, method: method, path: path, unixMillis: 1, body: body);
      expect(
          computeSignature(
              token: 'other', method: method, path: path, unixMillis: 1, body: body),
          isNot(base));
      expect(
          computeSignature(
              token: token, method: method, path: path, unixMillis: 2, body: body),
          isNot(base));
      expect(
          computeSignature(
              token: token, method: method, path: path, unixMillis: 1, body: 'x'),
          isNot(base));
    });
  });

  group('buildAuthorizationHeader', () {
    test('SKAPP-HMAC <uuid>:<ts>:<sig> biçimi üretir', () {
      final now = DateTime.fromMillisecondsSinceEpoch(1700000000000);
      final h = buildAuthorizationHeader(
        peerUuid: 'peer-1',
        token: token,
        method: method,
        path: path,
        body: body,
        now: now,
      );
      expect(h.startsWith('SKAPP-HMAC '), isTrue);
      final env = h.substring('SKAPP-HMAC '.length).split(':');
      expect(env, hasLength(3));
      expect(env[0], 'peer-1');
      expect(env[1], '1700000000000');
      expect(env[2].length, 64);
    });

    test('üretilen header verifier tarafından kabul edilir (round-trip)', () {
      final verifier =
          HmacRequestVerifier(tokenLookup: (uuid) => uuid == 'peer-1' ? token : null);
      final h = buildAuthorizationHeader(
        peerUuid: 'peer-1',
        token: token,
        method: method,
        path: path,
        body: body,
      );
      final r = verifier.verify(
          authorizationHeader: h, method: method, path: path, body: body);
      expect(r.ok, isTrue);
      expect(r.peerUuid, 'peer-1');
    });
  });

  group('HmacRequestVerifier.verify · ret yolları', () {
    HmacRequestVerifier makeVerifier() =>
        HmacRequestVerifier(tokenLookup: (uuid) => uuid == 'peer-1' ? token : null);

    String freshHeader({String peer = 'peer-1', String tok = token}) =>
        buildAuthorizationHeader(
            peerUuid: peer, token: tok, method: method, path: path, body: body);

    test('SKAPP-HMAC öneki yoksa malformed_header', () {
      final r = makeVerifier().verify(
          authorizationHeader: 'Bearer abc',
          method: method,
          path: path,
          body: body);
      expect(r.ok, isFalse);
      expect(r.code, 'malformed_header');
      expect(r.statusCode, 400);
    });

    test('üç parçalı olmayan zarf malformed_header', () {
      final r = makeVerifier().verify(
          authorizationHeader: 'SKAPP-HMAC peer-1:123',
          method: method,
          path: path,
          body: body);
      expect(r.code, 'malformed_header');
    });

    test('geçersiz hex uzunluğu malformed_header', () {
      final r = makeVerifier().verify(
          authorizationHeader: 'SKAPP-HMAC peer-1:123:deadbeef',
          method: method,
          path: path,
          body: body);
      expect(r.code, 'malformed_header');
    });

    test('pencere dışı timestamp stale_request', () {
      final old = DateTime.now().subtract(const Duration(minutes: 10));
      final h = buildAuthorizationHeader(
          peerUuid: 'peer-1',
          token: token,
          method: method,
          path: path,
          body: body,
          now: old);
      final r = makeVerifier()
          .verify(authorizationHeader: h, method: method, path: path, body: body);
      expect(r.ok, isFalse);
      expect(r.code, 'stale_request');
      expect(r.statusCode, 401);
    });

    test('bilinmeyen peer unknown_peer', () {
      final h = freshHeader(peer: 'ghost');
      final r = makeVerifier()
          .verify(authorizationHeader: h, method: method, path: path, body: body);
      expect(r.code, 'unknown_peer');
    });

    test('yanlış token ile imza invalid_signature', () {
      // Header doğru peer ama yanlış token ile imzalanır → sunucu doğru token
      // ile yeniden hesaplar, uyuşmaz.
      final h = freshHeader(tok: 'wrong-token');
      final r = makeVerifier()
          .verify(authorizationHeader: h, method: method, path: path, body: body);
      expect(r.code, 'invalid_signature');
    });

    test('aynı zarf ikinci kez replay_detected', () {
      final verifier = makeVerifier();
      final h = freshHeader();
      final first = verifier.verify(
          authorizationHeader: h, method: method, path: path, body: body);
      expect(first.ok, isTrue);
      final second = verifier.verify(
          authorizationHeader: h, method: method, path: path, body: body);
      expect(second.ok, isFalse);
      expect(second.code, 'replay_detected');
      expect(second.statusCode, 409);
    });
  });

  group('constantTimeEq', () {
    test('eşit stringler', () {
      expect(constantTimeEq('abcd', 'abcd'), isTrue);
    });
    test('farklı içerik', () {
      expect(constantTimeEq('abcd', 'abce'), isFalse);
    });
    test('farklı uzunluk', () {
      expect(constantTimeEq('abc', 'abcd'), isFalse);
    });
  });
}
