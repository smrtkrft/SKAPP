// Single source of truth for normalizing and comparing SmartKraft device
// identifiers.
//
// A deviceId reaches the app as either a BLE MAC (`98:A3:...`) or a
// SmartKraft id (`BF-A06TMFSQT`), and in mixed case depending on the source
// (mDNS instance name vs firmware `sk_identity_get()` vs webhook header).
// These helpers replace the case-folding / name-fallback chains that were
// copy-pasted across BondStore, the device-session resolver and the webhook
// receiver, so every call site normalizes identically.
//
// A full canonical re-keying (BLE MAC kept purely as an alias, SmartKraft id
// as the stored key, plus a storage migration of existing bonds) stays
// deferred to the planned Faz 4; this is the lower-risk consolidation step.

/// Normalizes [raw] for case-insensitive comparison and dedup keys. Trims
/// surrounding whitespace and lowercases; MACs and SmartKraft ids are ASCII
/// so a plain lowercase is a safe canonical form.
String canonicalizeDeviceId(String raw) => raw.trim().toLowerCase();

/// The set of secure-storage key spellings to probe for a bond. Pairing may
/// have stored the bond under the exact id, while firmware / mDNS can later
/// present the same id in a different case, so we try the exact value plus
/// the upper/lower folds. Order is irrelevant (the caller stops at the first
/// hit); the Set drops duplicates when [raw] is already single-case.
Set<String> deviceIdKeyVariants(String raw) => {
      raw,
      raw.toUpperCase(),
      raw.toLowerCase(),
    };
