import 'package:flutter/material.dart';

import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';
import '../data/api_endpoint.dart';

/// One endpoint's card: collapsed [_Head] summary + expandable [_Body]
/// editor form. Extracted from on_device_api_editor_screen.dart (Faz 5).
/// All persistence flows back to the parent screen through the callbacks
/// (`onChange` / `onSave` / `onRemove` / `onTest`); the card holds no CLI
/// reference of its own.
class EndpointCard extends StatelessWidget {
  const EndpointCard({
    super.key,
    required this.endpoint,
    required this.onChange,
    required this.onSave,
    required this.onRemove,
    required this.onTest,
  });

  final ApiEndpoint endpoint;
  final VoidCallback onChange;
  final Future<void> Function(ApiEndpoint draft, String? plainToken) onSave;
  final VoidCallback onRemove;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    return SkNeuCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Head(endpoint: endpoint, onChange: onChange),
          if (endpoint.expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: _Body(
                endpoint: endpoint,
                onChange: onChange,
                onSave: onSave,
                onRemove: onRemove,
                onTest: onTest,
              ),
            ),
        ],
      ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({required this.endpoint, required this.onChange});
  final ApiEndpoint endpoint;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final saved = endpoint.slot >= 0;
    return InkWell(
      onTap: () {
        endpoint.expanded = !endpoint.expanded;
        onChange();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            _TypeBadge(type: endpoint.type),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    endpoint.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      typeLabel(endpoint.type),
                      methodWire(endpoint.method),
                      if (endpoint.delayAfterSec > 0)
                        l.bfApiChainSavedDelaySeconds(endpoint.delayAfterSec),
                      if (!saved) l.bfApiChainNotSaved,
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: endpoint.expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 160),
              child: Icon(Icons.expand_more, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Endpoint editing form
// ---------------------------------------------------------------------------

class _Body extends StatefulWidget {
  const _Body({
    required this.endpoint,
    required this.onChange,
    required this.onSave,
    required this.onRemove,
    required this.onTest,
  });

  final ApiEndpoint endpoint;
  final VoidCallback onChange;
  final Future<void> Function(ApiEndpoint draft, String? plainToken) onSave;
  final VoidCallback onRemove;
  final VoidCallback onTest;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final TextEditingController _name;
  late final TextEditingController _url;
  late final TextEditingController _delay;
  late final TextEditingController _headerName;
  late final TextEditingController _contentType;
  late final TextEditingController _newToken;
  bool _saving = false;
  bool _showAdvanced = false;

  late ApiType _type;
  late HttpMethod _method;
  late AuthMode _auth;

  @override
  void initState() {
    super.initState();
    final e = widget.endpoint;
    _name = TextEditingController(text: e.name);
    _url = TextEditingController(text: e.url);
    _delay = TextEditingController(text: '${e.delayAfterSec}');
    _headerName = TextEditingController(text: e.headerName ?? '');
    _contentType =
        TextEditingController(text: e.contentType ?? 'application/json');
    _newToken = TextEditingController();
    _type = e.type;
    _method = e.method;
    _auth = e.auth;
  }

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    _delay.dispose();
    _headerName.dispose();
    _contentType.dispose();
    _newToken.dispose();
    super.dispose();
  }

  /// Strip duplicated scheme prefixes ("https://http://example.com",
  /// "http://https://...") and trailing whitespace. The endpoint editor
  /// previously wrote whatever the user typed straight to the device,
  /// where esp_http_client failed the malformed URL with ERR_HTTP_CONNECT
  ///, surfaced as a generic OOPS scene with no clue *why*. Normalising
  /// here means the form ships valid URLs and the user sees a hint when
  /// the input was wrong. For IFTTT (`type == ifttt`) the field is the
  /// event slug, not a URL, skip the prefix logic in that case.
  static String _sanitizeUrl(String raw, ApiType type) {
    var s = raw.trim();
    if (type == ApiType.ifttt) return s;
    // Collapse any number of leading scheme prefixes, keep only the
    // last one. "https://http://x" → "http://x"; "http://https://x" →
    // "https://x"; "http://http://x" → "http://x". A normal valid input
    // is already idempotent.
    while (true) {
      final lower = s.toLowerCase();
      // Find the last occurrence of "://", anything before its scheme
      // prefix is a stray duplicate.
      final lastScheme = lower.lastIndexOf('://');
      if (lastScheme < 0) break;
      // Locate the scheme word that owns this "://".
      var schemeStart = lastScheme;
      while (schemeStart > 0 && _isSchemeChar(lower.codeUnitAt(schemeStart - 1))) {
        schemeStart--;
      }
      if (schemeStart == 0) break;  // already clean
      s = s.substring(schemeStart);
    }
    return s;
  }

  static bool _isSchemeChar(int c) {
    return (c >= 0x61 && c <= 0x7a) || // a-z
           (c >= 0x41 && c <= 0x5a) || // A-Z
           (c >= 0x30 && c <= 0x39) || // 0-9
           c == 0x2b || c == 0x2d || c == 0x2e; // + - .
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final delay = int.tryParse(_delay.text) ?? 0;
      final clamped = delay < 0 ? 0 : (delay > 300 ? 300 : delay);
      final cleanedUrl = _sanitizeUrl(_url.text, _type);
      // If sanitiser changed the value, write it back to the field so
      // the user sees what was actually saved.
      if (cleanedUrl != _url.text) _url.text = cleanedUrl;
      final draft = widget.endpoint
        ..name = _name.text.trim()
        ..type = _type
        ..url = cleanedUrl
        ..method = _method
        ..auth = _auth
        ..headerName =
            _headerName.text.trim().isEmpty ? null : _headerName.text.trim()
        ..contentType =
            _contentType.text.trim().isEmpty ? null : _contentType.text.trim()
        ..delayAfterSec = clamped;
      await widget.onSave(
        draft,
        _newToken.text.isEmpty ? null : _newToken.text,
      );
      if (mounted) _newToken.clear();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final saved = widget.endpoint.slot >= 0;
    final masked = widget.endpoint.maskedToken;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Field(label: l.bfApiChainFieldNameLabel, controller: _name),
        const SizedBox(height: 12),
        _LabelText(l.bfApiChainTypeLabel),
        const SizedBox(height: 6),
        _TypeSelector(
          selected: _type,
          onChanged: (v) => setState(() => _type = v),
        ),
        const SizedBox(height: 12),
        _Field(
          label: _type == ApiType.ifttt ? l.bfApiChainEventOrApplet : 'URL',
          controller: _url,
        ),
        const SizedBox(height: 12),
        _LabelText(l.bfApiChainMethodLabel),
        const SizedBox(height: 6),
        _MethodSelector(
          selected: _method,
          onChanged: (v) => setState(() => _method = v),
        ),
        const SizedBox(height: 12),
        // Advanced section: auth + headers + content-type + delay-after.
        // Hidden by default to keep the form approachable; opens for
        // power users. delay-after moved inside here in S2.3 (plan
        // decision #7) so new users see a shorter form; the cooldown
        // really only matters when 2+ slots fire in a chain and the
        // user must avoid rate-limit (429) from IFTTT / Discord.
        InkWell(
          onTap: () => setState(() => _showAdvanced = !_showAdvanced),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  _showAdvanced ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _showAdvanced ? l.bfApiChainAdvancedHide : l.bfApiChainAdvancedShow,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
        if (_showAdvanced) ...[
          // delay-after: cooldown between this slot and the next in the
          // chain. Only meaningful when the user has 2+ endpoints; for
          // a single-slot binding this stays 0 and is invisible.
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(child: Text(l.bfApiChainDelayLabel)),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _delay,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(l.bfApiChainDelayUnit,
                  style: TextStyle(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 14),
          _LabelText(l.bfApiChainAuthLabel),
          const SizedBox(height: 6),
          _AuthSelector(
            selected: _auth,
            onChanged: (v) => setState(() => _auth = v),
          ),
          if (_auth == AuthMode.header) ...[
            const SizedBox(height: 12),
            _Field(label: l.bfApiChainFieldHeaderName, controller: _headerName),
          ],
          if (_auth != AuthMode.none) ...[
            const SizedBox(height: 12),
            if (masked != null && masked.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  l.bfApiChainCurrentTokenHint(masked),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            _Field(
              label: l.bfApiChainNewTokenLabel,
              controller: _newToken,
              obscure: true,
            ),
          ],
          const SizedBox(height: 12),
          _Field(label: l.bfApiChainContentTypeLabel, controller: _contentType),
        ],
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: saved ? widget.onRemove : null,
              icon: const Icon(Icons.delete_outline),
              label: Text(l.bfApiChainDeleteCta),
              style: TextButton.styleFrom(foregroundColor: cs.error),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: saved ? widget.onTest : null,
              icon: const Icon(Icons.send, size: 18),
              label: Text(l.bfApiChainTestCta),
            ),
            const SizedBox(width: 4),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child:
                          CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l.bfApiChainSaveCta),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tiny presentation primitives
// ---------------------------------------------------------------------------

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.obscure = false,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelText(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _LabelText extends StatelessWidget {
  const _LabelText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 1,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final ApiType type;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMustard = type == ApiType.ifttt;
    final bg = isMustard
        ? const Color(0xFFD4A017).withValues(alpha: 0.15)
        : cs.surfaceContainerHigh;
    final fg = isMustard ? const Color(0xFFD4A017) : cs.onSurface;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        typeBadgeText(type),
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.selected, required this.onChanged});
  final ApiType selected;
  final ValueChanged<ApiType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        for (final t in ApiType.values)
          ChoiceChip(
            label: Text(typeLabel(t)),
            selected: selected == t,
            onSelected: (v) {
              if (v) onChanged(t);
            },
          ),
      ],
    );
  }
}

class _MethodSelector extends StatelessWidget {
  const _MethodSelector({required this.selected, required this.onChanged});
  final HttpMethod selected;
  final ValueChanged<HttpMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        for (final m in HttpMethod.values)
          ChoiceChip(
            label: Text(methodWire(m)),
            selected: selected == m,
            onSelected: (v) {
              if (v) onChanged(m);
            },
          ),
      ],
    );
  }
}

class _AuthSelector extends StatelessWidget {
  const _AuthSelector({required this.selected, required this.onChanged});
  final AuthMode selected;
  final ValueChanged<AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Wrap(
      spacing: 6,
      children: [
        for (final a in AuthMode.values)
          ChoiceChip(
            label: Text(authLabel(l, a)),
            selected: selected == a,
            onSelected: (v) {
              if (v) onChanged(a);
            },
          ),
      ],
    );
  }
}
