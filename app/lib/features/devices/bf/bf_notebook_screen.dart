// BF Kullanıcı Defteri, userdata blob (100 KB AES-256-GCM, requires_auth)
// üzerinde oturan serbest-içerik metin editörü. Kullanıcı dilediği şemayı
// (notlar, JSON, scene tanımları) bu tek bayt akışına yazar.
//
// Wire (bf_secure_store.c):
//   userdata.size                                 → {size, capacity}
//   userdata.read  --offset N --len L             → {offset, len, data_b64, total}
//   userdata.write --offset N --data_b64 ...      → {written, total}
//   userdata.truncate --size N                    → boyutu ayarla
//   userdata.clear                                → critical, confirm token
//
// Tüm komutlar `requires_auth = true` (USB CLI'dan erişilemez). Chunk
// sınırı firmware tarafında 4096 bayt, büyük blob'lar bizim tarafta
// parçalara bölünür, sırayla yazılır.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../main_shell/main_shell.dart';
import 'bf_session.dart';
import 'widgets/bootstrap_banner.dart';

/// Firmware'in kabul ettiği maksimum chunk (bf_secure_store.c
/// USERDATA_CLI_CHUNK). Hem okuma hem yazmada parça sınırı.
const int _kChunkBytes = 4096;

/// Cihaz tarafındaki blob kapasitesi (BF_SECURE_USERDATA_CAP). UI'da
/// kapasite göstergesi için kullanılır; yazmadan önce de sınır kontrolü.
const int _kCapacityBytes = 102400;

class BfNotebookScreen extends ConsumerStatefulWidget {
  const BfNotebookScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  ConsumerState<BfNotebookScreen> createState() => _BfNotebookScreenState();
}

class _BfNotebookScreenState extends ConsumerState<BfNotebookScreen> {
  final _controller = TextEditingController();
  bool _loaded = false;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  /// Cihazdaki blob'un son okunan byte uzunluğu. Dirty check için
  /// gerekli, kullanıcı kaydet'e basmadan içeriği değiştirdiyse uyarı.
  int _serverSize = 0;

  /// Yüklenen içeriğin orijinal text'i, değişiklik göstergesi için.
  String _originalText = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final client = BfSession.of(context).client;

    int total = 0;
    final l = AppLocalizations.of(context);
    try {
      final r = await client.send('userdata.size');
      if (!r.ok || r.data is! Map) {
        if (!mounted) return;
        setState(() {
          _error = r.err ?? l.commonReadFailed;
          _loading = false;
        });
        return;
      }
      total = (((r.data as Map)['size']) as num?)?.toInt() ?? 0;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
      return;
    }

    // Boş blob yoksa baştan boş editör.
    if (total == 0) {
      if (!mounted) return;
      setState(() {
        _serverSize = 0;
        _originalText = '';
        _controller.text = '';
        _loading = false;
      });
      return;
    }

    // Chunked read.
    final bytes = <int>[];
    int offset = 0;
    while (offset < total) {
      final remain = total - offset;
      final len = remain < _kChunkBytes ? remain : _kChunkBytes;
      try {
        final r = await client.send(
          'userdata.read',
          args: {'offset': offset, 'len': len},
        );
        if (!r.ok || r.data is! Map) {
          if (!mounted) return;
          setState(() {
            _error = 'chunk read fail (offset=$offset): ${r.err ?? "?"}';
            _loading = false;
          });
          return;
        }
        final m = r.data as Map;
        final b64 = m['data_b64']?.toString() ?? '';
        final actual = ((m['len']) as num?)?.toInt() ?? 0;
        if (b64.isEmpty || actual == 0) break;
        bytes.addAll(base64Decode(b64));
        offset += actual;
      } catch (e) {
        if (!mounted) return;
        final l = AppLocalizations.of(context);
        setState(() {
          _error = l.logsErrorPrefix(e.toString());
          _loading = false;
        });
        return;
      }
    }

    String text;
    try {
      text = utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      text = '';
    }

