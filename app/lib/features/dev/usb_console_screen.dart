// USB CLI Konsol, Settings → Geliştirici modu → "USB Konsol".
//
// İki aşama:
//   1. Port-picker (henüz port seçilmediyse): bağlı USB seri portları
//      listede; BF (VID 0x303a / PID 0x1001) üstte rozetli, generic
//      portlar altta gri. Tap → konsol açılır.
//   2. Konsol: status header (port + bağlı süresi gibi yok, connection
//      state yeter) + scrollable history + input bar. Komut yaz, Enter
//      veya Gönder tuşu → cevap gelir, ekrana eklenir.
//
// CliClient signer: null kullanır → ham JSON gönderir. requires_auth
// komutlar firmware'dan ERR_NOT_AUTHENTICATED döner; konsolda "ERR"
// rozetiyle görünür, kullanıcıya dev mod sınırını net iletir.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cli/usb_port_scanner.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'usb_console_providers.dart';
import 'widgets/console_message_view.dart';

class UsbConsoleScreen extends ConsumerStatefulWidget {
  const UsbConsoleScreen({super.key});

  @override
  ConsumerState<UsbConsoleScreen> createState() => _UsbConsoleScreenState();
}

class _UsbConsoleScreenState extends ConsumerState<UsbConsoleScreen> {
  UsbPortInfo? _selectedPort;

  /// Auto-select bir kez tetiklenir: kullanıcı ekrandan disconnect ettikten
  /// sonra refresh listesinde tekrar BF görse bile zorla seçmez (kullanıcı
  /// niyeti = manuel picker). Disconnect → bayrak true, sonraki picker
  /// session'ında auto pass.
  bool _autoSelectConsumed = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final selected = _selectedPort;

    // Auto-select listener: portsAsync ilk başarılı snapshot'unda eğer
    // tam bir BF (Espressif VID/PID) varsa kullanıcıyı picker'a girmeden
    // konsol moduna alıyoruz. Bridge'le (CP2102/CH340) bağlı tek cihaz
    // varsa o da auto-select'e aday — yalnız tam eşleşme yoksa fallback.
    //
    // Riverpod ref.listen build içinde koşulsuz çağrılır; state check'i
    // callback içinde yaparız (koşullu çağırırsak duplicate subscription
    // riski + Riverpod best-practice ihlali).
    ref.listen<AsyncValue<List<UsbPortInfo>>>(
      usbPortsProvider,
      (_, next) {
        if (_selectedPort != null || _autoSelectConsumed) return;
        next.whenData((ports) {
          final auto = UsbPortScanner.autoSelect(ports);
          if (auto != null) {
            _autoSelectConsumed = true;
            setState(() => _selectedPort = auto);
          }
        });
      },
    );
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.usbConsoleAppBarTitle),
        actions: selected == null
            ? [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: l.usbConsolePortRefreshTooltip,
                  onPressed: () => ref.invalidate(usbPortsProvider),
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l.usbConsoleClear,
                  onPressed: () => ref
                      .read(usbConsoleSessionProvider(selected).notifier)
                      .clearEntries(),
                ),
                IconButton(
                  icon: const Icon(Icons.power_settings_new),
                  tooltip: l.usbConsoleDisconnect,
                  onPressed: () async {
                    await ref
                        .read(usbConsoleSessionProvider(selected).notifier)
                        .disconnect();
                    if (mounted) setState(() => _selectedPort = null);
                  },
                ),
              ],
      ),
      body: SafeArea(
        child: selected == null
            ? _PortPicker(onPick: (p) => setState(() => _selectedPort = p))
            : _ConsoleBody(port: selected),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Port picker
// ---------------------------------------------------------------------------

class _PortPicker extends ConsumerWidget {
  const _PortPicker({required this.onPick});
  final void Function(UsbPortInfo) onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final portsAsync = ref.watch(usbPortsProvider);
    return portsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(e.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      ),
      data: (ports) {
        if (ports.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.usb_rounded,
                    size: 56,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.usbConsolePickPortHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
          itemCount: ports.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                child: Text(
                  l.usbConsolePickPortTitle.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              );
            }
            final p = ports[i - 1];
            return _PortCard(port: p, onTap: () => onPick(p));
          },
        );
      },
    );
  }
}

class _PortCard extends StatelessWidget {
  const _PortCard({required this.port, required this.onTap});
  final UsbPortInfo port;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      onTap: onTap,
      borderRadius: 14,
      borderColor: port.looksLikeBf
          ? cs.primary.withValues(alpha: 0.6)
          : null,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            Icons.usb_rounded,
            color: port.looksLikeBf
                ? cs.primary
                : cs.onSurface.withValues(alpha: 0.55),
          ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            port.label,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (port.looksLikeBf)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              l.usbConsoleBfBadge,
                              style: TextStyle(
                                color: cs.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(port),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontFamily: 'monospace',
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          Icon(Icons.chevron_right_rounded,
              color: cs.onSurfaceVariant),
        ],
      ),
    );
  }

  String _subtitle(UsbPortInfo p) {
    final parts = <String>[];
    if (p.vendorId != null && p.productId != null) {
      parts.add('VID ${p.vendorId!.toRadixString(16).padLeft(4, '0')}'
          ':${p.productId!.toRadixString(16).padLeft(4, '0')}');
    }
    if (p.description != null) parts.add(p.description!);
    return parts.isEmpty ? p.portPath : parts.join(' · ');
  }
}

