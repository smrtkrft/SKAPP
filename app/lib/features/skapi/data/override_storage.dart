import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

import 'skapi_ids.dart';

/// Per-device, per-script user override of a bundled SKAPI script.
///
/// The repository holds read-only originals; this class persists the
/// user's "Düzenle" output to the OS user-data directory:
///
///   Windows : `%APPDATA%\SKAPP\skapi\overrides\<platform>\<id>.ps1`
///                                              `<id>.meta.json`
///   Android : `<appSupport>/skapi/overrides/<platform>/...`   (mobile-only
///             editing, execution still happens on Desktop, sync TBD)
///
/// `<id>.meta.json` records the original source's hash so that an app
/// update can detect "modified+outdated": when the bundled `.ps1` changes
/// but the user's edit predates that change, we surface the third Adım 4
/// state and offer Karşılaştır / Sıfırla.
class OverrideStorage {
  OverrideStorage();

  Directory? _rootCache;

  /// Resolves `<appSupport>/skapi/overrides/`. Created on first access.
  Future<Directory> _root() async {
    final cached = _rootCache;
    if (cached != null) return cached;
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/skapi/overrides');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _rootCache = dir;
    return dir;
  }

  Future<File> _scriptFile(String platform, String scriptId) async {
    _guardId(platform, 'platform');
    _guardId(scriptId, 'scriptId');
    final root = await _root();
    return File('${root.path}/$platform/$scriptId.ps1');
  }

  Future<File> _metaFile(String platform, String scriptId) async {
    _guardId(platform, 'platform');
    _guardId(scriptId, 'scriptId');
    final root = await _root();
    return File('${root.path}/$platform/$scriptId.meta.json');
  }

  static void _guardId(String value, String label) {
    if (!kAssetIdPattern.hasMatch(value)) {
      throw ArgumentError.value(value, label, 'Path traversal guard: invalid $label');
    }
  }

  /// Returns true when the user has saved an edited version of this script.
  Future<bool> hasOverride(String platform, String scriptId) async {
    final file = await _scriptFile(platform, scriptId);
    return file.exists();
  }

  /// Reads the user's edited source. Caller must check `hasOverride` first
  /// or be ready for a `FileSystemException`.
  Future<String> readOverride(String platform, String scriptId) async {
    final file = await _scriptFile(platform, scriptId);
    return file.readAsString();
  }

  /// Writes a new override. `originalSource` is the bundled source the user
  /// started editing from. Its hash is recorded so we can detect when an
  /// app update has moved the original out from under them.
  ///
  /// Both files are written together (script + meta) so no half-saved
  /// state can be observed by a later read.
  Future<OverrideMeta> writeOverride({
    required String platform,
    required String scriptId,
    required String editedSource,
    required String originalSource,
  }) async {
    final scriptFile = await _scriptFile(platform, scriptId);
    final metaFile = await _metaFile(platform, scriptId);
    await scriptFile.parent.create(recursive: true);

    final meta = OverrideMeta(
      originalHash: _sha256(originalSource),
      modifiedAt: DateTime.now().toUtc(),
      schemaVersion: 1,
    );

    await scriptFile.writeAsString(editedSource);
    await metaFile.writeAsString(jsonEncode(meta.toJson()));
    return meta;
  }

  /// Removes an override (Adım 5 "Sıfırla"). Both files are deleted; the
  /// next run falls back to the bundled original.
  Future<void> resetOverride(String platform, String scriptId) async {
    final scriptFile = await _scriptFile(platform, scriptId);
    final metaFile = await _metaFile(platform, scriptId);
    if (await scriptFile.exists()) await scriptFile.delete();
    if (await metaFile.exists()) await metaFile.delete();
  }

  /// Reads the meta sidecar. Returns `null` when no override exists or the
  /// meta file is missing/corrupt; callers should treat that the same as
  /// "fresh, no overdue check needed."
  Future<OverrideMeta?> readMeta(String platform, String scriptId) async {
    final metaFile = await _metaFile(platform, scriptId);
    if (!await metaFile.exists()) return null;
    try {
      final source = await metaFile.readAsString();
      return OverrideMeta.fromJson(jsonDecode(source) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// True when an override exists AND the bundled original has changed
  /// since it was edited. UI uses this to show the "Karşılaştır / Sıfırla"
  /// outdated prompt at the top of Adım 4.
  Future<bool> isOverrideOutdated({
    required String platform,
    required String scriptId,
    required String currentOriginalSource,
  }) async {
    final meta = await readMeta(platform, scriptId);
    if (meta == null) return false;
    return meta.originalHash != _sha256(currentOriginalSource);
  }

  static String _sha256(String source) =>
      sha256.convert(utf8.encode(source)).toString();
}

/// Persisted alongside an override `.ps1`. Schema version lets us migrate
/// older entries without losing user edits when the meta format evolves.
class OverrideMeta {
  const OverrideMeta({
    required this.originalHash,
    required this.modifiedAt,
    required this.schemaVersion,
  });

  /// SHA-256 hex digest of the bundled source the user forked from.
  final String originalHash;
  final DateTime modifiedAt;
  final int schemaVersion;

  Map<String, Object?> toJson() => {
        'originalHash': originalHash,
        'modifiedAt': modifiedAt.toIso8601String(),
        'schemaVersion': schemaVersion,
      };

  factory OverrideMeta.fromJson(Map<String, dynamic> json) => OverrideMeta(
        originalHash: json['originalHash'] as String,
        modifiedAt: DateTime.parse(json['modifiedAt'] as String),
        schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      );
}
