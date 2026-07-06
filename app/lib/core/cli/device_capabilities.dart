// Device capability fingerprint — wraps the hidden `device.capabilities`
// CLI command so feature-gated UI (e.g. the endpoint payload field) can
// degrade gracefully on older firmware instead of silently dropping args
// the device doesn't understand.
//
// Firmware response shape (sk_capabilities_render_json):
//   { "device_id": "BF-...", "fw_version": "1.2.3",
//     "books": [ {"name":"sk_api","version":"0.5.0"}, ... ] }

import 'cli_client.dart';

/// Parsed capability set of one device: book name → semver string.
class DeviceCapabilities {
  const DeviceCapabilities(this.books);

  /// Empty set — used when the device predates `device.capabilities`
  /// or the query failed; every `supports*` check then returns false.
  static const none = DeviceCapabilities({});

  final Map<String, String> books;

  String? versionOf(String book) => books[book];

  /// True when [book] is loaded at [min] version or newer. Versions are
  /// dotted numeric triples ("0.5.0"); missing segments count as 0.
  bool atLeast(String book, String min) {
    final v = books[book];
    if (v == null) return false;
    return _compareVersions(v, min) >= 0;
  }

  /// sk_api >= 0.5.0 stores a per-endpoint payload template
  /// (`api.endpoint.add --payload`). Older firmware silently ignores the
  /// arg, so callers must hide/skip payload when this is false.
  bool get supportsEndpointPayload => atLeast('sk_api', '0.5.0');

  static int _compareVersions(String a, String b) {
    final pa = a.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final pb = b.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    for (var i = 0; i < 3; i++) {
      final da = i < pa.length ? pa[i] : 0;
      final db = i < pb.length ? pb[i] : 0;
      if (da != db) return da.compareTo(db);
    }
    return 0;
  }
}

/// One-shot capability query against an already-connected [CliClient].
/// Failures (old firmware → ERR_UNKNOWN_COMMAND, timeouts) degrade to
/// [DeviceCapabilities.none] — feature gates stay closed, nothing throws.
Future<DeviceCapabilities> fetchDeviceCapabilities(CliClient client) async {
  try {
    final r = await client.send('device.capabilities');
    if (!r.ok || r.data is! Map) return DeviceCapabilities.none;
    final raw = (r.data as Map)['books'];
    if (raw is! List) return DeviceCapabilities.none;
    final books = <String, String>{};
    for (final b in raw) {
      if (b is Map && b['name'] is String && b['version'] is String) {
        books[b['name'] as String] = b['version'] as String;
      }
    }
    return DeviceCapabilities(books);
  } catch (_) {
    return DeviceCapabilities.none;
  }
}
