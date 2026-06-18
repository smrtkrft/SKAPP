// Vacation Mode section body for LebensSpur dashboard.
//
// Reads `timer.status` to learn whether vacation is currently active and
// until when. Two surfaces:
//   * OFF  : days stepper + "Start vacation" button
//   * ON   : info text "Active until <date>" + "Cancel vacation" button
//            outlined warn-red so it reads as a stop-action
//
// CLI contract:
//   READ  : timer.status → state, vacation_end_epoch
//   WRITE : vacation.set {days}  (1..60)
//   WRITE : vacation.cancel

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

class LsSectionVacation extends ConsumerStatefulWidget {
  const LsSectionVacation({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionVacation> createState() =>
      _LsSectionVacationState();
}

class _LsSectionVacationState extends ConsumerState<LsSectionVacation> {
  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  bool _active = false;
  int _endEpoch = 0;

  final _daysCtl = TextEditingController(text: '7');

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _daysCtl.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('timer.status');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = (r.data as Map).cast<String, dynamic>();
        final state = m['state']?.toString() ?? 'inactive';
        final end = (m['vacation_end_epoch'] as num?)?.toInt() ?? 0;
        setState(() {
          _active = state == 'vacation' && end > 0;
          _endEpoch = end;
          _loading = false;
        });
        widget.onStatusChanged(_summary());
      } else {
        final l = AppLocalizations.of(context);
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
    if (mounted) widget.onStatusChanged(_summary());
  }

  String _summary() {
    final l = AppLocalizations.of(context);
    if (!_active || _endEpoch == 0) return l.lsVacationStatusOff;
    final dt = DateTime.fromMillisecondsSinceEpoch(_endEpoch * 1000);
    return l.lsVacationStatusUntil(_fmtDate(dt));
  }

  String _fmtDate(DateTime dt) {
    final localeName = AppLocalizations.of(context).localeName;
    return DateFormat.MMMd(localeName).format(dt);
  }

  Future<void> _start() async {
    final l = AppLocalizations.of(context);
    final days = int.tryParse(_daysCtl.text.trim());
    if (days == null || days < 1 || days > 60) {
      _snack(l.lsVacationDaysValidationError);
      return;
    }
    setState(() => _saving = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(
        'vacation.set',
        args: {'days': days},
      );
      if (!mounted) return;
      if (r.ok) {
        _snack(l.lsVacationStartedSnack(days));
        await _fetch();
      } else {
        setState(() => _saving = false);
        _snack(l.lsCommonFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(l.lsCommonFailedWith(e.toString()));
    } finally {
      if (mounted && _saving) setState(() => _saving = false);
    }
  }

  Future<void> _cancel() async {
    final l = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('vacation.cancel');
      if (!mounted) return;
      if (r.ok) {
        _snack(l.lsVacationCancelledSnack);
        await _fetch();
      } else {
        setState(() => _saving = false);
        _snack(l.lsCommonFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(l.lsCommonFailedWith(e.toString()));
    } finally {
      if (mounted && _saving) setState(() => _saving = false);
    }
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

    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;

    final l = AppLocalizations.of(context);
    if (_active) {
      return LsSectionBody(
        children: [
          Row(
            children: [
              const Icon(
                Icons.bedtime_outlined,
                size: 18,
                color: SkColors.attentionMustard,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.lsVacationActiveUntilFmt(_fmtDate(
                    DateTime.fromMillisecondsSinceEpoch(_endEpoch * 1000),
                  )),
                  style: TextStyle(fontSize: 14, color: fg),
                ),
              ),
            ],
          ),
          Text(
            l.lsVacationResumeHint,
            style: TextStyle(
              fontSize: 11,
              color: fg.withValues(alpha: 0.50),
            ),
          ),
          LsActionsRow(
            children: [
              LsPillButton(
                label: _saving
                    ? l.lsVacationCancellingButton
                    : l.lsVacationCancelButton,
                icon: Icons.stop_outlined,
                danger: true,
                outlined: true,
                onPressed: _saving ? null : _cancel,
              ),
            ],
          ),
        ],
      );
    }

    return LsSectionBody(
      children: [
        LsField(
          label: l.lsVacationDaysLabel,
          row: true,
          hint: l.lsVacationDaysHint,
          child: SizedBox(
            width: 96,
            child: LsNeuTextField(
              controller: _daysCtl,
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
              label: _saving
                  ? l.lsVacationStartingButton
                  : l.lsVacationStartButton,
              icon: Icons.bedtime_outlined,
              accent: true,
              onPressed: _saving ? null : _start,
            ),
          ],
        ),
      ],
    );
  }
}
