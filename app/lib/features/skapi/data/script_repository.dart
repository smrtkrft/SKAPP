import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'script_manifest.dart';

/// Loads bundled SKAPI manifests (platform → groups → scripts) and the raw
/// `.ps1` source of each script. Read-only: the bundled library is shipped
/// with the app and never written to. User edits live in `OverrideStorage`.
///
/// The repository caches manifest objects per platform after first load.
/// Asset bundle reads are cheap but JSON decoding is repeated work, and
/// the SKAPI screen scrolls through these structures on every rebuild.
class ScriptRepository {
  ScriptRepository({this.assetRoot = 'assets/skapi'});

  final String assetRoot;

  final Map<String, PlatformManifest> _platformCache = {};
  final Map<String, GroupManifest> _groupCache = {};
  final Map<String, ScriptManifest> _scriptCache = {};
  final Map<String, ApiTemplateManifest> _apiTemplateCache = {};

  /// Loads and caches the platform manifest. `platformId` matches the
  /// asset folder name (`win`, `mac`, `lx`, `other`).
  Future<PlatformManifest> loadPlatform(String platformId) async {
    final cached = _platformCache[platformId];
    if (cached != null) return cached;
    final source = await rootBundle.loadString(
      '$assetRoot/$platformId/_platform.json',
    );
    final manifest = PlatformManifest.decode(source);
    _platformCache[platformId] = manifest;
    return manifest;
  }

  /// Loads a single group definition. Cached by `<platform>/<group>` key
  /// because group ids are unique per platform but not globally.
  Future<GroupManifest> loadGroup(String platformId, String groupId) async {
    final key = '$platformId/$groupId';
    final cached = _groupCache[key];
    if (cached != null) return cached;
    final source = await rootBundle.loadString(
      '$assetRoot/$platformId/$groupId.group.json',
    );
    final manifest = GroupManifest.decode(source);
    _groupCache[key] = manifest;
    return manifest;
  }

  /// Loads one script's sidecar manifest.
  Future<ScriptManifest> loadScript(String platformId, String scriptId) async {
    final key = '$platformId/$scriptId';
    final cached = _scriptCache[key];
    if (cached != null) return cached;
    final source = await rootBundle.loadString(
      '$assetRoot/$platformId/$scriptId.json',
    );
    final manifest = ScriptManifest.decode(source);
    _scriptCache[key] = manifest;
    return manifest;
  }

  /// Loads one API template manifest (`other-*` platforms). Lives next to
  /// scripts under the same folder but is parsed into [ApiTemplateManifest]
  /// because the schema and downstream UI differ (on-device editor instead
  /// of script editor).
  Future<ApiTemplateManifest> loadApiTemplate(
    String platformId,
    String templateId,
  ) async {
    final key = '$platformId/$templateId';
    final cached = _apiTemplateCache[key];
    if (cached != null) return cached;
    final source = await rootBundle.loadString(
      '$assetRoot/$platformId/$templateId.json',
    );
    final manifest = ApiTemplateManifest.decode(source);
    _apiTemplateCache[key] = manifest;
    return manifest;
  }

  /// Loads every API template declared in a platform's `_platform.json`
  /// `apiTemplates` list, in declaration order. Used by the Other category
  /// detail screen to render the template list.
  Future<List<ApiTemplateManifest>> loadAllApiTemplates(
    String platformId,
  ) async {
    final platform = await loadPlatform(platformId);
    final templates = <ApiTemplateManifest>[];
    for (final id in platform.apiTemplateIds) {
      templates.add(await loadApiTemplate(platformId, id));
    }
    return templates;
  }

  /// Reads the raw, untranslated script source as bundled in the asset
  /// pack. Always returns the original; for the override-aware variant
  /// use `ScriptResolver`.
  Future<String> loadOriginalSource(ScriptManifest manifest) async {
    return rootBundle.loadString(
      '$assetRoot/${manifest.platform}/${manifest.scriptFile}',
    );
  }

  /// Convenience: walks `_platform.json` → groups → script ids and returns
  /// every manifest under the platform. Useful when the SKAPI screen needs
  /// totals (e.g., the "N script" line at Adım 2) before drilling in.
  Future<List<ScriptManifest>> loadAllScripts(String platformId) async {
    final platform = await loadPlatform(platformId);
    final scripts = <ScriptManifest>[];
    for (final groupId in platform.groupIds) {
      final group = await loadGroup(platformId, groupId);
      for (final scriptId in group.scriptIds) {
        scripts.add(await loadScript(platformId, scriptId));
      }
    }
    return scripts;
  }

  /// Loads every group manifest under a platform in `_platform.json` order.
  /// The Adım 2 platform screen renders one row per group with its title,
  /// description count, and script count, so it needs all groups in one
  /// pass, not as separate provider watches that fan out.
  Future<List<GroupManifest>> loadAllGroups(String platformId) async {
    final platform = await loadPlatform(platformId);
    final groups = <GroupManifest>[];
    for (final groupId in platform.groupIds) {
      groups.add(await loadGroup(platformId, groupId));
    }
    return groups;
  }

  /// Loads every script manifest belonging to a group in declaration order
  /// (the order found in `<group>.group.json`'s `scripts` array). The Adım
  /// 3 group screen needs all scripts at once to render the bare-row list
  /// and its "N script" header, so we batch the reads here rather than
  /// fanning out one watch per script id at the call site.
  Future<List<ScriptManifest>> loadGroupScripts(
    String platformId,
    String groupId,
  ) async {
    final group = await loadGroup(platformId, groupId);
    final scripts = <ScriptManifest>[];
    for (final scriptId in group.scriptIds) {
      scripts.add(await loadScript(platformId, scriptId));
    }
    return scripts;
  }

  /// Returns total script count for a platform (used by the Adım 2 header).
  Future<int> countScripts(String platformId) async {
    final platform = await loadPlatform(platformId);
    var total = 0;
    for (final groupId in platform.groupIds) {
      total += (await loadGroup(platformId, groupId)).scriptIds.length;
    }
    return total;
  }

  /// Pretty JSON of the full bundled tree for debugging (`flutter run -v`).
  /// Not used by the UI; convenient for the dev screen and for tests.
  Future<String> debugDump(String platformId) async {
    final platform = await loadPlatform(platformId);
    final out = <String, Object?>{
      'platform': platform.platform,
      'runtime': platform.runtime,
      'groups': [
        for (final id in platform.groupIds)
          (await loadGroup(platformId, id)) //
              .let((g) => {
                    'id': g.id,
                    'scripts': g.scriptIds,
                  }),
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(out);
  }
}

extension _Let<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
