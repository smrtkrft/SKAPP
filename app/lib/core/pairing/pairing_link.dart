// Eşleştirme (pre-bond) konuşması için taşıyıcı soyutlaması. BLE GATT ve
// TCP, aynı NDJSON protokolünü konuşur; PairingSession tek durum
// makinesini bu arayüz üstünde çalıştırır. Satır ayrıştırma hataları
// SESSİZCE YUTULMAZ: link ham satırları verir, session parse edip
// malformed sayacını tutar.
//
// Linkler ayrıca [onTrace] ile ham byte/satır izleri yayınlar. Bu izler
// ekrandaki debug paneline düşer ve "cihaz hiç cevap vermedi" ile "cevap
// geldi ama satır tamamlanmadı" (\n eksik / MTU fragmentasyonu) ayrımını
// mümkün kılar — logcat'i olmayan kullanıcı için tek teşhis kanalı.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'pairing_timeouts.dart';

/// Bir NDJSON satırı [NdjsonLineBuffer.maxLineBytes] sınırını aştığında
/// fırlatılır. Karşı uç `\n` göndermiyorsa tampon sınırsız büyür (bellek)
/// ve her feed O(n²) CPU yakar; docs/ihlal.md İ-10 bu durumda bağlantının
/// kesilmesini şart koşar.
class PairingLineOverflow implements Exception {
  const PairingLineOverflow(this.bytes, this.limit);
  final int bytes;
  final int limit;
  @override
  String toString() =>
      'PairingLineOverflow(line exceeded $limit B — buffered $bytes B)';
}

/// Chunk akışından \n-ayrımlı satırlar üretir. Hem linkler hem transportlar
/// için ortak; boş satırları atar. Satır uzunluğu [maxLineBytes] ile
/// sınırlıdır.
class NdjsonLineBuffer {
  NdjsonLineBuffer({this.maxLineBytes = 64 * 1024});

  /// Tek satır için üst sınır. Eşleştirme zarfları birkaç yüz byte;
  /// 64 KiB fazlasıyla cömert bir tavan, ama sınırsız büyümeyi keser.
  final int maxLineBytes;

  final _buf = StringBuffer();

  List<String> feed(String chunk) {
    _buf.write(chunk);
    final out = <String>[];
    while (true) {
      final s = _buf.toString();
      final nl = s.indexOf('\n');
      if (nl < 0) {
        if (s.length > maxLineBytes) {
          _buf.clear();
          throw PairingLineOverflow(s.length, maxLineBytes);
        }
        break;
      }
      final line = s.substring(0, nl);
      _buf
        ..clear()
        ..write(s.substring(nl + 1));
      if (line.isNotEmpty) out.add(line);
    }
    return out;
  }
}

typedef PairingLinkTrace = void Function(String message);

abstract class PairingLink {
  /// Cihazdan gelen NDJSON satırları. Link koptuğunda stream kapanır;
  /// taşıyıcı hatası stream error olarak düşer (dinleyici karar verir).
  Stream<String> get lines;

  Future<void> sendJson(Map<String, dynamic> obj);

  Future<void> close();
}

class TcpPairingLink implements PairingLink {
  TcpPairingLink._(this._socket, this._onTrace) {
    _sub = utf8.decoder.bind(_socket).listen(
      _onChunk,
      onError: (Object e, StackTrace st) {
        // Soket okuma hatası: dinleyiciye AYNEN ilet — "cevap yok" ile
        // "bağlantı sıfırlandı" ayırt edilebilir kalmalı.
        _trace('rx error: $e');
        _lines.addError(e, st);
      },
      onDone: () {
        _trace('link closed by peer');
        if (!_lines.isClosed) _lines.close();
      },
    );
  }

  static Future<TcpPairingLink> connect(
    String host,
    int port, {
    Duration timeout = PairingTimeouts.tcpConnect,
    PairingLinkTrace? onTrace,
  }) async {
    final socket = await Socket.connect(host, port, timeout: timeout);
    return TcpPairingLink._(socket, onTrace);
  }

