// SD Modlar · design2.html "modlar" + "modEdit" görünümlerinin Flutter
// karşılığı.
//
// 3 sabit slot listelenir; düzenleyici davranışa duyarlı formdur ve
// binding JSON v2 üretir (SKAPP_CONTRACT.md):
//   {"v":2,"behavior","enabled","name","profile",
//    "targets":[{host,port,device_id,auth_key}],
//    "params":{step,accel,gestures_enabled,presets{...},
//              topic,payload_value,payload_gesture,broker,broker_port}}
//
// Doğrulama firmware kurallarını AYNEN yansıtır (cihaz zaten reddeder;
// buradaki kontrol yalnız erken/temiz hata içindir): name JSON-güvenli
// (tırnak/backslash yok), profile id [A-Za-z0-9_-] ve ≤15.
//   mode.set   <slot> <json>   → kaydet + hot-reload
//   mode.test  <slot>          → kuyruklu test-ateş (≤5 sn)
//   mode.clear <slot>          → confirm-token'lı (kritik)
//   mode.select <slot>         → aktif slot

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'sd_session.dart';

const _kBehaviors = ['dimmer', 'shutter', 'mqtt_remote', 'safe'];

class SdModesScreen extends StatefulWidget {
  const SdModesScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  State<SdModesScreen> createState() => _SdModesScreenState();
}

