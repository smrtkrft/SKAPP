// SD Kasa · design2.html "kasa / kasaEdit" görünümlerinin Flutter
// karşılığı.
//
// GÜVENLİK MODELİ (bilinçli kararlar — SKAPP_CONTRACT.md + ürün kararı
// 2026-07-03):
//   * DÜZENLERKEN dizi AÇIK görünür (ürün kararı: yanlış yapılandırmayı
//     önlemek doğru girişten daha öncelikli; ekranı o an fiziksel olarak
//     kullanan kişi zaten yetkili SKAPP oturumundadır). KAYITTAN SONRA
//     sır cihaza aittir: `safe.list` içeriği DEĞİL yalnız segment sayısını
//     döner, kayıt listesi asla dizi göstermez, alan kaydedince temizlenir.
//   * Dizi kuralı: 3-6 segment, segment başına 1-50 tık (firmware
//     SD_SEQ_MIN_SEGMENTS/SD_SEQ_MAX_SET_SEGMENTS/SD_SEQ_MAX_TICKS ile
//     birebir). 6+ segmentlik kilit açma denemeleri cihazda BAŞARISIZ
//     sayılır (lockout'u besler).
//   * `safe.*` yalnız kimlikli kanalda çalışır (requires_auth) — SKAPP
//     oturumu zaten ECDH+HMAC'lidir; USB'den istenirse firmware reddeder.
//   * Dizi GİRİŞİ (tetikleme) yalnız cihazdaki fiziksel düğmedendir;
//     buradan yalnız YAPILANDIRMA yapılır (hangi dizi hangi webhook'u
//     çeksin). Bu ayrım fiziksel varlık kanıtını korur.
//
//   safe.list             → [{n,enabled,segments,endpoint,lockout{...}}]
//   safe.set <n> {json}   → {"v":2,"enabled","sequence":"L3-R5-B",
//                            "endpoint","lockout":{enabled,after,seconds}}
//   safe.clear <n>

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import '../../skapi/on_device_api_editor_screen.dart';
import '../bf/bf_session.dart';
import 'sd_session.dart';
import '../../../core/devices/validators/sd_validators.dart';

class SdSafeScreen extends StatefulWidget {
  const SdSafeScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<SdSafeScreen> createState() => _SdSafeScreenState();
}

