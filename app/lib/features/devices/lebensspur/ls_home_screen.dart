// LebensSpur dashboard · Flutter port of ls_gui_design2.html.
//
// Single-page scrollable shell:
//   * Slim AppBar with brand + identity + connection dot.
//   * HERO: countdown ring inside a neumorphic well, 4 raised pill
//     buttons below (Start / Reset / Stop / Vacation icon-only), small
//     caps state label.
//   * Status chips row: BLE + Mail (informational, not clickable).
//   * Three clusters of collapsible sections (see _ClusterDef below):
//       1. CONFIGURATION  → Duration & Alarms · Vacation Mode · SMTP · Reset API
//       2. TRIGGER ACTIONS → Mail Groups · Relay · LS API webhook
//       3. EARLY WARNING  → Telegram · Reminder Mail · Alarm API webhook
//
// Each section is collapsed by default. The expanded body is supplied
// here as a placeholder; next-phase agents replace each [body] slot
// with the real form widget (the section's id stays stable so they
// can grep for `LsSection(id: 'duration', ...)` to find their hook).

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ble/device_model.dart';
import '../../../core/cli/cli_providers.dart';
import '../../../core/cli/cli_transport.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/device_session_views.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../device_pairing/pairing_screen.dart';
import '../../main_shell/main_shell.dart';
import 'ls_logs_screen.dart';
import 'ls_theme_tokens.dart';
import 'widgets/ls_countdown_ring.dart';
import 'widgets/ls_section.dart';
import 'widgets/sections/ls_section_alarm_api.dart';
import 'widgets/sections/ls_section_duration.dart';
import 'widgets/sections/ls_section_ls_api.dart';
import 'widgets/sections/ls_section_mail_groups.dart';
import 'widgets/sections/ls_section_relay.dart';
import 'widgets/sections/ls_section_reminder_mail.dart';
import 'widgets/sections/ls_section_reset_api.dart';
import 'widgets/sections/ls_section_smtp.dart';
import 'widgets/sections/ls_section_telegram.dart';
import 'widgets/sections/ls_section_vacation.dart';

class LsHomeScreen extends ConsumerStatefulWidget {
  const LsHomeScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  ConsumerState<LsHomeScreen> createState() => _LsHomeScreenState();
}

class _LsHomeScreenState extends ConsumerState<LsHomeScreen> {
  // Sections collapsed by default. Membership = expanded.
  final Set<String> _expanded = <String>{};

  // Live timer status. Seeded by `timer.status`, refreshed by event
  // stream (`timer.tick` / `timer.state` / `timer.vacation.*`). A 1s
  // local ticker decrements remaining between events so the digits
  // stay smooth even if the firmware throttles `timer.tick` cadence.
  LsTimerStateKind _state = LsTimerStateKind.inactive;
  int _remainingSec = 0;
  final int _totalSec = 0;

  // CONFIGURATION cluster status lines · pushed up by the four section
  // bodies via their onStatusChanged callbacks. They start as
  // "Loading…" so the user knows the section is fetching, then settle
  // to a concise summary ("30 days · 3 alarms", "smtp.gmail.com", ...).
  String? _durationStatus;
  String? _vacationStatus;
  String? _smtpStatus;
  String? _resetApiStatus;

  // TRIGGER ACTIONS cluster status lines · pushed up by the three
  // section bodies (Mail Groups · Relay · LS API webhook) via their
  // onStatusChanged callbacks. Same "Loading…" / settle pattern as
  // the CONFIGURATION cluster.
  String? _mailGroupsStatus;
  String? _relayStatus;
  String? _lsApiStatus;

  // EARLY WARNING cluster status lines · pushed up by the three section
  // bodies via their onStatusChanged callbacks. These start with
  // "Not configured" rather than "Loading…" because two of them
  // (Reminder Mail, Alarm API webhook) are mostly local-storage backed —
  // the read is near-instant and a "Loading…" flash would just be noise.
  String? _telegramStatus;
  String? _reminderMailStatus;
  String? _alarmApiStatus;

  Timer? _localTick;
  StreamSubscription<Map<String, dynamic>>? _eventSub;
  bool _bootstrapped = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    _bootstrapped = true;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final session = await ref.read(
      deviceSessionProvider(widget.deviceId).future,
    );
    if (!mounted) return;

