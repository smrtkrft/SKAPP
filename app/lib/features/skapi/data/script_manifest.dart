import 'dart:convert';

/// Sidecar manifest describing one bundled SKAPI script.
///
/// Lives next to its `.ps1` (or future runtime) file as `<id>.json`. The
/// `.ps1` is pure code in English and never translated; everything users
/// read (title, summary, parameter labels, hints, notes) lives behind the
/// i18n keys referenced here and is resolved against `AppLocalizations`.
class ScriptManifest {
  const ScriptManifest({
    required this.id,
    required this.platform,
    required this.group,
    required this.tier,
    required this.runtime,
    required this.scriptFile,
    required this.i18nTitle,
    required this.i18nSummaryWhat,
    required this.i18nSummaryHow,
    required this.i18nNote,
    required this.params,
    this.remoteRunnable = false,
  });

  /// Stable identifier, e.g. `save-active-window`. Never translated; used
  /// as filename, key for overrides, and CLI/log handle. Kebab-case.
  final String id;

  /// `win` | `mac` | `lx` | `other`. Matches the asset subfolder.
  final String platform;

  /// Group id (kebab-case), e.g. `save-work`. Matches `<group>.group.json`.
  final String group;

  /// Internal tier hint (1–3). Not surfaced to end users; affects runtime
  /// selection when Tier 2/3 are wired (currently only Tier 1 ships).
  final int tier;

  /// Runtime tag, e.g. `powershell-5.1`. Source of truth for the executor
  /// to pick the right interpreter/wrapper.
  final String runtime;

  /// Filename of the executable script (relative to manifest folder).
  /// Kept separate from `id` so a script could ship as `.ps1` today and a
  /// `.psm1` module tomorrow without renaming the id.
  final String scriptFile;

  final String i18nTitle;
  final String i18nSummaryWhat;
  final String i18nSummaryHow;
  /// Optional note rendered as the "Ek Notlar" section. `null` = section
  /// hidden entirely (default-empty case from the design spec).
  final String? i18nNote;

  final List<ScriptParam> params;

  /// Remote execution opt-in flag.
  ///
  /// When `false` (default), the desktop HTTP server's
  /// `POST /api/scripts/.../run` endpoint refuses to execute this script
  /// from a paired mobile SKAPP peer and returns 403 `not_remote_runnable`.
  /// Local execution (Desktop UI's "Run now") ignores this flag — it's
  /// strictly a wire-side whitelist guarding the peer-trigger surface.
  ///
  /// Safe scripts (toast/dialog/volume-set/brightness/media-key/show-desktop/
  /// fade-screen/grayscale/find-mouse-shake/mute-toggle) opt in by setting
  /// `"remoteRunnable": true` in their JSON manifest. Power scripts
  /// (shutdown/hibernate/kill-app/launch-app/browser-* etc.) deliberately
  /// stay default-off; promoting them needs a separate review.
  final bool remoteRunnable;

  factory ScriptManifest.fromJson(Map<String, dynamic> json) {
    final i18n = (json['i18n'] as Map?)?.cast<String, dynamic>() ?? const {};
    final rawParams = (json['params'] as List?) ?? const [];
    return ScriptManifest(
      id: json['id'] as String,
      platform: json['platform'] as String,
      group: json['group'] as String,
      tier: (json['tier'] as num?)?.toInt() ?? 1,
      runtime: json['runtime'] as String,
      scriptFile: json['scriptFile'] as String,
      i18nTitle: i18n['title'] as String,
      i18nSummaryWhat: i18n['summaryWhat'] as String,
      i18nSummaryHow: i18n['summaryHow'] as String,
      i18nNote: i18n['note'] as String?,
      params: [
        for (final p in rawParams)
          ScriptParam.fromJson((p as Map).cast<String, dynamic>()),
      ],
      remoteRunnable: json['remoteRunnable'] as bool? ?? false,
    );
  }