class _SdSafeScreenState extends State<SdSafeScreen> {
  bool _loaded = false;
  List<Map<String, dynamic>> _entries = [];
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _refresh();
  }

  Future<void> _refresh() async {
    final client = SdSession.of(context).client;
    final l = AppLocalizations.of(context);
    try {
      final r = await client.send('safe.list');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = r.data as Map;
        setState(() {
          _entries = [
            if (m['entries'] is List)
              for (final e in m['entries'] as List)
                if (e is Map) Map<String, dynamic>.from(e),
          ];
          _error = null;
        });
      } else {
        setState(() => _error = r.err ?? l.commonReadFailed);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _clear(int n) async {
    final l = AppLocalizations.of(context);
    final ok = await showSkConfirm(
      context,
      title: l.sdSafeClearTitle,
      message: l.sdSafeClearBody(n),
      confirmLabel: l.commonDelete,
      cancelLabel: l.commonCancel,
      destructive: true,
    );
    if (ok != true || !mounted) return;
    final client = SdSession.of(context).client;
    try {
      final r = await client.send('safe.clear', argv: ['$n']);
      if (!mounted) return;
      if (!r.ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l.commonError}: ${r.err ?? "?"}',
                textAlign: TextAlign.center),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString(), textAlign: TextAlign.center)),
        );
      }
    }
    await _refresh();
  }

  Future<void> _openEdit(int n, Map<String, dynamic>? existing) async {
    await SdSession.push(
      context,
      SdSafeEditScreen(deviceId: widget.deviceId, entry: n, existing: existing),
    );
    if (mounted) await _refresh();
  }

  Map<String, dynamic>? _entry(int n) {
    for (final e in _entries) {
      if ((e['n'] as num?)?.toInt() == n) return e;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.sdSafeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
            onPressed: _refresh,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
          children: [
            Text(
              l.sdSafeIntro,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: TextStyle(color: cs.error)),
              ),
            for (var n = 1; n <= 5; n++) ...[
              _EntryCard(
                n: n,
                data: _entry(n),
                onEdit: () => _openEdit(n, _entry(n)),
                onClear: () => _clear(n),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.n,
    required this.data,
    required this.onEdit,
    required this.onClear,
  });
  final int n;
  final Map<String, dynamic>? data;
  final VoidCallback onEdit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final set = data != null && data!['enabled'] != null;
    final enabled = data?['enabled'] == true;
    final segments = (data?['segments'] as num?)?.toInt() ?? 0;
    final endpoint = data?['endpoint']?.toString() ?? '';
    // Kayıtlı dizi içeriği gösterilmez — yalnız segment sayısı (● maskesi;
    // ürün kuralı 3-6, eski kayıt payı için 16'ya kadar tolere edilir).
    final subtitle = set
        ? '${'●' * segments.clamp(0, 16)} · $endpoint'
            '${enabled ? '' : ' · ${l.sdModesDisabled}'}'
        : l.sdSafeEntryEmpty;
    return SkNeuCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: SkNeuIconSlot(
          icon: set ? Icons.lock_outline : Icons.add,
          tone: set && enabled
              ? SkNeuIconSlotTone.mustard
              : SkNeuIconSlotTone.neutral,
        ),
        title: Text(l.sdSafeEntryN(n)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (set)
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20, color: cs.error),
                tooltip: l.commonRemove,
                onPressed: onClear,
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kayıt düzenleme — dizi + webhook endpoint + kilitleme politikası
// ---------------------------------------------------------------------------

class SdSafeEditScreen extends StatefulWidget {
  const SdSafeEditScreen({
    super.key,
    required this.deviceId,
    required this.entry,
    this.existing,
  });
  final String deviceId;
  final int entry;
  final Map<String, dynamic>? existing;

  @override
  State<SdSafeEditScreen> createState() => _SdSafeEditScreenState();
}

class _SdSafeEditScreenState extends State<SdSafeEditScreen> {
  final _sequence = TextEditingController();
  final _after = TextEditingController(text: '5');
  final _seconds = TextEditingController(text: '30');
  String? _endpoint;
  List<String> _endpoints = [];
  bool _enabled = true;
  bool _lockout = true;
  bool _loaded = false;
  bool _busy = false;
  String? _error;

  // --- ⏺ kayıt modu (design2.html kasaEdit birebiri) --------------------
  // Cihazdaki fiziksel girişin aynısını parmakla taklit eder: ◀L / R▶ her
  // dokunuş 1 tık; yön değişimi ya da ● butonu segmenti kapatır. Firmware
  // tavanları UI'da da geçerli: 6 segment (bekleyen dahil), 50 tık/segment.
  bool _recOn = false;
  final List<String> _recSegs = [];   // commit edilmiş segmentler ("L3")
  int _recDir = 0;                    // +1 = R, -1 = L, 0 = bekleyen yok
  int _recTicks = 0;

  void _recSync() {
    _sequence.text = [
      ..._recSegs,
      if (_recDir != 0) '${_recDir > 0 ? 'R' : 'L'}$_recTicks',
    ].join('-');
  }

  void _recCommit() {
    if (_recDir == 0 || _recTicks == 0) return;
    if (_recSegs.length >= 6) return;
    _recSegs.add('${_recDir > 0 ? 'R' : 'L'}$_recTicks');
    _recDir = 0;
    _recTicks = 0;
  }

  void _recRotate(int dir) {
    setState(() {
      if (_recDir != 0 && dir != _recDir) _recCommit();
      // Tavan: 6 segment doluysa yeni segment AÇILMAZ (bekleyen yoksa).
      if (_recDir == 0 && _recSegs.length >= 6) return;
      _recDir = dir;
      if (_recTicks < 50) _recTicks++;
      _recSync();
    });
  }

  void _recButton() {
    setState(() {
      _recCommit();
      _recSync();
    });
  }

  void _recClear() {
    setState(() {
      _recSegs.clear();
      _recDir = 0;
      _recTicks = 0;
      _sequence.clear();
    });
  }

  void _recToggle() {
    setState(() {
      if (_recOn) {
        _recCommit();          // bekleyen segmenti kapat
        _recSync();
        _recOn = false;
      } else {
        // Kayıt her zaman temiz başlar — elle yazılmış metinle kayıt
        // birleştirmek kafa karıştırır (mockup davranışı da böyle).
        _recSegs.clear();
        _recDir = 0;
        _recTicks = 0;
        _sequence.clear();
        _recOn = true;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    // Mevcut kayıt: dizi CİHAZDA sır — alan boş başlar; kullanıcı yeni
    // dizi girer (değiştirmek istemiyorsa zaten bu ekrana gelmez).
    final e = widget.existing;
    if (e != null && e['enabled'] != null) {
      _enabled = e['enabled'] == true;
      _endpoint = e['endpoint']?.toString();
      final lock = e['lockout'];
      if (lock is Map) {
        _lockout = lock['enabled'] == true;
        _after.text = ((lock['after'] as num?)?.toInt() ?? 5).toString();
        _seconds.text = ((lock['seconds'] as num?)?.toInt() ?? 30).toString();
      }
    }
    _loadEndpoints();
  }

  @override
  void dispose() {
    _sequence.dispose();
    _after.dispose();
    _seconds.dispose();
    super.dispose();
  }

  /// safe.set endpoint'in sk_api USER kaydı olmasını ister; dropdown
  /// cihazdaki kayıtlı endpoint adlarından beslenir.
  Future<void> _loadEndpoints() async {
    final client = SdSession.of(context).client;
    try {
      final r = await client.send('api.endpoint.list');
      if (!mounted) return;
      if (r.ok && r.data is Map && (r.data as Map)['endpoints'] is List) {
        setState(() {
          _endpoints = [
            for (final e in (r.data as Map)['endpoints'] as List)
              if (e is Map && e['name'] != null) e['name'].toString(),
          ];
          if (_endpoint != null && !_endpoints.contains(_endpoint)) {
            _endpoints = [..._endpoints, _endpoint!];
          }
        });
      }
    } catch (_) {/* sessiz; dropdown boş kalır, kaydetmede uyarılır */}
  }

  /// Saf dizi kuralları sd_validators.dart'ta (birim testli); burada
  /// hata → yerelleştirilmiş metin eşlemesi + endpoint zorunluluğu.
  String? _validate(AppLocalizations l) {
    final err = validateSafeSequence(_sequence.text);
    if (err != null) {
      return switch (err) {
        SdSafeSequenceError.required => l.sdSafeErrSequenceRequired,
        SdSafeSequenceError.format => l.sdSafeErrSequenceFormat,
        SdSafeSequenceError.tooShort => l.sdSafeErrSequenceTooShort,
        SdSafeSequenceError.tooLong => l.sdSafeErrSequenceTooLong,
      };
    }
    if (_endpoint == null || _endpoint!.isEmpty) {
      return l.sdSafeErrEndpointRequired;
    }
    return null;
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final err = _validate(l);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final client = SdSession.of(context).client;
    final body = {
      'v': 2,
      'enabled': _enabled,
      'sequence': _sequence.text.trim().toUpperCase(),
      'endpoint': _endpoint,
      'lockout': {
        'enabled': _lockout,
        'after': int.tryParse(_after.text.trim()) ?? 5,
        'seconds': int.tryParse(_seconds.text.trim()) ?? 30,
      },
    };
    try {
      final r = await client
          .send('safe.set', argv: ['${widget.entry}', jsonEncode(body)]);
      if (!mounted) return;
      if (r.ok) {
        // Dizi belleğe/geri-yığına sızmasın: alan hemen temizlenir.
        _sequence.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.sdSafeSaved, textAlign: TextAlign.center)),
        );
        Navigator.of(context).maybePop();
      } else {
        setState(() => _error = r.err ?? '?');
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.sdSafeEditTitle(widget.entry)),
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
          children: [
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: TextStyle(color: cs.error)),
              ),
            SkNeuCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _sequence,
                    // Ürün kararı (2026-07-03): düzenlerken dizi AÇIK
                    // görünür — yanlış yapılandırmayı önlemek öncelikli.
                    // Öneri/düzeltme kapalı (klavye önbelleğine girmesin);
                    // kayıt modundayken elle yazım kilitli.
                    readOnly: _recOn,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: l.sdSafeFieldSequence,
                      helperText: l.sdSafeFieldSequenceHint,
                      helperMaxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ⏺ kayıt modu — cihaz girişinin dokunmatik taklidi.
                  Row(
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          _recOn
                              ? Icons.stop_circle_outlined
                              : Icons.fiber_manual_record,
                          size: 18,
                          color: _recOn ? cs.error : cs.tertiary,
                        ),
                        label: Text(_recOn ? l.sdSafeRecStop : l.sdSafeRecStart),
                        onPressed: _busy ? null : _recToggle,
                      ),
                      if (_recOn) ...[
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          tooltip: 'L',
                          onPressed: () => _recRotate(-1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.radio_button_checked, size: 18),
                          tooltip: '●',
                          onPressed: _recButton,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          tooltip: 'R',
                          onPressed: () => _recRotate(1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.backspace_outlined, size: 18),
                          tooltip: l.sdSafeRecClear,
                          onPressed: _recClear,
                        ),
                      ],
                    ],
                  ),
                  if (_recOn)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Text(
                        l.sdSafeRecHint,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _endpoint,
                    decoration: InputDecoration(
                      labelText: l.sdSafeFieldEndpoint,
                      helperText: _endpoints.isEmpty
                          ? l.sdSafeFieldEndpointEmpty
                          : null,
                      helperMaxLines: 3,
                    ),
                    items: [
                      for (final e in _endpoints)
                        DropdownMenuItem(value: e, child: Text(e)),
                    ],
                    onChanged: (v) => setState(() => _endpoint = v),
                  ),
                  if (_endpoints.isEmpty)
                    // Çıkmaz sokak onarımı: cihazda hiç endpoint yokken
                    // kullanıcıyı başka ekrana yollamak yerine paylaşılan
                    // API editörünü buradan aç, dönüşte listeyi yenile.
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add_link, size: 18),
                          label: Text(l.sdSafeAddEndpoint),
                          onPressed: () async {
                            await BfSession.pushForDevice(
                              context: context,
                              deviceId: widget.deviceId,
                              child: OnDeviceApiEditorScreen(
                                  deviceId: widget.deviceId),
                            );
                            if (mounted) await _loadEndpoints();
                          },
                        ),
                      ),
                    ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.sdModesFieldEnabled),
                    value: _enabled,
                    onChanged: (v) => setState(() => _enabled = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SkNeuCard(
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.sdSafeFieldLockout),
                    subtitle: Text(l.sdSafeFieldLockoutHint),
                    value: _lockout,
                    onChanged: (v) => setState(() => _lockout = v),
                  ),
                  if (_lockout)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _after,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l.sdSafeFieldLockAfter,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _seconds,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l.sdSafeFieldLockSeconds,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                icon: const Icon(Icons.check, size: 18),
                label: Text(l.commonSave),
                onPressed: _busy ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
