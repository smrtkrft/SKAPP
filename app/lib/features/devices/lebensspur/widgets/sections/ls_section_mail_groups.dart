// Mail Groups section body for LebensSpur dashboard.
//
// Manages up to 10 mail groups: each group has a name, enabled flag,
// subject, body, and up to 32 recipients. The device-side state lives
// in NVS, exposed through `mail.group.*` CLI commands.
//
// CLI contract:
//   LIST    : mail.group.list  → {groups:[{id,name,enabled,recipients}]}
//   READ    : mail.group.get <id>
//             → {id,name,enabled,subject,body,recipients:[...]}
//   CREATE  : mail.group.add [name] → {id}
//   DELETE  : mail.group.delete <id>
//   TOGGLE  : mail.group.enable <id> <on|off>
//   FIELDS  : mail.group.{name,subject,body} <id> <value>
//   ROSTER  : mail.group.recipient.{add,remove} <id> <email>
//
// UI layout:
//   * Header summary "3 of 10 · 8 recipients total" + max indicator.
//   * Stack of group rows. Each row is tappable to expand-in-place,
//     revealing subject/body/recipients editors. The expansion is
//     inline (no modal) to keep the user oriented inside the already
//     collapsible LsSection — see file footer note for the nesting
//     concern.
//   * Bottom "+ Create new group" pill. Hidden when 10 groups exist.
//   * Empty state when zero groups.
//
// The parent (`LsHomeScreen`) is notified via [onChanged] on every
// successful write so its status line ("2 of 10 · 8 recipients") stays
// in sync without re-querying.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/cli/cli_providers.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '_ls_section_kit.dart';

class _GroupSummary {
  _GroupSummary({
    required this.id,
    required this.name,
    required this.enabled,
    required this.recipients,
  });

  final int id;
  String name;
  bool enabled;
  int recipients;
}

class _GroupDetail {
  _GroupDetail({
    required this.name,
    required this.enabled,
    required this.subject,
    required this.body,
    required this.recipients,
  });

  String name;
  bool enabled;
  String subject;
  String body;
  List<String> recipients;
}

class LsSectionMailGroups extends ConsumerStatefulWidget {
  const LsSectionMailGroups({
    super.key,
    required this.deviceId,
    required this.onStatusChanged,
  });

  final String deviceId;
  final ValueChanged<String> onStatusChanged;

  @override
  ConsumerState<LsSectionMailGroups> createState() =>
      _LsSectionMailGroupsState();
}

class _LsSectionMailGroupsState extends ConsumerState<LsSectionMailGroups> {
  static const int _maxGroups = 10;

  bool _loading = true;
  String? _loadError;
  bool _busy = false;

  List<_GroupSummary> _groups = [];

