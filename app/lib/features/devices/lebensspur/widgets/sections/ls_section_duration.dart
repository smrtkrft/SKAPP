// Duration & Alarms section body for LebensSpur dashboard.
//
// Surfaces the three knobs of `timer.set`: unit (minute|hour|day), value
// (1..60), and alarm count (0..10). Reads current state via `timer.get`,
// writes back the whole tuple as a single command. Save button is only
// enabled while a field actually differs from the device snapshot, so
// users can't accidentally re-issue a no-op write.
//
// CLI contract:
//   READ  : timer.get → {unit, value, alarms, total_duration_sec}
//   WRITE : timer.set {unit, value, alarms}
//
// The parent (`LsHomeScreen`) is notified via [onChanged] on every
// successful write so its status line stays in sync. We compose the
// summary string here too (e.g. "30 days · 3 alarms") and pipe it up.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

class LsSectionDuration extends ConsumerStatefulWidget {
  const LsSectionDuration({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;

  /// Pushed up to LsHomeScreen so its status line ("30 days · 3 alarms")
  /// reflects the latest device config without re-querying.
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionDuration> createState() =>
      _LsSectionDurationState();
}

class _LsSectionDurationState extends ConsumerState<LsSectionDuration> {
  // Device snapshot (last value confirmed from `timer.get`). Used to
  // diff against the form so Save is only enabled when something
  // actually changed.
  String? _deviceUnit;
  int? _deviceValue;
  int? _deviceAlarms;

  // Form state.
  String _unit = 'day';
  final _valueCtl = TextEditingController(text: '30');
  final _alarmCtl = TextEditingController(text: '3');

  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _valueCtl.addListener(_onFieldChanged);
    _alarmCtl.addListener(_onFieldChanged);
    _fetch();
  }

  @override
  void dispose() {
    _valueCtl.dispose();
    _alarmCtl.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    // Just trigger a rebuild so Save's disabled-state recomputes.
    if (mounted) setState(() {});
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('timer.get');
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      if (r.ok && r.data is Map) {
        final m = (r.data as Map).cast<String, dynamic>();
        final u = m['unit']?.toString() ?? 'day';
        final v = (m['value'] as num?)?.toInt() ?? 30;
        final a = (m['alarms'] as num?)?.toInt() ?? 0;
        setState(() {
          _deviceUnit = u;
          _deviceValue = v;
          _deviceAlarms = a;
          _unit = u;
          _valueCtl.text = v.toString();
          _alarmCtl.text = a.toString();
          _loading = false;
        });
        widget.onStatusChanged(_summary(l, u, v, a));
      } else {
        setState(() {
          _loading = false;
          _loadError = r.err ?? l.lsCommonReadFailed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  bool get _dirty {
    final v = int.tryParse(_valueCtl.text.trim());
    final a = int.tryParse(_alarmCtl.text.trim());
    if (v == null || a == null) return false;
    if (_deviceUnit == null) return false;
    return _unit != _deviceUnit ||
        v != _deviceValue ||
        a != _deviceAlarms;
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final v = int.tryParse(_valueCtl.text.trim());
    final a = int.tryParse(_alarmCtl.text.trim());
    if (v == null || v < 1 || v > 60) {
      _snack(l.lsDurationValueValidationError);
      return;
    }
    if (a == null || a < 0 || a > 10) {
      _snack(l.lsDurationAlarmsValidationError);
      return;
    }
    setState(() => _saving = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(
        'timer.set',
        args: {'unit': _unit, 'value': v, 'alarms': a},
      );
      if (!mounted) return;
      if (r.ok) {
        setState(() {
          _deviceUnit = _unit;
          _deviceValue = v;
          _deviceAlarms = a;
          _saving = false;
        });
        widget.onStatusChanged(_summary(l, _unit, v, a));
        _snack(l.lsDurationConfiguredSnack);
      } else {
        setState(() => _saving = false);
        _snack(l.lsCommonSaveFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(l.lsCommonSaveFailedWith(e.toString()));
    }
  }

  String _summary(AppLocalizations l, String unit, int value, int alarms) {
    final unitStr = switch (unit) {
      'minute' => l.lsDurationUnitMinute(value),
      'hour' => l.lsDurationUnitHour(value),
      _ => l.lsDurationUnitDay(value),
    };
    return '$unitStr · ${l.lsDurationAlarmCount(alarms)}';
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LsSectionBody(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      );
    }
    if (_loadError != null) {
      return LsSectionBody(
        children: [
          LsSectionErrorLine(message: _loadError!, onRetry: _fetch),
        ],
      );
    }

    final l = AppLocalizations.of(context);
    return LsSectionBody(
      children: [
        LsField2Col(
          left: LsField(
            label: l.lsDurationUnitLabel,
            child: LsNeuDropdown<String>(
              value: _unit,
              items: [
                DropdownMenuItem(value: 'minute', child: Text(l.lsDurationUnitMinutesPlural)),
                DropdownMenuItem(value: 'hour', child: Text(l.lsDurationUnitHoursPlural)),
                DropdownMenuItem(value: 'day', child: Text(l.lsDurationUnitDaysPlural)),
              ],
              onChanged: _saving
                  ? null
                  : (v) {
                      if (v != null) setState(() => _unit = v);
                    },
            ),
          ),
          right: LsField(
            label: l.lsDurationValueLabel,
            child: LsNeuTextField(
              controller: _valueCtl,
              keyboardType: TextInputType.number,
              enabled: !_saving,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              hint: l.lsDurationValueHint,
            ),
          ),
        ),
        LsField(
          label: l.lsDurationAlarmCountLabel,
          hint: l.lsDurationAlarmCountHint,
          row: true,
          child: SizedBox(
            width: 96,
            child: LsNeuTextField(
              controller: _alarmCtl,
              keyboardType: TextInputType.number,
              enabled: !_saving,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              align: TextAlign.right,
            ),
          ),
        ),
        LsActionsRow(
          children: [
            LsPillButton(
              label: _saving ? l.lsCommonSavingButton : l.lsCommonSaveButton,
              onPressed: (_dirty && !_saving) ? _save : null,
              accent: _dirty,
            ),
          ],
        ),
        if (_saving)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              minHeight: 2,
              color: SkColors.attentionMustard,
            ),
          ),
      ],
    );
  }
}
