import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_providers.dart';
import '../../../core/cli/device_id.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/storage/preferences_provider.dart';
import 'action_binding.dart';
import 'bindings_store.dart';
import 'bindings_trigger_service.dart';
import 'override_storage.dart';
import 'script_manifest.dart';
import 'script_repository.dart';
import 'script_resolver.dart';
import 'script_runner.dart';

/// Single source of truth for SKAPI data layer wiring.
///
/// `ScriptRepository` is stateless beyond its own caches; one app-wide
/// instance is fine. `OverrideStorage` resolves a real OS path on first
/// touch, also fine to share. `ScriptResolver` ties them together for
/// the UI and is the only object widgets should normally depend on.
final scriptRepositoryProvider = Provider<ScriptRepository>(
  (ref) => ScriptRepository(),
);

final overrideStorageProvider = Provider<OverrideStorage>(
  (ref) => OverrideStorage(),
);

final scriptResolverProvider = Provider<ScriptResolver>((ref) {
  return ScriptResolver(
    repository: ref.watch(scriptRepositoryProvider),
    overrides: ref.watch(overrideStorageProvider),
  );
});

/// Single shared `ScriptRunner`. Stateless beyond the resolver it composes,
/// so reusing one instance is safe and avoids reconstructing the temp dir
/// helper between runs. Concurrent-run guarding is handled by the Run
/// bottom sheet itself: while it's on the stack, a second tap on Run Now
/// is blocked by the modal route.
final scriptRunnerProvider = Provider<ScriptRunner>((ref) {
  return ScriptRunner(resolver: ref.watch(scriptResolverProvider));
});

/// Single shared bindings store. Reads from the same `SharedPreferences`
/// instance the rest of the app uses; the override happens in main().
final bindingsStoreProvider = Provider<BindingsStore>((ref) {
  return BindingsStore(ref.watch(sharedPreferencesProvider));
});

/// In-memory cache of all bindings. Mirrors the `paired_devices_store`
/// notifier shape: load on first read, replace state on every mutation,
/// listeners rebuild widgets that depend on the list (badges, lists).
class BindingsNotifier extends Notifier<List<ActionBinding>> {
  @override
  List<ActionBinding> build() {
    return ref.watch(bindingsStoreProvider).read();
  }

  Future<void> upsert(ActionBinding binding) async {
    final next = await ref.read(bindingsStoreProvider).upsert(binding);
    state = next;
  }

  Future<void> remove(String id) async {
    final next = await ref.read(bindingsStoreProvider).remove(id);
    state = next;
  }

  /// Cascade delete after unpair. Returns the number of bindings removed
  /// so callers can show "N actions removed" feedback.
  Future<int> removeForDevice(String deviceId) async {
    final result =
        await ref.read(bindingsStoreProvider).removeForDevice(deviceId);
    state = result.remaining;
    return result.removed;
  }

  Future<void> setEnabled(String id, bool enabled) async {
    final next =
        await ref.read(bindingsStoreProvider).setEnabled(id, enabled);
    state = next;
  }

  /// Reset Pairings / Factory Reset için: tüm binding state'ini siler.
  Future<void> clearAll() async {
    await ref.read(bindingsStoreProvider).clearAll();
    state = const [];
  }
}

final bindingsProvider =
    NotifierProvider<BindingsNotifier, List<ActionBinding>>(
        BindingsNotifier.new);

/// Bindings tied to a single script. The detail screen's Bindings section
/// and the badge both subscribe with the same family key.
final bindingsForScriptProvider =
    Provider.family<List<ActionBinding>, String>((ref, scriptId) {
  return ref
      .watch(bindingsProvider)
      .where((b) => b.scriptId == scriptId)
      .toList(growable: false);
});

