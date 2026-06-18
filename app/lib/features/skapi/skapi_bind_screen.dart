import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/paired_devices_store.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/action_binding.dart';
import 'data/mobile_event_catalog.dart';
import 'data/script_manifest.dart';
import 'data/skapi_providers.dart';
import 'widgets/skapi_basic_param_form.dart';

/// Single trigger BF actually fires the API chain on (per Faz B karar:
/// only `timer.expired`; pil / wifi / buton vs. olayları script
/// tetiklemez). The bind screen no longer surfaces an event picker —
/// every binding is implicitly tied to this filter, and existing rows
/// with stale filters (timer.state / face.changed / battery.* / ...)
/// are migrated to this value on next save so they actually fire.
const String _kTimerExpiredEvent = 'timer.expired';

/// Bind to Action form. Creates or edits a single [ActionBinding] for a
/// given script manifest.
///
/// Layout:
///   - script header (read-only) so the user knows what they're binding
///   - device dropdown sourced from [pairedDevicesProvider]; empty list
///     surfaces a paired-device CTA instead of an unselectable form
///   - event dropdown from [kBfEvents]
///   - param overrides editor (one row per manifest param)
///   - Save / Cancel / (when editing) Delete
///
/// The form uses string text fields for param overrides regardless of
/// type. Parsing happens at save time (int parses, bool toggles via
/// dropdown, list types accept comma-separated input). This keeps the
/// form widget tree small in Faz I; richer typed editors arrive when
/// the binding screen graduates from "single param column" in Faz K.
class SkapiBindScreen extends ConsumerStatefulWidget {
  const SkapiBindScreen({
    super.key,
    required this.manifest,
    this.existing,
  });

  final ScriptManifest manifest;
  final ActionBinding? existing;

  @override
  ConsumerState<SkapiBindScreen> createState() => _SkapiBindScreenState();
}