// ---------------------------------------------------------------------------
// Console body (after a port is selected)
// ---------------------------------------------------------------------------

class _ConsoleBody extends ConsumerStatefulWidget {
  const _ConsoleBody({required this.port});
  final UsbPortInfo port;

  @override
  ConsumerState<_ConsoleBody> createState() => _ConsoleBodyState();
}

class _ConsoleBodyState extends ConsumerState<_ConsoleBody> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focusNode = FocusNode();
  int _historyIndex = -1; // -1 = current draft

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _autoScrollToEnd() {
    // postFrame ile scroll, yeni satır eklendi, bir frame bekle.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final state = ref.watch(usbConsoleSessionProvider(widget.port));
    final notifier =
        ref.read(usbConsoleSessionProvider(widget.port).notifier);

    // Yeni entry geldiyse otomatik aşağı kaydır
    ref.listen(usbConsoleSessionProvider(widget.port), (prev, next) {
      if ((prev?.entries.length ?? 0) < next.entries.length) {
        _autoScrollToEnd();
      }
    });

    return Column(
      children: [
        _StatusBar(state: state),
        if (state.connection == UsbConnectionState.error &&
            state.error != null)
          Container(
            width: double.infinity,
            color: cs.errorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.usbConsoleErrorBanner(state.error!),
                    style: TextStyle(color: cs.onErrorContainer),
                  ),
                ),
                TextButton(
                  onPressed: notifier.reconnect,
                  child: Text(l.usbConsoleReconnect),
                ),
              ],
            ),
          ),
        if (state.connection == UsbConnectionState.disconnected)
          Container(
            width: double.infinity,
            color: cs.surfaceContainerHigh,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(child: Text(l.usbConsoleDisconnected)),
                TextButton(
                  onPressed: notifier.reconnect,
                  child: Text(l.usbConsoleReconnect),
                ),
              ],
            ),
          ),
        Expanded(
          child: state.entries.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      l.usbConsoleEmptyHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scroll,
                  padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: state.entries.length,
                  itemBuilder: (ctx, i) =>
                      ConsoleMessageView(entry: state.entries[i]),
                ),
        ),
        _InputBar(
          controller: _input,
          focusNode: _focusNode,
          enabled: state.connection == UsbConnectionState.connected,
          onSubmit: () => _onSubmit(notifier),
          onArrowUp: () => _historyNav(state.commandHistory, -1),
          onArrowDown: () => _historyNav(state.commandHistory, 1),
        ),
      ],
    );
  }

  void _onSubmit(UsbConsoleSessionNotifier notifier) {
    final cmd = _input.text;
    if (cmd.trim().isEmpty) return;
    _input.clear();
    _historyIndex = -1;
    notifier.send(cmd);
    _focusNode.requestFocus();
  }

  void _historyNav(List<String> history, int delta) {
    if (history.isEmpty) return;
    // -1 = current draft. ↑ → en son komut (history.length - 1).
    if (_historyIndex == -1 && delta < 0) {
      _historyIndex = history.length - 1;
    } else {
      final next = _historyIndex + delta;
      if (next < 0) {
        _historyIndex = 0;
      } else if (next >= history.length) {
        _historyIndex = -1;
      } else {
        _historyIndex = next;
      }
    }
    final text = _historyIndex == -1 ? '' : history[_historyIndex];
    _input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.state});
  final UsbConsoleState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final (color, label) = switch (state.connection) {
      UsbConnectionState.connecting =>
        (cs.onSurfaceVariant, l.usbConsoleConnecting),
      // tasarim.md: çevrimiçi/bağlı = tam opak foreground (renk değil).
      UsbConnectionState.connected => (cs.onSurface, l.usbConsoleConnected),
      UsbConnectionState.disconnected =>
        (cs.onSurfaceVariant, l.usbConsoleDisconnected),
      UsbConnectionState.error => (cs.error, l.usbConsoleDisconnected),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${state.port.label} · $label',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: cs.onSurfaceVariant,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onSubmit,
    required this.onArrowUp,
    required this.onArrowDown,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final VoidCallback onSubmit;
  final VoidCallback onArrowUp;
  final VoidCallback onArrowDown;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: cs.outlineVariant, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
      child: Row(
        children: [
          Expanded(
            child: Shortcuts(
              shortcuts: <LogicalKeySet, Intent>{
                LogicalKeySet(LogicalKeyboardKey.arrowUp):
                    const _HistoryUpIntent(),
                LogicalKeySet(LogicalKeyboardKey.arrowDown):
                    const _HistoryDownIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  _HistoryUpIntent: CallbackAction<_HistoryUpIntent>(
                    onInvoke: (_) {
                      onArrowUp();
                      return null;
                    },
                  ),
                  _HistoryDownIntent: CallbackAction<_HistoryDownIntent>(
                    onInvoke: (_) {
                      onArrowDown();
                      return null;
                    },
                  ),
                },
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  textInputAction: TextInputAction.send,
                  autocorrect: false,
                  enableSuggestions: false,
                  onSubmitted: (_) => onSubmit(),
                  style: const TextStyle(fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: l.usbConsoleInputHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.send_rounded),
            onPressed: enabled ? onSubmit : null,
            tooltip: l.usbConsoleSend,
          ),
        ],
      ),
    );
  }
}

class _HistoryUpIntent extends Intent {
  const _HistoryUpIntent();
}

class _HistoryDownIntent extends Intent {
  const _HistoryDownIntent();
}
