// Cihazlar sekmesi · KART GÖRÜNÜMÜ + YER GRUPLARI.
//
// Yapı (no_github/test/cihazlar_gorunum.html'den birebir):
//   [ Tüm cihazlar · Büro · Ev ]            Düzenle
//   BÜRO 2
//   ┌────────┐ ┌────────┐
//   └────────┘ └────────┘
//   GRUPLANMAMIŞ 1
//   ...
//   + Yer grubu ekle
//
// "Tüm cihazlar" SABİT bir görünümdür: grup listesinde yer almaz,
// silinemez, adı değiştirilemez, hep ilk sıradadır.
//
// Normal modda ekranda hiçbir yönetim kontrolü yoktur; sıralama /
// yeniden adlandırma / silme / toplu taşıma yalnız "Düzenle" arkasında
// belirir (Shelly'nin Rooms → Edit kalıbı).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/storage/device_groups_store.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../l10n/app_localizations.dart';
import 'device_group_card.dart';

/// Sabit "Tüm cihazlar" görünümünün anahtarı. Gerçek bir grup kimliği
/// değildir; DeviceGroup listesinde karşılığı yoktur.
const String kAllDevicesSegment = '__all__';

class DevicesCardView extends ConsumerStatefulWidget {
  const DevicesCardView({
    super.key,
    required this.devices,
    required this.isOnline,
    required this.onOpenDevice,
    required this.onForgetDevice,
  });

  final List<PairedDevice> devices;

  /// Çevrimiçilik ölçütü çağıran ekranda (lastSeen ≤ 90 sn) — burada
  /// tekrarlanmasın, iki yerde ıraksamasın.
  final bool Function(PairedDevice) isOnline;
  final void Function(PairedDevice) onOpenDevice;
  final void Function(PairedDevice) onForgetDevice;

  @override
  ConsumerState<DevicesCardView> createState() => _DevicesCardViewState();
}

class _DevicesCardViewState extends ConsumerState<DevicesCardView> {
  String _seg = kAllDevicesSegment;
  bool _editing = false;
  final Set<String> _sel = <String>{};

  List<PairedDevice> _sorted(Iterable<PairedDevice> list) {
    final out = list.toList();
    // Çevrimiçi önce, sonra ada göre — aranan cihaz hep yukarıda kalsın.
    out.sort((a, b) {
      final ao = widget.isOnline(a), bo = widget.isOnline(b);
      if (ao != bo) return ao ? -1 : 1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final groups = ref.watch(deviceGroupsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;

    // Silinen/bilinmeyen bir grup seçili kalmasın → boş ekran olurdu.
    if (_seg != kAllDevicesSegment && !groups.any((g) => g.id == _seg)) {
      _seg = kAllDevicesSegment;
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 120),
          children: [
            _SegmentBar(
              groups: groups,
              devices: widget.devices,
              selected: _seg,
              editing: _editing,
              fg: fg,
              onSelect: (s) => setState(() {
                _seg = s;
                _sel.clear();
              }),
              onToggleEdit: () => setState(() {
                _editing = !_editing;
                _sel.clear();
              }),
            ),
            const SizedBox(height: 12),
            ..._buildBody(context, l, groups, fg),
          ],
        ),
        if (_editing && _sel.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: Center(child: _ActionBar(
              count: _sel.length,
              onMove: () => _pickGroupForSelection(context, groups),
              onCancel: () => setState(_sel.clear),
            )),
          ),
      ],
    );
  }