class _SkapiBindScreenState extends ConsumerState<SkapiBindScreen> {
  String? _deviceId;
  late Map<String, TextEditingController> _paramControllers;
  late Map<String, bool> _paramBoolValues;
  bool _enabled = true;
  int _prerunDelay = 0;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _deviceId = existing?.deviceId;
    _enabled = existing?.enabled ?? true;
    _prerunDelay = existing?.prerunDelaySeconds ?? 0;
    _paramControllers = {
      for (final p in widget.manifest.params)
        if (p.type != 'bool')
          p.name: TextEditingController(
            text: _initialParamText(p.name, existing),
          ),
    };
    _paramBoolValues = {
      for (final p in widget.manifest.params)
        if (p.type == 'bool')
          p.name: (existing?.paramOverrides[p.name] as bool?) ??
              (p.defaultValue as bool? ?? false),
    };
  }

  String _initialParamText(String name, ActionBinding? existing) {
    final value = existing?.paramOverrides[name];
    if (value == null) return '';
    if (value is List) return value.join(',');
    return value.toString();
  }

  @override
  void dispose() {
    for (final c in _paramControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final devices = ref.watch(pairedDevicesProvider);

    if (_deviceId == null && devices.isNotEmpty) {
      _deviceId = devices.first.id;
    }

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(title: Text(l.skapiBindScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.skapiBindScreenSubtitle,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                _ScriptHeaderCard(manifest: widget.manifest),
                const SizedBox(height: 18),
                if (devices.isEmpty)
                  _NoDeviceWarning(text: l.skapiBindFieldDeviceEmpty)
                else
                  _DeviceField(
                    devices: devices,
                    selectedId: _deviceId,
                    onChanged: (id) => setState(() => _deviceId = id),
                  ),
                const SizedBox(height: 16),
                // Event picker dropped per Faz B karar: only `timer.expired`
                // ever fires the API chain on BF. A static info pill replaces
                // the old multi-event dropdown so the user understands the
                // implicit trigger without thinking they had a choice.
                _TriggerInfoPill(text: l.skapiBindFixedTriggerLabel),
                if (widget.manifest.params.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text(
                    l.skapiBindParamsHeader,
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.skapiBindParamsHint,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final p in widget.manifest.params) ...[
                    _ParamEditor(
                      param: p,
                      controller: _paramControllers[p.name],
                      boolValue: _paramBoolValues[p.name],
                      onBoolChanged: (v) =>
                          setState(() => _paramBoolValues[p.name] = v),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
                const SizedBox(height: 22),
                SkapiBasicPrerunDelay(
                  value: _prerunDelay,
                  onChanged: (v) => setState(() => _prerunDelay = v),
                ),
                const SizedBox(height: 18),
                // V2 tactile: SwitchListTile.adaptive yerine label + SkNeuSwitch
                // satırı. Etkin/devre dışı state görsel olarak hardal/krem track
                // ile V2 nötr toggle paletine uyum sağlar.
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _enabled
                            ? l.skapiBindStatusEnabled
                            : l.skapiBindStatusDisabled,
                        style: tt.bodyLarge,
                      ),
                    ),
                    SkNeuSwitch(
                      value: _enabled,
                      onChanged: (v) => setState(() => _enabled = v),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    if (widget.existing != null) ...[
                      OutlinedButton.icon(
                        onPressed: _onDelete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: Text(l.skapiBindButtonDelete),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.error,
                        ),
                      ),
                      const Spacer(),
                    ],
                    if (widget.existing == null) const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: Text(l.skapiBindButtonCancel),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: devices.isEmpty || _deviceId == null
                          ? null
                          : _onSave,
                      child: Text(l.skapiBindButtonSave),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    // Event filter is chosen by the device's prefix so the trigger
    // service routes correctly regardless of which device class fired
    // the event:
    //   - `BF` paired devices → `timer.expired` (only firmware event
    //     that fires the API chain, per Faz B karar).
    //   - `MS` paired mobile peers → `skapp.mobile.tap` (single Faz 3
    //     manual trigger; catalog grows in later phases).
    // Legacy BF bindings with stale filters get migrated on every save.
    final devices = ref.read(pairedDevicesProvider);
    final device = devices.where((d) => d.id == _deviceId).firstOrNull;
    final eventFilter = (device?.prefix == 'MS')
        ? kDefaultMobileEvent
        : _kTimerExpiredEvent;
    final binding = ActionBinding(
      id: widget.existing?.id ?? _newId(),
      scriptId: widget.manifest.id,
      platform: widget.manifest.platform,
      deviceId: _deviceId!,
      eventFilter: eventFilter,
      paramOverrides: _collectOverrides(),
      enabled: _enabled,
      createdAt: widget.existing?.createdAt ?? DateTime.now().toUtc(),
      prerunDelaySeconds: _prerunDelay,
    );
    await ref.read(bindingsProvider.notifier).upsert(binding);
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.skapiBindSavedToast, textAlign: TextAlign.center)));
    Navigator.of(context).maybePop();
  }

  Future<void> _onDelete() async {
    final existing = widget.existing;
    if (existing == null) return;
    await ref.read(bindingsProvider.notifier).remove(existing.id);
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.skapiBindDeletedToast, textAlign: TextAlign.center)));
    Navigator.of(context).maybePop();
  }

  Map<String, Object?> _collectOverrides() {
    final out = <String, Object?>{};
    for (final p in widget.manifest.params) {
      switch (p.type) {
        case 'bool':
          final v = _paramBoolValues[p.name];
          if (v != null && v != p.defaultValue) {
            out[p.name] = v;
          }
          break;
        case 'int':
          final raw = _paramControllers[p.name]?.text.trim() ?? '';
          if (raw.isEmpty) break;
          final parsed = int.tryParse(raw);
          if (parsed != null && parsed != p.defaultValue) {
            out[p.name] = parsed;
          }
          break;
        case 'stringList':
          final raw = _paramControllers[p.name]?.text.trim() ?? '';
          if (raw.isEmpty) break;
          final list =
              raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          out[p.name] = list;
          break;
        default:
          final raw = _paramControllers[p.name]?.text.trim() ?? '';
          if (raw.isEmpty) break;
          if (raw != p.defaultValue?.toString()) {
            out[p.name] = raw;
          }
      }
    }
    return out;
  }

  String _newId() {
    // Riverpod ScopeProviders are not used; a coarse v4-like id from
    // millisecond + DateTime.now().microsecond is enough collision-wise
    // for per-device binding sets and avoids pulling in a uuid package
    // just for this surface.
    final now = DateTime.now();
    return 'bind_'
        '${now.microsecondsSinceEpoch.toRadixString(36)}_'
        '${now.hashCode.toUnsigned(16).toRadixString(36)}';
  }
}

