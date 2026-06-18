import 'override_storage.dart';
import 'script_manifest.dart';
import 'script_repository.dart';

/// Joins the read-only library (`ScriptRepository`) with the user's local
/// edits (`OverrideStorage`) to answer two questions the UI keeps asking:
///
///   1. "Show me the source the user edits/sees right now."
///      → `resolveSource()`  (override if any, else bundled original)
///
///   2. "What state is this script in?"
///      → `resolveState()`   (original | modified | modifiedOutdated)
///
/// Adım 4's `.editstate` card switches its appearance off the state enum;
/// Adım 5 (the editor) seeds its textarea with `resolveSource()` and
/// records the bundled original hash on save so outdated detection works
/// across app updates.
class ScriptResolver {
  ScriptResolver({
    required ScriptRepository repository,
    required OverrideStorage overrides,
  })  : _repo = repository,
        _overrides = overrides;

  final ScriptRepository _repo;
  final OverrideStorage _overrides;

  /// Source code the UI should show, and the runner should execute.
  /// Returns the override if the user has saved one; otherwise the
  /// bundled original. Either way, the body is pure English and never
  /// translated.
  Future<ResolvedScript> resolveSource(ScriptManifest manifest) async {
    final original = await _repo.loadOriginalSource(manifest);
    final hasOverride =
        await _overrides.hasOverride(manifest.platform, manifest.id);
    if (!hasOverride) {
      return ResolvedScript(
        manifest: manifest,
        source: original,
        original: original,
        state: ScriptState.original,
      );
    }
    final edited = await _overrides.readOverride(manifest.platform, manifest.id);
    final outdated = await _overrides.isOverrideOutdated(
      platform: manifest.platform,
      scriptId: manifest.id,
      currentOriginalSource: original,
    );
    return ResolvedScript(
      manifest: manifest,
      source: edited,
      original: original,
      state: outdated ? ScriptState.modifiedOutdated : ScriptState.modified,
    );
  }

  /// Persists a user edit. Convenience wrapper that fetches the original
  /// source so callers don't have to thread it through.
  Future<void> saveEdit({
    required ScriptManifest manifest,
    required String editedSource,
  }) async {
    final original = await _repo.loadOriginalSource(manifest);
    await _overrides.writeOverride(
      platform: manifest.platform,
      scriptId: manifest.id,
      editedSource: editedSource,
      originalSource: original,
    );
  }

  /// Drops the user override. Next `resolveSource` returns the bundled
  /// original and the Adım 4 card flips back to its default state.
  Future<void> reset(ScriptManifest manifest) =>
      _overrides.resetOverride(manifest.platform, manifest.id);
}

/// One of the three Adım 4 detail-screen states. The UI maps each to a
/// distinct card chrome:
///   original          → neutral border, "Henüz düzenlenmedi" + Düzenle
///   modified          → mustard border, "Düzenlendi" + Görüntüle/Sıfırla
///   modifiedOutdated  → mustard border + warning ribbon, "Karşılaştır"
enum ScriptState { original, modified, modifiedOutdated }

/// The script the user currently sees and runs, plus enough context for
/// the editor and the state-aware detail card.
class ResolvedScript {
  const ResolvedScript({
    required this.manifest,
    required this.source,
    required this.original,
    required this.state,
  });

  final ScriptManifest manifest;

  /// Source the runner executes (override when present, else `original`).
  final String source;

  /// Bundled (read-only) version. Always loaded so the editor can show
  /// the "Orijinalle karşılaştır" diff without a second round-trip.
  final String original;

  final ScriptState state;

  bool get hasOverride => state != ScriptState.original;
  bool get isOutdated => state == ScriptState.modifiedOutdated;
}