  List<Widget> _buildBody(BuildContext context, AppLocalizations l,
      List<DeviceGroup> groups, Color fg) {
    // Tek grup seçili → başlıksız tek ızgara (şerit zaten adını söylüyor).
    if (_seg != kAllDevicesSegment) {
      final list = _sorted(widget.devices.where((d) => d.groupId == _seg));
      if (list.isEmpty) return [_EmptyLine(text: l.devicesGroupEmpty, fg: fg)];
      return [_grid(list)];
    }

    // Hiç grup yoksa düz ızgara — gruplama kullanılmadıkça ekranda izi olmaz.
    if (groups.isEmpty) {
      return [
        _grid(_sorted(widget.devices)),
        const SizedBox(height: 16),
        _AddGroupButton(onTap: () => _createGroup(context), fg: fg),
      ];
    }

    final out = <Widget>[];
    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      final list = _sorted(widget.devices.where((d) => d.groupId == g.id));
      out.add(_GroupHeader(
        name: g.name,
        count: list.length,
        editing: _editing,
        first: i == 0,
        canUp: i > 0,
        canDown: i < groups.length - 1,
        fg: fg,
        onUp: () => ref.read(deviceGroupsProvider.notifier).reorder(i, i - 1),
        onDown: () =>
            ref.read(deviceGroupsProvider.notifier).reorder(i, i + 2),
        onRename: () => _renameGroup(context, g),
        onDelete: () => _deleteGroup(context, g),
      ));
      out.add(list.isEmpty
          ? _EmptyLine(text: l.devicesGroupEmpty, fg: fg)
          : _grid(list));
    }