class _ScriptHeaderCard extends StatelessWidget {
  const _ScriptHeaderCard({required this.manifest});
  final ScriptManifest manifest;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return SkNeuCard(
      borderRadius: 14,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            manifest.id,
            style: tt.labelMedium?.copyWith(
              fontFamily: 'monospace',
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            manifest.platform.toUpperCase(),
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoDeviceWarning extends StatelessWidget {
  const _NoDeviceWarning({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    const mustard = Color(0xFFD4A017);
    return SkNeuCard(
      borderRadius: 14,
      borderColor: mustard,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: mustard),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _DeviceField extends StatelessWidget {
  const _DeviceField({
    required this.devices,
    required this.selectedId,
    required this.onChanged,
  });

  final List<PairedDevice> devices;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.skapiBindFieldDeviceLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: selectedId,
          isExpanded: true,
          items: [
            for (final d in devices)
              DropdownMenuItem(
                value: d.id,
                child: Text(
                  d.customName?.isNotEmpty == true ? d.customName! : d.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            helperText: l.skapiBindFieldDeviceHint,
            helperMaxLines: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          devices.firstWhere((d) => d.id == selectedId, orElse: () => devices.first).id,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
                fontFamily: 'monospace',
              ),
        ),
      ],
    );
  }
}

/// Read-only chip telling the user this binding fires when the BF
/// countdown finishes. Replaces the old multi-event dropdown — only
/// `timer.expired` actually triggers the API chain on the firmware side
/// (Faz B karar). Mustard accent so the implicit trigger feels deliberate
/// rather than missing.
class _TriggerInfoPill extends StatelessWidget {
  const _TriggerInfoPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    const mustard = Color(0xFFD4A017);
    return SkNeuCard(
      borderRadius: 12,
      borderColor: mustard.withValues(alpha: 0.55),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 18, color: mustard),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParamEditor extends StatelessWidget {
  const _ParamEditor({
    required this.param,
    this.controller,
    this.boolValue,
    required this.onBoolChanged,
  });

  final ScriptParam param;
  final TextEditingController? controller;
  final bool? boolValue;
  final ValueChanged<bool> onBoolChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final defaultText = param.defaultValue == null
        ? ''
        : (param.defaultValue is List
            ? (param.defaultValue as List).join(', ')
            : param.defaultValue.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                param.name,
                style: tt.bodyLarge?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              param.type,
              style: tt.labelSmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (param.type == 'bool')
          // V2 tactile: parametre bool toggle'ı için SkNeuSwitch satırı;
          // değer mono fontla görüntülenir (parametre script literal'ı).
          Row(
            children: [
              Expanded(
                child: Text(
                  boolValue == true ? 'true' : 'false',
                  style: tt.bodyLarge?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              SkNeuSwitch(
                value: boolValue ?? false,
                onChanged: onBoolChanged,
              ),
            ],
          )
        else
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: defaultText.isEmpty
                  ? null
                  : 'default: $defaultText',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: param.type == 'int'
                ? TextInputType.number
                : TextInputType.text,
          ),
      ],
    );
  }
}

