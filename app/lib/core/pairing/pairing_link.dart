// Eşleştirme (pre-bond) konuşması için taşıyıcı soyutlaması. BLE GATT ve
// TCP, aynı NDJSON protokolünü konuşur; PairingSession tek durum
// makinesini bu arayüz üstünde çalıştırır. Satır ayrıştırma hataları
// SESSİZCE YUTULMAZ: link ham satırları verir, session parse edip
// malformed sayacını tutar.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'pairing_timeouts.dart';

/// Chunk akışından \n-ayrımlı satırlar üretir. Hem linkler hem transportlar
/// için ortak; boş satırları atar.
class NdjsonLineBuffer {
  final _buf = StringBuffer();

  List<String> feed(String chunk) {
    _buf.write(chunk);
    final out = <String>[];
    while (true) {
      final s = _buf.toString();
      final nl = s.indexOf('\n');
      if (nl < 0) break;
      final line = s.substring(0, nl);
      _buf
        ..clear()
        ..write(s.substring(nl + 1));
      if (line.isNotEmpty) out.add(line);
    }
    return out;
  }
}

abstract class PairingLink {
  /// Cihazdan gelen NDJSON satırları. Link koptuğunda stream kapanır;
  /// taşıyıcı hatası stream error olarak düşer (dinleyici karar verir).
  Stream<String> get lines;

  Future<void> sendJson(Map<String, dynamic> obj);

  Future<void> close();
}

class TcpPairingLink implements PairingLink {
  TcpPairingLink._(this._socket) {
    _sub = utf8.decoder.bind(_socket).listen(
      (chunk) {
        for (final line in _lineBuf.feed(chunk)) {
          _lines.add(line);
        }
      },
      onError: (Object e, StackTrace st) {
        // Soket okuma hatası: dinleyiciye AYNEN ilet — "cevap yok" ile
        // "bağlantı sıfırlandı" ayırt edilebilir kalmalı.
        _lines.addError(e, st);
      },
      onDone: () {
        if (!_lines.isClosed) _lines.close();
      },
    );
  }

  static Future<TcpPairingLink> connect(String host, int port,
      {Duration timeout = PairingTimeouts.tcpConnect}) async {
    final socket = await Socket.connect(host, port, timeout: timeout);
    return TcpPairingLink._(socket);
  }

  final Socket _socket;
  final _lines = StreamController<String>.broadcast();
  final _lineBuf = NdjsonLineBuffer();
  StreamSubscription<String>? _sub;

  @override
  Stream<String> get lines => _lines.stream;

  @override
  Future<void> sendJson(Map<String, dynamic> obj) async {
    _socket.add(utf8.encode('${jsonEncode(obj)}\n'));
    await _socket.flush();
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    _sub = null;
    _socket.destroy();
    if (!_lines.isClosed) await _lines.close();
  }
}

/// GATT karakteristikleri üstünde pairing linki. Cihaz bağlantısı ve GATT
/// keşfi EKRANDA kalır (UI aşamaları oraya bağlı); bu sınıf notify aboneliği
/// + chunk'lı yazmayı üstlenir. [start] listener'ı CCCD'den ÖNCE bağlar —
/// aksi halde subscribe anında yayınlanan ilk notify kaçabilir (macOS
/// yarışı, d0a6ad1 kök nedeni).
class BlePairingLink implements PairingLink {
  BlePairingLink({required this.cmdRx, required this.eventTx});

  final BluetoothCharacteristic cmdRx;
  final BluetoothCharacteristic eventTx;

  final _lines = StreamController<String>.broadcast();
  final _lineBuf = NdjsonLineBuffer();
  StreamSubscription<List<int>>? _notifySub;

  @override
  Stream<String> get lines => _lines.stream;

  Future<void> start() async {
    _notifySub = eventTx.onValueReceived.listen((bytes) {
      for (final line
          in _lineBuf.feed(utf8.decode(bytes, allowMalformed: true))) {
        _lines.add(line);
      }
    });
    await eventTx.setNotifyValue(true).timeout(PairingTimeouts.bleSubscribe);
  }

  @override
  Future<void> sendJson(Map<String, dynamic> obj) async {
    final bytes = utf8.encode('${jsonEncode(obj)}\n');
    const chunk = 180; // MTU 247 altı güvenli taban (bkz. ble_transport)
    for (var i = 0; i < bytes.length; i += chunk) {
      final end = (i + chunk > bytes.length) ? bytes.length : i + chunk;
      await cmdRx
          .write(bytes.sublist(i, end), withoutResponse: false)
          .timeout(PairingTimeouts.writeChunk);
    }
  }

  @override
  Future<void> close() async {
    await _notifySub?.cancel();
    _notifySub = null;
    if (!_lines.isClosed) await _lines.close();
  }
}
