import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/user_script.dart';

/// Create / edit a user-authored script.
///
/// Device-independent: the user writes a title, a one-line description, picks
/// a platform, and types the script body. Saving upserts into
/// [userScriptsProvider] so the entry appears under "Benim Script'lerim" in
/// the SKAPI library. `existing == null` is create mode; otherwise edit.
class UserScriptEditorScreen extends ConsumerStatefulWidget {
  const UserScriptEditorScreen({super.key, this.existing});

  final UserScript? existing;

  @override
  ConsumerState<UserScriptEditorScreen> createState() =>
      _UserScriptEditorScreenState();
}

class _UserScriptEditorScreenState
    extends ConsumerState<UserScriptEditorScreen> {
  late final TextEditingController _title;
  late final TextEditingController _desc;
  late final TextEditingController _code;
  late String _platform;

  // Platform value → display label. Labels are proper nouns, not translated.
  static const _platforms = [
    ('win', 'Windows'),
    ('mac', 'macOS'),
    ('lx', 'Linux'),
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _desc = TextEditingController(text: e?.description ?? '');
    _code = TextEditingController(text: e?.source ?? '');
    _platform = e?.platform ?? 'win';
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final title = _title.text.trim();
    final code = _code.text;
    if (title.isEmpty || code.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.skapiUserValidationEmpty, textAlign: TextAlign.center),
        ));
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = widget.existing;
    final script = existing == null
        ? UserScript(
            id: 'user-$now',
            title: title,
            description: _desc.text.trim(),
            platform: _platform,
            source: code,
            createdAtMs: now,
            updatedAtMs: now,
          )
        : existing.copyWith(
            title: title,
            description: _desc.text.trim(),
            platform: _platform,
            source: code,
            updatedAtMs: now,
          );
    await ref.read(userScriptsProvider.notifier).upsert(script);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.skapiUserSavedSnack, textAlign: TextAlign.center),
      ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final isEdit = widget.existing != null;

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: l.commonClose,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(isEdit ? l.skapiUserEditTitle : l.skapiUserNewTitle),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check, size: 18),
            label: Text(l.skapiUserSaveCta),
          ),
        ],
      ),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            SkNeuCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _title,
                    maxLength: 48,
                    decoration: InputDecoration(
                      labelText: l.skapiUserTitleLabel,
                      hintText: l.skapiUserTitleHint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _desc,
                    maxLength: 120,
                    decoration: InputDecoration(
                      labelText: l.skapiUserDescLabel,
                      hintText: l.skapiUserDescHint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _platform,
                    decoration: InputDecoration(
                      labelText: l.skapiUserPlatformLabel,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      for (final (value, label) in _platforms)
                        DropdownMenuItem(value: value, child: Text(label)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _platform = v);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.skapiUserCodeLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.6,
                  ),
            ),
            const SizedBox(height: 8),
            SkNeuCard(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _code,
                minLines: 10,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.45,
                ),
                decoration: InputDecoration(
                  hintText: l.skapiUserCodeHint,
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
