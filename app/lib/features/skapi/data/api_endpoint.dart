import '../../../l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// On-device API endpoint model + wire-format ↔ enum conversions.
//
// Extracted from on_device_api_editor_screen.dart (Faz 5 god-file split) so
// the editor screen and its endpoint-card widget can share the model without
// a circular import. Helpers are public because both consumers reference them.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Wire-format ↔ enum conversions
// ---------------------------------------------------------------------------

enum ApiType { generic, ifttt, webhookPost }

String typeWire(ApiType t) => switch (t) {
      ApiType.generic => 'generic',
      ApiType.ifttt => 'ifttt',
      ApiType.webhookPost => 'webhook_post',
    };

ApiType typeFromWire(String? s) => switch (s) {
      'generic' => ApiType.generic,
      'ifttt' => ApiType.ifttt,
      'webhook_post' => ApiType.webhookPost,
      _ => ApiType.generic,
    };

String typeLabel(ApiType t) => switch (t) {
      ApiType.generic => 'Generic HTTP',
      ApiType.ifttt => 'IFTTT',
      ApiType.webhookPost => 'Webhook (POST)',
    };

String typeBadgeText(ApiType t) => switch (t) {
      ApiType.generic => 'GEN',
      ApiType.ifttt => 'IF',
      ApiType.webhookPost => 'WH',
    };

enum HttpMethod { get, post, put, delete }

String methodWire(HttpMethod m) => switch (m) {
      HttpMethod.get => 'GET',
      HttpMethod.post => 'POST',
      HttpMethod.put => 'PUT',
      HttpMethod.delete => 'DELETE',
    };

HttpMethod methodFromWire(String? s) => switch (s?.toUpperCase()) {
      'GET' => HttpMethod.get,
      'POST' => HttpMethod.post,
      'PUT' => HttpMethod.put,
      'DELETE' => HttpMethod.delete,
      _ => HttpMethod.post,
    };

enum AuthMode { none, bearer, basic, header }

String authWire(AuthMode a) => a.name;

AuthMode authFromWire(String? s) => switch (s) {
      'none' => AuthMode.none,
      'bearer' => AuthMode.bearer,
      'basic' => AuthMode.basic,
      'header' => AuthMode.header,
      _ => AuthMode.none,
    };

String authLabel(AppLocalizations l, AuthMode a) => switch (a) {
      AuthMode.none => l.bfApiChainAuthNone,
      AuthMode.bearer => l.bfApiChainAuthBearer,
      AuthMode.basic => l.bfApiChainAuthBasic,
      AuthMode.header => l.bfApiChainAuthHeader,
    };

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

/// Endpoint bucket kind, mirrors firmware sk_api_kind_t.
///   user   = manual IoT webhook (max SK_API_USER_SLOTS slots, fully editable)
///   system = auto-managed entry owned by a paired SKAPP install
///            (read-only here; the SKAPP install with the matching
///             peer_id manages it via api.system.add/remove from its
///             SKAPI bindings flow)
enum ApiKind { user, system }

ApiKind kindFromWire(String? s) => switch (s) {
      'system' => ApiKind.system,
      _ => ApiKind.user,
    };

class ApiEndpoint {
  ApiEndpoint({
    required this.name,
    required this.type,
    required this.url,
    this.method = HttpMethod.post,
    this.auth = AuthMode.none,
    this.headerName,
    this.contentType,
    this.maskedToken,
    this.delayAfterSec = 0,
    this.slot = -1,
    this.expanded = false,
    this.kind = ApiKind.user,
    this.peerIdHex,
  });

  String name;
  ApiType type;
  String url;
  HttpMethod method;
  AuthMode auth;
  String? headerName;
  String? contentType;

  /// BF returns a masked preview of the stored token (e.g. `sk_…AbCd`).
  /// SKAPP never gets the plaintext, to rotate, the user supplies a new
  /// value via the "Token" field which goes back as `--token <plain>`.
  String? maskedToken;

  int delayAfterSec;

  /// Slot index assigned by BF.
  ///   user   bucket: 0..SK_API_USER_SLOTS-1
  ///   system bucket: 0..SK_API_SYSTEM_SLOTS-1
  /// -1 means "not yet saved" (only used for in-progress USER drafts).
  int slot;

  /// UI-only: card expanded for editing.
  bool expanded;

  /// Bucket — manuel IoT (user) vs paired SKAPP (system).
  ApiKind kind;

  /// SYSTEM kind only: full hex of the peer_id that owns this slot.
  /// Empty string for USER kind. Used to label the read-only row with
  /// the SKAPP install identity.
  String? peerIdHex;

  factory ApiEndpoint.fromJson(Map<String, dynamic> j) => ApiEndpoint(
        slot: (j['slot'] as num?)?.toInt() ?? -1,
        name: (j['name'] ?? '').toString(),
        type: typeFromWire(j['type']?.toString()),
        url: (j['url'] ?? '').toString(),
        method: methodFromWire(j['method']?.toString()),
        auth: authFromWire(j['auth']?.toString()),
        headerName: (j['header'] as String?) ??
            (j['header_name'] as String?),
        contentType: j['content_type']?.toString(),
        maskedToken: j['masked_token']?.toString(),
        delayAfterSec:
            (j['delay_after_sec'] as num?)?.toInt() ?? 0,
        kind: kindFromWire(j['kind']?.toString()),
        peerIdHex: (j['peer_id'] as String?) ?? '',
      );
}
