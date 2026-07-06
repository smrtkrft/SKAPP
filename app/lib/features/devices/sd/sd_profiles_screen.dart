// SD Profiller — cihazdaki profillerin İNCE görünümü (Faz C sadeleştirme).
//
//   profile.list           → kompakt liste (BLE MTU dostu)
//   profile.get <id>       → tam JSON (görüntüleme)
//   profile.remove <id>    → bağlı binding varsa firmware ERR_IN_USE döner
//
// Profil OLUŞTURMA/EKLEME bu ekrandan kaldırıldı: bundled katalog seçici ve
// ham-JSON yapıştırma alanının yerini SKAPI Cihaz Şablonları kütüphanesi
// aldı ("+" → SkapiTemplateLibraryScreen, SD profilleriyle filtreli derin
// bağlantı). Tek doğruluk kaynağı SKAPI; bu ekran listele · görüntüle ·
// sil · yenile ile sınırlı.

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import '../../skapi/data/device_template.dart';
import '../../skapi/skapi_template_library_screen.dart';
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

  /// "+" → SKAPI Cihaz Şablonları kütüphanesi, SD profilleriyle filtreli
  /// derin bağlantı. Dağıtım servisinin session'ı deviceSessionProvider
  /// üzerinden çözülür; dönüşte liste yenilenir.
  Future<void> _openAdd() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkapiTemplateLibraryScreen(
          libraryContext: TemplateLibraryContext(
            deviceId: widget.deviceId,
            devicePrefix: 'SD',
            kinds: const {TemplateTargetKind.sdProfile},
          ),
        ),
      ),
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
        tooltip: l.sdProfilesAddViaLibrary,
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
