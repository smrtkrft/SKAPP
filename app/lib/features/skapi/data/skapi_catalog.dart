import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Static SKAPI catalog: the 4 platforms shown on the SKAPI tab.
///
/// Categories and templates are intentionally NOT defined here. That
/// content is owned by the `SKAPI/<platform>/*.md` files and will be
/// loaded by the parser later (see `SKAPI/plan.md` §4). Until then each
/// platform exposes an empty category list and the UI renders a "coming
/// from SKAPI" placeholder. Adding categories before SKAPI is ready
/// would mean rewriting them, so the skeleton stays content-light.
class SkapiPlatformSpec {
  const SkapiPlatformSpec({
    required this.id,
    required this.icon,
    required this.label,
    this.categories = const <SkapiCategorySpec>[],
  });

  /// Stable id matching the `SKAPI/` subfolder: `mac`, `win`, `lx`, `other`.
  final String id;
  final IconData icon;

  /// English label, used as a fallback / debug identifier.
  /// User-visible name comes from `AppLocalizations.skapiPlatform*`.
  final String label;

  /// Empty until the SKAPI parser populates this list. Kept on the spec so
  /// callers can iterate uniformly once content arrives.
  final List<SkapiCategorySpec> categories;
}

/// A category groups templates inside a platform detail screen. Definition
/// kept here so the screen can render an accordion list once SKAPI feeds it.
class SkapiCategorySpec {
  const SkapiCategorySpec({
    required this.id,
    required this.icon,
    required this.label,
  });

  final String id;
  final IconData icon;
  final String label;
}

/// Display order requested by the user: macOS, Windows, Linux, Other.
///
/// Brand icons (Apple/Windows/Linux/Tux) come from `font_awesome_flutter`.
/// Theme-aware coloring is the renderer's job; the icon is painted with
/// `colorScheme.onSurface`, which is near-black on light themes and
/// near-white on dark themes, so the logo always contrasts the card.
///
/// font_awesome 11 wraps glyphs in [FaIconData]; we unwrap with `.data` so
/// these specs stay plain [IconData] (mixed freely with Material icons like
/// `Icons.hub_rounded`) and render through the standard `Icon` widget — the
/// same path used since 10.x.
// `final` (not `const`): unwrapping FaIconData via `.data` is a runtime
// getter, so the list can't be const-evaluated. Elements are still cheap,
// immutable specs; all call sites iterate at runtime (no const dependency).
final List<SkapiPlatformSpec> kSkapiPlatforms = [
  SkapiPlatformSpec(
    id: 'mac',
    label: 'macOS',
    icon: FontAwesomeIcons.apple.data,
  ),
  SkapiPlatformSpec(
    id: 'win',
    label: 'Windows',
    icon: FontAwesomeIcons.windows.data,
  ),
  SkapiPlatformSpec(
    id: 'lx',
    label: 'Linux',
    icon: FontAwesomeIcons.linux.data,
  ),
  const SkapiPlatformSpec(
    id: 'other',
    label: 'Other',
    icon: Icons.hub_rounded,
  ),
];

/// Returns the platform id matching the current host, or `null` when SKAPP
/// runs on web or a mobile OS (Android/iOS) where there is no listener.
/// Used by the SKAPI screen to mark the host platform card with a small
/// "this computer" hint, does NOT filter the catalog.
String? hostSkapiPlatformId() {
  if (kIsWeb) return null;
  if (Platform.isMacOS) return 'mac';
  if (Platform.isWindows) return 'win';
  if (Platform.isLinux) return 'lx';
  return null;
}

/// Linux is split at the next level into distro families. Tapping the
/// "Linux" card on the SKAPI tab opens a selector that lists these specs;
/// each spec's `id` matches its `assets/skapi/<id>/` folder, so the
/// existing `ScriptRepository` can load it without changes.
final List<SkapiPlatformSpec> kSkapiLinuxDistros = [
  SkapiPlatformSpec(
    id: 'lx-debian',
    label: 'Debian-based',
    icon: FontAwesomeIcons.linux.data,
  ),
  SkapiPlatformSpec(
    id: 'lx-arch',
    label: 'Arch-based',
    icon: FontAwesomeIcons.linux.data,
  ),
];

/// Other (IoT/device-fired) splits at the next level into 5 categories.
/// First three are SmartKraft-specific device templates (SynDimm, LebensSpur,
/// Blocking Focus); last two are generic buckets (IoT for third-party
/// devices, Server for self-hosted HTTP receivers).
///
/// Each spec's `id` matches its `assets/skapi/<id>/` folder. Templates
/// inside these folders are NOT runnable scripts (the host doesn't fire
/// them) — they are `ApiTemplateManifest` prefills that the user uploads
/// onto a paired SmartKraft device, which fires them on its own trigger
/// (BF: `timer.expired`). See `yapilacaklar.md` Madde 24 for the full
/// architecture.
final List<SkapiPlatformSpec> kSkapiOtherCategories = [
  SkapiPlatformSpec(
    id: 'other-syndimm',
    label: 'SynDimm',
    icon: FontAwesomeIcons.lightbulb.data,
  ),
  SkapiPlatformSpec(
    id: 'other-lebensspur',
    label: 'LebensSpur',
    icon: FontAwesomeIcons.shoePrints.data,
  ),
  SkapiPlatformSpec(
    id: 'other-blockingfocus',
    label: 'Blocking Focus',
    icon: FontAwesomeIcons.bullseye.data,
  ),
  SkapiPlatformSpec(
    id: 'other-iot',
    label: 'IoT',
    icon: FontAwesomeIcons.networkWired.data,
  ),
  SkapiPlatformSpec(
    id: 'other-server',
    label: 'Server',
    icon: FontAwesomeIcons.server.data,
  ),
];