    if (!mounted) return;
    setState(() {
      _serverSize = total;
      _originalText = text;
      _controller.text = text;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final client = BfSession.of(context).client;
    final newBytes = utf8.encode(_controller.text);

    if (newBytes.length > _kCapacityBytes) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            AppLocalizations.of(context).notebookCapacityExceeded(
                newBytes.length, _kCapacityBytes))),
      );
      return;
    }

    try {
      // 1) Boyutu yeni içeriğe göre kıs/genişlet (zero-pad). Bu, eski
      //    içerikten kalan tail bayt'larının silinmesini garanti eder.
      final t = await client.send(
        'userdata.truncate',
        args: {'size': newBytes.length},
      );
      if (!t.ok) throw 'truncate fail: ${t.err ?? "?"}';

      // 2) Chunked write, boş içerik için truncate yeterli, yazmaya
      //    gerek yok.
      int offset = 0;
      while (offset < newBytes.length) {
        final remain = newBytes.length - offset;
        final len = remain < _kChunkBytes ? remain : _kChunkBytes;
        final chunk = newBytes.sublist(offset, offset + len);
        final w = await client.send(
          'userdata.write',
          args: {'offset': offset, 'data_b64': base64Encode(chunk)},
        );
        if (!w.ok) throw 'write fail (offset=$offset): ${w.err ?? "?"}';
        offset += len;
      }

      if (!mounted) return;
      final l = AppLocalizations.of(context);
      setState(() {
        _serverSize = newBytes.length;
        _originalText = _controller.text;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.notebookSaved)),
      );
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.notebookSaveError(e.toString()))),
      );
    }
  }

  Future<void> _confirmClear() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.notebookClearConfirmTitle),
        content: Text(l.notebookClearConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.notebookClearAction),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final client = BfSession.of(context).client;
    try {
      final r = await client.sendCritical(
        'userdata.clear',
        confirmRequest: (_) async => true,
      );
      if (!mounted) return;
      if (r.ok) {
        setState(() {
          _serverSize = 0;
          _originalText = '';
          _controller.text = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.notebookClearedSnack)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.notebookClearError(r.err ?? "?"))),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.notebookSaveError(e.toString()))),
      );
    }
  }

  bool get _isDirty => _controller.text != _originalText;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final usedBytes = utf8.encode(_controller.text).length;
    final pct = (usedBytes / _kCapacityBytes * 100).clamp(0, 100);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.bfNotebookTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.commonRefresh,
            onPressed: _loading || _saving
                ? null
                : () {
                    setState(() {
                      _loaded = false;
                      _loading = true;
                    });
                    _bootstrap();
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l.notebookClearTooltip,
            onPressed: _loading || _saving ? null : _confirmClear,
          ),
        ],
      ),
      bottomNavigationBar: const ShellNavBar(),
      body: SkContentFrame(
        maxWidth: 820,
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: BootstrapBanner(
                      error: _error!,
                      onRetry: _bootstrap,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline,
                          size: 14, color: cs.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l.notebookEncryptedHint,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_serverSize == 0 && _controller.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: SkNeuCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.menu_book_outlined,
                              size: 18, color: cs.onSurfaceVariant),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.notebookEmptyTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l.notebookEmptyBody,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: cs.onSurfaceVariant,
                                        height: 1.35,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.45,
                      ),
                      decoration: InputDecoration(
                        hintText: l.notebookHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerLow,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                _SizeBar(used: usedBytes, capacity: _kCapacityBytes, pct: pct.toDouble()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isDirty
                              ? l.notebookDirty
                              : (_serverSize == usedBytes
                                  ? l.notebookSaved2
                                  : l.notebookSyncedDifferent),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: _isDirty
                                    ? SkColors.attentionMustard
                                    : cs.onSurfaceVariant,
                              ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _saving || !_isDirty ? null : _save,
                        icon: _saving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(l.notebookSaveCta),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

class _SizeBar extends StatelessWidget {
  const _SizeBar(
      {required this.used, required this.capacity, required this.pct});
  final int used;
  final int capacity;
  final double pct;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isWarn = pct > 90;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    minHeight: 6,
                    backgroundColor: cs.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation(
                      isWarn ? SkColors.attentionMustard : cs.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${_fmt(used)} / ${_fmt(capacity)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _fmt(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 100) return '${kb.toStringAsFixed(1)} KB';
    return '${kb.toStringAsFixed(0)} KB';
  }
}
