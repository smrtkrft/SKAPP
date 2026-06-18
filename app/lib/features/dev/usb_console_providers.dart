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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/cli/cli_client.dart';
import '../../core/cli/usb_cli_transport.dart';
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
    final transport = createUsbCliTransport(portInfo: port);
    final client = CliClient(transport, signer: null);
    try {
      await client.start().timeout(const Duration(seconds: 8));
    } catch (e) {
      try {
        await client.stop();
      } catch (_) {/* */}
      if (_disposed) return;
      state = state.copyWith(
        connection: UsbConnectionState.error,
        error: e.toString(),
      );
      return;
    }
    if (_disposed) {
      // Kullanıcı bağlanma sırasında ekrandan çıktı.
      try {
        await client.stop();
      } catch (_) {/* */}
      return;
    }

    // Transport öldüğünde (kablo çekildi vs.) state'i disconnected yap.
    client.whenClosed.then((_) {
      if (_disposed) return;
      if (state.connection == UsbConnectionState.connected) {
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
        final resp = await client
            .send('help', timeout: const Duration(seconds: 6))
            .timeout(const Duration(seconds: 8));
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
      } catch (_) {/* retry */}
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
  Future<void> send(String input) async {
    final cmd = input.trim();
    if (cmd.isEmpty) return;
    final client = _client;
    if (client == null || state.connection != UsbConnectionState.connected) {
      _appendEntry(ConsoleEntryError('Bağlı değil'));
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
        _appendEntry(ConsoleEntryError(e.toString()));
      }
      return;
    }

    final parsed = _parseCommand(cmd);
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
      _appendEntry(ConsoleEntryError(e.toString()));
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
    String cmdName = tokens[0];

    // `help` / `?` bir topic ARGÜMANI alır (`help wifi`), namespace DEĞİL.
    // Bu yüzden sonraki token'ı asla nokta ile birleştirme: aksi halde
    // `help wifi` → `help.wifi` olur, firmware bunu ERR_UNKNOWN_COMMAND ile
    // reddeder (sözlük henüz dolmamışken kör birleştirme tam bunu yapıyordu).
    // cmd=`help` kalsın, topic argv olarak gitsin; konsol renderer'ı yazılan
    // ham komuta göre overview'i filtreler (console_message_view _helpMode).
    const noFoldRoots = {'help', '?'};

    if (!noFoldRoots.contains(tokens[0]) &&
        !tokens[0].contains('.') &&
        !tokens[0].contains('=')) {
      // Greedy: 4 token derinliğine kadar dene (`a.b.c.d` formatı için).
      for (int n = math.min(tokens.length, 4); n >= 2; n--) {
        if (_isFlagToken(tokens[n - 1])) continue;
        final candidate = tokens.sublist(0, n).join('.');
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
          !_isFlagToken(tokens[1]) &&
          !tokens[1].contains('=')) {
        cmdName = '${tokens[0]}.${tokens[1]}';
        consumed = 2;
      }
    }

    // 2) Geri kalan tokenları argümanlara ayır.
    final args = <String, dynamic>{};
    final argv = <String>[];
    int i = consumed;
    while (i < tokens.length) {
      final t = tokens[i];
      if (t.startsWith('--')) {
        final flag = t.substring(2);
        final eq = flag.indexOf('=');
        if (eq >= 0) {
          args[flag.substring(0, eq)] = flag.substring(eq + 1);
          i++;
        } else if (i + 1 < tokens.length && !_isFlagToken(tokens[i + 1])) {
          args[flag] = tokens[i + 1];
          i += 2;
        } else {
          args[flag] = true;
          i++;
        }
      } else if (t.contains('=') && !t.startsWith('=')) {
        final eq = t.indexOf('=');
        args[t.substring(0, eq)] = t.substring(eq + 1);
        i++;
      } else {
        argv.add(t);
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
  List<String> _tokenize(String input) {
    final out = <String>[];
    final buf = StringBuffer();
    String? quote;
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
      } else if (c == ' ' || c == '\t') {
        if (buf.isNotEmpty) {
          out.add(buf.toString());
          buf.clear();
        }
      } else {
        buf.write(c);
      }
    }
    if (buf.isNotEmpty) out.add(buf.toString());
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
    } catch (_) {/* */}
    _eventsSub = null;
    try {
      await _client?.stop();
    } catch (_) {/* */}
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