  final Socket _socket;
  final PairingLinkTrace? _onTrace;
  final _lines = StreamController<String>.broadcast();
  final _lineBuf = NdjsonLineBuffer();
  StreamSubscription<String>? _sub;

  void _trace(String s) => _onTrace?.call(s);

  void _onChunk(String chunk) {
    _trace('rx ${chunk.length}B');
    try {
      for (final line in _lineBuf.feed(chunk)) {
        _lines.add(line);
      }
    } on PairingLineOverflow catch (e, st) {
      // İ-10: taşan satır = bozuk/hasım uç. Bağlantıyı kes ve sebebi ilet.
      _trace('$e — link kapatılıyor');
      _lines.addError(e, st);
      close();
    }
  }

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
  BlePairingLink({
    required this.cmdRx,
    required this.eventTx,
    this.device,
    PairingLinkTrace? onTrace,
  }) : _onTrace = onTrace;

  final BluetoothCharacteristic cmdRx;
  final BluetoothCharacteristic eventTx;

  /// Kopuş izlemek için cihaz handle'ı. Verilmezse link, bağlantı düşüşünü
  /// göremez ve oturum cevap bütçesini boşa bekler.
  final BluetoothDevice? device;

  final PairingLinkTrace? _onTrace;
  final _lines = StreamController<String>.broadcast();
  final _lineBuf = NdjsonLineBuffer();
  StreamSubscription<List<int>>? _notifySub;
  StreamSubscription<BluetoothConnectionState>? _connSub;
  bool _sawConnected = false;

  void _trace(String s) => _onTrace?.call(s);

  @override
  Stream<String> get lines => _lines.stream;

  Future<void> start() async {
    _notifySub = eventTx.onValueReceived.listen((bytes) {
      _trace('rx ${bytes.length}B');
      try {
        for (final line
            in _lineBuf.feed(utf8.decode(bytes, allowMalformed: true))) {
          _lines.add(line);
        }
      } on PairingLineOverflow catch (e, st) {
        _trace('$e — link kapatılıyor');
        _lines.addError(e, st);
        close();
      }
    });
    try {
      await eventTx.setNotifyValue(true).timeout(PairingTimeouts.bleSubscribe);
    } catch (_) {
      // CCCD açılamadıysa dinleyiciyi sızdırma: her başarısız denemede bir
      // abonelik + açık controller birikirdi.
      await close();
      rethrow;
    }

    // Kopuş algılama: BLE notify stream'i bağlantı düşünce ne hata verir ne
    // kapanır. İzlemezsek cihaz reset attığında oturum 20 s'lik cevap
    // bütçesini bekler ve hatayı "timeout" diye yanlış etiketler.
    final dev = device;
    if (dev != null) {
      _connSub = dev.connectionState.listen((s) {
        if (s == BluetoothConnectionState.connected) {
          _sawConnected = true;
          return;
        }
        // İlk emisyon mevcut durumu tekrarlar; bağlanmadan önce gelen
        // 'disconnected' bilgisini yok say.
        if (!_sawConnected) return;
        _trace('link dropped (GAP disconnected)');
        if (!_lines.isClosed) {
          _lines.addError(const PairingLinkDropped());
        }
        close();
      });
    }
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
    await _connSub?.cancel();
    _connSub = null;
    await _notifySub?.cancel();
    _notifySub = null;
    if (!_lines.isClosed) await _lines.close();
  }
}

/// BLE linki eşleştirme sırasında düştü. PairingSession bunu
/// [PairingErrorCode.linkClosed] olarak sınıflandırır — "cevap gelmedi"
/// (timeout) ile karıştırılmamalı.
class PairingLinkDropped implements Exception {
  const PairingLinkDropped();
  @override
  String toString() => 'PairingLinkDropped(BLE link dropped during pairing)';
}
