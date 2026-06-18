// LebensSpur design tokens.
//
// The new dashboard renders through sk_core neumorphic primitives
// (SkNeuCard / SkNeuIconSlot / SkNeuSwitch) and per-section widgets that
// pull colors from Theme.of(context), so this file only carries the
// shared spacing rhythm and the timer-state enum used by the hero ring +
// status parsers. The legacy LsCards / LsTypography / LsButtons /
// LsStatusColors / LsRadius tokens from the browser-era GUI were never
// adopted by the new design and have been removed.

class LsSpacing {
  LsSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Timer state machine, mirrored from the firmware enum. Used by the hero
/// to pick label text + ring variant. Values intentionally match the
/// strings the device emits on `timer.status` / `timer.state` so the
/// parser can do a direct lookup.
enum LsTimerStateKind {
  inactive,
  running,
  vacation,
  triggered;

  static LsTimerStateKind parse(String? raw) {
    switch (raw) {
      case 'running':
        return LsTimerStateKind.running;
      case 'vacation':
        return LsTimerStateKind.vacation;
      case 'triggered':
        return LsTimerStateKind.triggered;
      case 'inactive':
      case 'stopped':
      case null:
      default:
        return LsTimerStateKind.inactive;
    }
  }
}