    final rest = _sorted(widget.devices.where((d) =>
        d.groupId == null || !groups.any((g) => g.id == d.groupId)));
    if (rest.isNotEmpty) {
      out.add(_GroupHeader(
        name: l.devicesUngrouped,
        count: rest.length,
        editing: false, // sabit kova: sıralanamaz/adlandırılamaz/silinemez
        first: groups.isEmpty,
        canUp: false,
        canDown: false,
        fg: fg,
      ));
      out.add(_grid(rest));
    }
    out.add(const SizedBox(height: 16));
    out.add(_AddGroupButton(onTap: () => _createGroup(context), fg: fg));
    return out;
  }

  Widget _grid(List<PairedDevice> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 190,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 104,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final d = list[i];
        return DeviceGroupCard(
          device: d,
          online: widget.isOnline(d),
          editing: _editing,
          selected: _sel.contains(d.id),
          onTap: () {
            if (_editing) {
              setState(() =>
                  _sel.contains(d.id) ? _sel.remove(d.id) : _sel.add(d.id));
            } else {
              widget.onOpenDevice(d);
            }
          },
          onLongPress: () => _deviceMenu(context, d),
        );
      },
    );
  }

  // ── Menüler ─────────────────────────────────────────────────────

  Future<void> _deviceMenu(BuildContext context, PairedDevice d) async {
    final l = AppLocalizations.of(context);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(d.displayName),
              subtitle: Text(d.name,
                  style: GoogleFonts.jetBrainsMono(fontSize: 11)),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: Text(l.devicesMoveToGroup),
              onTap: () => Navigator.pop(c, 'move'),
            ),
            ListTile(
              leading: Icon(Icons.link_off_rounded, color: SkColors.warnRed),
              title: Text(l.devicesActionForget,
                  style: TextStyle(color: SkColors.warnRed)),
              onTap: () => Navigator.pop(c, 'forget'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    if (action == 'move') {
      await _pickGroupFor(context, {d.id}, ref.read(deviceGroupsProvider));
    } else if (action == 'forget') {
      widget.onForgetDevice(d);
    }
  }

  Future<void> _pickGroupForSelection(
          BuildContext context, List<DeviceGroup> groups) =>
      _pickGroupFor(context, Set<String>.from(_sel), groups);

  Future<void> _pickGroupFor(
      BuildContext context, Set<String> ids, List<DeviceGroup> groups) async {
    final l = AppLocalizations.of(context);
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(l.devicesMoveToGroup)),
              const Divider(height: 1),
              for (final g in groups)
                ListTile(
                  leading: const Icon(Icons.folder_outlined),
                  title: Text(g.name),
                  onTap: () => Navigator.pop(c, g.id),
                ),
              ListTile(
                leading: const Icon(Icons.folder_off_outlined),
                title: Text(l.devicesUngrouped),
                onTap: () => Navigator.pop(c, ''),
              ),
              ListTile(
                leading: const Icon(Icons.add_rounded),
                title: Text(l.devicesNewGroup),
                onTap: () => Navigator.pop(c, '__new__'),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !context.mounted) return;

    String? target = choice.isEmpty ? null : choice;
    if (choice == '__new__') {
      target = await _promptGroupName(context, title: l.devicesNewGroup);
      if (target == null) return;
    }
    await ref.read(pairedDevicesProvider.notifier).setGroupMany(ids, target);
    if (!mounted) return;
    setState(_sel.clear);
    if (!context.mounted) return;
    final name = target == null
        ? null
        : ref
            .read(deviceGroupsProvider)
            .firstWhere((g) => g.id == target,
                orElse: () => DeviceGroup(id: '', name: '', order: 0))
            .name;
    _snack(context,
        name == null || name.isEmpty
            ? l.devicesRemovedFromGroup(ids.length)
            : l.devicesMovedToGroup(ids.length, name));
  }

  // ── Grup CRUD ───────────────────────────────────────────────────

  Future<void> _createGroup(BuildContext context) async {
    final l = AppLocalizations.of(context);
    await _promptGroupName(context, title: l.devicesNewGroup);
  }

  /// Ad sorar, doğrular, grubu oluşturur ve kimliğini döner. Doğrulama
  /// deposunda (checkName) — UI ile store aynı kuralı iki yerde
  /// tanımlamasın.
  Future<String?> _promptGroupName(BuildContext context,
      {required String title, DeviceGroup? existing}) async {
    final l = AppLocalizations.of(context);
    final ctl = TextEditingController(text: existing?.name ?? '');
    final notifier = ref.read(deviceGroupsProvider.notifier);

    final name = await showDialog<String>(
      context: context,
      builder: (c) {
        String? err;
        return StatefulBuilder(
          builder: (c, setLocal) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: ctl,
              autofocus: true,
              maxLength: 24,
              decoration: InputDecoration(
                hintText: l.devicesGroupNameHint,
                errorText: err,
              ),
              onSubmitted: (_) => Navigator.pop(c, ctl.text),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: Text(l.commonCancel),
              ),
              FilledButton(
                onPressed: () {
                  final check = notifier.checkName(ctl.text,
                      exceptId: existing?.id);
                  if (check == GroupNameCheck.ok) {
                    Navigator.pop(c, ctl.text.trim());
                    return;
                  }
                  setLocal(() => err = check == GroupNameCheck.empty
                      ? l.devicesGroupNameEmpty
                      : l.devicesGroupNameDuplicate);
                },
                child: Text(l.commonSave),
              ),
            ],
          ),
        );
      },
    );
    if (name == null || name.isEmpty) return null;
    if (existing != null) {
      await notifier.rename(existing.id, name);
      return existing.id;
    }
    return notifier.add(name);
  }

  Future<void> _renameGroup(BuildContext context, DeviceGroup g) async {
    final l = AppLocalizations.of(context);
    await _promptGroupName(context, title: l.devicesRenameGroup, existing: g);
  }

  Future<void> _deleteGroup(BuildContext context, DeviceGroup g) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showSkConfirm(
      context,
      title: l.devicesDeleteGroup,
      message: l.devicesDeleteGroupBody,
      cancelLabel: l.commonCancel,
      confirmLabel: l.devicesDeleteGroup,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    // ÖNCE cihazları çöz, SONRA grubu sil: ters sırada, silme ile çözme
    // arasında bir rebuild olursa cihazlar "bilinmeyen grup" kimliğiyle
    // kalır (görünürler ama hiçbir bölüme düşmezler).
    final moved =
        await ref.read(pairedDevicesProvider.notifier).detachGroup(g.id);
    await ref.read(deviceGroupsProvider.notifier).remove(g.id);
    if (!mounted) return;
    setState(() {
      if (_seg == g.id) _seg = kAllDevicesSegment;
    });
    if (!context.mounted) return;
    _snack(
        context,
        moved > 0
            ? l.devicesGroupDeletedWithDevices(moved)
            : l.devicesGroupDeleted);
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg, textAlign: TextAlign.center)));
  }
}

