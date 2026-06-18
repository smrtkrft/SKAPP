/// Tiny matcher for `ActionBinding.eventFilter`.
///
/// Two forms are supported:
///   - exact:    `timer.expired`        -> matches `timer.expired` only
///   - prefix:   `timer.*`              -> matches anything starting with
///                                          `timer.` (one or more dotted
///                                          segments)
///   - all:      `*`                    -> matches every event
///
/// More complex glob / regex matchers are not justified yet: BF's event
/// namespace is shallow and predictable. If a script ever needs OR
/// across multiple unrelated events, the user creates two bindings.
class EventFilter {
  const EventFilter._();

  static bool match(String filter, String event) {
    if (filter.isEmpty || event.isEmpty) return false;
    if (filter == '*') return true;
    if (filter == event) return true;
    if (filter.endsWith('.*')) {
      final prefix = filter.substring(0, filter.length - 2);
      // require a dot after the prefix so `timer.*` matches `timer.expired`
      // but not `timerextra.foo`.
      return event.length > prefix.length &&
          event.startsWith(prefix) &&
          event.codeUnitAt(prefix.length) == 0x2E /* . */;
    }
    return false;
  }
}