  // Per-group expanded body cache + form controllers, keyed by group id.
  // Lazily populated on first expand so we don't fetch detail for groups
  // the user never opens.
  final Set<int> _expanded = {};
  final Map<int, _GroupDetail> _details = {};
  final Map<int, TextEditingController> _nameCtls = {};
  final Map<int, TextEditingController> _subjectCtls = {};
  final Map<int, TextEditingController> _bodyCtls = {};
  final Map<int, TextEditingController> _recipientCtls = {};
  final Set<int> _detailLoading = {};

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  @override
  void dispose() {
    for (final c in _nameCtls.values) {
      c.dispose();
    }
    for (final c in _subjectCtls.values) {
      c.dispose();
    }
    for (final c in _bodyCtls.values) {
      c.dispose();
    }
    for (final c in _recipientCtls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchList() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send('mail.group.list');
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final raw = ((r.data as Map)['groups'] as List?) ?? const [];
        final parsed = <_GroupSummary>[];
        for (final g in raw) {
          if (g is! Map) continue;
          final m = g.cast<String, dynamic>();
          parsed.add(_GroupSummary(
            id: (m['id'] as num?)?.toInt() ?? -1,
            name: m['name']?.toString() ?? '',
            enabled: m['enabled'] == true,
            recipients: (m['recipients'] as num?)?.toInt() ?? 0,
          ));
        }
        parsed.sort((a, b) => a.id.compareTo(b.id));
        setState(() {
          _groups = parsed;
          _loading = false;
        });
        _pushStatus();
      } else {
        final l = AppLocalizations.of(context);
        setState(() {
          _loading = false;
          _loadError = r.err ?? l.lsCommonReadFailed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  void _pushStatus() {
    final l = AppLocalizations.of(context);
    if (_groups.isEmpty) {
      widget.onStatusChanged(l.lsSmtpStatusNotConfigured);
      return;
    }
    final totalRcpt =
        _groups.fold<int>(0, (sum, g) => sum + g.recipients);
    widget.onStatusChanged(
        l.lsMailGroupsStatusFmt(_groups.length, _maxGroups, totalRcpt));
  }

  Future<void> _fetchDetail(int id) async {
    setState(() => _detailLoading.add(id));
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(
        'mail.group.get',
        args: {'id': id},
      );
      if (!mounted) return;
      if (r.ok && r.data is Map) {
        final m = (r.data as Map).cast<String, dynamic>();
        final detail = _GroupDetail(
          name: m['name']?.toString() ?? '',
          enabled: m['enabled'] == true,
          subject: m['subject']?.toString() ?? '',
          body: m['body']?.toString() ?? '',
          recipients: ((m['recipients'] as List?) ?? const [])
              .map((e) => e.toString())
              .toList(),
        );
        setState(() {
          _details[id] = detail;
          _nameCtls[id] = TextEditingController(text: detail.name);
          _subjectCtls[id] = TextEditingController(text: detail.subject);
          _bodyCtls[id] = TextEditingController(text: detail.body);
          _recipientCtls[id] = TextEditingController();
          _detailLoading.remove(id);
        });
      } else {
        final l = AppLocalizations.of(context);
        setState(() => _detailLoading.remove(id));
        _snack(l.lsMailGroupsReadFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      setState(() => _detailLoading.remove(id));
      _snack(l.lsMailGroupsReadFailedWith(e.toString()));
    }
  }

  Future<void> _toggleExpand(int id) async {
    if (_expanded.contains(id)) {
      setState(() => _expanded.remove(id));
      return;
    }
    setState(() => _expanded.add(id));
    if (!_details.containsKey(id)) {
      await _fetchDetail(id);
    }
  }

  Future<void> _setEnabled(int id, bool enabled) async {
    final ok = await _send('mail.group.enable',
        {'id': id, 'enabled': enabled ? 'on' : 'off'});
    if (!ok || !mounted) return;
    setState(() {
      final ix = _groups.indexWhere((g) => g.id == id);
      if (ix >= 0) _groups[ix].enabled = enabled;
      final d = _details[id];
      if (d != null) d.enabled = enabled;
    });
    _pushStatus();
  }

  Future<void> _saveName(int id) async {
    final l = AppLocalizations.of(context);
    final ctl = _nameCtls[id];
    if (ctl == null) return;
    final v = ctl.text.trim();
    if (v.isEmpty || v.length > 47) {
      _snack(l.lsMailGroupsNameValidation);
      return;
    }
    final ok = await _send('mail.group.name', {'id': id, 'name': v});
    if (!ok || !mounted) return;
    setState(() {
      final ix = _groups.indexWhere((g) => g.id == id);
      if (ix >= 0) _groups[ix].name = v;
      final d = _details[id];
      if (d != null) d.name = v;
    });
    _snack(l.lsMailGroupsNameSaved);
  }

  Future<void> _saveSubject(int id) async {
    final l = AppLocalizations.of(context);
    final ctl = _subjectCtls[id];
    if (ctl == null) return;
    final v = ctl.text.trim();
    if (v.length > 127) {
      _snack(l.lsMailGroupsSubjectValidation);
      return;
    }
    final ok = await _send('mail.group.subject', {'id': id, 'subject': v});
    if (!ok || !mounted) return;
    setState(() {
      final d = _details[id];
      if (d != null) d.subject = v;
    });
    _snack(l.lsMailGroupsSubjectSaved);
  }

  Future<void> _saveBody(int id) async {
    final l = AppLocalizations.of(context);
    final ctl = _bodyCtls[id];
    if (ctl == null) return;
    final v = ctl.text;
    if (v.length > 511) {
      _snack(l.lsMailGroupsBodyValidation);
      return;
    }
    final ok = await _send('mail.group.body', {'id': id, 'body': v});
    if (!ok || !mounted) return;
    setState(() {
      final d = _details[id];
      if (d != null) d.body = v;
    });
    _snack(l.lsMailGroupsBodySaved);
  }

  Future<void> _addRecipient(int id) async {
    final l = AppLocalizations.of(context);
    final ctl = _recipientCtls[id];
    if (ctl == null) return;
    final email = ctl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _snack(l.lsMailGroupsEmailValidation);
      return;
    }
    final ok = await _send(
        'mail.group.recipient.add', {'id': id, 'email': email});
    if (!ok || !mounted) return;
    setState(() {
      final d = _details[id];
      if (d != null && !d.recipients.contains(email)) {
        d.recipients.add(email);
      }
      final ix = _groups.indexWhere((g) => g.id == id);
      if (ix >= 0) _groups[ix].recipients++;
      ctl.clear();
    });
    _pushStatus();
  }

  Future<void> _removeRecipient(int id, String email) async {
    final ok = await _send(
        'mail.group.recipient.remove', {'id': id, 'email': email});
    if (!ok || !mounted) return;
    setState(() {
      final d = _details[id];
      d?.recipients.remove(email);
      final ix = _groups.indexWhere((g) => g.id == id);
      if (ix >= 0 && _groups[ix].recipients > 0) {
        _groups[ix].recipients--;
      }
    });
    _pushStatus();
  }

  Future<void> _createGroup() async {
    final l = AppLocalizations.of(context);
    if (_groups.length >= _maxGroups) {
      _snack(l.lsMailGroupsMaxReached(_maxGroups));
      return;
    }
    final name = await _promptName(context);
    if (name == null) return; // cancelled
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      _snack(l.lsMailGroupsNameEmpty);
      return;
    }
    setState(() => _busy = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(
        'mail.group.add',
        args: {'name': trimmed},
      );
      if (!mounted) return;
      if (r.ok) {
        await _fetchList();
        _snack(l.lsMailGroupsCreatedSnack);
      } else {
        _snack(l.lsMailGroupsCreateFailedWith(r.err ?? '?'));
      }
    } catch (e) {
      if (!mounted) return;
      _snack(l.lsMailGroupsCreateFailedWith(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteGroup(int id) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.lsMailGroupsDeleteDialogTitle),
        content: Text(l.lsMailGroupsDeleteDialogBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l.lsMailGroupsDeleteConfirm)),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await _send('mail.group.delete', {'id': id});
    if (!ok || !mounted) return;
    setState(() {
      _expanded.remove(id);
      _details.remove(id);
      _nameCtls.remove(id)?.dispose();
      _subjectCtls.remove(id)?.dispose();
      _bodyCtls.remove(id)?.dispose();
      _recipientCtls.remove(id)?.dispose();
      _groups.removeWhere((g) => g.id == id);
    });
    _pushStatus();
    _snack(l.lsMailGroupsDeletedSnack);
  }

  Future<String?> _promptName(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctl = TextEditingController(
        text: l.lsMailGroupsDefaultName(_groups.length + 1));
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.lsMailGroupsNewGroupTitle),
        content: TextField(
          controller: ctl,
          autofocus: true,
          maxLength: 47,
          decoration: InputDecoration(
            labelText: l.lsMailGroupsGroupNameLabel,
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l.commonCancel)),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(ctl.text),
              child: Text(l.lsMailGroupsCreateConfirm)),
        ],
      ),
    );
  }

  /// Wrap a CLI write call with a busy flag + error snackbar. Returns
  /// `true` on success (response.ok), `false` otherwise.
  Future<bool> _send(String cmd, Map<String, dynamic> args) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final session = await ref
          .read(deviceSessionProvider(widget.deviceId).future);
      final r = await session.client.send(cmd, args: args);
      if (!mounted) return false;
      if (!r.ok) {
        _snack(l.lsRelayCmdFailedWith(cmd, r.err ?? '?'));
        return false;
      }
      return true;
    } catch (e) {
      if (!mounted) return false;
      _snack(l.lsRelayCmdFailedWith(cmd, e.toString()));
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LsSectionBody(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ],
      );
    }
    if (_loadError != null) {
      return LsSectionBody(
        children: [
          LsSectionErrorLine(message: _loadError!, onRetry: _fetchList),
        ],
      );
    }

    final children = <Widget>[];
    final totalRcpt =
        _groups.fold<int>(0, (sum, g) => sum + g.recipients);
    children.add(_HeaderLine(
      count: _groups.length,
      max: _maxGroups,
      totalRecipients: totalRcpt,
    ));

    final l = AppLocalizations.of(context);
    if (_groups.isEmpty) {
      children.add(LsSectionEmptyLine(
        message: l.lsMailGroupsEmptyHint,
      ));
    } else {
      for (final g in _groups) {
        children.add(_GroupRow(
          group: g,
          expanded: _expanded.contains(g.id),
          loadingDetail: _detailLoading.contains(g.id),
          detail: _details[g.id],
          busy: _busy,
          onExpand: () => _toggleExpand(g.id),
          onEnabledChanged: (v) => _setEnabled(g.id, v),
          onDelete: () => _deleteGroup(g.id),
          nameCtl: _nameCtls[g.id],
          subjectCtl: _subjectCtls[g.id],
          bodyCtl: _bodyCtls[g.id],
          recipientCtl: _recipientCtls[g.id],
          onSaveName: () => _saveName(g.id),
          onSaveSubject: () => _saveSubject(g.id),
          onSaveBody: () => _saveBody(g.id),
          onAddRecipient: () => _addRecipient(g.id),
          onRemoveRecipient: (email) => _removeRecipient(g.id, email),
        ));
      }
    }

    if (_groups.length < _maxGroups) {
      children.add(LsActionsRow(
        children: [
          LsPillButton(
            label: _busy ? l.lsMailGroupsWorkingButton : l.lsMailGroupsCreateNewButton,
            onPressed: _busy ? null : _createGroup,
            accent: true,
            icon: Icons.group_add_outlined,
          ),
        ],
      ));
    }

    return LsSectionBody(children: children);
  }
}

