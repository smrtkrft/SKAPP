import 'package:flutter/material.dart';

import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../data/script_manifest.dart';
import '../data/skapi_i18n_lookup.dart';

/// Basic-mode parameter form. Renders one widget per `ScriptParam` and
/// returns the collected overrides through [onChanged] / [onSubmit].
///
/// Per-type widget mapping:
///   int (unit:"seconds") - number stepper + fixed "saniye" badge +
///                          live conversion ("600 sn = 10 dakika")
///   int (no unit)        - plain number stepper
///   bool                 - switch row
///   string               - text field
///   stringList           - chip input
///
/// Empty `params` shows the "no settings needed" placeholder.
class SkapiBasicParamForm extends StatefulWidget {
  const SkapiBasicParamForm({
    super.key,
    required this.params,
    required this.initialValues,
    this.onChanged,
  });

  final List<ScriptParam> params;
  final Map<String, Object?> initialValues;
  final ValueChanged<Map<String, Object?>>? onChanged;

  @override
  State<SkapiBasicParamForm> createState() => _SkapiBasicParamFormState();
}

class _SkapiBasicParamFormState extends State<SkapiBasicParamForm> {
  late Map<String, Object?> _values;
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    _values = {};
    for (final p in widget.params) {
      final initial =
          widget.initialValues[p.name] ?? p.defaultValue;
      _values[p.name] = initial;
      if (p.type == 'string' || p.type == 'int') {
        _textControllers[p.name] =
            TextEditingController(text: initial?.toString() ?? '');
      } else if (p.type == 'stringList') {
        // List values are kept in `_values`, not a controller.
      }
    }
  }

  @override
  void dispose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _set(String name, Object? value) {
    setState(() => _values[name] = value);
    widget.onChanged?.call(Map<String, Object?>.from(_values));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (widget.params.isEmpty) {
      // V2 tactile: empty-state placeholder içerik sarıcı kart → SkNeuCard
      // (well). İçinde sadece italic metin; çift well yok.
      return SkNeuCard(
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(
          l.skapiBasicEmptyParams,
          textAlign: TextAlign.center,
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.params.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          _buildField(widget.params[i]),
        ],
      ],
    );
  }

  Widget _buildField(ScriptParam p) {
    switch (p.type) {
      case 'int':
        return _IntField(
          param: p,
          value: _intValue(p.name),
          onChanged: (v) => _set(p.name, v),
          controller: _textControllers[p.name]!,
        );
      case 'bool':
        return _BoolField(
          param: p,
          value: _boolValue(p.name),
          onChanged: (v) => _set(p.name, v),
        );
      case 'stringList':
        return _StringListField(
          param: p,
          value: _listValue(p.name),
          onChanged: (v) => _set(p.name, v),
        );
      default:
        return _StringField(
          param: p,
          controller: _textControllers[p.name]!,
          onChanged: (v) => _set(p.name, v),
        );
    }
  }

  int _intValue(String name) {
    final v = _values[name];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  bool _boolValue(String name) {
    final v = _values[name];
    if (v is bool) return v;
    return false;
  }

  List<String> _listValue(String name) {
    final v = _values[name];
    if (v is List) return v.map((e) => e.toString()).toList();
    return const [];
  }
}

/// Shared label above each field.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: tt.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),
    );
  }
}

class _IntField extends StatelessWidget {
  const _IntField({
    required this.param,
    required this.value,
    required this.onChanged,
    required this.controller,
  });

  final ScriptParam param;
  final int value;
  final ValueChanged<int> onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hasUnit = param.unit == 'seconds';
    final label = resolveSkapiI18nKey(l, param.i18nLabel);
    final hint = param.i18nHint == null
        ? null
        : resolveSkapiI18nKey(l, param.i18nHint!);

