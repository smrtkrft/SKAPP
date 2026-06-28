import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// A GitHub release + its downloadable assets, parsed from the REST API.
class GithubRelease {
  const GithubRelease({
    required this.tagName,
    required this.prerelease,
    required this.htmlUrl,
    required this.assets,
  });

  final String tagName;
  final bool prerelease;
  final String htmlUrl;
  final List<GithubAsset> assets;

  static GithubRelease? fromJson(Map<String, dynamic> json) {
    final tag = json['tag_name'];
    if (tag is! String) return null;
    final rawAssets = (json['assets'] as List?) ?? const [];
    final assets = <GithubAsset>[];
    for (final a in rawAssets) {
      if (a is Map<String, dynamic>) {
        final asset = GithubAsset.fromJson(a);
        if (asset != null) assets.add(asset);
      }
    }
    return GithubRelease(
      tagName: tag,
      prerelease: json['prerelease'] == true,
      htmlUrl: (json['html_url'] as String?) ?? '',
      assets: assets,
    );
  }

  /// The download URL for the current platform's stable-named asset, falling
  /// back to the release page if no matching asset is present. Asset names are
  /// kept stable across releases (see docs/RELEASE_CHECKLIST.md).
  String downloadUrlForCurrentPlatform() {
    final name = _assetNameForCurrentPlatform();
    if (name != null) {
      for (final a in assets) {
        if (a.name == name) return a.downloadUrl;
      }
    }
    return htmlUrl;
  }

  static String? _assetNameForCurrentPlatform() {
    if (kIsWeb) return null;
    if (Platform.isMacOS) return 'SKAPP-macos.dmg';
    if (Platform.isWindows) return 'SKAPP-windows-setup.exe';
    if (Platform.isLinux) return 'SKAPP-linux-x86_64.AppImage';
    if (Platform.isAndroid) return 'SKAPP-android.apk';
    return null;
  }
}

class GithubAsset {
  const GithubAsset({required this.name, required this.downloadUrl});

  final String name;
  final String downloadUrl;

  static GithubAsset? fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json['browser_download_url'];
    if (name is! String || url is! String) return null;
    return GithubAsset(name: name, downloadUrl: url);
  }
}
