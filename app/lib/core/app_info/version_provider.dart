import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Single source of truth for the app version shown anywhere in the UI.
///
/// Why this exists: pubspec.yaml holds the canonical version (e.g. 0.1.0+1).
/// Hard-coding that string inside screens means every release we have to go
/// hunt and update copies. Instead, every display site watches this provider
/// and formatting happens in one place.
final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});

/// Human-readable version line, "0.1.0" for release, "0.1.0 (build 1)" if
/// you want the build number visible during development. Returns a string
/// so screens can drop it in with zero ceremony.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await ref.watch(packageInfoProvider.future);
  return info.version;
});