  static ScriptManifest decode(String source) =>
      ScriptManifest.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

/// One `param()` block entry from the underlying script. The default value
/// is the source-of-truth fallback shown in the Adım 4 warning panel; users
/// override it through the editor (Adım 5) or via per-binding values.
class ScriptParam {
  const ScriptParam({
    required this.name,
    required this.type,
    required this.defaultValue,
    required this.i18nLabel,
    required this.i18nHint,
    this.unit,
    this.pattern,
    this.allowedValues,
    this.minValue,
    this.maxValue,
  });

  /// Parameter name as declared in the script (e.g. `timeout`). PowerShell
  /// invocations use `-timeout 5`, so this string must stay in sync with
  /// the `param()` block; it is not translated.
  final String name;

  /// Loose type tag for UI rendering: `int`, `bool`, `string`, `stringList`.
  /// The executor coerces final values back to the runtime's native types.
  final String type;

  /// Raw default; kept dynamic because PowerShell-source defaults span
  /// several JSON types and are surfaced verbatim to the user.
  final Object? defaultValue;

  final String i18nLabel;
  final String? i18nHint;

  /// Optional semantic unit hint for the basic-mode form. Currently only
  /// `"seconds"` is supported; when set, the int input renders a fixed
  /// "saniye" badge and a live conversion line ("600 sn = 10 dakika").
  /// Null means a plain number with no unit decoration. Adding a new
  /// unit (e.g. `"percent"`) is a UI-only change here plus a manifest
  /// edit; the executor still receives the raw number.
  final String? unit;

  /// Optional regex used by `ParamValidator` to reject override values that
  /// don't match. Anchors must be added by the manifest author; the
  /// validator does not auto-wrap. Only consulted for string-typed params.
  final String? pattern;

  /// Optional finite set of accepted string values. Case-sensitive. When
  /// present, the validator rejects override values not in this list,
  /// regardless of `pattern`. Used for enum-like params (e.g. media key
  /// alias, dialog button preset).
  final List<String>? allowedValues;

  /// Optional inclusive lower bound for numeric params (int / num). Stored
  /// as double for JSON parsing convenience; integer params still receive
  /// the raw int through `ParamMerge`.
  final double? minValue;

  /// Optional inclusive upper bound for numeric params.
  final double? maxValue;

  factory ScriptParam.fromJson(Map<String, dynamic> json) => ScriptParam(
        name: json['name'] as String,
        type: json['type'] as String,
        defaultValue: json['default'],
        i18nLabel: json['i18nLabel'] as String,
        i18nHint: json['i18nHint'] as String?,
        unit: json['unit'] as String?,
        pattern: json['pattern'] as String?,
        allowedValues:
            (json['allowedValues'] as List?)?.cast<String>().toList(growable: false),
        minValue: (json['min'] as num?)?.toDouble(),
        maxValue: (json['max'] as num?)?.toDouble(),
      );
}

/// Group-level manifest (`<group>.group.json`). Holds ordered script ids
/// plus the i18n keys used for the group header and description directly
/// rendered on the group screen (Adım 3, no accordion).
class GroupManifest {
  const GroupManifest({
    required this.id,
    required this.platform,
    required this.i18nTitle,
    required this.i18nDesc,
    required this.i18nFoot,
    required this.scriptIds,
  });

  final String id;
  final String platform;
  final String i18nTitle;
  final String i18nDesc;
  /// Optional footer line under the description (italic typical-use hint).
  /// `null` hides the footer.
  final String? i18nFoot;
  final List<String> scriptIds;

  factory GroupManifest.fromJson(Map<String, dynamic> json) => GroupManifest(
        id: json['id'] as String,
        platform: json['platform'] as String,
        i18nTitle: json['i18nTitle'] as String,
        i18nDesc: json['i18nDesc'] as String,
        i18nFoot: json['i18nFoot'] as String?,
        scriptIds: ((json['scripts'] as List?) ?? const [])
            .map((e) => e as String)
            .toList(growable: false),
      );

