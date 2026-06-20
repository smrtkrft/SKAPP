// Self-signed TLS certificate management for the SKAPP HTTP listener
// (Faz B step 4). The desktop generates a fresh RSA-2048 key + X.509
// cert on first launch, persists both inside secure storage, and
// re-uses them for the rest of the install's lifetime. Mobile peers
// pin the SHA-256 fingerprint at pairing time, so even though the cert
// is not chained to a public CA the mobile side can detect MITM.
//
// Why self-signed:
//   - SKAPP listener is LAN-only and discovered via mDNS / manual IP.
//     There's no public DNS name for Let's Encrypt to attest, so a
//     CA-signed cert wouldn't help anyway.
//   - Trust anchor is the QR fingerprint shown at pairing — same
//     model as Tailscale, Syncthing, ZeroTier.
//
// Storage layout:
//   - Primary: flutter_secure_storage entries `tls.cert.v1` (PEM)
//     and `tls.key.v1` (PEM). Platform-native keystore on
//     Windows/macOS/iOS/Android; libsecret on Linux when present.
//   - Linux fallback: when libsecret is unavailable, fall through to
//     `<ApplicationSupportDirectory>/skapp_tls/cert.pem` +
//     `skapp_tls/key.pem`. The key file is written with mode 0600 to
//     keep it out of other users' reach.
//
// Rotation:
//   - `regenerate()` produces a brand-new cert+key, replaces the
//     stored entries, and bumps the fingerprint. Existing paired
//     peers will see a fingerprint mismatch on the next request and
//     have to re-pair. Settings exposes this as the "Yenile sertifika"
//     button under Developer mode.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:crypto/crypto.dart' as crypto_pkg;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

const _kCertKey = 'tls.cert.v1';
const _kKeyKey = 'tls.key.v1';

/// Bundle of certificate + private key + a precomputed fingerprint
/// suitable for pairing QR insertion. PEM strings are kept around for
/// `HttpServer.bindSecure` (which wants byte arrays) and the
/// fingerprint is the SHA-256 of the DER cert encoded as lowercase
/// hex without separators.
class SelfSignedCert {
  const SelfSignedCert({
    required this.certPem,
    required this.privateKeyPem,
    required this.fingerprintHex,
  });

  final String certPem;
  final String privateKeyPem;
  final String fingerprintHex;
}

/// Load the stored cert + key, or issue a fresh pair on first launch.
///
/// [uuid] is used as the certificate's Common Name so MITM attempts
/// against a different UUID can be cross-checked (Faz B step 1 uses
/// the UUID last-4 manual confirmation as the same trust anchor).
///
/// Async because the secure-storage / file-system reads are async and
/// because RSA-2048 keygen is CPU-bound enough to warrant offloading
/// later if startup latency becomes a concern (single-threaded Dart
/// makes it ~200-400 ms on modern desktops).
Future<SelfSignedCert> loadOrIssueCert({required String uuid}) async {
  if (kIsWeb) {
    throw StateError(
      'TLS listener is not supported on web — bindSecure has no analogue '
      'in dart:js_interop.',
    );
  }
  final read = await _readCert();
  if (read != null) return read;
  final issued = _issueCert(uuid: uuid);
  await _writeCert(issued);
  return issued;
}

/// Forced re-issue. Used by the Settings "rotate cert" action.
Future<SelfSignedCert> regenerateCert({required String uuid}) async {
  final fresh = _issueCert(uuid: uuid);
  await _writeCert(fresh);
  return fresh;
}

// ---------------------------------------------------------------------
// Storage layer
// ---------------------------------------------------------------------

Future<SelfSignedCert?> _readCert() async {
  // Try secure storage first.
  try {
    const storage = FlutterSecureStorage();
    final certPem = await storage.read(key: _kCertKey);
    final keyPem = await storage.read(key: _kKeyKey);
    if (certPem != null && keyPem != null) {
      return SelfSignedCert(
        certPem: certPem,
        privateKeyPem: keyPem,
        fingerprintHex: _fingerprintFromPem(certPem),
      );
    }
  } catch (e) {
    debugPrint('[self-signed-cert] secure storage read failed: $e');
  }
  // Fall back to on-disk file (Linux without libsecret).
  try {
    final dir = await _fallbackDir();
    final certFile = File('${dir.path}${Platform.pathSeparator}cert.pem');
    final keyFile = File('${dir.path}${Platform.pathSeparator}key.pem');
    if (await certFile.exists() && await keyFile.exists()) {
      final certPem = await certFile.readAsString();
      final keyPem = await keyFile.readAsString();
      return SelfSignedCert(
        certPem: certPem,
        privateKeyPem: keyPem,
        fingerprintHex: _fingerprintFromPem(certPem),
      );
    }
  } catch (e) {
    debugPrint('[self-signed-cert] file fallback read failed: $e');
  }
  return null;
}