// ─────────────────────────────────────────────────────────────────────
// Small empty-state caption (`LsSectionEmptyLine` lives in the kit).
// ─────────────────────────────────────────────────────────────────────

class LsSectionEmptyLine extends StatelessWidget {
  const LsSectionEmptyLine({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12,
          color: fg.withValues(alpha: 0.55),
          height: 1.4,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Header summary "3 of 10 · 8 recipients total"
// ─────────────────────────────────────────────────────────────────────

class _HeaderLine extends StatelessWidget {
  const _HeaderLine({
    required this.count,
    required this.max,
    required this.totalRecipients,
  });

  final int count;
  final int max;
  final int totalRecipients;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    return Row(
      children: [
        Text(
          l.lsMailGroupsHeaderCount(count, max),
          style: TextStyle(
            fontSize: 12,
            color: fg.withValues(alpha: 0.70),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l.lsMailGroupsHeaderTotalRecipients(totalRecipients),
          style: TextStyle(
            fontSize: 12,
            color: fg.withValues(alpha: 0.40),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// One group row (header + inline editor when expanded)
// ─────────────────────────────────────────────────────────────────────

class _GroupRow extends StatelessWidget {
  const _GroupRow({
    required this.group,
    required this.expanded,
    required this.loadingDetail,
    required this.detail,
    required this.busy,
    required this.onExpand,
    required this.onEnabledChanged,
    required this.onDelete,
    required this.nameCtl,
    required this.subjectCtl,
    required this.bodyCtl,
    required this.recipientCtl,
    required this.onSaveName,
    required this.onSaveSubject,
    required this.onSaveBody,
    required this.onAddRecipient,
    required this.onRemoveRecipient,
  });

  final _GroupSummary group;
  final bool expanded;
  final bool loadingDetail;
  final _GroupDetail? detail;
  final bool busy;
  final VoidCallback onExpand;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onDelete;

  final TextEditingController? nameCtl;
  final TextEditingController? subjectCtl;
  final TextEditingController? bodyCtl;
  final TextEditingController? recipientCtl;

  final VoidCallback onSaveName;
  final VoidCallback onSaveSubject;
  final VoidCallback onSaveBody;
  final VoidCallback onAddRecipient;
  final ValueChanged<String> onRemoveRecipient;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final hairline = fg.withValues(alpha: 0.06);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: hairline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onExpand,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    expanded
                        ? Icons.expand_more
                        : Icons.chevron_right,
                    size: 18,
                    color: fg.withValues(alpha: 0.55),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          group.name.isEmpty
                              ? l.lsMailGroupsUnnamed
                              : group.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: fg,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.lsMailGroupsRowSummary(
                            group.recipients,
                            group.enabled
                                ? l.lsMailGroupsEnabled
                                : l.lsMailGroupsDisabled,
                          ),
                          style: TextStyle(
                            fontSize: 11,
                            color: fg.withValues(alpha: 0.50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: group.enabled,
                    onChanged: busy ? null : onEnabledChanged,
                    activeThumbColor: SkColors.attentionMustard,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOutCubic,
            child: expanded
                ? _ExpandedEditor(
                    loading: loadingDetail,
                    detail: detail,
                    busy: busy,
                    nameCtl: nameCtl,
                    subjectCtl: subjectCtl,
                    bodyCtl: bodyCtl,
                    recipientCtl: recipientCtl,
                    onSaveName: onSaveName,
                    onSaveSubject: onSaveSubject,
                    onSaveBody: onSaveBody,
                    onAddRecipient: onAddRecipient,
                    onRemoveRecipient: onRemoveRecipient,
                    onDelete: onDelete,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Inline editor (subject + body + recipients) revealed when a group
// row is expanded.
// ─────────────────────────────────────────────────────────────────────

class _ExpandedEditor extends StatelessWidget {
  const _ExpandedEditor({
    required this.loading,
    required this.detail,
    required this.busy,
    required this.nameCtl,
    required this.subjectCtl,
    required this.bodyCtl,
    required this.recipientCtl,
    required this.onSaveName,
    required this.onSaveSubject,
    required this.onSaveBody,
    required this.onAddRecipient,
    required this.onRemoveRecipient,
    required this.onDelete,
  });

  final bool loading;
  final _GroupDetail? detail;
  final bool busy;
  final TextEditingController? nameCtl;
  final TextEditingController? subjectCtl;
  final TextEditingController? bodyCtl;
  final TextEditingController? recipientCtl;
  final VoidCallback onSaveName;
  final VoidCallback onSaveSubject;
  final VoidCallback onSaveBody;
  final VoidCallback onAddRecipient;
  final ValueChanged<String> onRemoveRecipient;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    if (loading || detail == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    final divider = fg.withValues(alpha: 0.06);
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: divider, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (nameCtl != null)
            LsField(
              label: l.lsMailGroupsNameLabel,
              child: Row(
                children: [
                  Expanded(
                    child: LsNeuTextField(
                      controller: nameCtl!,
                      enabled: !busy,
                      maxLength: 47,
                    ),
                  ),
                  const SizedBox(width: 8),
                  LsPillButton(
                    label: l.lsCommonSaveButton,
                    onPressed: busy ? null : onSaveName,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (subjectCtl != null)
            LsField(
              label: l.lsMailGroupsSubjectLabel,
              child: Row(
                children: [
                  Expanded(
                    child: LsNeuTextField(
                      controller: subjectCtl!,
                      enabled: !busy,
                      maxLength: 127,
                    ),
                  ),
                  const SizedBox(width: 8),
                  LsPillButton(
                    label: l.lsCommonSaveButton,
                    onPressed: busy ? null : onSaveSubject,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (bodyCtl != null)
            LsField(
              label: l.lsReminderMailBodyLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LsNeuTextField(
                    controller: bodyCtl!,
                    enabled: !busy,
                    maxLength: 511,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: LsPillButton(
                      label: l.lsMailGroupsSaveBodyButton,
                      onPressed: busy ? null : onSaveBody,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          _RecipientsBlock(
            recipients: detail!.recipients,
            controller: recipientCtl,
            busy: busy,
            onAdd: onAddRecipient,
            onRemove: onRemoveRecipient,
          ),
          const SizedBox(height: 12),
          LsActionsRow(
            children: [
              LsPillButton(
                label: l.lsMailGroupsDeleteGroupButton,
                onPressed: busy ? null : onDelete,
                danger: true,
                outlined: true,
                icon: Icons.delete_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Recipients list + add input.
// ─────────────────────────────────────────────────────────────────────

class _RecipientsBlock extends StatelessWidget {
  const _RecipientsBlock({
    required this.recipients,
    required this.controller,
    required this.busy,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> recipients;
  final TextEditingController? controller;
  final bool busy;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.lsMailGroupsRecipientsHeader(recipients.length),
          style: TextStyle(
            fontSize: 12,
            color: fg.withValues(alpha: 0.70),
          ),
        ),
        const SizedBox(height: 6),
        if (recipients.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              l.lsMailGroupsNoRecipients,
              style: TextStyle(
                fontSize: 11,
                color: fg.withValues(alpha: 0.45),
              ),
            ),
          )
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final email in recipients)
                _RecipientChip(
                  email: email,
                  onRemove: busy ? null : () => onRemove(email),
                ),
            ],
          ),
        const SizedBox(height: 8),
        if (controller != null)
          Row(
            children: [
              Expanded(
                child: LsNeuTextField(
                  controller: controller!,
                  enabled: !busy,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 95,
                ),
              ),
              const SizedBox(width: 8),
              LsPillButton(
                label: l.lsMailGroupsAddRecipientButton,
                onPressed: busy ? null : onAdd,
                accent: true,
                icon: Icons.add,
              ),
            ],
          ),
      ],
    );
  }
}

class _RecipientChip extends StatelessWidget {
  const _RecipientChip({required this.email, required this.onRemove});

  final String email;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            email,
            style: TextStyle(fontSize: 11, color: fg),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 13,
              color: onRemove == null
                  ? fg.withValues(alpha: 0.20)
                  : SkColors.warnRed,
            ),
          ),
        ],
      ),
    );
  }
}
