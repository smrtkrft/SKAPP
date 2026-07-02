// SD Kasa · design2.html "kasa / kasaEdit" görünümlerinin Flutter
// karşılığı.
//
// GÜVENLİK MODELİ (bilinçli kararlar — SKAPP_CONTRACT.md):
//   * Diziler SIRDIR: `safe.list` içeriği DEĞİL yalnız segment sayısını
//     döner; bu ekran da asla dizi göstermez. Kayıttan sonra girilen
//     dizi alan temizlenerek unutulur.
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
import 'sd_session.dart';

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
    // Dizi içeriği asla gösterilmez — yalnız segment sayısı (● maskesi).
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

  /// Dizi grameri firmware sd_sequence ile aynı: L/R + 1-99 tık, "-" ile
  /// ayrılır, son segment "B" (buton) olabilir; ≤16 segment.
  String? _validate(AppLocalizations l) {
    final seq = _sequence.text.trim().toUpperCase();
    if (seq.isEmpty) return l.sdSafeErrSequenceRequired;
    final re = RegExp(r'^([LR][1-9][0-9]?)(-([LR][1-9][0-9]?))*(-B)?$');
    if (!re.hasMatch(seq)) return l.sdSafeErrSequenceFormat;
    if (seq.split('-').length > 16) return l.sdSafeErrSequenceTooLong;
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
                    // Dizi sırdır: yazarken maskelenir, otomatik
                    // düzeltme/öneri kapalı (klavye önbelleğine girmesin).
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: l.sdSafeFieldSequence,
                      helperText: l.sdSafeFieldSequenceHint,
                      helperMaxLines: 3,
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
