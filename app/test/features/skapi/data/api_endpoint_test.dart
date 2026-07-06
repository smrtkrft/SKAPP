// ApiEndpoint wire-parse sözleşmesi — sk_api >= 0.5.0 payload alanı dahil.
//
// `api.endpoint.list` satırı payload'ı TAM döner (token'ın aksine maskesiz)
// ki düzenleme round-trip edebilsin. Eski firmware satırlarında alan hiç
// yoktur → null kalmalı ve kaydetme yolu payload argümanını atlamalı.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/data/api_endpoint.dart';

void main() {
  test('fromJson parses a full 0.5.0 row including payload', () {
    final e = ApiEndpoint.fromJson({
      'slot': 2,
      'kind': 'user',
      'name': 'ha',
      'type': 'webhook_post',
      'url': 'https://ha.local/api/webhook/x',
      'method': 'POST',
      'auth': 'bearer',
      'header': '',
      'content_type': 'application/json',
      'masked_token': 'abcd...wxyz',
      'payload': '{"entity_id":"script.focus","note":"{event}"}',
      'delay_after_sec': 5,
      'peer_id': '',
    });
    expect(e.slot, 2);
    expect(e.kind, ApiKind.user);
    expect(e.type, ApiType.webhookPost);
    expect(e.auth, AuthMode.bearer);
    expect(e.payload, '{"entity_id":"script.focus","note":"{event}"}');
    expect(e.delayAfterSec, 5);
  });

  test('fromJson tolerates pre-0.5.0 rows without payload', () {
    final e = ApiEndpoint.fromJson({
      'slot': 0,
      'name': 'lights',
      'type': 'ifttt',
      'url': 'focus_done',
      'method': 'POST',
      'auth': 'none',
    });
    expect(e.payload, isNull);
    expect(e.type, ApiType.ifttt);
  });

  test('empty payload string round-trips as empty (not null)', () {
    final e = ApiEndpoint.fromJson({
      'slot': 1,
      'name': 'x',
      'type': 'generic',
      'url': 'https://x',
      'payload': '',
    });
    // Firmware list rows always include the key from 0.5.0 on; the save
    // path treats empty the same as null (arg omitted).
    expect(e.payload, '');
  });
}
