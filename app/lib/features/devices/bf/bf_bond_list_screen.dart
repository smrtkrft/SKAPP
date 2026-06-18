// BfBondListScreen, manage SKAPP installs paired with this device.
//
// Reads `bond.list` and renders one row per occupied slot. The row
// belonging to the active session (the SKAPP we're connected through
// right now) is marked with "This phone"; others can be removed via
// `bond.remove --slot N`.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/bond_store.dart';
import '../../../core/cli/cli_client.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'bf_session.dart';

class BfBondListScreen extends ConsumerStatefulWidget {
  const BfBondListScreen({super.key});

  @override
  ConsumerState<BfBondListScreen> createState() => _BfBondListScreenState();
}

class _BfBondListScreenState extends ConsumerState<BfBondListScreen> {
  bool _loading = true;
  String? _err;
  int _capacity = 8;
  int _activeSlot = -1;
  String _ourPeerHex = '';
  List<_BondRow> _rows = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loading) _refresh();
  }

  CliClient get _client => BfSession.of(context).client;

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _err = null;
    });
    final l = AppLocalizations.of(context);
    try {
      final ours = await ref.read(bondStoreProvider).appPeerId();
      final ourHex = _hex(ours);
      final r = await _client.send('bond.list');
      if (!mounted) return;
      if (!r.ok || r.data is! Map) {
        setState(() {
          _err = l.bfBondListFetchError(r.err ?? '?');
          _loading = false;
        });
        return;
      }
      final m = Map<String, dynamic>.from(r.data as Map);
      final cap = (m['capacity'] as num?)?.toInt() ?? 8;
      final active = (m['active_slot'] as num?)?.toInt() ?? -1;
      final peers = (m['peers'] as List?) ?? const [];
      final rows = <_BondRow>[];
      for (final p in peers) {
        if (p is! Map) continue;
        rows.add(_BondRow(
          slot: (p['slot'] as num?)?.toInt() ?? -1,
          peerIdHex: (p['peer_id'] ?? '').toString(),
          label: (p['label'] ?? '').toString(),
          pairedAtUnix: (p['paired_at'] as num?)?.toInt() ?? 0,
        ));
      }
      rows.sort((a, b) => a.slot.compareTo(b.slot));
      setState(() {
        _capacity = cap;
        _activeSlot = active;
        _ourPeerHex = ourHex.toLowerCase();
        _rows = rows;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _err = l.bfBondListFetchError(e.toString());
        _loading = false;
      });
    }
  }

  Future<void> _remove(_BondRow row) async {
    final l = AppLocalizations.of(context);
    final isOurs = row.peerIdHex.toLowerCase() == _ourPeerHex;
    final body = isOurs
        ? l.bfBondListRemoveSelfBody
        : l.bfBondListRemoveOtherBody(
            row.label.isEmpty ? l.bondPeerUnnamed : row.label,
            row.slot);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text(l.bfBondListRemoveTitle),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dctx).pop(true),
            child: Text(l.commonRemove),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final r = await _client.sendCritical(
      'bond.remove',
      args: {'slot': row.slot},
      confirmRequest: (_) async => true,
    );
    if (!mounted) return;
    if (r.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bfBondListSlotRemoved(row.slot))),
      );
      if (isOurs) {
        Navigator.of(context).pop();
        return;
      }
      await _refresh();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.logsErrorPrefix(r.err ?? '?'))),
      );
    }
  }

  static String _hex(List<int> bytes) {
    const hex = '0123456789abcdef';
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(hex[(b >> 4) & 0xF]);
      sb.write(hex[b & 0xF]);
    }
    return sb.toString();
  }

  String _formatPairedAt(int unix) {
    if (unix <= 0) return '-';
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final usedCount = _rows.length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.bfBondListTitle(usedCount, _capacity)),
        actions: [
          IconButton(
            tooltip: l.commonRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _refresh,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _err != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_err!),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _refresh,
                          icon: const Icon(Icons.refresh),
                          label: Text(l.commonRetry),
                        ),
                      ],
                    ),
                  ),
                )
              : _list(),
      ),
    );
  }

  Widget _list() {
    final l = AppLocalizations.of(context);
    if (_rows.isEmpty) {
      return Center(child: Text(l.bfBondListEmpty));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
      itemCount: _rows.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final r = _rows[i];
        final isOurs = r.peerIdHex.toLowerCase() == _ourPeerHex;
        final isActive = r.slot == _activeSlot;
        final shortPid = r.peerIdHex.length > 8
            ? r.peerIdHex.substring(0, 8)
            : r.peerIdHex;
        return SkNeuCard(
          padding: EdgeInsets.zero,
          child: ListTile(
          leading: CircleAvatar(child: Text('${r.slot}')),
          title: Row(
            children: [
              Expanded(
                child: Text(r.label.isEmpty ? l.bondPeerUnnamed : r.label),
              ),
              if (isOurs)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(l.bfBondListBadgeThisPhone),
                ),
              if (isActive && !isOurs)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(l.bfBondListBadgeActiveSession),
                ),
            ],
          ),
          subtitle: Text(
            l.bfBondListRowSubtitle(shortPid, _formatPairedAt(r.pairedAtUnix)),
          ),
          trailing: IconButton(
            tooltip: l.bfBondListRemoveTooltip,
            icon: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.error),
            onPressed: () => _remove(r),
          ),
          ),
        );
      },
    );
  }
}

class _BondRow {
  const _BondRow({
    required this.slot,
    required this.peerIdHex,
    required this.label,
    required this.pairedAtUnix,
  });
  final int slot;
  final String peerIdHex;
  final String label;
  final int pairedAtUnix;
}