/// Bindings tied to a single device, ordered as stored. Used by the
/// trigger service when picking which bindings to evaluate for an
/// incoming event.
///
/// **Case-insensitive match** by deviceId is critical: BF firmware
/// sends `X-SK-Device-Id` from `sk_identity_get()` (e.g.
/// `BF-A06TMFSQT`, uppercase). Bindings stored from the UI may
/// originate from `PairedDevice.id` which has historically been the
/// BLE MAC (lowercase hex with colons) OR the SmartKraft id depending
/// on pair path (BLE vs WiFi). An exact-match `==` here was producing
/// a silent zero-match scenario where the webhook is accepted (200,
/// activity recordAccepted) but the bindings list is empty so no
/// script ever runs and the user sees no error. Triple lookup
/// (exact, upper, lower) is the same defensive pattern used by
/// `BondStore.tokenFor`.
final bindingsForDeviceProvider =
    Provider.family<List<ActionBinding>, String>((ref, deviceId) {
  final all = ref.watch(bindingsProvider);
  // Build the set of identifiers that all refer to THIS physical device.
  //
  // Bindings are keyed by `PairedDevice.id` (historically the BLE MAC, e.g.
  // "B4:3A:45:80:A8:DE"), but a BF SYSTEM webhook arrives with
  // X-SK-Device-Id = the SmartKraft id from sk_identity_get() (e.g.
  // "BF-AM1MDDQV1") which is stored as `PairedDevice.name`, NOT the id.
  // Case-only matching missed that MAC<->SmartKraft-id gap: the webhook was
  // accepted (200) but matched 0 bindings, so the script never ran and the
  // user saw no error ("silently swallowed"). Resolve the incoming id to its
  // PairedDevice and add BOTH its .id and .name (+ case variants) so a
  // webhook keyed by SmartKraft id matches a binding keyed by MAC, and the
  // BLE/CLI path (keyed by PairedDevice.id) keeps working too.
  // Shared canonicalization: collect every case spelling of the incoming
  // id plus the matched PairedDevice's id and name, so a binding keyed by
  // SmartKraft id matches a webhook keyed by MAC (and vice versa) and the
  // BLE/CLI path keyed by PairedDevice.id keeps working too.
  final variants = <String>{...deviceIdKeyVariants(deviceId)};
  final matched = ref.watch(pairedDevicesProvider).matchDeviceId(deviceId);
  if (matched != null) {
    variants
      ..addAll(deviceIdKeyVariants(matched.id))
      ..addAll(deviceIdKeyVariants(matched.name));
  }

  return all
      .where((b) => b.enabled && variants.contains(b.deviceId))
      .toList(growable: false);
});

/// Long-lived trigger service. The host app calls
/// `ref.read(bindingsTriggerServiceProvider).start()` once during app
/// startup; from then on the service watches paired devices and fires
/// matching bindings. `ref.invalidate(...)` cleanly tears it down.
final bindingsTriggerServiceProvider =
    Provider<BindingsTriggerService>((ref) {
  final service = BindingsTriggerService(ref);
  ref.onDispose(service.dispose);
  return service;
});

/// Loads the platform manifest (`_platform.json`) for a given platform id.
/// Used by the SKAPI Windows screen header to render the group list.
final skapiPlatformManifestProvider = FutureProvider.family
    .autoDispose<PlatformManifest, String>((ref, platformId) {
  return ref.watch(scriptRepositoryProvider).loadPlatform(platformId);
});

/// Loads one group definition. `(platformId, groupId)` keyed.
final skapiGroupManifestProvider = FutureProvider.family
    .autoDispose<GroupManifest, ({String platform, String group})>(
  (ref, key) =>
      ref.watch(scriptRepositoryProvider).loadGroup(key.platform, key.group),
);

/// Loads one script manifest. `(platformId, scriptId)` keyed; the script
/// detail screen reads this to populate Adım 4.
final skapiScriptManifestProvider = FutureProvider.family
    .autoDispose<ScriptManifest, ({String platform, String script})>(
  (ref, key) =>
      ref.watch(scriptRepositoryProvider).loadScript(key.platform, key.script),
);