class _SdModesScreenState extends State<SdModesScreen> {
  bool _loaded = false;
  List<Map<String, dynamic>> _slots = [];
  int _active = 1;
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
      final r = await client.send('mode.list');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = r.data as Map;
        setState(() {
          _slots = [
            if (m['slots'] is List)
              for (final s in m['slots'] as List)
                if (s is Map) Map<String, dynamic>.from(s),
          ];
          _active = (m['active'] as num?)?.toInt() ?? 1;
          _error = null;
        });
      } else {
        setState(() => _error = r.err ?? l.commonReadFailed);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _select(int slot) async {
    final client = SdSession.of(context).client;
    final r = await client.send('mode.select', argv: ['$slot']);
    if (!mounted) return;
    if (!r.ok) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.sdDashboardWriteFailed(r.err ?? '?'))),
      );
    }
    await _refresh();
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
        title: Text(l.sdModesTitle),
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
            for (var n = 1; n <= 3; n++) ...[
              _SlotCard(
                data: _slotData(n),
                number: n,
                active: n == _active,
                onSelect: () => _select(n),
                onEdit: () async {
                  await SdSession.push(
                    context,
                    SdModeEditScreen(deviceId: widget.deviceId, slot: n),
                  );
                  if (mounted) await _refresh();
                },
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, dynamic>? _slotData(int n) {
    for (final s in _slots) {
      if ((s['slot'] as num?)?.toInt() == n) return s;
    }
    return null;
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.data,
    required this.number,
    required this.active,
    required this.onSelect,
    required this.onEdit,
  });
  final Map<String, dynamic>? data;
  final int number;
  final bool active;
  final VoidCallback onSelect;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final assigned = data?['assigned'] == true;
    final error = data?['error'] == true;
    final name = data?['name']?.toString() ?? '';
    final behavior = data?['behavior']?.toString() ?? '';
    final subtitle = assigned
        ? [
            behavior,
            if (error) l.sdDashboardSlotError,
            if (data?['enabled'] == false) l.sdModesDisabled,
          ].join(' · ')
        : l.sdDashboardSlotEmpty;
    return SkNeuCard(
      padding: EdgeInsets.zero,
      borderColor: active ? cs.tertiary.withValues(alpha: 0.55) : null,
      child: ListTile(
        leading: SkNeuIconSlot(
          icon: switch (behavior) {
            'dimmer' => Icons.light_mode_outlined,
            'shutter' => Icons.blinds_outlined,
            'mqtt_remote' => Icons.cell_tower,
            'safe' => Icons.lock_outline,
            _ => Icons.add,
          },
          tone: error ? SkNeuIconSlotTone.danger : SkNeuIconSlotTone.neutral,
        ),
        title: Text(
          assigned && name.isNotEmpty ? name : l.sdModesSlotN(number),
          style: TextStyle(color: error ? cs.error : cs.onSurface),
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (assigned && !active)
              TextButton(
                onPressed: onSelect,
                child: Text(l.sdModesMakeActive),
              ),
            if (active)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(Icons.radio_button_checked,
                    size: 18, color: cs.tertiary),
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
// Düzenleyici — davranışa duyarlı form (design2 modEdit)
// ---------------------------------------------------------------------------

class SdModeEditScreen extends StatefulWidget {
  const SdModeEditScreen({
    super.key,
    required this.deviceId,
    required this.slot,
  });
  final String deviceId;
  final int slot;

  @override
  State<SdModeEditScreen> createState() => _SdModeEditScreenState();
}

class _SdModeEditScreenState extends State<SdModeEditScreen> {
  bool _loaded = false;
  bool _busy = false;
  String? _error;

  String _behavior = 'dimmer';
  bool _enabled = true;
  final _name = TextEditingController();
  String? _profile;
  List<String> _profileIds = [];
  final _host = TextEditingController();
  final _port = TextEditingController(text: '80');
  final _deviceIdField = TextEditingController();
  final _authKey = TextEditingController();
  final _step = TextEditingController(text: '1');
  bool _accel = true;
  bool _gestures = true;
  final _presetDouble = TextEditingController(text: '100');
  final _presetLong = TextEditingController(text: '10');
  final _topic = TextEditingController();
  final _payloadValue = TextEditingController(text: '{value}');
  final _payloadGesture = TextEditingController(text: '{toggle}');
  final _broker = TextEditingController();
  final _brokerPort = TextEditingController(text: '1883');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _bootstrap();
  }

  @override
  void dispose() {
    for (final c in [
      _name, _host, _port, _deviceIdField, _authKey, _step,
      _presetDouble, _presetLong, _topic, _payloadValue, _payloadGesture,
      _broker, _brokerPort,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final client = SdSession.of(context).client;
    // Profil listesi dropdown için; hata form'u engellemez (boş liste).
    try {
      final p = await client.send('profile.list');
      if (mounted && p.ok && p.data is Map && (p.data as Map)['profiles'] is List) {
        _profileIds = [
          for (final e in (p.data as Map)['profiles'] as List)
            if (e is Map && e['id'] != null) e['id'].toString(),
        ];
      }
    } catch (_) {/* sessiz */}
    try {
      final r = await client.send('mode.get', argv: ['${widget.slot}']);
      if (!mounted) return;
      if (r.ok && r.data is Map) _populate(Map<String, dynamic>.from(r.data as Map));
      setState(() {});
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  void _populate(Map<String, dynamic> b) {
    // Boş slot: firmware {assigned:false} döner — varsayılanlar kalır.
    if (b['assigned'] == false || b['behavior'] == null) return;
    _behavior = b['behavior']?.toString() ?? 'dimmer';
    if (!_kBehaviors.contains(_behavior)) _behavior = 'dimmer';
    _enabled = b['enabled'] != false;
    _name.text = b['name']?.toString() ?? '';
    final profile = b['profile']?.toString() ?? '';
    _profile = profile.isEmpty ? null : profile;
    if (_profile != null && !_profileIds.contains(_profile)) {
      _profileIds = [..._profileIds, _profile!];
    }
    final targets = b['targets'];
    if (targets is List && targets.isNotEmpty && targets.first is Map) {
      final t = targets.first as Map;
      _host.text = t['host']?.toString() ?? '';
      _port.text = ((t['port'] as num?)?.toInt() ?? 80).toString();
      _deviceIdField.text = t['device_id']?.toString() ?? '';
      _authKey.text = t['auth_key']?.toString() ?? '';
    }
    final params = b['params'];
    if (params is Map) {
      _step.text = ((params['step'] as num?)?.toInt() ?? 1).toString();
      _accel = params['accel'] != false;
      _gestures = params['gestures_enabled'] != false;
      final presets = params['presets'];
      if (presets is Map) {
        _presetDouble.text =
            ((presets['double_click'] as num?)?.toInt() ?? 100).toString();
        _presetLong.text =
            ((presets['long_press'] as num?)?.toInt() ?? 10).toString();
      }
      _topic.text = params['topic']?.toString() ?? '';
      if (params['payload_value'] != null) {
        _payloadValue.text = params['payload_value'].toString();
      }
      if (params['payload_gesture'] != null) {
        _payloadGesture.text = params['payload_gesture'].toString();
      }
      _broker.text = params['broker']?.toString() ?? '';
      _brokerPort.text =
          ((params['broker_port'] as num?)?.toInt() ?? 1883).toString();
    }
  }

  /// Firmware doğrulama kurallarının aynası (erken, temiz hata için).
  String? _validate(AppLocalizations l) {
    final name = _name.text.trim();
    if (name.isEmpty) return l.sdModesErrNameRequired;
    if (name.contains('"') || name.contains('\\')) {
      return l.sdModesErrNameJsonSafe;
    }
    final idRe = RegExp(r'^[A-Za-z0-9_-]+$');
    if (_behavior != 'safe' && _behavior != 'mqtt_remote') {
      final p = _profile;
      if (p == null || p.isEmpty) return l.sdModesErrProfileRequired;
      if (!idRe.hasMatch(p) || p.length > 15) return l.sdModesErrProfileId;
      if (_host.text.trim().isEmpty) return l.sdModesErrHostRequired;
    }
    if (_behavior == 'mqtt_remote') {
      if (_topic.text.trim().isEmpty) return l.sdModesErrTopicRequired;
      if (_broker.text.trim().isEmpty) return l.sdModesErrBrokerRequired;
    }
    return null;
  }

  Map<String, dynamic> _buildBinding() {
    final binding = <String, dynamic>{
      'v': 2,
      'behavior': _behavior,
      'enabled': _enabled,
      'name': _name.text.trim(),
    };
    if (_behavior == 'safe') return binding; // kasa: hedef/param yok

    final params = <String, dynamic>{};
    if (_behavior == 'mqtt_remote') {
      params['topic'] = _topic.text.trim();
      if (_payloadValue.text.trim().isNotEmpty) {
        params['payload_value'] = _payloadValue.text.trim();
      }
      if (_payloadGesture.text.trim().isNotEmpty) {
        params['payload_gesture'] = _payloadGesture.text.trim();
      }
      params['broker'] = _broker.text.trim();
      params['broker_port'] = int.tryParse(_brokerPort.text.trim()) ?? 1883;
      binding['params'] = params;
      return binding;
    }

    // dimmer / shutter
    binding['profile'] = _profile;
    binding['targets'] = [
      {
        'host': _host.text.trim(),
        'port': int.tryParse(_port.text.trim()) ?? 80,
        if (_deviceIdField.text.trim().isNotEmpty)
          'device_id': _deviceIdField.text.trim(),
        if (_authKey.text.trim().isNotEmpty)
          'auth_key': _authKey.text.trim(),
      },
    ];
    params['step'] = int.tryParse(_step.text.trim()) ?? 1;
    params['accel'] = _accel;
    params['gestures_enabled'] = _gestures;
    params['presets'] = {
      'double_click': int.tryParse(_presetDouble.text.trim()) ?? 100,
      'long_press': int.tryParse(_presetLong.text.trim()) ?? 10,
    };
    binding['params'] = params;
    return binding;
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
    try {
      final r = await client.send(
        'mode.set',
        argv: ['${widget.slot}', jsonEncode(_buildBinding())],
      );
      if (!mounted) return;
      if (r.ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.sdModesSaved, textAlign: TextAlign.center)),
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

  /// mode.test — kuyruklu test-ateş; sonuç zarfı {"ok","err","status"}.
  Future<void> _test() async {
    final l = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final client = SdSession.of(context).client;
    try {
      final r = await client.send(
        'mode.test',
        argv: ['${widget.slot}'],
        timeout: const Duration(seconds: 8),
      );
      if (!mounted) return;
      final data = r.data is Map ? r.data as Map : const {};
      final ok = r.ok && data['ok'] != false;
      final status = (data['status'] as num?)?.toInt();
      final msg = ok
          ? l.sdModesTestOk(status ?? 0)
          : l.sdModesTestFail((data['err'] ?? r.err ?? '?').toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg, textAlign: TextAlign.center)),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// mode.clear — kritik (confirm-token); firmware iki-adımlı onay ister.
  Future<void> _clear() async {
    final l = AppLocalizations.of(context);
    final client = SdSession.of(context).client;
    setState(() => _busy = true);
    try {
      final r = await client.sendCritical(
        'mode.clear',
        argv: ['${widget.slot}'],
        confirmRequest: (req) async {
          if (!mounted) return false;
          return showSkConfirm(
            context,
            title: l.sdModesClearConfirmTitle,
            message: l.sdModesClearConfirmBody,
            confirmLabel: l.commonDelete,
            cancelLabel: l.commonCancel,
            destructive: true,
          );
        },
      );
      if (!mounted) return;
      if (r.ok) {
        Navigator.of(context).maybePop();
      } else if (r.err != 'ERR_CONFIRM_TOKEN_REQUIRED') {
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
    final showTargets = _behavior == 'dimmer' || _behavior == 'shutter';
    final showMqtt = _behavior == 'mqtt_remote';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.sdModesEditTitle(widget.slot)),
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
                  DropdownButtonFormField<String>(
                    initialValue: _behavior,
                    decoration:
                        InputDecoration(labelText: l.sdModesFieldBehavior),
                    items: [
                      for (final b in _kBehaviors)
                        DropdownMenuItem(value: b, child: Text(b)),
                    ],
                    onChanged: (v) =>
                        setState(() => _behavior = v ?? 'dimmer'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _name,
                    maxLength: 31,
                    decoration: InputDecoration(
                      labelText: l.sdModesFieldName,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.sdModesFieldEnabled),
                    value: _enabled,
                    onChanged: (v) => setState(() => _enabled = v),
                  ),
                  if (_behavior == 'safe')
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l.sdModesSafeHint,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (showTargets) ...[
              const SizedBox(height: 16),
              SkNeuCard(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _profile,
                      decoration:
                          InputDecoration(labelText: l.sdModesFieldProfile),
                      items: [
                        for (final id in _profileIds)
                          DropdownMenuItem(value: id, child: Text(id)),
                      ],
                      onChanged: (v) => setState(() => _profile = v),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _host,
                      decoration:
                          InputDecoration(labelText: l.sdModesFieldHost),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _port,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: l.sdModesFieldPort),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _step,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: l.sdModesFieldStep),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _deviceIdField,
                      decoration: InputDecoration(
                        labelText: l.sdModesFieldDeviceId,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _authKey,
                      // Hedef API anahtarı: omuz sörfüne karşı gizli, klavye
                      // önbelleğine/öneri geçmişine girmesin (safe dizi alanı
                      // ile tutarlı sertleştirme).
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: l.sdModesFieldAuthKey,
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.sdModesFieldAccel),
                      value: _accel,
                      onChanged: (v) => setState(() => _accel = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.sdModesFieldGestures),
                      subtitle: Text(l.sdModesFieldGesturesHint),
                      value: _gestures,
                      onChanged: (v) => setState(() => _gestures = v),
                    ),
                    if (_gestures)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _presetDouble,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: l.sdModesFieldPresetDouble,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _presetLong,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: l.sdModesFieldPresetLong,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
            if (showMqtt) ...[
              const SizedBox(height: 16),
              SkNeuCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _broker,
                      decoration:
                          InputDecoration(labelText: l.sdModesFieldBroker),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _brokerPort,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: l.sdModesFieldBrokerPort),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _topic,
                      decoration:
                          InputDecoration(labelText: l.sdModesFieldTopic),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _payloadValue,
                      decoration: InputDecoration(
                        labelText: l.sdModesFieldPayloadValue,
                        helperText: l.sdModesTemplateHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _payloadGesture,
                      decoration: InputDecoration(
                        labelText: l.sdModesFieldPayloadGesture,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.play_arrow_outlined, size: 18),
                  label: Text(l.sdModesTest),
                  onPressed: _busy ? null : _test,
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  style:
                      TextButton.styleFrom(foregroundColor: cs.error),
                  label: Text(l.sdModesClear),
                  onPressed: _busy ? null : _clear,
                ),
                const Spacer(),
                FilledButton.icon(
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(l.commonSave),
                  onPressed: _busy ? null : _save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
