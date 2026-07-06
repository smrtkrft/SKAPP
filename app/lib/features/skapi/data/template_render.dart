// Config-time `{{param}}` substitution for API/device templates.
//
// Two distinct placeholder layers exist in the template pipeline:
//   {{param}}  — double-brace, resolved HERE in the app before anything is
//                sent to a device. Values come from the template's param
//                form (secrets, hostnames, keys).
//   {token}    — single-brace, NOT touched here. These survive the upload
//                and are rendered on-device at fire time by sk_api
//                (render_ep_payload: {event}, {device}, {value1}...).
//
// Keeping the syntaxes disjoint means a template can safely mix both:
//   {"key":"{{ifttt-key}}","note":"{event} on {device}"}

final RegExp _placeholderRe = RegExp(r'\{\{([a-z0-9_-]+)\}\}');

/// Replaces every `{{name}}` placeholder with `values[name]`. Placeholders
/// without a matching entry (or with an empty value) are left verbatim so
/// [unresolvedPlaceholders] can flag them before save.
String renderTemplate(String template, Map<String, String> values) {
  return template.replaceAllMapped(_placeholderRe, (m) {
    final v = values[m.group(1)];
    return (v == null || v.isEmpty) ? m.group(0)! : v;
  });
}

/// Distinct `{{name}}` keys still present in [text] — after a full render
/// this means the user left required params empty. Order of first
/// appearance, no duplicates.
List<String> unresolvedPlaceholders(String text) {
  final seen = <String>{};
  final out = <String>[];
  for (final m in _placeholderRe.allMatches(text)) {
    final name = m.group(1)!;
    if (seen.add(name)) out.add(name);
  }
  return out;
}
