import 'dart:convert';

import 'package:http/http.dart' as http;

import '../settings/settings_providers.dart';
import 'github_release.dart';
import 'semver.dart';

/// Outcome of an update check.
class UpdateCheckResult {
  const UpdateCheckResult({
    required this.updateAvailable,
    this.latest,
    this.latestVersion,
  });

  final bool updateAvailable;
  final GithubRelease? latest;
  final String? latestVersion;
}

/// Cloud-free updater: the GitHub Releases REST API IS the version manifest.
/// No auth (public repo; 60 req/hr/IP unauthenticated is ample). Channel maps
/// to release flags — stable → newest non-prerelease; beta → newest of any —
/// reusing the existing [UpdateChannel] enum.
class UpdateService {
  UpdateService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _owner = 'smrtkrft';
  static const _repo = 'SKAPP';
  static final Uri _releasesUri = Uri.parse(
    'https://api.github.com/repos/$_owner/$_repo/releases?per_page=20',
  );

  /// Fetches the relevant release for [channel] and compares it against
  /// [currentVersion] (e.g. "0.4.0"). Throws on network / non-200 / parse
  /// errors — callers must degrade silently (offline must never block).
  Future<UpdateCheckResult> check({
    required String currentVersion,
    required UpdateChannel channel,
  }) async {
    final resp = await _client.get(
      _releasesUri,
      headers: const {'Accept': 'application/vnd.github+json'},
    );
    if (resp.statusCode != 200) {
      throw Exception('GitHub API ${resp.statusCode}');
    }
    final releases = (jsonDecode(resp.body) as List)
        .whereType<Map<String, dynamic>>()
        .map(GithubRelease.fromJson)
        .whereType<GithubRelease>()
        .toList();

    final latest = _selectLatest(releases, channel);
    if (latest == null) return const UpdateCheckResult(updateAvailable: false);

    final current = SemVer.tryParse(currentVersion);
    final remote = SemVer.tryParse(latest.tagName);
    final available =
        current != null && remote != null && remote.isNewerThan(current);
    return UpdateCheckResult(
      updateAvailable: available,
      latest: latest,
      latestVersion: remote?.toString() ?? latest.tagName,
    );
  }

  /// Highest semver among the channel-eligible releases (robust to API
  /// ordering). stable excludes pre-releases; beta includes everything.
  GithubRelease? _selectLatest(
    List<GithubRelease> releases,
    UpdateChannel channel,
  ) {
    final eligible = releases
        .where((r) => channel == UpdateChannel.beta || !r.prerelease)
        .toList();
    if (eligible.isEmpty) return null;
    eligible.sort((a, b) {
      final va = SemVer.tryParse(a.tagName);
      final vb = SemVer.tryParse(b.tagName);
      if (va == null && vb == null) return 0;
      if (va == null) return 1;
      if (vb == null) return -1;
      return vb.compareTo(va); // descending
    });
    return eligible.first;
  }

  void dispose() => _client.close();
}
