import 'script_manifest.dart';

/// Outcome of a `ParamValidator.validate` call. `ok == true` means every
/// override passed every rule applicable to its manifest param; `ok ==
/// false` carries the first violation only so the API caller gets a clear
/// single-fault message rather than a noisy aggregate.
class ParamValidationResult {
  const ParamValidationResult.ok()
      : ok = true,
        code = null,
        paramName = null,
        message = null;
  const ParamValidationResult.fail({
    required this.code,
    required this.paramName,
    required this.message,
  }) : ok = false;

  final bool ok;

  /// Machine-readable failure code. Stable identifiers picked so a future
  /// mobile UI can map them to localized messages without parsing English:
  /// `unknown_param`, `type_mismatch`, `pattern_violation`, `not_allowed`,
  /// `range_violation`, `invalid_chars`.
  final String? code;
  final String? paramName;

  /// Human-readable English explanation, returned to the HTTP caller in
  /// the response body. Mobile renders its own localized copy keyed by
  /// `code`; this string is for logs and curl users.
  final String? message;
}

/// Validates a `paramOverrides` map against a script manifest's declared
/// `ScriptParam`s before the override is fed into `ParamMerge` and shipped
/// to PowerShell. Guards the wire surface; mirrors what well-behaved
/// callers would do, but enforced server-side so a paired peer can't ship
/// junk that the script then trusts.
///
/// Rules, applied in order, first failure wins:
///   1. Override key is not declared in manifest → `unknown_param`.
///   2. Override value's runtime type can't be coerced to the manifest's
///      declared `type` → `type_mismatch`.
///   3. Numeric out of `[minValue, maxValue]` → `range_violation`.
///   4. String not in `allowedValues` (when defined) → `not_allowed`.
///   5. String doesn't match `pattern` (when defined) → `pattern_violation`.
///   6. String contains C0 control chars (0x00–0x08, 0x0B, 0x0C, 0x0E–0x1F)
///      → `invalid_chars`. Defense-in-depth against newline injection,
///      terminal escape sequences, and similar trivially weaponized bytes.
class ParamValidator {
  const ParamValidator();

  ParamValidationResult validate({
    required List<ScriptParam> manifestParams,
    required Map<String, Object?> overrides,
  }) {
    final byName = {for (final p in manifestParams) p.name: p};

    for (final entry in overrides.entries) {
      final p = byName[entry.key];
      if (p == null) {
        return ParamValidationResult.fail(
          code: 'unknown_param',
          paramName: entry.key,
          message: 'Override "${entry.key}" is not declared in the script manifest',
        );
      }
      final value = entry.value;
      if (value == null) continue; // null means "use manifest default", fine

      final typeFail = _checkType(p, value);
      if (typeFail != null) return typeFail;

      switch (p.type) {
        case 'int':
        case 'num':
          final n = (value as num).toDouble();
          final rangeFail = _checkRange(p, n);
          if (rangeFail != null) return rangeFail;
          break;
        case 'string':
          final s = value as String;
          final allowFail = _checkAllowed(p, s);
          if (allowFail != null) return allowFail;
          final patFail = _checkPattern(p, s);
          if (patFail != null) return patFail;
          final ctrlFail = _checkControlChars(p, s);
          if (ctrlFail != null) return ctrlFail;
          break;
        case 'stringList':
          if (value is List) {
            for (final item in value) {
              if (item is! String) {
                return ParamValidationResult.fail(
                  code: 'type_mismatch',
                  paramName: p.name,
                  message:
                      'Param "${p.name}" expects List<String>; element was ${item.runtimeType}',
                );
              }
              final allowFail = _checkAllowed(p, item);
              if (allowFail != null) return allowFail;
              final patFail = _checkPattern(p, item);
              if (patFail != null) return patFail;
              final ctrlFail = _checkControlChars(p, item);
              if (ctrlFail != null) return ctrlFail;
              // Madde 19: ParamMerge stringList'i `,` ile birleştirip tek
              // argv token gönderiyor (PowerShell `[string[]]` named param
              // virgülle array alır; ayrı token binding'i kırar). Bir öğe
              // virgül içerirse script split'inde fazladan eleman olarak
              // belirir — wire'da bunu reddederek list-injection'ı kapat.
              if (item.contains(',')) {
                return ParamValidationResult.fail(
                  code: 'invalid_chars',
                  paramName: p.name,
                  message:
                      'Param "${p.name}" list element contains a comma; the '
                      'comma is the list delimiter and would inject extra items',
                );
              }
            }
          }
          break;
        case 'bool':
          // Already validated by _checkType; no additional constraints.
          break;
      }
    }
    return const ParamValidationResult.ok();
  }

  ParamValidationResult? _checkType(ScriptParam p, Object value) {
    switch (p.type) {
      case 'bool':
        if (value is! bool) {
          return _typeMismatch(p, value, 'bool');
        }
        return null;
      case 'int':
        if (value is! int) {
          return _typeMismatch(p, value, 'int');
        }
        return null;
      case 'num':
        if (value is! num) {
          return _typeMismatch(p, value, 'num');
        }
        return null;
      case 'string':
        if (value is! String) {
          return _typeMismatch(p, value, 'string');
        }
        return null;
      case 'stringList':
        if (value is! List) {
          return _typeMismatch(p, value, 'List<String>');
        }
        return null;
      default:
        // Unknown manifest type — let it through to `ParamMerge`, which
        // already has a default-stringify fallback. A bad type tag is a
        // manifest bug, not a wire-side attack vector.
        return null;
    }
  }

