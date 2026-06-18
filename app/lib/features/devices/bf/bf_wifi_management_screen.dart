// BF WiFi yönetim ekranı, Settings'teki "Birincil/Yedek WiFi" satırlarına
// gerçek davranış kazandırır. Cihazın iki kayıtlı slotunu (`primary` /
// `backup`) listeler; her biri için "Değiştir" (yeni SSID + şifreyle
// üzerine yaz) ve "Unut" eylemleri sunar.
//
// Wire format (sk_wifi.c):
//   wifi.list  → { active, slots:[{slot, ssid, static_ip, active}] }
//   wifi.connect --ssid X --password Y --slot primary|backup
//                → kaydet + bağlan, non-critical
//   wifi.forget --slot primary|backup → slot'u sil
//
// Kapsam dışı bırakılanlar (ileride ayrı ekran/iş):
//   - WiFi tarama ile seçim (mevcut wifi_scan_screen pairing flow'una
//     özel; tek başına çağrılabilir hale gelmesi ayrı iş)
//   - Statik IP düzenleme (BF firmware destekliyor; UI henüz yok)
//   - Saklı şifrenin yerinde değiştirilmesi (firmware şifreyi geri
//     vermez; "Değiştir" her seferinde tam yeniden yapılandırma)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'bf_session.dart';
import 'widgets/bootstrap_banner.dart';

class BfWifiManagementScreen extends ConsumerStatefulWidget {
  const BfWifiManagementScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  ConsumerState<BfWifiManagementScreen> createState() =>
      _BfWifiManagementScreenState();
}

class _BfWifiManagementScreenState
    extends ConsumerState<BfWifiManagementScreen> {
  bool _loaded = false;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _wifiList; // {active, slots:[...]}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final client = BfSession.of(context).client;
    final l = AppLocalizations.of(context);
    try {
      final r = await client.send('wifi.list');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        setState(() {
          _wifiList = Map<String, dynamic>.from(r.data as Map);
          _loading = false;
        });
      } else {
        setState(() {
          _error = r.err ?? l.commonReadFailed;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Map<String, dynamic>? _slot(String name) {
    final slots = _wifiList?['slots'];
    if (slots is! List) return null;
    for (final s in slots) {
      if (s is Map && s['slot']?.toString() == name) {
        return Map<String, dynamic>.from(s);
      }
    }
    return null;
  }

  Future<void> _editSlot(String slotName) async {
    final result = await showDialog<_WifiCreds>(
      context: context,
      builder: (ctx) => _WifiEditDialog(slotName: slotName),
    );
    if (result == null || !mounted) return;
    await _runConnect(slotName, result);
  }

  Future<void> _runConnect(String slotName, _WifiCreds creds) async {
    final l = AppLocalizations.of(context);
    final client = BfSession.of(context).client;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.bfWifiConnecting),
        duration: const Duration(seconds: 25),
      ),
    );
    try {
      final r = await client.send(
        'wifi.connect',
        args: {
          'ssid': creds.ssid,
          'password': creds.password,
          'slot': slotName,
        },
        timeout: const Duration(seconds: 25),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (r.ok) {
        await _bootstrap();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.bfWifiConnectionRejected(r.err ?? "?"))),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.commonError}: $e')),
      );
    }
  }

  Future<void> _forgetSlot(String slotName) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.bfWifiForgetTitle),
        content: Text(l.bfWifiForgetBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.bfWifiForget),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final client = BfSession.of(context).client;
    try {
      // wifi.forget is CRITICAL on the firmware (sk_wifi.c) — it needs a
      // confirm token. The AlertDialog above is the user's intent; sendCritical
      // drives the firmware's mandatory token round-trip. Plain send() returned
      // ERR_CONFIRM_TOKEN_REQUIRED, so forgetting a slot always failed silently.
      final r = await client.sendCritical(
        'wifi.forget',
        args: {'slot': slotName},
        confirmRequest: (_) async => true,
      );
      if (!mounted) return;
      if (r.ok) {
        await _bootstrap();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.commonError}: ${r.err ?? "?"}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.commonError}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.bfWifiManagementTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
            onPressed: _bootstrap,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              children: [
                if (_error != null)
                  BootstrapBanner(error: _error!, onRetry: _bootstrap),
                _SlotCard(
                  label: l.bfSettingsWifiPrimary,
                  slot: _slot('primary'),
                  isActive: _wifiList?['active'] == 'primary',
                  onEdit: () => _editSlot('primary'),
                  onForget: () => _forgetSlot('primary'),
                ),
                const SizedBox(height: 16),
                _SlotCard(
                  label: l.bfSettingsWifiSecondary,
                  slot: _slot('backup'),
                  isActive: _wifiList?['active'] == 'backup',
                  onEdit: () => _editSlot('backup'),
                  onForget: () => _forgetSlot('backup'),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    l.bfWifiHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Slot card
// ---------------------------------------------------------------------------

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.label,
    required this.slot,
    required this.isActive,
    required this.onEdit,
    required this.onForget,
  });

  final String label;
  final Map<String, dynamic>? slot;
  final bool isActive;
  final VoidCallback onEdit;
  final VoidCallback onForget;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final ssid = slot?['ssid']?.toString() ?? '';
    final staticIp = slot?['static_ip']?.toString() ?? '';
    final configured = ssid.isNotEmpty;

    return SkNeuCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                configured ? Icons.wifi : Icons.wifi_off,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (configured && isActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l.bfWifiActive,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (configured) ...[
            _Field(label: 'SSID', value: ssid, mono: true),
            if (staticIp.isNotEmpty) ...[
              const SizedBox(height: 6),
              _Field(label: 'Static IP', value: staticIp, mono: true),
            ],
          ] else
            Text(
              l.bfWifiNotConfigured,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(configured ? l.bfWifiChange : l.bfWifiSetUp),
                  onPressed: onEdit,
                ),
              ),
              if (configured) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.link_off, size: 18),
                    label: Text(l.bfWifiForget),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.error,
                    ),
                    onPressed: onForget,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.mono = false});
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 1,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: mono ? 'monospace' : null,
                ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Edit dialog (yeni SSID + şifre)
// ---------------------------------------------------------------------------

class _WifiCreds {
  _WifiCreds({required this.ssid, required this.password});
  final String ssid;
  final String password;
}

class _WifiEditDialog extends StatefulWidget {
  const _WifiEditDialog({required this.slotName});
  final String slotName;

  @override
  State<_WifiEditDialog> createState() => _WifiEditDialogState();
}

class _WifiEditDialogState extends State<_WifiEditDialog> {
  final _ssid = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void dispose() {
    _ssid.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pop(_WifiCreds(
      ssid: _ssid.text.trim(),
      password: _password.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = widget.slotName == 'primary'
        ? l.bfSettingsWifiPrimary
        : l.bfSettingsWifiSecondary;
    return AlertDialog(
      title: Text(l.bfWifiConfigure(label)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _ssid,
              decoration: const InputDecoration(
                labelText: 'SSID',
                prefixIcon: Icon(Icons.wifi),
              ),
              autocorrect: false,
              enableSuggestions: false,
              autofocus: true,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'SSID' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _password,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: l.bfWifiPasswordLabel,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_showPassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return null;
                if (v.length < 8) return '≥ 8';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.commonCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l.commonConnect)),
      ],
    );
  }
}