/// Resolves the *current* source for a script (override-aware) plus its
/// state. Adım 4's `.editstate` card and Adım 5's editor both subscribe.
final resolvedScriptProvider = FutureProvider.family
    .autoDispose<ResolvedScript, ScriptManifest>(
  (ref, manifest) =>
      ref.watch(scriptResolverProvider).resolveSource(manifest),
);

/// Total script count for a platform. Drives the Adım 2 header subline
/// ("N gruplar · toplam M script") without forcing the screen to fan out
/// every script manifest individually.
final skapiPlatformScriptCountProvider =
    FutureProvider.family.autoDispose<int, String>(
  (ref, platformId) =>
      ref.watch(scriptRepositoryProvider).countScripts(platformId),
);

/// All groups under a platform, in `_platform.json` order. The platform
/// screen (Adım 2) renders these as a single bare-row list; one watch
/// instead of one per group keeps rebuild scope tight and avoids partial
/// loading flicker when the platform first opens.
final skapiPlatformGroupsProvider =
    FutureProvider.family.autoDispose<List<GroupManifest>, String>(
  (ref, platformId) =>
      ref.watch(scriptRepositoryProvider).loadAllGroups(platformId),
);

/// Scripts inside one group in declaration order. The Adım 3 group screen
/// renders these as bare rows under the group description; the platform
/// + group key keeps the cache scoped so opening a different group in the
/// same session is still a fresh load.
final skapiGroupScriptsProvider = FutureProvider.family.autoDispose<
    List<ScriptManifest>, ({String platform, String group})>(
  (ref, key) => ref
      .watch(scriptRepositoryProvider)
      .loadGroupScripts(key.platform, key.group),
);

/// Loads one API template manifest. `(platformId, templateId)` keyed; the
/// Other-category detail screen reads this to render the template card and
/// the "Upload to device" CTA (S2.5).
final skapiApiTemplateManifestProvider = FutureProvider.family
    .autoDispose<ApiTemplateManifest, ({String platform, String template})>(
  (ref, key) => ref
      .watch(scriptRepositoryProvider)
      .loadApiTemplate(key.platform, key.template),
);

/// All API templates under an `other-*` platform, in `_platform.json`
/// declaration order. Used by the Other category screen to list available
/// templates (S2.5). Empty list is normal during S2.1 skeleton stage.
final skapiPlatformApiTemplatesProvider = FutureProvider.family
    .autoDispose<List<ApiTemplateManifest>, String>(
  (ref, platformId) =>
      ref.watch(scriptRepositoryProvider).loadAllApiTemplates(platformId),
);

/// Read-only summary of one on-device API endpoint, as returned by
/// `api.endpoint.list`. Used by [_OnDeviceApiList] to render a row per
/// USER slot (SYSTEM slots are filtered out before the list reaches the
/// UI). Storage model is "live": SKAPP does not cache these locally; the
/// device is the source of truth (Madde 24 karar #1).
class OnDeviceApiSummary {
  const OnDeviceApiSummary({
    required this.slot,
    required this.name,
    required this.type,
    required this.method,
    required this.url,
  });

  /// USER slot index, 0..SK_API_USER_SLOTS-1 (=4).
  final int slot;
  final String name;
  final String type;   // generic | ifttt | webhook_post
  final String method; // POST | GET | PUT | DELETE
  final String url;
}