    // Pull initial snapshot. firmware returns
    //   {state: ..., remaining: N, total: N, ...}
    try {
      final r = await session.client.send('timer.status');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        _applyStatusSnapshot((r.data as Map).cast<String, dynamic>());
      }
    } catch (_) {/* silent, UI shows inactive */}

    // Event subscription. We dispatch by name and patch the local
    // mirror; full status refetches are avoided so a brief tick storm
    // can't queue a wall of round-trips.
    _eventSub = session.client.events.listen(_onEvent);

    // Local 1-Hz tick. Only decrements when running so vacation +
    // triggered stay frozen.
    _localTick ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_state != LsTimerStateKind.running) return;
      if (_remainingSec <= 0) return;
      setState(() => _remainingSec--);
    });
  }

  void _applyStatusSnapshot(Map<String, dynamic> data) {
    // Firmware contract per esp32/ls/protocol/v1/commands.json:
    //   timer.status returns: state, remaining_sec, deadline_epoch,
    //   vacation_end_epoch, vacation_remaining_sec, alarms_fired_mask
    // (No `total` field on the wire — we keep our cached _totalSec from
    // the most recent timer.get derivation in the Duration section.)
    final state = LsTimerStateKind.parse(data['state']?.toString());
    final remaining = (data['remaining_sec'] as num?)?.toInt() ?? 0;
    setState(() {
      _state = state;
      _remainingSec = remaining;
    });
  }

  void _onEvent(Map<String, dynamic> evt) {
    // Firmware event names per esp32/ls/protocol/v1/events.json:
    //   timer.tick        {remaining_sec}
    //   timer.state       {state, remaining_sec}
    //   timer.triggered   {duration_sec}
    //   timer.reset       {by: manual|api}
    //   timer.vacation    {active: bool, end_epoch?: int}
    final name = evt['evt']?.toString();
    if (name == null) return;
    final data = evt['data'];

    if (name == 'timer.tick' && data is Map) {
      final r = (data['remaining_sec'] as num?)?.toInt();
      if (r != null) setState(() => _remainingSec = r);
      return;
    }
    if (name == 'timer.state' && data is Map) {
      final s = data['state']?.toString();
      if (s != null) setState(() => _state = LsTimerStateKind.parse(s));
      final r = (data['remaining_sec'] as num?)?.toInt();
      if (r != null) setState(() => _remainingSec = r);
      return;
    }
    if (name == 'timer.triggered') {
      setState(() {
        _state = LsTimerStateKind.triggered;
        _remainingSec = 0;
      });
      return;
    }
    if (name == 'timer.reset' && data is Map) {
      // Either local manual or via /api/reset?key=... -- countdown is
      // re-armed; pull a fresh status so the digits are correct (the
      // event payload only carries `by`).
      _sessionStatusRefresh();
      return;
    }
    if (name == 'timer.vacation' && data is Map) {
      final active = data['active'] == true;
      setState(() {
        _state = active ? LsTimerStateKind.vacation : LsTimerStateKind.running;
      });
      return;
    }
  }

  // Re-fetches timer.status when an event lacks the full snapshot.
  // Best-effort; failures are silent (the next status event reconciles).
  Future<void> _sessionStatusRefresh() async {
    try {
      final session =
          await ref.read(deviceSessionProvider(widget.deviceId).future);
      if (!mounted) return;
      final r = await session.client.send('timer.status');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        _applyStatusSnapshot((r.data as Map).cast<String, dynamic>());
      }
    } catch (_) {/* silent */}
  }

  @override
  void dispose() {
    _localTick?.cancel();
    _eventSub?.cancel();
    super.dispose();
  }

  void _toggleSection(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        _expanded.add(id);
      }
    });
  }

  // Optimistically send a CLI command; on failure, surface as a
  // SnackBar but leave local state untouched (the next status event
  // will reconcile reality).
  Future<void> _sendCli(String cmd, {Map<String, dynamic>? args}) async {
    final session =
        await ref.read(deviceSessionProvider(widget.deviceId).future);
    if (!mounted) return;
    try {
      await session.client.send(cmd, args: args);
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.lsRelayCmdFailedWith(cmd, e.toString()))),
      );
    }
  }

  void _onStart() {
    setState(() => _state = LsTimerStateKind.running);
    _sendCli('timer.start');
  }

  void _onReset() {
    setState(() {
      _state = LsTimerStateKind.running;
      _remainingSec = _totalSec;
    });
    _sendCli('timer.reset');
  }

  void _onStop() {
    setState(() {
      _state = LsTimerStateKind.inactive;
      _remainingSec = 0;
    });
    _sendCli('timer.stop');
  }

  void _onVacation() {
    setState(() => _state = LsTimerStateKind.vacation);
    // Default 7 days, matching the design's mockup. The Vacation Mode
    // section owns the editable value; this button is a quick shortcut.
    _sendCli('vacation.set', args: {'days': 7});
  }

  /// "Eşleşme yenilenmeli" durumunda PairingScreen'i açar. Saklı
  /// [PairedDevice] kaydından DiscoveredDevice kurar; dönüşte oturum
  /// provider'ını invalidate edip taze handshake'i tetikler.
  Future<void> _startRepair(PairedDevice paired) async {
    final device = DiscoveredDevice(
      id: paired.id,
      name: paired.name,
      rssi: 0,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PairingScreen(device: device)),
    );
    ref.invalidate(deviceSessionProvider(widget.deviceId));
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync =
        ref.watch(deviceSessionProvider(widget.deviceId));
    final paired = ref.watch(pairedDevicesProvider).firstWhere(
          (d) => d.id == widget.deviceId,
          orElse: () => PairedDevice(
            id: widget.deviceId,
            name: widget.deviceId,
            prefix: 'LS',
            pairedAt: DateTime.now(),
          ),
        );

    final transportKind = sessionAsync.maybeWhen(
      data: (s) => s.transportKind,
      orElse: () => null,
    );
    final connected = sessionAsync.hasValue;

    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: _SlimAppBar(
        title: paired.typeFullName,
        identity: paired.displayName,
        connected: connected,
        transportKind: transportKind,
        logsTooltip: l.lsHomeLogsTooltip,
        onLogsPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LsLogsScreen(deviceId: widget.deviceId),
          ),
        ),
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: sessionAsync.when(
        loading: () => const DeviceSessionLoading(withScaffold: false),
        error: (e, _) => DeviceSessionError(
          deviceId: widget.deviceId,
          error: e,
          withScaffold: false,
          onRepair: () => _startRepair(paired),
        ),
        data: (_) => SkContentFrame(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l = AppLocalizations.of(context);
    final loading = l.lsHomeStatusLoading;
    final notConfigured = l.lsSmtpStatusNotConfigured;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
      children: [
        _Hero(
          state: _state,
          remainingSec: _remainingSec,
          totalSec: _totalSec,
          onStart: _onStart,
          onReset: _onReset,
          onStop: _onStop,
          onVacation: _onVacation,
        ),
        const SizedBox(height: 24),
        const _StatusChipsRow(),
        const SizedBox(height: 24),

        // ─── Cluster 1: Configuration ──────────────────────────────
        _ClusterLabel(l.lsHomeClusterConfiguration),
        const SizedBox(height: 8),
        LsSection(
          icon: Icons.timer_outlined,
          title: l.lsHomeSectionDurationTitle,
          statusText: _durationStatus ?? loading,
          expanded: _expanded.contains('duration'),
          onToggle: () => _toggleSection('duration'),
          body: LsSectionDuration(
            deviceId: widget.deviceId,
            onStatusChanged: (s) =>
                setState(() => _durationStatus = s),
          ),
        ),
        LsSection(
          icon: Icons.beach_access_outlined,
          title: l.lsHomeSectionVacationTitle,
          statusText: _vacationStatus ?? loading,
          expanded: _expanded.contains('vacation'),
          onToggle: () => _toggleSection('vacation'),
          body: LsSectionVacation(
            deviceId: widget.deviceId,
            onStatusChanged: (s) =>
                setState(() => _vacationStatus = s),
          ),
        ),
        LsSection(
          icon: Icons.mail_outline,
          title: l.lsHomeSectionSmtpTitle,
          statusText: _smtpStatus ?? loading,
          expanded: _expanded.contains('smtp'),
          onToggle: () => _toggleSection('smtp'),
          body: LsSectionSmtp(
            deviceId: widget.deviceId,
            onStatusChanged: (s) => setState(() => _smtpStatus = s),
          ),
        ),
        LsSection(
          icon: Icons.refresh,
          title: l.lsHomeSectionResetApiTitle,
          statusText: _resetApiStatus ?? loading,
          expanded: _expanded.contains('reset_api'),
          onToggle: () => _toggleSection('reset_api'),
          body: LsSectionResetApi(
            deviceId: widget.deviceId,
            onStatusChanged: (s) =>
                setState(() => _resetApiStatus = s),
          ),
        ),

        const SizedBox(height: 16),

        // ─── Cluster 2: Trigger Actions ────────────────────────────
        _ClusterLabel(l.lsHomeClusterTriggerActions),
        const SizedBox(height: 8),
        LsSection(
          icon: Icons.group_outlined,
          title: l.lsHomeSectionMailGroupsTitle,
          statusText: _mailGroupsStatus ?? loading,
          expanded: _expanded.contains('mail_groups'),
          onToggle: () => _toggleSection('mail_groups'),
          body: LsSectionMailGroups(
            deviceId: widget.deviceId,
            onStatusChanged: (s) =>
                setState(() => _mailGroupsStatus = s),
          ),
        ),
        LsSection(
          icon: Icons.bolt_outlined,
          title: l.lsHomeSectionRelayTitle,
          statusText: _relayStatus ?? loading,
          expanded: _expanded.contains('relay'),
          onToggle: () => _toggleSection('relay'),
          body: LsSectionRelay(
            deviceId: widget.deviceId,
            onStatusChanged: (s) => setState(() => _relayStatus = s),
          ),
        ),
        LsSection(
          icon: Icons.public,
          title: l.lsHomeSectionLsApiTitle,
          statusText: _lsApiStatus ?? loading,
          expanded: _expanded.contains('ls_api'),
          onToggle: () => _toggleSection('ls_api'),
          body: LsSectionLsApi(
            deviceId: widget.deviceId,
            onStatusChanged: (s) => setState(() => _lsApiStatus = s),
          ),
        ),

        const SizedBox(height: 16),

        // ─── Cluster 3: Early Warning ──────────────────────────────
        _ClusterLabel(l.lsHomeClusterEarlyWarning),
        const SizedBox(height: 8),
        // Cluster-level disclaimer · the firmware-side timer.alarm event
        // subscriber that drives these three actions is deferred to a
        // mini Faz 1.7 patch. The form bodies persist their config so
        // the user can prepare credentials now, but no auto-fire happens
        // until that firmware hook lands.
        const _EarlyWarningPendingNote(),
        const SizedBox(height: 8),
        LsSection(
          icon: Icons.send_outlined,
          title: l.lsHomeSectionTelegramTitle,
          statusText: _telegramStatus ?? notConfigured,
          expanded: _expanded.contains('telegram'),
          onToggle: () => _toggleSection('telegram'),
          body: LsSectionTelegram(
            deviceId: widget.deviceId,
            onStatusChanged: (s) =>
                setState(() => _telegramStatus = s),
          ),
        ),
        LsSection(
          icon: Icons.notifications_outlined,
          title: l.lsHomeSectionReminderMailTitle,
          statusText: _reminderMailStatus ?? notConfigured,
          expanded: _expanded.contains('reminder_mail'),
          onToggle: () => _toggleSection('reminder_mail'),
          body: LsSectionReminderMail(
            deviceId: widget.deviceId,
            onStatusChanged: (s) =>
                setState(() => _reminderMailStatus = s),
          ),
        ),
        LsSection(
          icon: Icons.warning_amber_outlined,
          title: l.lsHomeSectionAlarmApiTitle,
          statusText: _alarmApiStatus ?? notConfigured,
          expanded: _expanded.contains('alarm_api'),
          onToggle: () => _toggleSection('alarm_api'),
          body: LsSectionAlarmApi(
            deviceId: widget.deviceId,
            onStatusChanged: (s) =>
                setState(() => _alarmApiStatus = s),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// AppBar · slim, brand + identity + connection dot.
// ──────────────────────────────────────────────────────────────────────

class _SlimAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SlimAppBar({
    required this.title,
    required this.identity,
    required this.connected,
    required this.transportKind,
    required this.logsTooltip,
    this.onLogsPressed,
  });

  final String title;
  final String identity;
  final VoidCallback? onLogsPressed;
  final bool connected;
  final CliTransportKind? transportKind;
  final String logsTooltip;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    final dotColor = connected
        ? SkColors.attentionMustard
        : fg.withValues(alpha: 0.35);
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: fg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  identity,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    letterSpacing: 0.4,
                    color: fg.withValues(alpha: 0.50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (onLogsPressed != null)
          IconButton(
            tooltip: logsTooltip,
            icon: const Icon(Icons.article_outlined),
            onPressed: onLogsPressed,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Hero · ring well + digits + 4 raised buttons + state label.
// ──────────────────────────────────────────────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({
    required this.state,
    required this.remainingSec,
    required this.totalSec,
    required this.onStart,
    required this.onReset,
    required this.onStop,
    required this.onVacation,
  });

  final LsTimerStateKind state;
  final int remainingSec;
  final int totalSec;
  final VoidCallback onStart;
  final VoidCallback onReset;
  final VoidCallback onStop;
  final VoidCallback onVacation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fraction = totalSec > 0 ? remainingSec / totalSec : 0.0;
    final running = state == LsTimerStateKind.running;
    final triggered = state == LsTimerStateKind.triggered;

    return SkNeuCard(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: LsCountdownRing(
                    fraction: fraction,
                    accentDashed: triggered,
                  ),
                ),
                // Digits + state caption. HTML used a 12% inset; the
                // ring widget paints inside its box so we re-create the
                // same breathing room with explicit padding here.
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDigits(state, remainingSec),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.4,
                          height: 1.0,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _stateLabel(l, state),
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Raised pill buttons. Start is highlighted (mustard) when
          // the timer is inactive; Stop is suppressed when not active.
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _HeroPill(
                icon: Icons.play_arrow_outlined,
                label: 'Start',
                primary: !running,
                onTap: onStart,
              ),
              _HeroPill(
                icon: Icons.refresh,
                label: 'Reset',
                onTap: onReset,
              ),
              if (running || state == LsTimerStateKind.vacation)
                _HeroPill(
                  icon: Icons.stop_outlined,
                  label: 'Stop',
                  onTap: onStop,
                ),
              _HeroPill(
                icon: Icons.bedtime_outlined,
                iconOnly: true,
                onTap: onVacation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _stateLabel(AppLocalizations l, LsTimerStateKind state) {
    switch (state) {
      case LsTimerStateKind.inactive:
        return l.lsHomeStateInactive;
      case LsTimerStateKind.running:
        return l.lsHomeStateRemaining;
      case LsTimerStateKind.vacation:
        return l.lsHomeStateVacation;
      case LsTimerStateKind.triggered:
        return l.lsHomeStateTriggered;
    }
  }

  static String _formatDigits(LsTimerStateKind state, int secs) {
    if (state == LsTimerStateKind.inactive) return '--:--:--';
    final s = secs < 0 ? 0 : secs;
    final days = s ~/ 86400;
    final h = (s % 86400) ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    if (days > 0) {
      return '${days}d '
          '${h.toString().padLeft(2, '0')}:'
          '${m.toString().padLeft(2, '0')}';
    }
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${sec.toString().padLeft(2, '0')}';
  }
}

// Single raised pill button. Mirrors `.neu-pill .ctrl` from the HTML:
// dual outer BoxShadow (top-left light + bottom-right dark), pill
// radius, optional mustard fg when [primary] is true.
class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    this.label,
    this.iconOnly = false,
    this.primary = false,
    required this.onTap,
  });

  final IconData icon;
  final String? label;
  final bool iconOnly;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.18);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);
    final fg = primary
        ? SkColors.attentionMustard
        : (isDark
            ? SkColors.darkFg.withValues(alpha: 0.90)
            : SkColors.black.withValues(alpha: 0.90));

    final padding = iconOnly
        ? const EdgeInsets.all(10)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 10);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: shLight,
                offset: const Offset(-2, -2),
                blurRadius: 3,
              ),
              BoxShadow(
                color: shDark,
                offset: const Offset(2, 2),
                blurRadius: 3,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: fg),
              if (!iconOnly && label != null) ...[
                const SizedBox(width: 8),
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: fg,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Status chips · BLE + Mail. Informational, not interactive.
// ──────────────────────────────────────────────────────────────────────

class _StatusChipsRow extends StatelessWidget {
  const _StatusChipsRow();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        // Real BLE bond / pairable count lands when the Pairing section
        // owner wires it. Static placeholder for now per agent brief.
        _StatusChip(
          label: l.lsHomeChipBle,
          value: l.lsSmtpStatusNotConfigured,
        ),
        _StatusChip(
          label: l.lsHomeChipMail,
          value: l.lsSmtpStatusNotConfigured,
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.18);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: shLight,
            offset: const Offset(-1, -1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: shDark,
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: fg.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: fg.withValues(alpha: 0.50),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────
// Cluster label · small uppercase, wide letter-spacing.
// ──────────────────────────────────────────────────────────────────────

class _ClusterLabel extends StatelessWidget {
  const _ClusterLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w500,
          color: fg.withValues(alpha: 0.50),
        ),
      ),
    );
  }
}

// One-liner note above the EARLY WARNING cluster making the deferred
// firmware status explicit. Each section repeats the disclaimer inside
// its body, but a cluster-wide hint here means the user sees the
// caveat *before* opening any of them.
class _EarlyWarningPendingNote extends StatelessWidget {
  const _EarlyWarningPendingNote();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
      child: Text(
        l.lsHomeEarlyWarningPendingNote,
        style: TextStyle(
          fontSize: 11,
          fontStyle: FontStyle.italic,
          color: fg.withValues(alpha: 0.50),
          height: 1.4,
        ),
      ),
    );
  }
}
