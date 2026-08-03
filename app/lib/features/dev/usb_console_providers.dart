// USB CLI Konsol, Riverpod state.
//
// İki provider:
//   1. `usbPortsProvider`, bağlı portları 2 sn aralıkla yayınlar
//      (StreamProvider.autoDispose). UI port-picker buradan watch eder.
//   2. `usbConsoleSessionProvider`, seçilen port için CliClient + komut
//      geçmişi tutan StateNotifier (autoDispose.family by portInfo).
//      Ekran kapanınca client.stop() → port serbest kalır.
//
// Neden StateNotifier (legacy) kullanıyoruz: Riverpod 3'te hand-written
// `Notifier<T>` family argümanına erişemiyor (FamilyNotifier sınıfı
// kaldırılmış, yerine codegen geldi). Bu projenin codebase'inde codegen
// yok; legacy StateNotifier hâlâ desteklenir ve aynı autoDispose+family
// semantiğini sunar. Diğer providers (deviceSessionProvider) FutureProvider
// olduğu için bu uyumsuzluk hissedilmez.
//
// CliClient signer: null ile sarmalanır, USB CLI ham JSON gönderir,
// HMAC envelope yok (sk_transport_usb.c:103 unauthenticated dispatch).
// `requires_auth=true` komutlar firmware'dan ERR_NOT_AUTHENTICATED döner;
// kullanıcı UI'da görür.

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/cli/cli_client.dart';
import '../../core/cli/cli_transport.dart' show TransportClosedException;
import '../../core/cli/usb_cli_transport.dart';
import '../../core/pairing/pairing_link.dart' show PairingLineOverflow;
import '../../core/cli/usb_port_scanner.dart';

/// Aktif USB portları. UI port-picker bunu watch eder; ekran açıkken
/// 2 sn aralıkla taze liste gelir, kullanıcı kabloyu takıp çıkardığında
/// liste otomatik güncellenir.
final usbPortsProvider = StreamProvider.autoDispose<List<UsbPortInfo>>((ref) {
  return UsbPortScanner.watch();
});

enum UsbConnectionState {
  connecting,
  connected,
  disconnected,
  error,
}

/// Konsol satırı türleri. Kullanıcı yazdığı komut, cihazdan gelen yanıt,
/// async event, lokal hata, hepsi tek liste içinde sırayla gösterilir.
sealed class ConsoleEntry {
  const ConsoleEntry(this.timestamp);
  final DateTime timestamp;
}

class ConsoleEntrySent extends ConsoleEntry {
  ConsoleEntrySent(this.command) : super(DateTime.now());
  final String command;
}

class ConsoleEntryResponse extends ConsoleEntry {
  ConsoleEntryResponse({
    required this.ok,
    required this.raw,
    this.cmd,
    this.id,
    this.err,
    this.autoConfirmedTokenSuffix,
    this.transportUnauthenticated = false,
  }) : super(DateTime.now());

  /// `{"ok":true,...}` mı yoksa `false` mı.
  final bool ok;

  /// Pretty-print için ham JSON satırı.
  final String raw;

  /// Bu cevabı üreten ham komut (örn. `help`, `help wifi`, `wifi.scan`).
  /// Renderer kullanır: `help` çıktısının nasıl gösterileceği komuta bağlı
  /// (overview vs. tek topic'in komutları vs. tek komut detay). Null
  /// olabilir; eski entry'ler ve raw JSON path için.
  final String? cmd;

  final int? id;
  final String? err;

  /// Auto-confirm akışı tetiklendiyse (kritik komut → ilk istek
  /// `ERR_CONFIRM_TOKEN_REQUIRED` döndü → aynı komut firmware'in verdiği
  /// tek kullanımlık token'la otomatik yeniden gönderildi) burada o
  /// token'in ilk 8 karakteri durur. UI auto-confirm rozeti gösterir,
  /// kullanıcı sessizce iki round-trip olduğunu fark eder.
  final String? autoConfirmedTokenSuffix;

  /// `true` ise hata kodu `ERR_NOT_AUTHENTICATED` ve kullanıcı USB CLI
  /// (unauthenticated transport) üstünde. UI `requires_auth=true` olan
  /// komutun BLE/TCP bonded oturumdan çağrılması gerektiğini açıklar;
  /// sahte "kapalı" UI değil, neden çalışmadığını net söyler.
  final bool transportUnauthenticated;
}

class ConsoleEntryEvent extends ConsoleEntry {
  ConsoleEntryEvent({required this.evt, required this.raw})
      : super(DateTime.now());
  final String evt;
  final String raw;
}