/// Live on-device USER endpoints. SKAPP fetches `api.endpoint.list` from
/// the device every time the provider is observed; no local cache. When
/// the user navigates away the autoDispose drops it, so re-entering the
/// SKAPI tab triggers a fresh fetch — that's the "live" guarantee.
///
/// Failure modes:
///   * Device session not ready (paired but offline) → empty list. The
///     Aksiyonlarım sub-section then renders the "cihaz çevrimdışı"
///     placeholder rather than a hard error, so the user sees the
///     other (Local scripts) section without distraction.
///   * api.endpoint.list returns error → propagated as AsyncError; the
///     widget surfaces a small inline error row.
final onDeviceApiEndpointsProvider = FutureProvider.family
    .autoDispose<List<OnDeviceApiSummary>, String>((ref, deviceId) async {
  final sessionAsync = ref.watch(deviceSessionProvider(deviceId));
  final session = sessionAsync.asData?.value;
  if (session == null) return const <OnDeviceApiSummary>[];

  final r = await session.client.send('api.endpoint.list');
  if (!r.ok) return const <OnDeviceApiSummary>[];

  final raw = r.data is List
      ? r.data as List
      : (r.data is Map
          ? ((r.data as Map)['endpoints'] as List? ?? const [])
          : const []);

  final out = <OnDeviceApiSummary>[];
  for (final e in raw) {
    if (e is! Map) continue;
    final m = Map<String, dynamic>.from(e);
    // Filter SYSTEM bucket — those are auto-managed paired SKAPP listeners
    // and belong to the Local scripts pipeline (Yapı 1 webhook delivery),
    // not the user-visible Yapı 2 endpoints.
    final kind = m['kind']?.toString();
    if (kind == 'system') continue;
    out.add(OnDeviceApiSummary(
      slot: (m['slot'] as num?)?.toInt() ?? -1,
      name: (m['name'] ?? '').toString(),
      type: (m['type'] ?? 'generic').toString(),
      method: (m['method'] ?? 'POST').toString(),
      url: (m['url'] ?? '').toString(),
    ));
  }
  return out;
});

/// Persisted favourites set, keyed by `<platformId>:<scriptId>` (composite
/// so the same `lock` script id starred on `win` and `mac` stays
/// independent). Hydrates from `SharedPreferences` on first read; toggle
/// writes back fire-and-forget so the UI reflects state immediately.
///
/// Migration note: previous in-memory build stored just `<scriptId>`. No
/// persisted data existed, so no migration is needed; first read after the
/// upgrade returns an empty set.
class FavouriteScriptsNotifier extends Notifier<Set<String>> {
  static const _kPrefsKey = 'skapi.favourites.v1';

  /// Composite key that uniquely identifies a script across platforms.
  static String keyFor(String platformId, String scriptId) =>
      '$platformId:$scriptId';

  @override
  Set<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getStringList(_kPrefsKey) ?? const <String>[];
    return Set<String>.from(stored);
  }

  Future<void> _persist(Set<String> next) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_kPrefsKey, next.toList(growable: false));
  }

  /// Toggle a script's favourite state. The composite key prevents
  /// cross-platform collisions for scripts sharing an id.
  void toggle(String platformId, String scriptId) {
    final key = keyFor(platformId, scriptId);
    final next = {...state};
    if (!next.add(key)) next.remove(key);
    state = next;
    // Fire-and-forget; SharedPreferences writes are quick and any error
    // here doesn't justify blocking the UI tap.
    _persist(next);
  }

  bool isFavourite(String platformId, String scriptId) =>
      state.contains(keyFor(platformId, scriptId));
}

final favouriteScriptsProvider =
    NotifierProvider<FavouriteScriptsNotifier, Set<String>>(
  FavouriteScriptsNotifier.new,
);

/// Resolved manifests for every starred script, in the order their composite
/// keys appear in the favourites set. Manifest loads are cached inside
/// `ScriptRepository`, so the second visit to the SKAPI tab is instant.
///
/// Failures (e.g. a stored key that points at an asset which has since been
/// removed) are silently dropped from the returned list; the entry stays in
/// the favourites set so the user can clean it up by un-starring later.
final starredScriptsProvider =
    FutureProvider.autoDispose<List<ScriptManifest>>((ref) async {
  final keys = ref.watch(favouriteScriptsProvider);
  if (keys.isEmpty) return const [];
  final repo = ref.watch(scriptRepositoryProvider);
  final out = <ScriptManifest>[];
  for (final key in keys) {
    final sep = key.indexOf(':');
    if (sep <= 0) continue;
    final platform = key.substring(0, sep);
    final scriptId = key.substring(sep + 1);
    try {
      out.add(await repo.loadScript(platform, scriptId));
    } catch (_) {
      // Asset missing / renamed — drop silently.
    }
  }
  return out;
});