  ParamValidationResult _typeMismatch(
      ScriptParam p, Object value, String expected) =>
    ParamValidationResult.fail(
      code: 'type_mismatch',
      paramName: p.name,
      message:
          'Param "${p.name}" expects $expected, got ${value.runtimeType}',
    );

  ParamValidationResult? _checkRange(ScriptParam p, double n) {
    if (p.minValue != null && n < p.minValue!) {
      return ParamValidationResult.fail(
        code: 'range_violation',
        paramName: p.name,
        message: 'Param "${p.name}" = $n below minimum ${p.minValue}',
      );
    }
    if (p.maxValue != null && n > p.maxValue!) {
      return ParamValidationResult.fail(
        code: 'range_violation',
        paramName: p.name,
        message: 'Param "${p.name}" = $n above maximum ${p.maxValue}',
      );
    }
    return null;
  }

  ParamValidationResult? _checkAllowed(ScriptParam p, String s) {
    final allowed = p.allowedValues;
    if (allowed == null) return null;
    if (allowed.contains(s)) return null;
    return ParamValidationResult.fail(
      code: 'not_allowed',
      paramName: p.name,
      message: 'Param "${p.name}" = "$s" not in allowedValues',
    );
  }

  ParamValidationResult? _checkPattern(ScriptParam p, String s) {
    final pattern = p.pattern;
    if (pattern == null) return null;
    final re = RegExp(pattern);
    if (re.hasMatch(s)) return null;
    return ParamValidationResult.fail(
      code: 'pattern_violation',
      paramName: p.name,
      message: 'Param "${p.name}" = "$s" does not match $pattern',
    );
  }

  ParamValidationResult? _checkControlChars(ScriptParam p, String s) {
    for (var i = 0; i < s.length; i++) {
      final c = s.codeUnitAt(i);
      // Allow TAB (0x09), LF (0x0A), CR (0x0D) — these appear in legitimate
      // multi-line dialog bodies. Ban the rest of the C0 range.
      if (c < 0x20 && c != 0x09 && c != 0x0A && c != 0x0D) {
        return ParamValidationResult.fail(
          code: 'invalid_chars',
          paramName: p.name,
          message:
              'Param "${p.name}" contains control byte 0x${c.toRadixString(16).padLeft(2, '0')}',
        );
      }
    }
    return null;
  }
}

/// Merges manifest defaults with runtime overrides and emits the argv list
/// PowerShell consumes.
///
/// Rules:
///   - bool true is rendered as a switch (`-name`); bool false is omitted
///     (no `-name:$false` form, scripts opt out by simply not seeing the
///     flag, matches typical PowerShell conventions for our scripts).
///   - int / num: rendered as `-name `value``.
///   - string: rendered as `-name "value"` via argv list, no shell
///     escape needed (Process.start runInShell:false).
///   - `List<String>`: joined with comma, sent as a single quoted string;
///     the script's `param([string[]]$apps)` will accept comma-split input
///     (it does in our save-all-open). For richer lists we'd need to send
///     multiple `-name value1 value2 ...` tokens, deferred until a script
///     actually needs it.
///   - null: parameter omitted.
/// Argv flag convention, picked per script runtime by [ScriptRunner].
enum ParamStyle {
  /// PowerShell (`win` + user scripts): `-name value`; bool `true` becomes a
  /// bare switch `-name`, `false` is omitted. Matches `param([switch]$x)`.
  powershell,

  /// POSIX shell (`mac` = applescript-bash, `lx` = bash): `--name value` for
  /// every type — bool too (`--name true|false`). Matches the bundled `.sh`
  /// scripts' `case --name) x="$2"; shift 2 ;;` parse convention, where every
  /// flag (including bools like `--verbose`) reads a following value.
  posix,
}

class ParamMerge {
  const ParamMerge();

  /// Returns argv list ready to append after the script path. [style] picks
  /// the flag convention so the same manifest+overrides drive PowerShell
  /// (`-name`) and POSIX (`--name`) scripts identically.
  List<String> resolve({
    required List<ScriptParam> manifestParams,
    Map<String, Object?> overrides = const {},
    ParamStyle style = ParamStyle.powershell,
  }) {
    final dash = style == ParamStyle.posix ? '--' : '-';
    final args = <String>[];
    for (final p in manifestParams) {
      final value = overrides.containsKey(p.name)
          ? overrides[p.name]
          : p.defaultValue;
      if (value == null) continue;
      switch (p.type) {
        case 'bool':
          if (style == ParamStyle.posix) {
            // Emit explicit value: the `.sh` scripts always `shift 2` after a
            // flag, so a bare `--name` would consume the next token as its
            // value and desync parsing.
            args
              ..add('$dash${p.name}')
              ..add((value == true).toString());
          } else if (value is bool && value) {
            args.add('$dash${p.name}'); // PowerShell switch
          }
          break;
        case 'int':
        case 'num':
        case 'string':
          args
            ..add('$dash${p.name}')
            ..add(value.toString());
          break;
        case 'stringList':
          // Comma-joined single token for both styles (PS `[string[]]` splits
          // on comma; `.sh` scripts read the csv into one var). Per-item comma
          // injection is blocked by ParamValidator (güvenlik.md Madde 19).
          if (value is List) {
            args
              ..add('$dash${p.name}')
              ..add(value.join(','));
          } else if (value is String) {
            args
              ..add('$dash${p.name}')
              ..add(value);
          }
          break;
        default:
          // Unknown types are passed through as plain strings so a new
          // param type isn't silently dropped during runner upgrades.
          args
            ..add('$dash${p.name}')
            ..add(value.toString());
      }
    }
    return args;
  }
}
