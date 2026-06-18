// SKAPP-side wrapper around the device's `secure.*` and `userdata.*` CLI
// commands (implemented by bf_secure_store on the firmware).
//
// Both surfaces require an authenticated session: the device dispatcher
// rejects any matching command unless it arrived through the HMAC envelope
// path. That means a CliClient passed in here MUST already have a `signer`
// attached (post-handshake). Calls made on a pre-bond client will surface
// `ERR_NOT_AUTHENTICATED` errors.
//
// The 100 KB user-script blob is byte-addressable; `userdataRead` /
// `userdataWrite` take care of chunking so callers can hand in or pull out
// arbitrary lengths up to the firmware-side capacity.

import 'dart:convert';
import 'dart:typed_data';

import 'cli_client.dart';

class SecureStoreException implements Exception {
  SecureStoreException(this.code, [this.params]);
  final String code;
  final Map<String, dynamic>? params;
  @override
  String toString() => 'SecureStoreException($code)';
}

class SecureStoreClient {
  SecureStoreClient(this._cli);

  final CliClient _cli;

  // Firmware-side per-call read cap (USERDATA_CLI_CHUNK in
  // bf_secure_store.c). Keep in lockstep when changing firmware.
  static const int _chunkSize = 4096;

  // ---- KV API -------------------------------------------------------------

  /// Returns the decrypted value for [key], or `null` if it's not set.
  Future<String?> get(String key) async {
    final r = await _cli.send('secure.get', args: {'key': key});
    if (r.ok) return (r.data as Map)['value'] as String?;
    if (r.err == 'ERR_NOT_FOUND') return null;
    throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
  }

  /// Persists [value] under [key]. Existing entries are overwritten.
  Future<void> set(String key, String value) async {
    final r = await _cli.send('secure.set', args: {'key': key, 'value': value});
    if (!r.ok) throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
  }

  Future<void> erase(String key) async {
    final r = await _cli.send('secure.erase', args: {'key': key});
    if (!r.ok && r.err != 'ERR_NOT_FOUND') {
      throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
    }
  }

  /// Returns the current key names. Order is the firmware's insertion
  /// order, callers shouldn't rely on it being sorted.
  Future<List<String>> list() async {
    final r = await _cli.send('secure.list');
    if (!r.ok) throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
    final keys = (r.data as Map)['keys'] as List;
    return keys.cast<String>();
  }

  // ---- Userdata blob ------------------------------------------------------

  /// Total logical size of the user-script blob in bytes. 0 on first run.
  Future<int> userdataSize() async {
    final r = await _cli.send('userdata.size');
    if (!r.ok) throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
    return ((r.data as Map)['size'] as num).toInt();
  }

  /// Read `[offset, offset+len)` from the blob. The firmware caps each
  /// envelope at 4 KB, so this method calls `userdata.read` repeatedly
  /// and concatenates. If `len == null`, reads from `offset` to the end.
  Future<Uint8List> userdataRead({int offset = 0, int? len}) async {
    int remaining = len ?? (await userdataSize()) - offset;
    if (remaining <= 0) return Uint8List(0);
    final builder = BytesBuilder(copy: false);
    int cursor = offset;
    while (remaining > 0) {
      final take = remaining < _chunkSize ? remaining : _chunkSize;
      final r = await _cli.send('userdata.read',
          args: {'offset': '$cursor', 'len': '$take'});
      if (!r.ok) {
        throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
      }
      final data = r.data as Map;
      final actual = (data['len'] as num).toInt();
      if (actual == 0) break;        // hit EOF early
      final b64 = data['data_b64'] as String;
      builder.add(base64Decode(b64));
      cursor += actual;
      remaining -= actual;
      if (actual < take) break;      // partial = end-of-blob
    }
    return builder.toBytes();
  }

  /// Convenience: read the entire blob and decode it as UTF-8 text.
  Future<String> userdataReadString() async {
    final bytes = await userdataRead();
    return utf8.decode(bytes, allowMalformed: true);
  }

  /// Write `bytes` starting at `offset`. Chunks above 4 KB are split
  /// transparently. Use [userdataTruncate] afterwards if the new logical
  /// size should be smaller than what's already on the device.
  Future<void> userdataWrite(Uint8List bytes, {int offset = 0}) async {
    int cursor = offset;
    int remaining = bytes.length;
    int srcOff = 0;
    while (remaining > 0) {
      final take = remaining < _chunkSize ? remaining : _chunkSize;
      final slice = bytes.sublist(srcOff, srcOff + take);
      final r = await _cli.send('userdata.write', args: {
        'offset': '$cursor',
        'data_b64': base64Encode(slice),
      });
      if (!r.ok) {
        throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
      }
      cursor    += take;
      srcOff    += take;
      remaining -= take;
    }
  }

  /// Convenience: replace the entire blob with [text]. Truncates afterwards
  /// so any leftover bytes from a previously-larger blob are dropped.
  Future<void> userdataWriteString(String text) async {
    final bytes = Uint8List.fromList(utf8.encode(text));
    await userdataWrite(bytes);
    await userdataTruncate(bytes.length);
  }

  Future<void> userdataTruncate(int size) async {
    final r = await _cli.send('userdata.truncate', args: {'size': '$size'});
    if (!r.ok) throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
  }

  /// Wipes the user-script blob. Requires a confirm token; either pass
  /// one obtained from `device.confirm-token`, or use
  /// [CliClient.sendCritical] which drives the firmware's auto-issue
  /// flow end-to-end.
  Future<void> userdataClear({required String confirmToken}) async {
    final r = await _cli
        .send('userdata.clear', confirmToken: confirmToken);
    if (!r.ok) throw SecureStoreException(r.err ?? 'ERR_INTERNAL', r.params);
  }
}