  static GroupManifest decode(String source) =>
      GroupManifest.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

/// Platform-level manifest (`_platform.json`). Lists which group files to
/// load and pins the runtime; lets us add platforms without code changes.
///
/// `other-*` platforms (SynDimm, LebensSpur, Blocking Focus, IoT, Server)
/// use `apiTemplates` instead of `groups` — their entries are
/// [ApiTemplateManifest]s the user uploads onto a paired device, not
/// scripts the host executes. Both lists are honoured so a platform can
/// in principle expose both kinds.
class PlatformManifest {
  const PlatformManifest({
    required this.platform,
    required this.runtime,
    required this.groupIds,
    this.apiTemplateIds = const [],
  });

  final String platform;
  final String runtime;
  final List<String> groupIds;
  final List<String> apiTemplateIds;

  factory PlatformManifest.fromJson(Map<String, dynamic> json) =>
      PlatformManifest(
        platform: json['platform'] as String,
        runtime: json['runtime'] as String,
        groupIds: ((json['groups'] as List?) ?? const [])
            .map((e) => e as String)
            .toList(growable: false),
        apiTemplateIds: ((json['apiTemplates'] as List?) ?? const [])
            .map((e) => e as String)
            .toList(growable: false),
      );

  static PlatformManifest decode(String source) =>
      PlatformManifest.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

/// Sidecar manifest describing one on-device API template (Yapı 2).
///
/// Lives under `assets/skapi/other-<category>/<id>.json` with `kind: "api"`.
/// Loaded by `skapi_providers.dart` and unioned with [ScriptManifest] at the
/// catalog layer; downstream UI dispatches on type (`ScriptManifest` →
/// `SkapiScriptDetailScreen`, `ApiTemplateManifest` →
/// `SkapiApiTemplateDetailScreen`).
///
/// A template is a *prefill* for [OnDeviceApiEditorScreen]: the user picks
/// a template, the editor opens populated with `defaults`, the user fills
/// any [params] (typically secrets like an IFTTT key), and on save SKAPP
/// substitutes the user's values into [urlTemplate] / [payloadTemplate]
/// then calls `api.endpoint.add` on the target device.
///
/// Template values map 1:1 to BF firmware fields (`sk_api_endpoint_cfg_t`
/// in `esp32/BF/components/sk_api/include/sk_api.h`):
///   defaultName       → name (max 31 char)
///   type              → sk_api_type_t (generic | ifttt | webhook_post)
///   urlTemplate       → url (max 191 char)
///   method            → sk_api_method_t (POST | GET | PUT | DELETE)
///   auth              → sk_api_auth_t (none | bearer | basic | header)
///   headerName        → header_name (only when auth=header)
///   contentType       → content_type (override "application/json")
///   payloadTemplate   → request body (max 768 char, after substitution)
///   delayAfterSec     → delay_after_sec (0-300, cooldown before next slot)
class ApiTemplateManifest {
  const ApiTemplateManifest({
    required this.id,
    required this.platform,
    required this.targetDeviceType,
    required this.i18nTitle,
    required this.i18nSummary,
    required this.defaultName,
    required this.type,
    required this.urlTemplate,
    required this.method,
    required this.auth,
    required this.delayAfterSec,
    this.i18nNote,
    this.headerName,
    this.contentType,
    this.payloadTemplate,
    this.params = const [],
  });

  /// Stable identifier, e.g. `lights-on`. Kebab-case; matches the JSON
  /// filename (`<id>.json`) and is used as an asset / override key.
  final String id;

  /// Asset platform id, e.g. `other-syndimm`. Matches the
  /// `assets/skapi/<platform>/` folder.
  final String platform;

  /// Which physical device kind this template targets. `bf` today; future
  /// values like `lebensspur` will gate the device picker so the user only
  /// sees compatible peers when uploading the template.
  final String targetDeviceType;

  final String i18nTitle;
  final String i18nSummary;
  final String? i18nNote;

  /// Default `name` written to the BF slot. Max 31 ASCII chars. The user
  /// may rename it in the editor; uniqueness across the 5 USER slots is
  /// enforced by firmware (upsert by name).
  final String defaultName;

  /// `generic` | `ifttt` | `webhook_post`. Wire-format strings; the
  /// editor maps to `ApiType` enum, the CLI sends them verbatim.
  final String type;

