/// One Desktop SKAPP peer the local device knows about.
///
/// Stored locally (`SkappPeerStore`), keyed by `uuid`. The Mobile app
/// pairs once via QR / manual token entry; from then on `lastIp` and
/// `lastPort` are refreshed by the mDNS browser, and `lastSeen` lets
/// the UI surface online/offline rozets without a live ping.
class SkappPeerTarget {
  const SkappPeerTarget({
    required this.uuid,
    required this.name,
    required this.bearerToken,
    required this.port,
    required this.pairedAt,
    this.lastIp,
    this.lastSeen,
    this.certFingerprint,
    this.developerModeEnabled,
  });

  /// Server's stable identity (matches `NetworkIdentity.uuid` on the
  /// other side). The pairing payload carries this value; persisting
  /// it lets us reject stale or rotated peers without a rediscovery.
  final String uuid;

  /// User-facing label (mDNS instance name). Updated on every mDNS hit
  /// so renaming on the Desktop side propagates to the phone.
  final String name;

  /// Bearer token negotiated at pairing. Sent on every HTTP request.
  /// Rotates only when the user explicitly regenerates on the Desktop;
  /// the next call returns 401 and the UI offers to re-pair.
  final String bearerToken;

  /// Port the listener was bound to at pairing. mDNS hits update this
  /// if the user later changes the port in Settings.
  final int port;

  final DateTime pairedAt;
  final String? lastIp;
  final DateTime? lastSeen;

  /// SHA-256 fingerprint of the desktop's self-signed TLS cert, lowercase
  /// hex. Populated when pairing happened over a v:2 QR (Faz B step 4).
  /// Null for legacy v:1 pairings — the mobile HTTP client treats null
  /// as "no pin, accept anything but log a warning" so upgrade-in-place
  /// works without breaking previously paired phones.
  final String? certFingerprint;

  /// Last-known developer-mode flag reported by `/api/health`. The peer
  /// health prober refreshes this every 30 s. `null` means "never
  /// probed yet" — the peer picker treats null as "unknown, allow the
  /// attempt and let the run endpoint reject with 403 if needed".
  /// Enables peer picker rozets ("Geliştirici modu kapalı") before the
  /// user even tries a remote run.
  final bool? developerModeEnabled;

  SkappPeerTarget copyWith({
    String? name,
    String? bearerToken,
    int? port,
    String? lastIp,
    DateTime? lastSeen,
    String? certFingerprint,
    bool? developerModeEnabled,
  }) =>
      SkappPeerTarget(
        uuid: uuid,
        name: name ?? this.name,
        bearerToken: bearerToken ?? this.bearerToken,
        port: port ?? this.port,
        pairedAt: pairedAt,
        lastIp: lastIp ?? this.lastIp,
        lastSeen: lastSeen ?? this.lastSeen,
        certFingerprint: certFingerprint ?? this.certFingerprint,
        developerModeEnabled:
            developerModeEnabled ?? this.developerModeEnabled,
      );

  Map<String, Object?> toJson() => {
        'uuid': uuid,
        'name': name,
        'bearerToken': bearerToken,
        'port': port,
        'pairedAt': pairedAt.toIso8601String(),
        'lastIp': lastIp,
        'lastSeen': lastSeen?.toIso8601String(),
        'certFingerprint': certFingerprint,
        'developerModeEnabled': developerModeEnabled,
      };

  factory SkappPeerTarget.fromJson(Map<String, dynamic> j) => SkappPeerTarget(
        uuid: j['uuid'] as String,
        name: j['name'] as String,
        bearerToken: j['bearerToken'] as String,
        port: (j['port'] as num).toInt(),
        pairedAt: DateTime.parse(j['pairedAt'] as String),
        lastIp: j['lastIp'] as String?,
        lastSeen: j['lastSeen'] == null
            ? null
            : DateTime.parse(j['lastSeen'] as String),
        certFingerprint: j['certFingerprint'] as String?,
        developerModeEnabled: j['developerModeEnabled'] as bool?,
      );

  /// Heuristic for the UI online rozet. mDNS announces every ~30 s, so
  /// within 90 s of the last sighting we consider the peer online; older
  /// records show as offline until the next mDNS query refreshes them.
  bool get online {
    final seen = lastSeen;
    if (seen == null) return false;
    return DateTime.now().difference(seen).inSeconds < 90;
  }
}

/// Pairing payload encoded inside the QR code on the Desktop. Mobile
/// scans this, deserialises, and either writes a `SkappPeerTarget`
/// directly (legacy v:1) or redeems the included `handshakeToken` for a
/// per-peer token via `POST /api/pair/redeem` (Faz B v:2).
///
/// Two coexisting versions:
///
/// - **v:1** carries the install bearer in the QR. Treat the QR as a
///   secret. Kept for older mobile builds that haven't updated yet;
///   server still serves these QRs only when explicit downgrade is
///   asked for (not the default code path).
/// - **v:2** carries a short-lived `handshakeToken` (60 s TTL,
///   single-use) and an optional `certFingerprint` for TLS pinning
///   (Faz B step 4). Even if the QR is photographed, the leak expires
///   in under a minute and can only be redeemed once.
class SkappPairingPayload {
  const SkappPairingPayload({
    required this.uuid,
    required this.name,
    required this.port,
    this.bearerToken,
    this.handshakeToken,
    this.certFingerprint,
    this.ip,
  });

  /// Format version. Mobile branches on this — v:2 means "redeem the
  /// handshake before pairing finishes", v:1 means "trust the bearer
  /// straight from the QR".
  int get version => handshakeToken != null ? 2 : 1;

  final String uuid;
  final String name;
  final int port;

  /// v:1 only. Legacy install bearer baked into the QR. Null in v:2 —
  /// the redeem endpoint hands out a per-peer token instead.
  final String? bearerToken;

  /// v:2 only. Single-use, time-boxed handshake token. Mobile POSTs it
  /// to `/api/pair/redeem` and the server returns a freshly minted
  /// per-peer token.
  final String? handshakeToken;

  /// v:2 only, optional. SHA-256 fingerprint of the desktop's TLS cert
  /// (Faz B step 4). When present, mobile pins the TLS handshake to
  /// this fingerprint.
  final String? certFingerprint;

  /// Optional desktop LAN IP at QR-generation time. Lets the mobile
  /// scan flow call `/api/pair/redeem` without an mDNS browse — mDNS
  /// can still take over afterwards for `lastIp` refresh. Manual
  /// pairing ignores this and uses the user-typed host.
  final String? ip;

  Map<String, Object?> toJson() {
    final v = version;
    return {
      'v': v,
      'uuid': uuid,
      'name': name,
      'port': port,
      if (v == 1) 'token': bearerToken,
      if (v == 2) 'handshakeToken': handshakeToken,
      if (certFingerprint != null) 'certFingerprint': certFingerprint,
      if (ip != null) 'ip': ip,
    };
  }

  factory SkappPairingPayload.fromJson(Map<String, dynamic> j) {
    final v = (j['v'] as num?)?.toInt() ?? 1;
    if (v != 1 && v != 2) {
      throw FormatException('Unsupported pairing version: $v');
    }
    return SkappPairingPayload(
      uuid: j['uuid'] as String,
      name: j['name'] as String,
      port: (j['port'] as num).toInt(),
      bearerToken: v == 1 ? j['token'] as String? : null,
      handshakeToken: v == 2 ? j['handshakeToken'] as String? : null,
      certFingerprint: j['certFingerprint'] as String?,
      ip: j['ip'] as String?,
    );
  }
}
