// Config-time {{param}} substitution — Faz A3 sözleşme kilidi.
//
// Çift süslü {{param}} yer tutucuları app'te ÇÖZÜLÜR; tek süslü {token}
// firmware'e DOKUNULMADAN geçer (sk_api render_ep_payload ateşleme anında
// doldurur). Bu ayrım bozulursa şablonlar cihazda literal {{...}} ile
// ateşlenir — Madde 24'ün kök hatası geri gelir.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/data/template_render.dart';

void main() {
  group('renderTemplate', () {
    test('replaces double-brace placeholders with values', () {
      expect(
        renderTemplate('https://x/{{key}}/go', {'key': 'abc123'}),
        'https://x/abc123/go',
      );
    });

    test('replaces repeated and multiple placeholders', () {
      expect(
        renderTemplate('{{a}}-{{b}}-{{a}}', {'a': '1', 'b': '2'}),
        '1-2-1',
      );
    });

    test('leaves unknown placeholders verbatim', () {
      expect(
        renderTemplate('x{{missing}}y', {'other': 'v'}),
        'x{{missing}}y',
      );
    });

    test('leaves empty-valued placeholders verbatim (unfilled form)', () {
      expect(renderTemplate('x{{key}}y', {'key': ''}), 'x{{key}}y');
    });

    test('single-brace firmware tokens pass through untouched', () {
      const tpl = '{"key":"{{ifttt-key}}","note":"{event} on {device}"}';
      expect(
        renderTemplate(tpl, {'ifttt-key': 'SECRET'}),
        '{"key":"SECRET","note":"{event} on {device}"}',
      );
    });

    test('kebab-case and underscore param names match', () {
      expect(
        renderTemplate('{{my-key}}/{{my_key2}}',
            {'my-key': 'a', 'my_key2': 'b'}),
        'a/b',
      );
    });
  });

  group('unresolvedPlaceholders', () {
    test('empty for fully rendered text', () {
      expect(unresolvedPlaceholders('{"a":1,"b":"{event}"}'), isEmpty);
    });

    test('lists distinct unresolved names in first-seen order', () {
      expect(
        unresolvedPlaceholders('{{b}} {{a}} {{b}}'),
        ['b', 'a'],
      );
    });

    test('single-brace tokens are not reported', () {
      expect(unresolvedPlaceholders('{event} {device}'), isEmpty);
    });
  });
}
