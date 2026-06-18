// Relay section body for LebensSpur dashboard.
//
// Configures the trigger relay output: which GPIO drives it, idle
// polarity, start delay, total active duration, and an optional pulse
// mode (off / on with default 1 s half-cycle / custom 1..60 s
// half-cycle). Also lets the user fire the relay manually and watch
// live phase / abort an in-progress fire.
//
// CLI contract:
//   READ   : relay.get    → {gpio, invert, delay_sec, duration_sec,
//                            pulse, pulse_duration_sec}
//   STATUS : relay.status → {phase, gpio, gpio_level, active,
//                            fire_started_us}
//   WRITE  : relay.gpio <N>, relay.invert <on|off>,
//            relay.delay <s>, relay.duration <s>,
//            relay.pulse <on|off|N>
//   ACTION : relay.test, relay.abort, relay.off
//
// UI:
//   * GPIO pin number, invert toggle, start delay slider, active
//     duration (number + unit dropdown), pulse mode segmented control.
//   * Save · Test relay · Abort buttons at the bottom.
//   * While firing, poll `relay.status` once a second and show the live
//     phase + elapsed seconds. Polling stops automatically once the
//     phase returns to "idle" or the user closes the section.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

enum _DurationUnit { seconds, minutes }
enum _PulseMode { off, on, custom }

