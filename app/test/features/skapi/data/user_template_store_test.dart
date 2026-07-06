// UserTemplate store round-trip — UserScriptStore deseninin aynası.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/features/skapi/data/device_template.dart';
import 'package:skapp/features/skapi/data/user_template.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  UserTemplate tpl(String id, {String title = 'Salon Dimmer'}) => UserTemplate(
        id: id,
        title: title,
        summary: 'test',
        category: 'dimmer',
        targetKind: TemplateTargetKind.sdProfile,
        compatiblePrefixes: const ['SD'],
        createdAtMs: 1,
        updatedAtMs: 1,
        jsonBody: '{"v":2,"id":"salon_dim","protocol":"http"}',
        sourceTemplateId: 'sd-profile-shelly-dimmer2',
      );

  test('upsert + read round-trip, en yeni başta', () async {
    SharedPreferences.setMockInitialValues({});
    final store = UserTemplateStore(await SharedPreferences.getInstance());
    await store.upsert(tpl('usertpl-1'));
    await store.upsert(tpl('usertpl-2'));
    final list = store.read();
    expect(list.map((t) => t.id), ['usertpl-2', 'usertpl-1']);
    expect(list.first.targetKind, TemplateTargetKind.sdProfile);
    expect(list.first.jsonBody, contains('salon_dim'));
  });

  test('aynı id üzerine yazar (upsert), sıra korunur', () async {
    SharedPreferences.setMockInitialValues({});
    final store = UserTemplateStore(await SharedPreferences.getInstance());
    await store.upsert(tpl('usertpl-1'));
    await store.upsert(tpl('usertpl-2'));
    await store.upsert(tpl('usertpl-1', title: 'Yeni Ad'));
    final list = store.read();
    expect(list.length, 2);
    expect(list.last.title, 'Yeni Ad');
  });

  test('remove siler, bozuk kayıt temiz başlar', () async {
    SharedPreferences.setMockInitialValues(
        {'skapi.userTemplates.v1': '{bozuk'});
    final store = UserTemplateStore(await SharedPreferences.getInstance());
    expect(store.read(), isEmpty); // bozuk payload sekmeyi düşürmez
    await store.upsert(tpl('usertpl-1'));
    await store.remove('usertpl-1');
    expect(store.read(), isEmpty);
  });

  test('toDeviceTemplate projeksiyonu kimliği ve gövdeyi korur', () {
    final t = tpl('usertpl-9');
    final d = t.toDeviceTemplate();
    expect(d.id, 'usertpl-9');
    expect(d.i18nTitle, 'Salon Dimmer'); // literal — resolver aynen geçirir
    expect(d.targetKind, TemplateTargetKind.sdProfile);
    expect(d.jsonBody, t.jsonBody);
  });
}
