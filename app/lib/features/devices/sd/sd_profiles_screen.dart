// SD Profiller · design2.html "profiller / profilJson / profilAdd"
// görünümlerinin Flutter karşılığı.
//
//   profile.list           → kompakt liste (BLE MTU dostu)
//   profile.get <id>       → tam JSON (görüntüleme)
//   profile.add {json}     → doğrula + kaydet (id ≤15, [A-Za-z0-9_-])
//   profile.remove <id>    → bağlı binding varsa firmware ERR_IN_USE döner
//
// JSON doğrulaması firmware kurallarının aynasıdır: erken/temiz hata
// içindir, son söz her zaman cihazındır.

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'sd_session.dart';

class SdProfilesScreen extends StatefulWidget {
  const SdProfilesScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<SdProfilesScreen> createState() => _SdProfilesScreenState();
}

class _SdProfilesScreenState extends State<SdProfilesScreen> {
  bool _loaded = false;
  List<Map<String, dynamic>> _profiles = [];
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
      final r = await client.send('profile.list');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = r.data as Map;
        setState(() {
          _profiles = [
            if (m['profiles'] is List)
              for (final p in m['profiles'] as List)
                if (p is Map) Map<String, dynamic>.from(p),
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

  Future<void> _showJson(String id) async {
    final client = SdSession.of(context).client;
    final l = AppLocalizations.of(context);
    String body;
    try {
      final r = await client.send('profile.get', argv: [id]);
      body = r.ok
          ? const JsonEncoder.withIndent('  ').convert(r.data)
          : '${l.commonError}: ${r.err ?? "?"}';
    } catch (e) {
      body = e.toString();
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(id),
        content: SingleChildScrollView(
          child: SelectableText(
            body,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.commonClose),
          ),
        ],
      ),
    );
  }

  Future<void> _remove(String id) async {
    final l = AppLocalizations.of(context);
    final ok = await showSkConfirm(
      context,
      title: l.sdProfilesRemoveTitle,
      message: l.sdProfilesRemoveBody(id),
      confirmLabel: l.commonRemove,
      cancelLabel: l.commonCancel,
      destructive: true,
    );
    if (ok != true || !mounted) return;
    final client = SdSession.of(context).client;
    try {
      final r = await client.send('profile.remove', argv: [id]);
      if (!mounted) return;
      if (!r.ok) {
        // ERR_IN_USE: bir binding bu profili kullanıyor — firmware korur.
        final msg = r.err == 'ERR_IN_USE'
            ? l.sdProfilesErrInUse
            : '${l.commonError}: ${r.err ?? "?"}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg, textAlign: TextAlign.center)),
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

  Future<void> _openAdd() async {
    await SdSession.push(
      context,
      SdProfileAddScreen(deviceId: widget.deviceId),
    );
    if (mounted) await _refresh();
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
        title: Text(l.sdProfilesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
            onPressed: _refresh,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: TextStyle(color: cs.error)),
              ),
            if (_profiles.isEmpty && _error == null)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l.sdProfilesEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ),
            for (final p in _profiles) ...[
              SkNeuCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.category_outlined,
                      color: cs.onSurfaceVariant),
                  title: Text(p['id']?.toString() ?? '?'),
                  subtitle: Text(
                    [
                      if ((p['name'] ?? '').toString().isNotEmpty)
                        p['name'].toString(),
                      if ((p['protocol'] ?? '').toString().isNotEmpty)
                        p['protocol'].toString(),
                    ].join(' · '),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.data_object, size: 20),
                        tooltip: l.sdProfilesShowJson,
                        onPressed: () => _showJson(p['id']?.toString() ?? ''),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            size: 20, color: cs.error),
                        tooltip: l.commonRemove,
                        onPressed: () => _remove(p['id']?.toString() ?? ''),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profil ekleme — JSON yapıştır + firmware kurallarının aynası doğrulama
// ---------------------------------------------------------------------------

class SdProfileAddScreen extends StatefulWidget {
  const SdProfileAddScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<SdProfileAddScreen> createState() => _SdProfileAddScreenState();
}

class _SdProfileAddScreenState extends State<SdProfileAddScreen> {
  final _json = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _json.dispose();
    super.dispose();
  }

  /// Firmware doğrulamasının aynası (sd_profiles): geçerli JSON nesnesi,
  /// id [A-Za-z0-9_-] ve ≤15 (NVS key sınırı), v=2, ≤2048 B.
  String? _validate(AppLocalizations l, String raw) {
    if (raw.trim().isEmpty) return l.sdProfilesErrJsonEmpty;
    if (utf8.encode(raw).length > 2048) return l.sdProfilesErrTooBig;
    dynamic parsed;
    try {
      parsed = jsonDecode(raw);
    } catch (e) {
      return l.sdProfilesErrJsonInvalid(e.toString());
    }
    if (parsed is! Map) return l.sdProfilesErrJsonNotObject;
    final id = parsed['id']?.toString() ?? '';
    if (id.isEmpty) return l.sdProfilesErrIdRequired;
    if (id.length > 15 || !RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(id)) {
      return l.sdProfilesErrIdFormat;
    }
    if (parsed['v'] != 2) return l.sdProfilesErrVersion;
    return null;
  }

  Future<void> _add() async {
    final l = AppLocalizations.of(context);
    final raw = _json.text;
    final err = _validate(l, raw);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final client = SdSession.of(context).client;
    try {
      // Firmware kompakt tek satır bekler; yapıştırılan JSON yeniden
      // encode edilerek boşluk/yeni satırlardan arındırılır.
      final compact = jsonEncode(jsonDecode(raw));
      final r = await client.send('profile.add', argv: [compact]);
      if (!mounted) return;
      if (r.ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l.sdProfilesAdded, textAlign: TextAlign.center)),
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
        title: Text(l.sdProfilesAddTitle),
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
          children: [
            Text(
              l.sdProfilesAddHint,
              style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            SkNeuCard(
              child: TextField(
                controller: _json,
                maxLines: 16,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                decoration: InputDecoration(
                  hintText: '{"v":2,"id":"shelly_dimmer2",...}',
                  border: InputBorder.none,
                  errorText: _error,
                  errorMaxLines: 3,
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                icon: const Icon(Icons.check, size: 18),
                label: Text(l.commonSave),
                onPressed: _busy ? null : _add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