// ── Parçalar ──────────────────────────────────────────────────────

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({
    required this.groups,
    required this.devices,
    required this.selected,
    required this.editing,
    required this.fg,
    required this.onSelect,
    required this.onToggleEdit,
  });

  final List<DeviceGroup> groups;
  final List<PairedDevice> devices;
  final String selected;
  final bool editing;
  final Color fg;
  final ValueChanged<String> onSelect;
  final VoidCallback onToggleEdit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Seg(
                  label: l.devicesAllDevices,
                  count: devices.length,
                  on: selected == kAllDevicesSegment,
                  fg: fg,
                  onTap: () => onSelect(kAllDevicesSegment),
                ),
                for (final g in groups) ...[
                  const SizedBox(width: 16),
                  _Seg(
                    label: g.name,
                    count: devices.where((d) => d.groupId == g.id).length,
                    on: selected == g.id,
                    fg: fg,
                    onTap: () => onSelect(g.id),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: onToggleEdit,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            editing ? l.devicesEditDone : l.devicesEdit,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: editing
                  ? SkColors.attentionMustard
                  : fg.withValues(alpha: 0.40),
            ),
          ),
        ),
      ],
    );
  }
}

class _Seg extends StatelessWidget {
  const _Seg({
    required this.label,
    required this.count,
    required this.on,
    required this.fg,
    required this.onTap,
  });
  final String label;
  final int count;
  final bool on;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 2, bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: on ? fg : Colors.transparent,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                color: on ? fg : fg.withValues(alpha: 0.40),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9.5,
                color: (on ? fg : fg.withValues(alpha: 0.40))
                    .withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.name,
    required this.count,
    required this.editing,
    required this.first,
    required this.canUp,
    required this.canDown,
    required this.fg,
    this.onUp,
    this.onDown,
    this.onRename,
    this.onDelete,
  });

  final String name;
  final int count;
  final bool editing;
  final bool first;
  final bool canUp;
  final bool canDown;
  final Color fg;
  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(4, first ? 2 : 16, 4, 7),
      child: Row(
        children: [
          Text(
            name.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: fg.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              color: fg.withValues(alpha: 0.25),
            ),
          ),
          if (editing) ...[
            const Spacer(),
            _Tool(icon: Icons.keyboard_arrow_up_rounded, fg: fg,
                tooltip: l.devicesGroupMoveUp,
                onTap: canUp ? onUp : null),
            _Tool(icon: Icons.keyboard_arrow_down_rounded, fg: fg,
                tooltip: l.devicesGroupMoveDown,
                onTap: canDown ? onDown : null),
            _Tool(icon: Icons.edit_outlined, fg: fg,
                tooltip: l.devicesRenameGroup, onTap: onRename),
            _Tool(icon: Icons.delete_outline_rounded, fg: fg,
                tooltip: l.devicesDeleteGroup, danger: true, onTap: onDelete),
          ],
        ],
      ),
    );
  }
}

class _Tool extends StatelessWidget {
  const _Tool({
    required this.icon,
    required this.fg,
    required this.tooltip,
    this.danger = false,
    this.onTap,
  });
  final IconData icon;
  final Color fg;
  final String tooltip;
  final bool danger;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      padding: EdgeInsets.zero,
      iconSize: 15,
      icon: Icon(
        icon,
        color: !enabled
            ? fg.withValues(alpha: 0.15)
            : danger
                ? SkColors.warnRed
                : fg.withValues(alpha: 0.45),
      ),
    );
  }
}

class _AddGroupButton extends StatelessWidget {
  const _AddGroupButton({required this.onTap, required this.fg});
  final VoidCallback onTap;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: fg.withValues(alpha: 0.16),
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          l.devicesAddGroup,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: fg.withValues(alpha: 0.40),
          ),
        ),
      ),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({required this.text, required this.fg});
  final String text;
  final Color fg;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: fg.withValues(alpha: 0.40),
          ),
        ),
      );
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.count,
    required this.onMove,
    required this.onCancel,
  });
  final int count;
  final VoidCallback onMove;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final fg = isDark ? SkColors.black : SkColors.cream;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.devicesSelectedCount(count),
              style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w500, color: fg),
            ),
            const SizedBox(width: 14),
            TextButton(
              onPressed: onMove,
              child: Text(l.devicesMoveToGroup,
                  style: GoogleFonts.inter(
                      fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text(l.commonCancel,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: fg.withValues(alpha: 0.7))),
            ),
          ],
        ),
      ),
    );
  }
}