    // Sync controller text without losing cursor position when user is
    // typing; only update when external value changed.
    if (controller.text != value.toString()) {
      controller.value = TextEditingValue(
        text: value.toString(),
        selection:
            TextSelection.collapsed(offset: value.toString().length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.16)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _StepBtn(
                icon: '−',
                onTap: () => onChanged((value - 1).clamp(0, 1 << 31)),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                  ),
                  style: tt.titleSmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                  ),
                  onChanged: (s) {
                    final n = int.tryParse(s.trim());
                    if (n != null) onChanged(n);
                  },
                ),
              ),
              _StepBtn(
                icon: '+',
                onTap: () => onChanged(value + 1),
              ),
              if (hasUnit) _UnitBadge(text: l.skapiBasicUnitSeconds),
            ],
          ),
        ),
        if (hasUnit) ...[
          const SizedBox(height: 8),
          _ConversionLine(seconds: value),
        ],
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 42,
      height: 40,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          foregroundColor: cs.onSurface,
          shape: const RoundedRectangleBorder(),
        ),
        child: Text(
          icon,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _UnitBadge extends StatelessWidget {
  const _UnitBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        border: Border(
          left: BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: cs.onSurface.withValues(alpha: 0.7),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Live "= X dakika" / "= X saat Y dakika" conversion line under a
/// seconds-typed input. Pure formatting helper, no state.
class _ConversionLine extends StatelessWidget {
  const _ConversionLine({required this.seconds});
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final humanText = _humanReadable(l, seconds);
    final after = seconds <= 0
        ? l.skapiBasicConvImmediate
        : l.skapiBasicConvAfter(humanText);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            '$seconds ${l.skapiBasicUnitSeconds.substring(0, 2)}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '→',
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.4),
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            after,
            style: TextStyle(
              fontSize: 11.5,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  static String _humanReadable(AppLocalizations l, int seconds) {
    if (seconds <= 0) return l.skapiBasicConvImmediate;
    if (seconds == 30) return l.skapiBasicConvHalfMinute;
    if (seconds < 60) return l.skapiBasicConvLessThanMinute;
    if (seconds < 3600) {
      final m = seconds ~/ 60;
      return l.skapiBasicConvMinutes(m);
    }
    final hours = seconds ~/ 3600;
    final remainder = seconds % 3600;
    if (remainder == 0) return l.skapiBasicConvHours(hours);
    return l.skapiBasicConvHoursMinutes(hours, remainder ~/ 60);
  }
}

class _BoolField extends StatelessWidget {
  const _BoolField({
    required this.param,
    required this.value,
    required this.onChanged,
  });

  final ScriptParam param;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final label = resolveSkapiI18nKey(l, param.i18nLabel);
    final hint = param.i18nHint == null
        ? null
        : resolveSkapiI18nKey(l, param.i18nHint!);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                if (hint != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    hint,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.65),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          SkNeuSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _StringField extends StatelessWidget {
  const _StringField({
    required this.param,
    required this.controller,
    required this.onChanged,
  });

  final ScriptParam param;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final label = resolveSkapiI18nKey(l, param.i18nLabel);
    final hint = param.i18nHint == null
        ? null
        : resolveSkapiI18nKey(l, param.i18nHint!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: cs.onSurface.withValues(alpha: 0.16)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: cs.onSurface.withValues(alpha: 0.16)),
            ),
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _StringListField extends StatefulWidget {
  const _StringListField({
    required this.param,
    required this.value,
    required this.onChanged,
  });

  final ScriptParam param;
  final List<String> value;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_StringListField> createState() => _StringListFieldState();
}

class _StringListFieldState extends State<_StringListField> {
  final _addCtrl = TextEditingController();

  @override
  void dispose() {
    _addCtrl.dispose();
    super.dispose();
  }

  void _add() {
    final t = _addCtrl.text.trim();
    if (t.isEmpty) return;
    widget.onChanged([...widget.value, t]);
    _addCtrl.clear();
  }

  void _remove(int idx) {
    final next = [...widget.value]..removeAt(idx);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final label = resolveSkapiI18nKey(l, widget.param.i18nLabel);
    final hint = widget.param.i18nHint == null
        ? null
        : resolveSkapiI18nKey(l, widget.param.i18nHint!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
          constraints: const BoxConstraints(minHeight: 42),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.16)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var i = 0; i < widget.value.length; i++)
                _ListChip(
                  text: widget.value[i],
                  onRemove: () => _remove(i),
                ),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _addCtrl,
                  onSubmitted: (_) => _add(),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: l.skapiBasicListAddPlaceholder,
                    hintStyle: tt.labelMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.4),
                      fontFamily: 'monospace',
                    ),
                  ),
                  style: tt.labelMedium?.copyWith(
                    fontFamily: 'monospace',
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

class _ListChip extends StatelessWidget {
  const _ListChip({required this.text, required this.onRemove});
  final String text;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 3, 6, 3),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: cs.onSurface,
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '×',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontSize: 14,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pre-execution delay block. Default state shows a "Geciktirme ekle"
/// outlined button; when the user opens it, an int field with seconds
/// badge + conversion line + remove button appears. Hidden when delay
/// is 0 unless [forceVisible] is set (e.g., editing an existing binding
/// that already has a value).
class SkapiBasicPrerunDelay extends StatefulWidget {
  const SkapiBasicPrerunDelay({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<SkapiBasicPrerunDelay> createState() => _SkapiBasicPrerunDelayState();
}

class _SkapiBasicPrerunDelayState extends State<SkapiBasicPrerunDelay> {
  late TextEditingController _ctrl;
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = widget.value > 0;
    _ctrl = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _expand() {
    setState(() => _open = true);
  }

  void _remove() {
    setState(() => _open = false);
    widget.onChanged(0);
    _ctrl.text = '0';
  }

  void _setValue(int v) {
    final clamped = v < 0 ? 0 : v;
    if (_ctrl.text != clamped.toString()) {
      _ctrl.value = TextEditingValue(
        text: clamped.toString(),
        selection:
            TextSelection.collapsed(offset: clamped.toString().length),
      );
    }
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (!_open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _expand,
          icon: const Icon(Icons.timer_outlined, size: 18),
          label: Text(l.skapiBasicPrerunAddCta),
          style: TextButton.styleFrom(
            foregroundColor: cs.onSurface.withValues(alpha: 0.75),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
        ),
      );
    }

    // V2 tactile: prerun delay paneli well sarıcı içinde; içerideki int
     // stepper kendi raised border'lı input alanını korur (well içinde
     // form input = nötr çift katman, çift well değil).
    return SkNeuCard(
      borderRadius: 12,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.skapiBasicPrerunSectionTitle,
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: _remove,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  foregroundColor: cs.onSurface.withValues(alpha: 0.65),
                ),
                child: Text(
                  l.skapiBasicPrerunRemove,
                  style: const TextStyle(fontSize: 11.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l.skapiBasicPrerunLabel,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.16)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _StepBtn(
                  icon: '−',
                  onTap: () => _setValue(widget.value - 1),
                ),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                    style: tt.titleSmall?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                    ),
                    onChanged: (s) {
                      final n = int.tryParse(s.trim());
                      if (n != null) widget.onChanged(n < 0 ? 0 : n);
                    },
                  ),
                ),
                _StepBtn(
                  icon: '+',
                  onTap: () => _setValue(widget.value + 1),
                ),
                _UnitBadge(text: l.skapiBasicUnitSeconds),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _ConversionLine(seconds: widget.value),
          const SizedBox(height: 6),
          Text(
            l.skapiBasicPrerunHelp,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
