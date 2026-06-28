/// Minimal semantic-version compare for the GitHub-based updater.
///
/// Parses `MAJOR.MINOR.PATCH`, ignoring a leading `v`, build metadata (`+N`)
/// and pre-release suffixes (`-beta.1`). SKAPP expresses the beta/stable
/// channel via GitHub release flags — NOT via the semver string — so ordering
/// deliberately ignores pre-release identifiers.
class SemVer implements Comparable<SemVer> {
  const SemVer(this.major, this.minor, this.patch);

  final int major;
  final int minor;
  final int patch;

  static SemVer? tryParse(String? raw) {
    if (raw == null) return null;
    var s = raw.trim();
    if (s.startsWith('v') || s.startsWith('V')) s = s.substring(1);
    // Drop build (+) and pre-release (-) metadata.
    s = s.split('+').first.split('-').first;
    final parts = s.split('.');
    if (parts.isEmpty || int.tryParse(parts[0]) == null) return null;
    int at(int i) => i < parts.length ? (int.tryParse(parts[i]) ?? 0) : 0;
    return SemVer(at(0), at(1), at(2));
  }

  @override
  int compareTo(SemVer other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  bool isNewerThan(SemVer other) => compareTo(other) > 0;

  @override
  String toString() => '$major.$minor.$patch';
}
