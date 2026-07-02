// SD Tercihler · design2.html "tercihler" görünümünün Flutter karşılığı.
//
// Seçimlik özellik anahtarları (`sd_prefs`): gestures / buzzer bool,
// quiet "HH:MM-HH:MM" (boş = kapalı), tz POSIX dizesi.
//   prefs.list            → {"gestures":bool,"buzzer":bool,"quiet":"","tz":""}
//   prefs.set <key> <val> → whitelist + değer doğrulama cihazda
//
// Yazma deseni BF toggle'larıyla aynı: iyimser çevir, cihaz reddederse
// geri al + snackbar.

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'sd_session.dart';

class SdPrefsScreen extends StatefulWidget {
  const SdPrefsScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<SdPrefsScreen> createState() => _SdPrefsScreenState();
}

class _SdPrefsScreenState extends State<SdPrefsScreen> {
  bool _loaded = false;
  bool _gestures = true;
  bool _buzzer = true;
  final _quiet = TextEditingController();
  final _tz = TextEditingController();
  String _quietInitial = '';
  String _tzInitial = '';
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _refresh();
  }

  @override
  void dispose() {
    _quiet.dispose();
    _tz.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final client = SdSession.of(context).client;
    final l = AppLocalizations.of(context);
    try {
      final r = await client.send('prefs.list');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = r.data as Map;
        setState(() {
          _gestures = m['gestures'] != false;
          _buzzer = m['buzzer'] != false;
          _quietInitial = m['quiet']?.toString() ?? '';
          _tzInitial = m['tz']?.toString() ?? '';
          _quiet.text = _quietInitial;
          _tz.text = _tzInitial;
          _error = null;
        });
      } else {
        setState(() => _error = r.err ?? l.commonReadFailed);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _set(String key, String value, VoidCallback rollback) async {
    final client = SdSession.of(context).client;
    String? errText;
    try {
      final r = await client.send('prefs.set', argv: [key, value]);
      if (!r.ok) errText = r.err ?? '?';
    } catch (e) {
      errText = e.toString();
    }
    if (errText == null || !mounted) return;
    rollback();
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.sdDashboardWriteFailed(errText))),
    );
  }

  void _toggle(String key, bool value) {
    final prevG = _gestures;
    final prevB = _buzzer;
    setState(() {
      if (key == 'gestures') _gestures = value;
      if (key == 'buzzer') _buzzer = value;
    });
    _set(key, value ? 'on' : 'off', () {
      setState(() {
        _gestures = prevG;
        _buzzer = prevB;
      });
    });
  }

  /// quiet: "HH:MM-HH:MM" veya boş (kapalı). Gece yarısı sarmalı geçerli
  /// (23:00-07:00) — asıl doğrulayıcı cihazdaki sd_quiet'tir.
  Future<void> _saveQuiet() async {
    final l = AppLocalizations.of(context);
    final v = _quiet.text.trim();
    if (v.isNotEmpty &&
        !RegExp(r'^\d{2}:\d{2}-\d{2}:\d{2}$').hasMatch(v)) {
      setState(() => _error = l.sdPrefsErrQuietFormat);
      return;
    }
    setState(() => _error = null);
    final prev = _quietInitial;
    _quietInitial = v;
    await _set('quiet', v, () {
      _quietInitial = prev;
      _quiet.text = prev;
      setState(() {});
    });
    if (mounted) setState(() {});
  }

  Future<void> _saveTz() async {
    final v = _tz.text.trim();
    final prev = _tzInitial;
    _tzInitial = v;
    await _set('tz', v, () {
      _tzInitial = prev;
      _tz.text = prev;
      setState(() {});
    });
    if (mounted) setState(() {});
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
        title: Text(l.sdPrefsTitle),
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
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: TextStyle(color: cs.error)),
              ),
            SkNeuCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.touch_app_outlined, color: cs.onSurfaceVariant),
                    title: Text(l.sdPrefsGestures),
                    subtitle: Text(l.sdPrefsGesturesHint),
                    trailing: SkNeuSwitch(
                      value: _gestures,
                      onChanged: (v) => _toggle('gestures', v),
                    ),
                    onTap: () => _toggle('gestures', !_gestures),
                  ),
                  Divider(height: 1, thickness: 0.5, color: cs.outlineVariant),
                  ListTile(
                    leading: Icon(Icons.volume_up_outlined,
                        color: cs.onSurfaceVariant),
                    title: Text(l.sdPrefsBuzzer),
                    subtitle: Text(l.sdPrefsBuzzerHint),
                    trailing: SkNeuSwitch(
                      value: _buzzer,
                      onChanged: (v) => _toggle('buzzer', v),
                    ),
                    onTap: () => _toggle('buzzer', !_buzzer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SkNeuCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _quiet,
                    decoration: InputDecoration(
                      labelText: l.sdPrefsQuiet,
                      helperText: l.sdPrefsQuietHint,
                      helperMaxLines: 3,
                      hintText: '23:00-07:00',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check, size: 20),
                        onPressed: _saveQuiet,
                      ),
                    ),
                    onSubmitted: (_) => _saveQuiet(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tz,
                    decoration: InputDecoration(
                      labelText: l.sdPrefsTz,
                      helperText: l.sdPrefsTzHint,
                      helperMaxLines: 3,
                      hintText: 'CET-1CEST,M3.5.0,M10.5.0/3',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check, size: 20),
                        onPressed: _saveTz,
                      ),
                    ),
                    onSubmitted: (_) => _saveTz(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
