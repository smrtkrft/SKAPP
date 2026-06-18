import 'dart:convert';

/// One row in the SKAPI binding table.
///
/// A binding ties a SKAPI script to a device event: when the device
/// emits an event matching `eventFilter`, the trigger service runs
/// `scriptId` (on Desktop directly via `ScriptRunner`, on Mobile a
/// dürüst SnackBar in Faz I, real forward in Faz K).
///
/// `id` is a v4 UUID-ish string generated at create time so the same
/// (script, device, event) combination can be saved twice with
/// different param overrides without collisions.
class ActionBinding {
  const ActionBinding({
    required this.id,
    required this.scriptId,
    required this.platform,
    required this.deviceId,
    required this.eventFilter,
    required this.paramOverrides,
    required this.enabled,
    required this.createdAt,
    this.prerunDelaySeconds = 0,
  });

  final String id;
  final String scriptId;
  final String platform;
  final String deviceId;
  final String eventFilter;
  final Map<String, Object?> paramOverrides;
  final bool enabled;
  final DateTime createdAt;

  /// Optional wait between the binding firing and the script actually
  /// starting. Useful when the user wants the device's notification to
  /// land first, or when chaining actions. Default 0 (immediate).
  /// Older serialised entries without this field round-trip safely as 0.
  final int prerunDelaySeconds;

  ActionBinding copyWith({
    String? scriptId,
    String? platform,
    String? deviceId,
    String? eventFilter,
    Map<String, Object?>? paramOverrides,
    bool? enabled,
    int? prerunDelaySeconds,
  }) {
    return ActionBinding(
      id: id,
      scriptId: scriptId ?? this.scriptId,
      platform: platform ?? this.platform,
      deviceId: deviceId ?? this.deviceId,
      eventFilter: eventFilter ?? this.eventFilter,
      paramOverrides: paramOverrides ?? this.paramOverrides,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt,
      prerunDelaySeconds: prerunDelaySeconds ?? this.prerunDelaySeconds,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'scriptId': scriptId,
        'platform': platform,
        'deviceId': deviceId,
        'eventFilter': eventFilter,
        'paramOverrides': paramOverrides,
        'enabled': enabled,
        'createdAt': createdAt.toIso8601String(),
        'prerunDelaySeconds': prerunDelaySeconds,
      };

  factory ActionBinding.fromJson(Map<String, dynamic> json) => ActionBinding(
        id: json['id'] as String,
        scriptId: json['scriptId'] as String,
        platform: json['platform'] as String,
        deviceId: json['deviceId'] as String,
        eventFilter: json['eventFilter'] as String,
        paramOverrides:
            ((json['paramOverrides'] as Map?)?.cast<String, Object?>() ??
                const {}),
        enabled: json['enabled'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
        prerunDelaySeconds:
            (json['prerunDelaySeconds'] as num?)?.toInt() ?? 0,
      );

  static String encodeList(List<ActionBinding> bindings) =>
      jsonEncode(bindings.map((b) => b.toJson()).toList());

  static List<ActionBinding> decodeList(String source) {
    if (source.isEmpty) return const [];
    final raw = jsonDecode(source) as List<dynamic>;
    return raw
        .map((e) => ActionBinding.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);
  }
}