  /// URL with optional `{{paramName}}` placeholders that map onto entries
  /// in [params]. Substitution happens at save time, not at render time —
  /// the editor shows the raw template so the user understands where their
  /// secret goes.
  final String urlTemplate;

  /// `POST` | `GET` | `PUT` | `DELETE`.
  final String method;

  /// `none` | `bearer` | `basic` | `header`.
  final String auth;

  /// Required header name when [auth] is `header` (e.g. `X-API-Key`).
  /// Ignored otherwise.
  final String? headerName;

  /// Override for `Content-Type`. Null → firmware default
  /// (`application/json`).
  final String? contentType;

  /// Request body template. May contain `{{paramName}}` placeholders.
  /// Null → no body (typical for GET).
  final String? payloadTemplate;

  /// Seconds to wait after this endpoint fires before the next chain slot
  /// fires. Capped at 300 by firmware; default 0.
  final int delayAfterSec;

  /// User-fillable values that get substituted into [urlTemplate] /
  /// [payloadTemplate]. Typically secrets (IFTTT key, bearer token) the
  /// template author cannot bake in.
  final List<ApiTemplateParam> params;

  factory ApiTemplateManifest.fromJson(Map<String, dynamic> json) {
    final i18n = (json['i18n'] as Map?)?.cast<String, dynamic>() ?? const {};
    final defaults = (json['defaults'] as Map?)?.cast<String, dynamic>() ?? const {};
    final rawParams = (json['params'] as List?) ?? const [];
    return ApiTemplateManifest(
      id: json['id'] as String,
      platform: json['platform'] as String,
      targetDeviceType: json['targetDeviceType'] as String,
      i18nTitle: i18n['title'] as String,
      i18nSummary: i18n['summary'] as String,
      i18nNote: i18n['note'] as String?,
      defaultName: defaults['name'] as String? ?? json['id'] as String,
      type: defaults['type'] as String? ?? 'generic',
      urlTemplate: defaults['url'] as String? ?? '',
      method: defaults['method'] as String? ?? 'POST',
      auth: defaults['auth'] as String? ?? 'none',
      headerName: defaults['headerName'] as String?,
      contentType: defaults['contentType'] as String?,
      payloadTemplate: defaults['payload'] as String?,
      delayAfterSec: (defaults['delayAfterSec'] as num?)?.toInt() ?? 0,
      params: [
        for (final p in rawParams)
          ApiTemplateParam.fromJson((p as Map).cast<String, dynamic>()),
      ],
    );
  }

  static ApiTemplateManifest decode(String source) =>
      ApiTemplateManifest.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

/// One user-fillable slot inside an [ApiTemplateManifest].
///
/// Distinct from [ScriptParam] (no min/max/regex, no enum) because API
/// template params are mostly free-form strings the firmware never sees
/// (they get substituted into url/payload templates before the CLI call).
class ApiTemplateParam {
  const ApiTemplateParam({
    required this.name,
    required this.placeholder,
    required this.i18nLabel,
    this.i18nHint,
    this.defaultValue,
    this.secret = false,
  });

  /// Param key, kebab-case (e.g. `ifttt-key`). Used as override storage
  /// key; not translated.
  final String name;

  /// The exact placeholder string that appears in [ApiTemplateManifest
  /// .urlTemplate] / `.payloadTemplate` (e.g. `{{ifttt-key}}`). Editor
  /// substitutes this with the user's value at save time.
  final String placeholder;

  final String i18nLabel;
  final String? i18nHint;

  /// Optional prefill. Useful for non-secret defaults like a region or
  /// device id; secrets stay null so the editor surfaces an empty field.
  final String? defaultValue;

  /// When true, the editor renders an obscured (password) input and
  /// avoids logging the substituted final string.
  final bool secret;

  factory ApiTemplateParam.fromJson(Map<String, dynamic> json) =>
      ApiTemplateParam(
        name: json['name'] as String,
        placeholder: json['placeholder'] as String,
        i18nLabel: json['i18nLabel'] as String,
        i18nHint: json['i18nHint'] as String?,
        defaultValue: json['default'] as String?,
        secret: json['secret'] as bool? ?? false,
      );
}