Future<void> _writeCert(SelfSignedCert cert) async {
  // Always attempt secure storage; the platform-native keystore is
  // the right home for a private key when it works.
  var secureOk = false;
  try {
    const storage = FlutterSecureStorage();
    await storage.write(key: _kCertKey, value: cert.certPem);
    await storage.write(key: _kKeyKey, value: cert.privateKeyPem);
    secureOk = true;
  } catch (e) {
    debugPrint('[self-signed-cert] secure storage write failed: $e');
  }
  // Mirror to disk on Linux fallback path too. On Windows/macOS the
  // file is redundant and we deliberately skip writing it so the only
  // copy of the private key lives in the keystore.
  if (!secureOk && Platform.isLinux) {
    try {
      final dir = await _fallbackDir();
      await dir.create(recursive: true);
      final certFile = File('${dir.path}${Platform.pathSeparator}cert.pem');
      final keyFile = File('${dir.path}${Platform.pathSeparator}key.pem');
      await certFile.writeAsString(cert.certPem);
      await keyFile.writeAsString(cert.privateKeyPem);
      // Tighten the key file's permissions to owner-only (0600).
      try {
        await Process.run('chmod', ['600', keyFile.path]);
      } catch (_) {}
      // Madde 16: chmod best-effort'tu — FAT/exFAT mount'unda ya da chmod
      // fail durumunda key world-readable kalabilir. Yazımdan sonra modu
      // doğrula; group/other'a herhangi bir erişim biti açıksa diski
      // bırakmak yerine SİL (çok-kullanıcılı makinede başka kullanıcının
      // private key'i okuyup MITM yapmasını engelle). Bir sonraki başlangıç
      // anahtarı yeniden üretir; bu çalışmada TLS RAM-only cert ile devam.
      try {
        final mode = keyFile.statSync().mode;
        if (mode & 0x3F != 0) {
          debugPrint('[self-signed-cert] key file world/group-readable '
              '(mode=${(mode & 0x1FF).toRadixString(8)}); deleting insecure '
              'disk copy — TLS key will live RAM-only this run');
          try {
            await keyFile.delete();
          } catch (_) {}
        }
      } catch (e) {
        debugPrint('[self-signed-cert] key mode verify failed: $e');
      }
    } catch (e) {
      debugPrint('[self-signed-cert] file fallback write failed: $e');
    }
  }
}

Future<Directory> _fallbackDir() async {
  final base = await getApplicationSupportDirectory();
  return Directory('${base.path}${Platform.pathSeparator}skapp_tls');
}

// ---------------------------------------------------------------------
// Issuance
// ---------------------------------------------------------------------

SelfSignedCert _issueCert({required String uuid}) {
  final pair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
  final private = pair.privateKey as RSAPrivateKey;
  final public = pair.publicKey as RSAPublicKey;

  // Subject + issuer share the same identity since this is self-
  // signed. Common Name is the UUID — same trust anchor as the manual
  // pairing UUID confirmation, so a malicious cert with a different
  // CN will look obviously wrong to a debugging human and to
  // automated tooling that compares CN against the paired peer.
  final dn = {'CN': uuid};
  final csrPem = X509Utils.generateRsaCsrPem(dn, private, public);
  final certPem = X509Utils.generateSelfSignedCertificate(
    private,
    csrPem,
    365 * 5, // 5-year validity, easily covers SKAPP install lifetimes
  );
  final keyPem = CryptoUtils.encodeRSAPrivateKeyToPem(private);
  return SelfSignedCert(
    certPem: certPem,
    privateKeyPem: keyPem,
    fingerprintHex: _fingerprintFromPem(certPem),
  );
}

String _fingerprintFromPem(String pem) {
  // basic_utils ships the cert as PEM; extract the DER bytes and hash.
  // Strip header/footer, drop whitespace, base64-decode.
  final inner = pem
      .replaceAll('-----BEGIN CERTIFICATE-----', '')
      .replaceAll('-----END CERTIFICATE-----', '')
      .replaceAll(RegExp(r'\s+'), '');
  final der = base64Decode(inner);
  final digest = crypto_pkg.sha256.convert(der);
  // Lowercase hex without separators — matches the wire format used
  // in `SkappPairingPayload.certFingerprint` and the mobile pinning
  // comparison.
  final buf = StringBuffer();
  for (final b in digest.bytes) {
    buf.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return buf.toString();
}