class ConsoleEntryError extends ConsoleEntry {
  ConsoleEntryError(this.message) : super(DateTime.now());
  final String message;
}

/// Konsolun durumu. StateNotifier her komut/cevap/event geldiğinde state'i
/// kopyalayıp yayınlar; UI listenable.
class UsbConsoleState {
  const UsbConsoleState({
    required this.port,
    required this.connection,
    required this.entries,
    required this.commandHistory,
    this.error,
  });

  final UsbPortInfo port;
  final UsbConnectionState connection;
  final List<ConsoleEntry> entries;
  final List<String> commandHistory;
  final String? error;

  UsbConsoleState copyWith({
    UsbConnectionState? connection,
    List<ConsoleEntry>? entries,
    List<String>? commandHistory,
    String? error,
    bool clearError = false,
  }) {
    return UsbConsoleState(
      port: port,
      connection: connection ?? this.connection,
      entries: entries ?? this.entries,
      commandHistory: commandHistory ?? this.commandHistory,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Bir port için konsol oturumu, CliClient sahibi. Ekran kapanınca
/// autoDispose tetiklenir, `dispose()` içinde client.stop() çalışır,
/// USB port serbest kalır (Windows'ta COM kilidi açılır, başka uygulama
/// portu açabilir).
class UsbConsoleSessionNotifier extends StateNotifier<UsbConsoleState> {
  UsbConsoleSessionNotifier(this.port)
      : super(UsbConsoleState(
          port: port,
          connection: UsbConnectionState.connecting,
          entries: const [],
          commandHistory: const [],
        )) {
    Future.microtask(_connect);
  }

  final UsbPortInfo port;

  CliClient? _client;
  StreamSubscription<Map<String, dynamic>>? _eventsSub;
  StreamSubscription<Map<String, dynamic>>? _unmatchedSub;
  StreamSubscription<String>? _unparsedSub;

  /// Arka planda (kullanıcı yazmadan) gönderilen isteklerin id'leri —
  /// geç gelen cevapları konsola dökmemek için.
  final Set<int> _internalRequestIds = <int>{};

  /// Cevabı beklenen kullanıcı komutu sayısı. Kablo çekilmesinde hem
  /// komutun catch'i hem `whenClosed` aynı hatayı yazmasın diye.
  int _inFlightCommands = 0;

  /// Bağlanma akışı için reentrancy koruması: "Yeniden bağlan" butonu
  /// disconnect'in await'leri sırasında canlı kaldığından çift dokunuş
  /// iki paralel _connect() başlatabiliyordu — ikincisi exclusive
  /// CreateFile'da düşüp state'i hata yapıyor, birincisinin canlı client'ı
  /// ise sızıyordu (COM portu tutulu kalır).
  bool _connecting = false;
  bool _disposed = false;

  /// Cihazdan `help` cevabıyla doldurulan komut adları seti
  /// (`wifi.connect`, `device.info`, ...). Parser greedy match için
  /// kullanır: kullanıcı `wifi connect X Y` yazdığında ardışık tokenları
  /// nokta ile birleştirip sözlüğe bakar — `wifi.connect` bulunursa
  /// onu cmd adı, geri kalanı argv yapar. Sözlük boşken (henüz `help`
  /// dönmemiş) parser dot-notation/heuristic'e düşer.
  final Set<String> _knownCommands = <String>{};

  static const int _kMaxEntries = 200;
  static const int _kMaxCommandHistory = 50;

  Future<void> _connect() async {
    // Reentrancy: iki paralel bağlanma, exclusive COM açılışında ikinciyi
    // düşürüp state'i hataya çeviriyor ve birincinin canlı client'ını
    // sızdırıyordu (port tutulu kalır, sonraki denemeler de düşer).
    if (_connecting) {
      debugPrint('[USB-CONSOLE] _connect: reentrancy blocked');
      return;
    }
    _connecting = true;
    try {
      await _connectLocked();
    } catch (e) {
      // Son çare: createUsbCliTransport (platform kapısı) ve aradaki
      // senkron kablolama try/catch'in DIŞINDA kalıyordu; oradan kaçan bir
      // hata Future.microtask üzerinden zone'a düşüyor ve ekran sonsuza
      // kadar "Connecting…" durumunda kalıyordu — hata banner'ı yok,
      // yeniden bağlan butonu yok.
      debugPrint('[USB-CONSOLE] connect failed: $e');
      if (!_disposed) {
        state = state.copyWith(
          connection: UsbConnectionState.error,
          error: describeCliFailure(e),
        );
      }
    } finally {
      _connecting = false;
    }
  }

  Future<void> _connectLocked() async {
    // Her yeni CliClient id sayacını 1'den başlatır. Eski oturumun
    // id'leri sette kalırsa, yeni oturumda AYNI id'yi alan KULLANICI
    // komutunun geç cevabı "iç istek" sanılıp sessizce yutulur — tam da
    // düzeltmeye çalıştığımız görünmezlik. Oturum başında temizle.
    _internalRequestIds.clear();
    final transport = createUsbCliTransport(portInfo: port);
    final client = CliClient(transport, signer: null);
    try {
      await client.start().timeout(const Duration(seconds: 8));
    } catch (e) {
      try {
        await client.stop();
      } catch (e2) {
        debugPrint('[USB-CONSOLE] cleanup stop failed: $e2');
      }
      if (_disposed) return;
      state = state.copyWith(
        connection: UsbConnectionState.error,
        error: describeCliFailure(e),
      );
      return;
    }
    if (_disposed) {
      // Kullanıcı bağlanma sırasında ekrandan çıktı.
      try {
        await client.stop();
      } catch (e) {
        debugPrint('[USB-CONSOLE] stop after mid-connect dispose failed: $e');
      }
      return;
    }

    // Transport öldüğünde (kablo çekildi vs.) state'i disconnected yap.
    client.whenClosed.then((_) {
      if (_disposed) return;
      if (state.connection == UsbConnectionState.connected) {
        // Sebebi de göster: kablo çekilme/satır taşması gibi nedenler
        // yalnız o an bir komut uçuyorsa görünüyordu; boştayken kopunca
        // kullanıcı açıklamasız "bağlantı kesildi" görüyordu.
        final reason = client.closedReason;
        // Uçan bir komut varsa onun catch'i aynı metni zaten yazdı; aynı
        // olay için iki kırmızı satır göstermeyelim.
        if (reason != null && _inFlightCommands == 0) {
          _appendEntry(ConsoleEntryError(describeCliFailure(reason)));
        }
        state = state.copyWith(connection: UsbConnectionState.disconnected);
      }
    });

    // Async event'leri dinle, battery.sample, face.changed vs. cihaz
    // kendiliğinden yayınlıyor. Ham CLI olduğu için her event'i konsola
    // yazıyoruz.
    _eventsSub = client.events.listen((evt) {
      final entry = ConsoleEntryEvent(
        evt: evt['evt']?.toString() ?? 'event',
        raw: jsonEncode(evt),
      );
      _appendEntry(entry);
    });

    // Eşleşmeyen cevaplar: ham JSON modunda kullanıcının kendi id'siyle
    // gönderdiği komutun cevabı ve timeout'tan SONRA gelen geç cevaplar.
    // İkisi de eskiden sessizce düşüyordu — "komut hiçbir şey yapmadı"
    // ve "zaman aşımı ama cihaz aslında cevapladı" şikayetlerinin kaynağı.
    // Non-NDJSON device output: ESP-IDF boot logs, printf debug lines and
    // panic backtraces share the USB wire with the protocol. Showing them
    // is the whole point of a dev console — a firmware crash used to look
    // like a plain "device did not respond in time".
    _unparsedSub = client.unparsed.listen((line) {
      _appendEntry(ConsoleEntryEvent(evt: 'device output', raw: line));
    });

    _unmatchedSub = client.unmatched.listen((msg) {
      final id = msg['id'];
      // Arka planda gönderdiğimiz `help` isteklerinin geç cevabı kullanıcı
      // çıktısı değildir — sessizce yut (iz debugPrint'te kalır).
      if (id is int && _internalRequestIds.remove(id)) {
        debugPrint('[USB-CONSOLE] internal help late reply id=$id ignored');
        return;
      }
      _appendEntry(ConsoleEntryResponse(
        ok: msg['ok'] == true,
        raw: const JsonEncoder.withIndent('  ').convert(msg),
        cmd: 'Unmatched response · id=${msg['id']}',
        id: (msg['id'] is int) ? msg['id'] as int : -1,
        err: msg['err'] as String?,
      ));
    });

    _client = client;
    state = state.copyWith(
      connection: UsbConnectionState.connected,
      clearError: true,
    );

    // Komut sözlüğünü doldur: bağlandıktan sonra arka planda `help` çağır.
    // Cevap geldiğinde _knownCommands seti dolar; parser ardışık token
    // birleştirme için bunu kullanır (`wifi connect X Y` → `wifi.connect`
    // sözlükte varsa cmd=`wifi.connect`, argv=[X, Y]). Sözlük dolmamışsa
    // parser dot-notation heuristic'ine düşer; ilk birkaç saniyede
    // boşluklu syntax başarısız olabilir.
    unawaited(_loadCommandDictionary(client));
  }

  Future<void> _loadCommandDictionary(CliClient client) async {
    // Tek-atış DEĞİL: ilk `help` race'e (kullanıcı hemen komut yazdı) ya da
    // ~12 KB tek-satır yanıtın yavaş host'ta yarım kalmasına takılabilir;
    // takılırsa sözlük boş kalır ve boşluklu syntax (`wifi status`) greedy
    // match yapamaz. Sözlük dolana kadar 3 kez, 1 sn arayla dene. `help`/`?`
    // zaten sözlükten bağımsız çalışır (no-fold), bu yalnızca boşluk-formu
    // komutların güvenilirliği için.
    for (int attempt = 0; attempt < 3 && !_disposed && _knownCommands.isEmpty;
        attempt++) {
      try {
        // Bu client hâlâ güncel mi? Kullanıcı yeniden bağlandıysa bu döngü
        // ESKİ client üstünde dönüyordur; id kaydı yeni oturumun setini
        // kirletir ve yeni oturumdaki AYNI id'li kullanıcı komutunun geç
        // cevabı yutulur.
        if (!identical(_client, client)) return;
        int? sentId;
        final resp = await client
            .send('help',
                timeout: const Duration(seconds: 6),
                // Bu istek kullanıcının yazdığı bir komut DEĞİL. Geç gelen
                // cevabı `unmatched`'te ~12 KB'lık, kimsenin istemediği bir
                // satır olarak konsola dökmeyelim.
                onRequestId: (id) {
              sentId = id;
              _internalRequestIds.add(id);
            })
            .timeout(const Duration(seconds: 8))
            // Cevap ZAMANINDA geldiyse id'yi sette tutmanın anlamı yok:
            // kalırsa, ileride aynı id'yi alan kullanıcı komutunun geç
            // cevabı (ör. ham JSON modunda `"id":1`) sessizce yutulur.
            // Zaman aşımında ise id KALIR — geç gelen cevabı yutmak zaten
            // bu setin varlık sebebi.
            .then((r) {
          final id = sentId;
          if (id != null) _internalRequestIds.remove(id);
          return r;
        });
        if (_disposed) return;
        final data = resp.data;
        if (resp.ok && data is Map && data['commands'] is List) {
          for (final c in data['commands'] as List) {
            if (c is Map) {
              final name = c['name'];
              if (name is String && name.isNotEmpty) {
                _knownCommands.add(name);
              }
            }
          }
        }
      } catch (e) {
        // Sözlük yüklenemezse boşluklu syntax (`wifi status`) nokta-katlama
        // sezgisine düşer; hangi denemenin neden başarısız olduğu tek izdir.
        debugPrint('[USB-CONSOLE] help dictionary attempt failed: $e');
      }
      if (_knownCommands.isNotEmpty || _disposed) return;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Ham komut gönder. JSON ise direkt yollanır; değilse `device.info` →
  /// `{"cmd":"device.info","id":N}` şekline sarmalanır.
  ///
  /// Kritik komutlar için iki adımlı confirm-token akışı:
  /// firmware ilk denemede `ERR_CONFIRM_TOKEN_REQUIRED` döner ve
  /// `params.confirm_token` içinde tek kullanımlık token gönderir.
  /// Otomatik olarak aynı komutu o token'la tekrar gönderiyoruz; UI'da
  /// tek satır cevap görünür (auto-retry chip eklenir). Bu sayede
  /// `device.restart`, `wifi.forget`, `auth.passphrase.set` gibi
  /// critical=true komutlar USB CLI'dan da çalışır.
  /// [confirmCritical] verilirse, firmware `ERR_CONFIRM_TOKEN_REQUIRED`
  /// döndüğünde (device.factory-reset gibi geri alınamaz komutlar) token
  /// otomatik değil, kullanıcı onayıyla gönderilir. Eskiden onay tamamen
  /// atlanıyordu: tek yazım hatası cihazı anında siliyordu.
  Future<void> send(
    String input, {
    Future<bool> Function(CliConfirmRequest req)? confirmCritical,
  }) async {
    final cmd = input.trim();
    if (cmd.isEmpty) return;
    final client = _client;
    if (client == null || state.connection != UsbConnectionState.connected) {
      _appendEntry(ConsoleEntryError('Not connected'));
      return;
    }

    // Komut history'sine ekle (tekrar yazılan komutu üste taşı).
    final newHistory = [
      ...state.commandHistory.where((c) => c != cmd),
      cmd,
    ];
    if (newHistory.length > _kMaxCommandHistory) {
      newHistory.removeRange(0, newHistory.length - _kMaxCommandHistory);
    }
    state = state.copyWith(commandHistory: newHistory);

    _appendEntry(ConsoleEntrySent(cmd));

    // İki giriş şekli desteklenir:
    //   1) Direkt JSON (kullanıcı `{...}` yazdı): transport'a olduğu gibi
    //      sendLine ile geç. CliClient request id matching atlanır;
    //      cevap events stream'inden veya raw incoming'den gelir, biz
    //      events'leri zaten dinliyoruz, ama cevap "evt" olmadığı için
    //      ConsoleEntryEvent'ı tetiklemez. Bu sınırı kabul ediyoruz
    //      ileri özellik (Faz 2'de tab-completion'la birlikte ham mod).
    //   2) Komut adı + argümanlar: "wifi.connect ssid=Foo password=Bar"
    //      veya "wifi.connect --ssid Foo --password Bar". _parseCommand
    //      ile cmd adı ve args map'ine ayrıştırılıp CliClient.send()'e
    //      named args olarak verilir (firmware machine mode positional
    //      kabul etmez, sk_wifi.c:751-773 yorum satırı bunu açıklar).
    if (cmd.startsWith('{')) {
      try {
        await client.transport.sendLine(cmd);
      } catch (e) {
        _appendEntry(ConsoleEntryError(describeCliFailure(e)));
      }
      return;
    }

    final parsed = _parseCommand(cmd);
    _inFlightCommands++;
    try {
      var resp = await client
          .send(
            parsed.cmd,
            args: parsed.args,
            argv: parsed.argv,
            confirmToken: parsed.confirmToken,
            timeout: const Duration(seconds: 10),
          )
          .timeout(const Duration(seconds: 12));

      // Auto-confirm akışı: kullanıcı kritik komutu manuel token'sız
      // tetiklediyse firmware tek kullanımlık token + ttl döner. Onay
      // dialogu olmadan otomatik retry yapıyoruz çünkü USB CLI zaten
      // fiziksel erişim gerektiriyor (gate orada). Sahte success
      // göstermemek için retry sonucu (ok / err) UI'a aynen yansır.
      // İkinci tur ERR_CONFIRM_TOKEN_REQUIRED dönerse loop'lamayız
      // (issuer hatası vs.) — kullanıcı görsel olarak gerçek hatayı görür.
      String? autoConfirmedTokenSuffix;
      if (!resp.ok &&
          resp.err == 'ERR_CONFIRM_TOKEN_REQUIRED' &&
          parsed.confirmToken == null) {
        final token = resp.params?['confirm_token'] as String?;
        if (token != null && token.isNotEmpty) {
          if (confirmCritical != null) {
            final approved = await confirmCritical(CliConfirmRequest(
              cmd: (resp.params?['cmd'] as String?) ?? parsed.cmd,
              ttlSec: (resp.params?['ttl_sec'] as num?)?.toInt() ?? 30,
            ));
            if (!approved) {
              _appendEntry(ConsoleEntryError(
                  'Critical command not confirmed, not sent: '
                  '${parsed.cmd}'));
              return;
            }
          }
          resp = await client
              .send(
                parsed.cmd,
                args: parsed.args,
                argv: parsed.argv,
                confirmToken: token,
                timeout: const Duration(seconds: 10),
              )
              .timeout(const Duration(seconds: 12));
          autoConfirmedTokenSuffix = token.length > 8
              ? '${token.substring(0, 8)}…'
              : token;
        }
      }

      final raw = _stringifyResponse(resp);
      _appendEntry(ConsoleEntryResponse(
        ok: resp.ok,
        raw: raw,
        cmd: cmd,
        id: resp.id,
        err: resp.err,
        autoConfirmedTokenSuffix: autoConfirmedTokenSuffix,
        transportUnauthenticated:
            !resp.ok && resp.err == 'ERR_NOT_AUTHENTICATED',
      ));
    } catch (e) {
      _appendEntry(ConsoleEntryError(describeCliFailure(e)));
    } finally {
      if (_inFlightCommands > 0) _inFlightCommands--;
    }
  }

  /// Kullanıcının yazdığı satırı (cmd adı, named args, pozisyonel argv)
  /// üçlüsüne ayır. Komut adı belirleme:
  ///
  ///   1. tokens[0] dot içerir (`wifi.connect`) → as-is cmd
  ///   2. Sözlük doluysa: en uzun ardışık birleşim sözlükte mi? (örn.
  ///      tokens=[wifi, connect, X] için `wifi.connect` sözlükte → cmd=
  ///      `wifi.connect`, argv=[X])
  ///   3. Sözlük boşsa veya hiçbir birleşim sözlükte yoksa: tokens[0]
  ///      cmd, sonraki tokenlar argv
  ///
  /// Geri kalan tokenlar:
  ///   --key value      → args[key]=value
  ///   --key=value      → args[key]=value
  ///   key=value        → args[key]=value
  ///   --flag (yalın)   → args[flag]=true
  ///   yalın token      → argv listesine eklenir (positional)
  ///
  /// Desteklenen biçimler:
  ///   wifi connect ofis_wifi 12345678              (önerilen, doğal)
  ///   wifi.connect ssid="X" password="Y"           (named, machine)
  ///   wifi connect ofis_wifi 12345678 backup       (positional + slot)
  ///   wifi.scan
  _ParsedCommand _parseCommand(String input) {
    final tokens = _tokenize(input);
    if (tokens.isEmpty) {
      return const _ParsedCommand('', null, null, null);
    }

    // 1) Komut adını belirle — sözlük varsa greedy longest-prefix match.
    int consumed = 1;
    String cmdName = tokens[0].text;

    // `help` / `?` bir topic ARGÜMANI alır (`help wifi`), namespace DEĞİL.
    // Bu yüzden sonraki token'ı asla nokta ile birleştirme: aksi halde
    // `help wifi` → `help.wifi` olur, firmware bunu ERR_UNKNOWN_COMMAND ile
    // reddeder (sözlük henüz dolmamışken kör birleştirme tam bunu yapıyordu).
    // cmd=`help` kalsın, topic argv olarak gitsin; konsol renderer'ı yazılan
    // ham komuta göre overview'i filtreler (console_message_view _helpMode).
    const noFoldRoots = {'help', '?'};

    if (!noFoldRoots.contains(tokens[0].text) &&
        !tokens[0].text.contains('.') &&
        !tokens[0].text.contains('=')) {
      // Greedy: 4 token derinliğine kadar dene (`a.b.c.d` formatı için).
      for (int n = math.min(tokens.length, 4); n >= 2; n--) {
        if (_isFlagToken(tokens[n - 1].text)) continue;
        final candidate = tokens.sublist(0, n).map((t) => t.text).join('.');
        if (_knownCommands.contains(candidate)) {
          cmdName = candidate;
          consumed = n;
          break;
        }
      }
      // Sözlük boş veya match yok: tokens[1] yalın kelime ise birleştir.
      if (consumed == 1 &&
          _knownCommands.isEmpty &&
          tokens.length >= 2 &&
          !_isFlagToken(tokens[1].text) &&
          !tokens[1].text.contains('=')) {
        cmdName = '${tokens[0].text}.${tokens[1].text}';
        consumed = 2;
      }
    }

    // 2) Geri kalan tokenları argümanlara ayır. Değerler firmware'in
    //    beklediği JSON tipine çevrilir (coerceCliArgValue); tırnaklı
    //    yazılanlar metin kalır.
    final args = <String, dynamic>{};
    final argv = <String>[];
    int i = consumed;
    while (i < tokens.length) {
      final t = tokens[i];
      final text = t.text;
      if (text.startsWith('--')) {
        final flag = text.substring(2);
        final eq = flag.indexOf('=');
        if (eq >= 0) {
          args[flag.substring(0, eq)] = cliArgValue(flag.substring(eq + 1));
          i++;
        } else if (i + 1 < tokens.length && !_isFlagToken(tokens[i + 1].text)) {
          args[flag] = cliArgValue(tokens[i + 1].text);
          i += 2;
        } else {
          // Yalın `--flag`: firmware'de hiçbir okuyucu JSON bool göremez
          // (sk_cli_arg_named string olmayan değere NULL, sk_cli_arg_long
          // bool'u reddeder), yani `true` göndermek bayrağı SESSİZCE yok
          // eder. String "true" en azından sk_cli_arg_long'un strtol
          // yoluna ve string okuyuculara ulaşır — aynı sözleşme.
          args[flag] = cliArgValue('true');
          i++;
        }
      } else if (text.contains('=') && !text.startsWith('=')) {
        final eq = text.indexOf('=');
        args[text.substring(0, eq)] = cliArgValue(text.substring(eq + 1));
        i++;
      } else {
        argv.add(text);
        i++;
      }
    }

    // 3) confirm_token lift: kullanıcı `--confirm-token <hex>` veya
    //    `--confirm_token <hex>` yazdıysa onu top-level `confirmToken`
    //    alanına taşı. sk_cli.c machine-mode dispatcher token'i
    //    `args` içinde değil, mesajın kökünde (`confirm_token`) okur;
    //    args içinde kalırsa firmware görmüyor ve auto-issue tekrar
    //    tekrar yeni token döndürüyordu — kritik komutlar USB CLI'dan
    //    hiç tamamlanamıyordu.
    String? confirmToken;
    for (final key in const ['confirm-token', 'confirm_token']) {
      final v = args.remove(key);
      if (v is String && v.isNotEmpty && confirmToken == null) {
        confirmToken = v;
      }
    }

    return _ParsedCommand(
      cmdName,
      args.isEmpty ? null : args,
      argv.isEmpty ? null : argv,
      confirmToken,
    );
  }

  bool _isFlagToken(String t) => t.startsWith('--');

  /// Quote-aware tokenize: boşluklara böl ama tek/çift tırnak içindeki
  /// boşlukları korur. Tırnak kapanmazsa stringin sonuna kadar kabul edilir.
  List<CliToken> _tokenize(String input) {
    final out = <CliToken>[];
    final buf = StringBuffer();
    String? quote;
    var sawQuote = false;
    void flush() {
      if (buf.isEmpty && !sawQuote) return;
      out.add(CliToken(buf.toString(), quoted: sawQuote));
      buf.clear();
      sawQuote = false;
    }

    for (int i = 0; i < input.length; i++) {
      final c = input[i];
      if (quote != null) {
        if (c == quote) {
          quote = null;
        } else {
          buf.write(c);
        }
      } else if (c == '"' || c == "'") {
        quote = c;
        // Tırnak kullanıcının "bu bir metin" işaretidir; değer dönüşümü
        // bunu görüp sayıya çevirmemeli (ör. parola "12345678").
        sawQuote = true;
      } else if (c == ' ' || c == '\t') {
        flush();
      } else {
        buf.write(c);
      }
    }
    flush();
    return out;
  }

  /// Manuel bağlantıyı kes, UI'da "Bağlantıyı kes" butonu çağırır.
  Future<void> disconnect() async {
    await _disposeClient();
    if (_disposed) return;
    state = state.copyWith(connection: UsbConnectionState.disconnected);
  }

  /// Disconnected/error state'inden tekrar bağlan (UI "Yeniden bağlan"
  /// butonu).
  Future<void> reconnect() async {
    await _disposeClient();
    if (_disposed) return;
    state = state.copyWith(
      connection: UsbConnectionState.connecting,
      clearError: true,
    );
    await _connect();
  }

  /// Kullanıcı konsolu temizler.
  void clearEntries() {
    if (_disposed) return;
    state = state.copyWith(entries: const []);
  }

  @override
  void dispose() {
    _disposed = true;
    _disposeClient();
    super.dispose();
  }

  Future<void> _disposeClient() async {
    try {
      await _eventsSub?.cancel();
      await _unmatchedSub?.cancel();
      await _unparsedSub?.cancel();
    } catch (e) {
      debugPrint('[USB-CONSOLE] subscription cancel failed: $e');
    }
    _eventsSub = null;
    _unmatchedSub = null;
    _unparsedSub = null;
    try {
      await _client?.stop();
    } catch (e) {
      debugPrint('[USB-CONSOLE] client stop failed: $e');
    }
    _client = null;
  }

  void _appendEntry(ConsoleEntry entry) {
    if (_disposed) return;
    final list = [...state.entries, entry];
    if (list.length > _kMaxEntries) {
      list.removeRange(0, list.length - _kMaxEntries);
    }
    state = state.copyWith(entries: list);
  }

  String _stringifyResponse(CliResponse resp) {
    final body = <String, dynamic>{
      'id': resp.id,
      'ok': resp.ok,
      if (resp.data != null) 'data': resp.data,
      if (resp.err != null) 'err': resp.err,
      if (resp.params != null) 'params': resp.params,
    };
    return jsonEncode(body);
  }
}

/// `_parseCommand` çıkışı: cmd adı + named args + pozisyonel argv +
/// opsiyonel confirm token.
///
/// args / argv null ise CliClient JSON body'sine hiç yazılmaz.
/// confirmToken null değilse `confirm_token` top-level alanı olarak
/// gider (sk_cli.c dispatch_machine `cJSON_GetObjectItemCaseSensitive
/// (msg, "confirm_token")` ile orayı okur). Kullanıcı `--confirm-token`
/// veya `--confirm_token` yazsa da aynı yere lift ediliyor; aksi halde
/// kritik komut iki adımlı confirm-token akışı USB CLI'da hiç çalışmaz.
/// Konsolda gösterilecek insan-okur hata metni. Refaktörden sonra
/// transportlar tipli hata fırlatıyor; ham `toString()` kullanıcıya
/// "TransportClosedException(SerialPortError…)" gibi satırlar
/// gösteriyordu. Teknik ayrıntı korunur ama önüne ne olduğu yazılır.
String describeCliFailure(Object e) {
  if (e is TimeoutException) {
    return 'Device did not respond in time. Check the cable/port and try again. (${e.message ?? 'timeout'})';
  }
  if (e is TransportClosedException) {
    // Sebep bir TransportClosedException ise iç içe sarmalama var
    // (transport → CliClient); kullanıcıya iki katmanlı tip adı
    // göstermek yerine en içteki gerçek sebebi yaz.
    var reason = e.reason;
    while (reason is TransportClosedException) {
      reason = reason.reason;
    }
    if (reason is PairingLineOverflow) return 'The device sent very long data with no line break — this port may not be a SmartKraft device. Connection closed.';
    return reason == null
        ? 'USB connection closed.'
        : 'USB connection closed: ${reason.toString()}';
  }
  if (e is PairingLineOverflow) return 'The device sent very long data with no line break — this port may not be a SmartKraft device. Connection closed.';
  if (e is UnsupportedError) return e.message ?? e.toString();
  if (e is StateError) return e.message;
  return e.toString();
}

/// Tokenizer çıktısı. `quoted`, kullanıcının değeri tırnak içine alıp
/// almadığını taşır — [coerceCliArgValue] bunu görünce sayı/bool
/// dönüşümü yapmaz.
class CliToken {
  const CliToken(this.text, {this.quoted = false});
  final String text;
  final bool quoted;
  @override
  String toString() => text;
}

/// Konsol argüman değerlerini firmware'e GÖNDERİLECEK biçime çevirir:
/// **her zaman string**. Bu bilinçli ve firmware sözleşmesiyle zorunlu.
///
/// `sk_cli.c:sk_cli_arg_named` makine modunda cJSON değeri string DEĞİLSE
/// `NULL` döner; `sk_cli_arg_long` ise hem gerçek sayıyı hem sayısal
/// string'i kabul eder (`strtol` yolu). Yani:
///   * string göndermek her iki okuyucu için de çalışır,
///   * sayı/bool göndermek string bekleyen alanları SESSİZCE düşürür.
///
/// Somut hasar (bir kez denendi ve geri alındı): `password=12345678`
/// sayıya çevrilince `sk_wifi.c` parolayı `NULL` görür, `strncpy` atlanır
/// ve cihaz "ok" döndürerek ağı PAROLASIZ kaydeder. Aynı şekilde
/// `unix=...`, `delay-after=...` sessizce yok sayılır.
///
/// Bu yüzden burada dönüşüm YOKTUR — fonksiyon, gelecekte "sayıya
/// çevirelim" refleksine karşı sözleşmeyi belgeleyen ve testle sabitleyen
/// tek nokta olarak duruyor.
String cliArgValue(String raw) => raw;

class _ParsedCommand {
  const _ParsedCommand(this.cmd, this.args, this.argv, this.confirmToken);
  final String cmd;
  final Map<String, dynamic>? args;
  final List<String>? argv;
  final String? confirmToken;
}

/// `family` arg = portInfo. Aynı port iki kere açılmasın diye notifier
/// per-port instantiate edilir; iki konsol açmak için iki farklı port
/// gerekir (Faz 1 hedefi tek konsol, multi-port out of scope).
final usbConsoleSessionProvider = StateNotifierProvider.autoDispose
    .family<UsbConsoleSessionNotifier, UsbConsoleState, UsbPortInfo>(
  (ref, port) => UsbConsoleSessionNotifier(port),
);
