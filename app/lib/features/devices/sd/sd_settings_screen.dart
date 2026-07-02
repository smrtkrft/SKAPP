// SD Ayarlar · design2.html ayar panelinin hub'ı (bf_settings deseni).
//
// SD'ye özgü ekranlar (Modlar / Profiller / Kasa / Tercihler / Olaylar)
// SdSession altında yaşar; sk-katmanı paylaşılan yüzeyler (WiFi, OTA,
// parola, eşleşmiş telefonlar, cihaz bilgisi) BF ekranlarının kendisidir —
// komutlar (`wifi.*`, `ota.*`, `auth.passphrase.*`, `bond.*`,
// `device.info`) iki firmware'de de aynı sk bileşenlerinden gelir. Bu
// ekranlar `BfSession.of` okuduğundan `BfSession.pushForDevice` ile
// açılırlar (route gate aynı cihaz-agnostik provider'lardan BfSession
// kurar; SD cihazında birebir çalışır).
//
// l10n notu: metni birebir aynı olan jenerik anahtarlar (bfSettings*,
// common*, deviceName*) bilinçli olarak yeniden kullanılıyor — 9 dilde
// çevirileri hazır; sd* kopyaları yalnız İngilizce fallback üretirdi.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import '../bf/bf_bond_list_screen.dart';
import '../bf/bf_device_info_screen.dart';
import '../bf/bf_ota_screen.dart';
import '../bf/bf_passphrase_screen.dart';
import '../bf/bf_session.dart';
import '../bf/bf_wifi_management_screen.dart';
import '../bf/widgets/bootstrap_banner.dart';
import 'sd_events_screen.dart';
import 'sd_logs_screen.dart';
import 'sd_modes_screen.dart';
import 'sd_prefs_screen.dart';
import 'sd_profiles_screen.dart';
import 'sd_safe_screen.dart';
import 'sd_session.dart';

class SdSettingsScreen extends ConsumerStatefulWidget {
  const SdSettingsScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  ConsumerState<SdSettingsScreen> createState() => _SdSettingsScreenState();
}