class LsSectionRelay extends ConsumerStatefulWidget {
  const LsSectionRelay({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionRelay> createState() => _LsSectionRelayState();
}

class _LsSectionRelayState extends ConsumerState<LsSectionRelay> {
  // Device snapshot.
  int? _deviceGpio;
  bool? _deviceInvert;
  int? _deviceDelay;
  int? _deviceDuration;
  bool? _devicePulse;
  int? _devicePulseDuration;

  // Form state.
  final _gpioCtl = TextEditingController(text: '19');
  bool _invert = false;
  int _delay = 0;
  final _durationValueCtl = TextEditingController(text: '60');
  _DurationUnit _durationUnit = _DurationUnit.seconds;
  _PulseMode _pulseMode = _PulseMode.off;
  final _pulseHalfCtl = TextEditingController(text: '1');

  bool _loading = true;
  bool _saving = false;
  bool _testing = false;
  String? _loadError;

  // Live phase polling.
  Timer? _statusPoll;
  String _livePhase = 'idle';
  int? _fireStartedUs;

  @override
  void initState() {
    super.initState();
    _gpioCtl.addListener(_onAnyChange);
    _durationValueCtl.addListener(_onAnyChange);
    _pulseHalfCtl.addListener(_onAnyChange);
    _fetch();
  }

  @override
  void dispose() {
    _statusPoll?.cancel();
    _gpioCtl.dispose();
    _durationValueCtl.dispose();
    _pulseHalfCtl.dispose();
    super.dispose();
  }

  void _onAnyChange() {
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
      final r = await session.client.send('relay.get');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = (r.data as Map).cast<String, dynamic>();
        final gpio = (m['gpio'] as num?)?.toInt() ?? 19;
        final invert = m['invert'] == true;
        final delaySec = (m['delay_sec'] as num?)?.toInt() ?? 0;
        final durationSec = (m['duration_sec'] as num?)?.toInt() ?? 60;
        final pulse = m['pulse'] == true;
        final pulseDuration =
            (m['pulse_duration_sec'] as num?)?.toInt() ?? 1;

        setState(() {
          _deviceGpio = gpio;
          _deviceInvert = invert;
          _deviceDelay = delaySec;
          _deviceDuration = durationSec;
          _devicePulse = pulse;
          _devicePulseDuration = pulseDuration;

          _gpioCtl.text = gpio.toString();
          _invert = invert;
          _delay = delaySec.clamp(0, 10);
          // Use minutes only when duration is a clean multiple of 60.
          if (durationSec % 60 == 0 && durationSec >= 60) {
            _durationUnit = _DurationUnit.minutes;
            _durationValueCtl.text = (durationSec ~/ 60).toString();
          } else {
            _durationUnit = _DurationUnit.seconds;
            _durationValueCtl.text = durationSec.toString();
          }
          if (!pulse) {
            _pulseMode = _PulseMode.off;
          } else if (pulseDuration == 1) {
            _pulseMode = _PulseMode.on;
          } else {
            _pulseMode = _PulseMode.custom;
          }
          _pulseHalfCtl.text = pulseDuration.toString();
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
  }

  int? _durationSeconds() {
    final v = int.tryParse(_durationValueCtl.text.trim());
    if (v == null || v < 1) return null;
    final secs =
        _durationUnit == _DurationUnit.minutes ? v * 60 : v;
    if (secs < 1 || secs > 3600) return null;
    return secs;
  }

  int? _pulseHalfSeconds() {
    final v = int.tryParse(_pulseHalfCtl.text.trim());
    if (v == null || v < 1 || v > 60) return null;
    return v;
  }

  String _summary() {
    final l = AppLocalizations.of(context);
    if (_deviceGpio == null) return l.lsSmtpStatusNotConfigured;
    final dur = _deviceDuration ?? 0;
    final unit = dur >= 60 && dur % 60 == 0
        ? l.lsRelaySummaryMinutes(dur ~/ 60)
        : l.lsRelaySummarySeconds(dur);
    final mode = (_devicePulse ?? false)
        ? l.lsRelayModePulse
        : l.lsRelayModeSteady;
    return l.lsRelaySummaryFmt(_deviceGpio!, unit, mode);
  }

  bool get _dirty {
    if (_deviceGpio == null) return false;
    final gpio = int.tryParse(_gpioCtl.text.trim());
    if (gpio == null) return false;
    final secs = _durationSeconds();
    if (secs == null) return false;
    final wantPulse = _pulseMode != _PulseMode.off;
    final wantPulseDur = _pulseMode == _PulseMode.custom
        ? (_pulseHalfSeconds() ?? -1)
        : 1;
    if (_pulseMode == _PulseMode.custom && wantPulseDur < 1) return false;

    return gpio != _deviceGpio ||
        _invert != _deviceInvert ||
        _delay != _deviceDelay ||
        secs != _deviceDuration ||
        wantPulse != _devicePulse ||
        (wantPulse && wantPulseDur != _devicePulseDuration);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final gpio = int.tryParse(_gpioCtl.text.trim());
    if (gpio == null || gpio < 0 || gpio > 30) {
      _snack(l.lsRelayGpioValidation);
      return;
    }
    final secs = _durationSeconds();
    if (secs == null) {
      _snack(l.lsRelayDurationValidation);
      return;
    }
    if (_pulseMode == _PulseMode.custom && _pulseHalfSeconds() == null) {
      _snack(l.lsRelayPulseValidation);
      return;
    }

    setState(() => _saving = true);
    try {
      // Push only the deltas. Keeps the log readable and avoids no-op
      // writes that re-trigger NVS commits.
      if (gpio != _deviceGpio) {
        if (!await _send('relay.gpio', {'gpio': gpio})) return;
      }
      if (_invert != _deviceInvert) {
        if (!await _send(
            'relay.invert', {'invert': _invert ? 'on' : 'off'})) {
          return;
        }
      }
      if (_delay != _deviceDelay) {
        if (!await _send('relay.delay', {'delay': _delay})) return;
      }
      if (secs != _deviceDuration) {
        if (!await _send('relay.duration', {'duration': secs})) return;
      }
      // Pulse: mode changes go via on/off; custom half-cycle via the
      // numeric form of `relay pulse <N>`.
      final wasPulse = _devicePulse ?? false;
      switch (_pulseMode) {
        case _PulseMode.off:
          if (wasPulse) {
            if (!await _send('relay.pulse', {'pulse': 'off'})) return;
          }
          break;
        case _PulseMode.on:
          if (!wasPulse || (_devicePulseDuration ?? 0) != 1) {
            // Enable + reset half-cycle to 1 (default "on" preset).
            if (!await _send('relay.pulse', {'pulse': 'on'})) return;
            // Some firmwares need explicit numeric to set the value;
            // safe extra call when value differs.
            if ((_devicePulseDuration ?? 0) != 1) {
              if (!await _send('relay.pulse', {'pulse': 1})) return;
            }
          }
          break;
        case _PulseMode.custom:
          final half = _pulseHalfSeconds()!;
          if (!wasPulse || (_devicePulseDuration ?? 0) != half) {
            if (!await _send('relay.pulse', {'pulse': half})) return;
          }
          break;
      }

      if (!mounted) return;
      setState(() {
        _deviceGpio = gpio;
        _deviceInvert = _invert;
        _deviceDelay = _delay;
        _deviceDuration = secs;
        _devicePulse = _pulseMode != _PulseMode.off;
        _devicePulseDuration = _pulseMode == _PulseMode.custom
            ? _pulseHalfSeconds()!
            : 1;
      });
      widget.onStatusChanged(_summary());
      _snack(l.lsRelayConfiguredSnack);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _send(String cmd, Map<String, dynamic> args) async {
    final l = AppLocalizations.of(context);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(cmd, args: args);
      if (!mounted) return false;
      if (!r.ok) {
        _snack(l.lsRelayCmdFailedWith(cmd, r.err ?? '?'));
        return false;
      }
      return true;
    } catch (e) {
      if (!mounted) return false;
      _snack(l.lsRelayCmdFailedWith(cmd, e.toString()));
      return false;
    }
  }

  Future<void> _test() async {
    if (_testing) return;
    setState(() => _testing = true);
    final ok = await _send('relay.test', const {});
    if (!ok) {
      if (mounted) setState(() => _testing = false);
      return;
    }
    // Start polling phase ~1 Hz; auto-stop on idle or after 30 s
    // safety window (covers up to 30 s duration; longer fires will
    // continue server-side, we just stop showing live status).
    final start = DateTime.now();
    _statusPoll?.cancel();
    _statusPoll = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) {
        t.cancel();
        return;
      }
      try {
        final session = await ref
            .read(deviceSessionProvider(widget.deviceId).future);
        final r = await session.client.send('relay.status');
        if (!mounted) return;
        if (r.ok && r.data is Map) {
          final m = (r.data as Map).cast<String, dynamic>();
          setState(() {
            _livePhase = m['phase']?.toString() ?? 'idle';
            _fireStartedUs = (m['fire_started_us'] as num?)?.toInt();
          });
          if (_livePhase == 'idle') {
            t.cancel();
            if (mounted) setState(() => _testing = false);
            return;
          }
        }
      } catch (_) {/* swallow during poll */}
      if (DateTime.now().difference(start).inSeconds > 30) {
        t.cancel();
        if (mounted) setState(() => _testing = false);
      }
    });
  }

  Future<void> _abort() async {
    final ok = await _send('relay.abort', const {});
    if (!ok || !mounted) return;
    setState(() {
      _testing = false;
      _livePhase = 'idle';
    });
    _statusPoll?.cancel();
    _snack(AppLocalizations.of(context).lsRelayFireAbortedSnack);
  }

  Future<void> _kill() async {
    final ok = await _send('relay.off', const {});
    if (!ok || !mounted) return;
    setState(() {
      _testing = false;
      _livePhase = 'idle';
    });
    _statusPoll?.cancel();
    _snack(AppLocalizations.of(context).lsRelayForcedIdleSnack);
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;

    return LsSectionBody(
      children: [
        LsField2Col(
          left: LsField(
            label: l.lsRelayGpioLabel,
            hint: l.lsRelayGpioHint,
            child: LsNeuTextField(
              controller: _gpioCtl,
              keyboardType: TextInputType.number,
              enabled: !_saving,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 2,
            ),
          ),
          right: LsField(
            label: l.lsRelayInvertLabel,
            row: true,
            child: Switch(
              value: _invert,
              onChanged: _saving ? null : (v) => setState(() => _invert = v),
              activeThumbColor: SkColors.attentionMustard,
            ),
          ),
        ),
        LsField(
          label: l.lsRelayStartDelayLabel,
          hint: l.lsRelayStartDelayHint(_delay),
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: SkColors.attentionMustard,
              thumbColor: SkColors.attentionMustard,
              inactiveTrackColor: fg.withValues(alpha: 0.12),
            ),
            child: Slider(
              value: _delay.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: '${_delay}s',
              onChanged: _saving
                  ? null
                  : (v) => setState(() => _delay = v.round()),
            ),
          ),
        ),
        LsField2Col(
          left: LsField(
            label: l.lsRelayActiveDurationLabel,
            child: LsNeuTextField(
              controller: _durationValueCtl,
              keyboardType: TextInputType.number,
              enabled: !_saving,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              hint: '1..3600',
            ),
          ),
          right: LsField(
            label: l.lsDurationUnitLabel,
            child: LsNeuDropdown<_DurationUnit>(
              value: _durationUnit,
              items: [
                DropdownMenuItem(
                  value: _DurationUnit.seconds,
                  child: Text(l.lsRelayUnitSeconds),
                ),
                DropdownMenuItem(
                  value: _DurationUnit.minutes,
                  child: Text(l.lsRelayUnitMinutes),
                ),
              ],
              onChanged: _saving
                  ? null
                  : (v) {
                      if (v != null) setState(() => _durationUnit = v);
                    },
            ),
          ),
        ),
        LsField(
          label: l.lsRelayPulseModeLabel,
          hint: l.lsRelayPulseModeHint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _PulseSegmented(
                value: _pulseMode,
                enabled: !_saving,
                onChanged: (m) => setState(() => _pulseMode = m),
              ),
              if (_pulseMode == _PulseMode.custom) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.lsRelayHalfCycleLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: fg.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 96,
                      child: LsNeuTextField(
                        controller: _pulseHalfCtl,
                        keyboardType: TextInputType.number,
                        enabled: !_saving,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        align: TextAlign.right,
                        maxLength: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (_testing || _livePhase != 'idle')
          _LivePhaseLine(
            phase: _livePhase,
            startedUs: _fireStartedUs,
          ),
        LsActionsRow(
          children: [
            LsPillButton(
              label: _testing ? l.lsRelayFiringButton : l.lsRelayTestRelayButton,
              onPressed: (_saving || _testing) ? null : _test,
              icon: Icons.bolt_outlined,
              outlined: true,
            ),
            LsPillButton(
              label: l.lsRelayAbortButton,
              onPressed:
                  (_livePhase == 'idle' && !_testing) ? null : _abort,
              danger: true,
              outlined: true,
              icon: Icons.stop_circle_outlined,
            ),
            LsPillButton(
              label: l.lsRelayForceOffButton,
              onPressed: _saving ? null : _kill,
              outlined: true,
              icon: Icons.power_settings_new,
            ),
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

// ─────────────────────────────────────────────────────────────────────
// 3-way segmented control for pulse mode.
// ─────────────────────────────────────────────────────────────────────

class _PulseSegmented extends StatelessWidget {
  const _PulseSegmented({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final _PulseMode value;
  final bool enabled;
  final ValueChanged<_PulseMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.18);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);
    Widget chip(_PulseMode mode, String label) {
      final selected = mode == value;
      return Expanded(
        child: GestureDetector(
          onTap: enabled ? () => onChanged(mode) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: shLight,
                        offset: const Offset(-1.5, -1.5),
                        blurRadius: 2.5,
                      ),
                      BoxShadow(
                        color: shDark,
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 2.5,
                      ),
                    ]
                  : null,
              border: selected
                  ? null
                  : Border.all(color: fg.withValues(alpha: 0.10)),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected
                    ? SkColors.attentionMustard
                    : fg.withValues(alpha: enabled ? 0.70 : 0.30),
              ),
            ),
          ),
        ),
      );
    }

    final l = AppLocalizations.of(context);
    return Row(
      children: [
        chip(_PulseMode.off, l.lsRelayPulseOff),
        chip(_PulseMode.on, l.lsRelayPulseOn),
        chip(_PulseMode.custom, l.lsRelayPulseCustom),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Live phase / elapsed line shown while a fire sequence is in progress.
// ─────────────────────────────────────────────────────────────────────

class _LivePhaseLine extends StatelessWidget {
  const _LivePhaseLine({required this.phase, required this.startedUs});

  final String phase;
  final int? startedUs;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    String elapsed = '';
    if (startedUs != null && startedUs! > 0) {
      // startedUs is the device monotonic timestamp at fire start; we
      // can't reliably convert without knowing device epoch, so show a
      // simple "active" badge instead of computing wall-clock delta.
      elapsed = ' · ${l.lsRelayPhaseActiveBadge}';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: SkColors.attentionMustard.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: SkColors.attentionMustard.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, size: 16, color: SkColors.attentionMustard),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l.lsRelayPhaseLine(phase, elapsed),
              style: TextStyle(
                fontSize: 12,
                color: fg,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
