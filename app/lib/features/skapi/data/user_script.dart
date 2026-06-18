import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/preferences_provider.dart';
import 'script_manifest.dart';

/// A user-authored SKAPI script.
///
/// Unlike bundled scripts (asset `.ps1` + i18n-key manifest), a user script
/// is created in-app, stored locally, and carries **literal** title/summary
/// text in the user's own language (no translation pipeline). It surfaces in
/// the SKAPI library under "Benim Script'lerim" and reuses the existing
/// detail/run/bind machinery by projecting to a [ScriptManifest] whose
/// `i18n*` fields hold the literal strings — `resolveSkapiI18nKey` returns
/// any unrecognised key verbatim, so literals render as-is.
class UserScript {
  const UserScript({
    required this.id,
    required this.title,
    required this.description,
    required this.platform,
    required this.source,
    required this.createdAtMs,
    required this.updatedAtMs,
  });

  /// Stable id, e.g. `user-1716998400000`. Used as manifest id, run temp-file
  /// handle, override key, and binding scriptId. Never translated.
  final String id;

  /// Free-text title shown in lists and the detail header.
  final String title;

  /// Free-text one-line description (the "what" summary).
  final String description;

  /// `win` | `mac` | `lx`. Drives the runtime/interpreter and the platform
  /// badge; mirrors the bundled-script platform tag.
  final String platform;

  /// The script body (PowerShell on win, pwsh on mac/lx).
  final String source;

  final int createdAtMs;
  final int updatedAtMs;

  /// Runtime tag derived from [platform]; same values bundled manifests use.
  String get runtime =>
      platform == 'win' ? 'powershell-5.1' : 'powershell-7';

  UserScript copyWith({
    String? title,
    String? description,
    String? platform,
    String? source,
    int? updatedAtMs,
  }) =>
      UserScript(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        platform: platform ?? this.platform,
        source: source ?? this.source,
        createdAtMs: createdAtMs,
        updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'platform': platform,
        'source': source,
        'createdAtMs': createdAtMs,
        'updatedAtMs': updatedAtMs,
      };

  factory UserScript.fromJson(Map<String, dynamic> j) => UserScript(
        id: j['id'] as String,
        title: (j['title'] ?? '') as String,
        description: (j['description'] ?? '') as String,
        platform: (j['platform'] ?? 'win') as String,
        source: (j['source'] ?? '') as String,
        createdAtMs: (j['createdAtMs'] as num?)?.toInt() ?? 0,
        updatedAtMs: (j['updatedAtMs'] as num?)?.toInt() ?? 0,
      );

  /// Projects to a [ScriptManifest] so the script flows through the existing
  /// catalog/detail/run code. The literal title/description land in the
  /// `i18n*` slots (pass-through resolver), and there are no params in the
  /// MVP. `group` is a synthetic constant; `scriptFile` is a stable temp
  /// handle the raw-source runner uses for naming only.
  ScriptManifest toManifest() => ScriptManifest(
        id: id,
        platform: platform,
        group: kUserScriptGroup,
        tier: 1,
        runtime: runtime,
        scriptFile: '$id.ps1',
        i18nTitle: title,
        i18nSummaryWhat: description,
        i18nSummaryHow: '',
        i18nNote: null,
        params: const [],
      );
}

/// Synthetic group id for user scripts; never matches a bundled group.
const String kUserScriptGroup = 'user-scripts';

/// Persists the user-script list as a single JSON array under one key.
class UserScriptStore {
  UserScriptStore(this._prefs);
  final SharedPreferences _prefs;

  static const _kKey = 'skapi.userScripts.v1';

  List<UserScript> read() {
    final raw = _prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return [
        for (final e in list)
          if (e is Map) UserScript.fromJson(e.cast<String, dynamic>()),
      ];
    } catch (_) {
      // Corrupt payload: start clean rather than crash the tab.
      return const [];
    }
  }

  Future<List<UserScript>> _write(List<UserScript> next) async {
    await _prefs.setString(
      _kKey,
      jsonEncode([for (final s in next) s.toJson()]),
    );
    return next;
  }

  /// Insert or replace by id. New entries go to the front (most-recent-first).
  Future<List<UserScript>> upsert(UserScript script) {
    final current = read();
    final idx = current.indexWhere((s) => s.id == script.id);
    final next = [...current];
    if (idx >= 0) {
      next[idx] = script;
    } else {
      next.insert(0, script);
    }
    return _write(next);
  }

  Future<List<UserScript>> remove(String id) {
    final next = read().where((s) => s.id != id).toList(growable: false);
    return _write(next);
  }

  Future<void> clear() => _prefs.remove(_kKey);
}

final userScriptStoreProvider = Provider<UserScriptStore>((ref) {
  return UserScriptStore(ref.watch(sharedPreferencesProvider));
});

/// In-memory cache of user scripts. Mirrors [BindingsNotifier]: load on first
/// read, replace state on every mutation so dependent widgets rebuild.
class UserScriptsNotifier extends Notifier<List<UserScript>> {
  @override
  List<UserScript> build() => ref.watch(userScriptStoreProvider).read();

  Future<void> upsert(UserScript script) async {
    state = await ref.read(userScriptStoreProvider).upsert(script);
  }

  Future<void> remove(String id) async {
    state = await ref.read(userScriptStoreProvider).remove(id);
  }

  UserScript? byId(String id) {
    for (final s in state) {
      if (s.id == id) return s;
    }
    return null;
  }
}

final userScriptsProvider =
    NotifierProvider<UserScriptsNotifier, List<UserScript>>(
        UserScriptsNotifier.new);