class _SdSettingsScreenState extends ConsumerState<SdSettingsScreen> {
  bool _loaded = false;
  Map<String, dynamic>? _wifiList;
  Map<String, dynamic>? _deviceInfo;
  String? _bootstrapError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final client = SdSession.of(context).client;
    final l = AppLocalizations.of(context);
    Map<String, dynamic>? wifiList;
    Map<String, dynamic>? deviceInfo;
    String? wifiErr;
    String? infoErr;
    try {
      final r1 = await client.send('wifi.list');
      if (r1.ok && r1.data is Map) {
        wifiList = Map<String, dynamic>.from(r1.data as Map);
      } else if (!r1.ok) {
        wifiErr = r1.err ?? l.commonReadFailed;
      }
    } catch (e) {
      wifiErr = e.toString();
    }
    try {
      final r2 = await client.send('device.info');
      if (r2.ok && r2.data is Map) {
        deviceInfo = Map<String, dynamic>.from(r2.data as Map);
      } else if (!r2.ok) {
        infoErr = r2.err ?? l.commonReadFailed;
      }
    } catch (e) {
      infoErr = e.toString();
    }
    if (!mounted) return;
    setState(() {
      _wifiList = wifiList;
      _deviceInfo = deviceInfo;
      _bootstrapError = _combineErrors(wifiErr: wifiErr, infoErr: infoErr);
    });
  }

  static String? _combineErrors({String? wifiErr, String? infoErr}) {
    if (wifiErr == null && infoErr == null) return null;
    if (wifiErr != null && infoErr != null) {
      if (wifiErr == infoErr) return wifiErr;
      return 'wifi.list: $wifiErr · device.info: $infoErr';
    }
    if (wifiErr != null) return 'wifi.list: $wifiErr';
    return 'device.info: $infoErr';
  }

  Map<String, dynamic>? _slot(String slotName) {
    final slots = _wifiList?['slots'];
    if (slots is! List) return null;
    for (final s in slots) {
      if (s is Map && s['slot']?.toString() == slotName) {
        return Map<String, dynamic>.from(s);
      }
    }
    return null;
  }

  String _wifiSubtitle(AppLocalizations l, Map<String, dynamic>? slot) {
    if (slot == null) return l.bfSettingsWifiUnconfigured;
    final ssid = slot['ssid']?.toString() ?? '';
    if (ssid.isEmpty) return l.bfSettingsWifiUnconfigured;
    final staticIp = slot['static_ip']?.toString();
    if (staticIp != null && staticIp.isNotEmpty) {
      return '$ssid · $staticIp';
    }
    return ssid;
  }

  String get _firmwareSubtitle =>
      _deviceInfo?['fw_version']?.toString() ?? '-';

  String _passphraseSubtitle(AppLocalizations l) {
    final p = _deviceInfo?['passphrase'];
    if (p is! Map) return '-';
    if (p['set'] != true) return l.bfPassphraseBadgeNone;
    final mode = (p['mode'] as Map?)?.cast<String, dynamic>();
    final pairing = mode?['pairing'] == true;
    final always = mode?['always'] == true;
    if (always) return l.bfSettingsPassphraseSubtitleAlways;
    if (pairing) return l.bfSettingsPassphraseSubtitlePairing;
    return l.bfSettingsPassphraseSubtitleOff;
  }

  String _bondsSubtitle(AppLocalizations l) {
    final b = _deviceInfo?['bonds'];
    if (b is! Map) return '-';
    final count = (b['count'] as num?)?.toInt() ?? 0;
    final capacity = (b['capacity'] as num?)?.toInt() ?? 8;
    return l.bfSettingsBondsSubtitle(count, capacity);
  }

  /// sk-katmanı paylaşılan ekranlar BfSession okur → pushForDevice.
  Future<void> _pushShared(Widget child) async {
    await BfSession.pushForDevice(
      context: context,
      deviceId: widget.deviceId,
      child: child,
    );
    if (mounted) await _bootstrap();
  }

  Future<void> _runWithConfirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cmd,
    bool destructive = false,
  }) async {
    final client = SdSession.of(context).client;
    final l = AppLocalizations.of(context);
    final r = await client.sendCritical(
      cmd,
      confirmRequest: (req) async {
        if (!context.mounted) return false;
        return showSkConfirm(
          context,
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: l.commonCancel,
          destructive: destructive,
        );
      },
    );
    if (!context.mounted) return;
    final msg = r.ok
        ? 'OK'
        : r.err == 'ERR_CONFIRM_TOKEN_REQUIRED'
            ? l.commonCancel
            : '${l.commonError}: ${r.err ?? "?"}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, textAlign: TextAlign.center)),
    );
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
        title: Text(l.bfSettingsTitle),
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
          children: [
            if (_bootstrapError != null)
              BootstrapBanner(error: _bootstrapError!, onRetry: _bootstrap),
            _CustomNameCard(deviceId: widget.deviceId),
            const SizedBox(height: 24),
            _Section(title: l.sdSettingsSectionControl, children: [
              _Row(
                icon: Icons.tune,
                title: l.sdModesTitle,
                subtitle: l.sdSettingsModesSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => SdSession.push(
                  context,
                  SdModesScreen(deviceId: widget.deviceId),
                ),
              ),
              _Row(
                icon: Icons.category_outlined,
                title: l.sdProfilesTitle,
                subtitle: l.sdSettingsProfilesSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => SdSession.push(
                  context,
                  SdProfilesScreen(deviceId: widget.deviceId),
                ),
              ),
              _Row(
                icon: Icons.lock_outline,
                title: l.sdSafeTitle,
                subtitle: l.sdSettingsSafeSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => SdSession.push(
                  context,
                  SdSafeScreen(deviceId: widget.deviceId),
                ),
              ),
              _Row(
                icon: Icons.toggle_on_outlined,
                title: l.sdPrefsTitle,
                subtitle: l.sdSettingsPrefsSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => SdSession.push(
                  context,
                  SdPrefsScreen(deviceId: widget.deviceId),
                ),
              ),
            ]),
            const SizedBox(height: 24),
            _Section(title: l.bfSettingsSectionNetwork, children: [
              _Row(
                icon: Icons.wifi,
                title: l.bfSettingsWifiPrimary,
                subtitle: _wifiSubtitle(l, _slot('primary')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    _pushShared(BfWifiManagementScreen(deviceId: widget.deviceId)),
              ),
              _Row(
                icon: Icons.wifi_lock,
                title: l.bfSettingsWifiSecondary,
                subtitle: _wifiSubtitle(l, _slot('backup')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    _pushShared(BfWifiManagementScreen(deviceId: widget.deviceId)),
              ),
            ]),
            const SizedBox(height: 24),
            _Section(title: l.bfSettingsSectionSecurity, children: [
              _Row(
                icon: Icons.lock_outline,
                title: l.bfSettingsPassphraseTitle,
                subtitle: _passphraseSubtitle(l),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pushShared(const BfPassphraseScreen()),
              ),
              _Row(
                icon: Icons.devices_other,
                title: l.bfSettingsBondListTitle,
                subtitle: _bondsSubtitle(l),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pushShared(const BfBondListScreen()),
              ),
            ]),
            const SizedBox(height: 24),
            _Section(title: l.bfSettingsSectionUpdates, children: [
              _Row(
                icon: Icons.system_update_alt,
                title: l.bfSettingsFirmware,
                subtitle: _firmwareSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pushShared(BfOtaScreen(deviceId: widget.deviceId)),
              ),
              _Row(
                icon: Icons.info_outline,
                title: l.bfDashboardMoreDeviceInfo,
                subtitle: _deviceInfo?['model']?.toString() ?? '-',
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    _pushShared(BfDeviceInfoScreen(deviceId: widget.deviceId)),
              ),
              _Row(
                icon: Icons.bolt_outlined,
                title: l.sdEventsTitle,
                subtitle: l.sdSettingsEventsSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => SdSession.push(
                  context,
                  SdEventsScreen(deviceId: widget.deviceId),
                ),
              ),
              _Row(
                icon: Icons.receipt_long_outlined,
                title: l.bfLogsTitle,
                subtitle: l.sdSettingsLogsSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => SdSession.push(
                  context,
                  SdLogsScreen(deviceId: widget.deviceId),
                ),
              ),
            ]),
            const SizedBox(height: 24),
            _Section(title: l.bfSettingsSectionDanger, children: [
              _Row(
                icon: Icons.restart_alt,
                title: l.bfSettingsReboot,
                subtitle: l.bfSettingsRebootSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _runWithConfirm(
                  context,
                  title: l.bfSettingsRebootConfirmTitle,
                  message: l.bfSettingsRebootConfirmBody,
                  confirmLabel: l.bfSettingsReboot,
                  cmd: 'device.restart',
                ),
              ),
              _Row(
                icon: Icons.link_off,
                title: l.bfSettingsUnpairThisPhone,
                subtitle: l.bfSettingsUnpairSubtitle,
                trailing: const Icon(Icons.chevron_right),
                tone: _Tone.warn,
                onTap: () => _runWithConfirm(
                  context,
                  title: l.bfSettingsUnpairConfirmTitle,
                  message: l.bfSettingsUnpairSubtitle,
                  confirmLabel: l.commonRemove,
                  cmd: 'ble.unpair',
                ),
              ),
              _Row(
                icon: Icons.delete_forever,
                title: l.bfSettingsFactoryReset,
                subtitle: l.bfSettingsFactoryResetSubtitle,
                trailing: const Icon(Icons.chevron_right),
                tone: _Tone.danger,
                onTap: () => _runWithConfirm(
                  context,
                  title: l.bfSettingsFactoryResetConfirmTitle,
                  message: l.bfSettingsFactoryResetConfirmBody,
                  confirmLabel: l.commonDelete,
                  cmd: 'device.factory-reset',
                  destructive: true,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section + Row primitives (bf_settings ile aynı görsel dil)
// ---------------------------------------------------------------------------

enum _Tone { normal, warn, danger }

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: cs.onSurfaceVariant,
                ),
          ),
        ),
        SkNeuCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(height: 1, thickness: 0.5, color: cs.outlineVariant),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.tone = _Tone.normal,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final _Tone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = switch (tone) {
      _Tone.normal => cs.onSurface,
      _Tone.warn => SkColors.attentionMustard,
      _Tone.danger => cs.error,
    };
    final iconColor = tone == _Tone.normal ? cs.onSurfaceVariant : fg;
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: fg)),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// Custom-name card — alias yalnız bu SKAPP kurulumunda yaşar
// (PairedDevice.customName); firmware görmez. (bf_settings deseni.)
// ---------------------------------------------------------------------------

class _CustomNameCard extends ConsumerStatefulWidget {
  const _CustomNameCard({required this.deviceId});
  final String deviceId;

  @override
  ConsumerState<_CustomNameCard> createState() => _CustomNameCardState();
}

class _CustomNameCardState extends ConsumerState<_CustomNameCard> {
  final _controller = TextEditingController();
  String _initial = '';
  bool _wired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wired) return;
    _wired = true;
    final list = ref.read(pairedDevicesProvider);
    final paired = list.firstWhere(
      (d) => d.id == widget.deviceId,
      orElse: () => PairedDevice(
        id: widget.deviceId,
        name: widget.deviceId,
        prefix: '',
        pairedAt: DateTime.now(),
      ),
    );
    _initial = paired.customName ?? '';
    _controller.text = _initial;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final raw = _controller.text.trim();
    await ref
        .read(pairedDevicesProvider.notifier)
        .setCustomName(widget.deviceId, raw.isEmpty ? null : raw);
    setState(() => _initial = raw);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.deviceNameSaved, textAlign: TextAlign.center)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final isDirty = _controller.text.trim() != _initial;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text(
            l.deviceNameSectionHeading,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: cs.onSurfaceVariant,
                ),
          ),
        ),
        SkNeuCard(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                maxLength: 32,
                decoration: InputDecoration(
                  labelText: l.deviceNameLabel,
                  hintText: l.deviceNameHint,
                  prefixIcon: const Icon(Icons.label_outline),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 4),
              Text(
                l.deviceNameSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.clear, size: 18),
                    label: Text(l.deviceNameClear),
                    onPressed: _controller.text.isEmpty
                        ? null
                        : () {
                            _controller.clear();
                            setState(() {});
                          },
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(l.deviceNameSave),
                    onPressed: isDirty ? _save : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
