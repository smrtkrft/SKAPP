// Yer grupları · model + kalıcılık sözleşmesi.
//
// Kilitlenen kurallar:
//   · Grup SİLİNİNCE cihazlar silinmez, groupId null'a döner.
//   · Eski kayıtlarda groupId alanı yok → null (gruplanmamış) okunur.
//   · Ad boş ya da yinelenmiş (harf duyarsız) olamaz.
//   · Sıra 0..n-1 normalize edilir.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/core/storage/device_groups_store.dart';
import 'package:skapp/core/storage/paired_devices_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('DeviceGroupsStore', () {
    test('ekle · yeniden adlandır · sil', () async {
      final s = DeviceGroupsStore(prefs);
      final buro = await s.add('Büro');
      final ev = await s.add('Ev');
      expect(buro, isNotNull);
      expect(s.read().map((g) => g.name), ['Büro', 'Ev']);

      expect(await s.rename(ev!, 'Salon'), isTrue);
      expect(s.read().map((g) => g.name), ['Büro', 'Salon']);

      await s.remove(buro!);
      expect(s.read().map((g) => g.name), ['Salon']);
    });

    test('boş ve yinelenen ad reddedilir (harf duyarsız)', () async {
      final s = DeviceGroupsStore(prefs);
      await s.add('Büro');
      expect(s.checkName('  '), GroupNameCheck.empty);
      expect(s.checkName('büro'), GroupNameCheck.duplicate);
      expect(s.checkName('BÜRO'), GroupNameCheck.duplicate);
      expect(s.checkName('Ev'), GroupNameCheck.ok);
      expect(await s.add(''), isNull);
      expect(await s.add('BÜRO'), isNull);
      expect(s.read().length, 1);
    });

    test('yeniden adlandırmada kendi adı yinelenme sayılmaz', () async {
      final s = DeviceGroupsStore(prefs);
      final id = await s.add('Büro');
      expect(s.checkName('Büro', exceptId: id), GroupNameCheck.ok);
      expect(await s.rename(id!, 'Büro'), isTrue);
    });

    test('sıralama · order 0..n-1 normalize edilir', () async {
      final s = DeviceGroupsStore(prefs);
      await s.add('A');
      await s.add('B');
      await s.add('C');
      await s.reorder(2, 0); // C en başa
      expect(s.read().map((g) => g.name), ['C', 'A', 'B']);
      expect(s.read().map((g) => g.order), [0, 1, 2]);

      await s.reorder(0, 3); // C en sona (ReorderableListView sözleşmesi)
      expect(s.read().map((g) => g.name), ['A', 'B', 'C']);
    });

    test('bozuk kayıt tüm listeyi öldürmez', () async {
      SharedPreferences.setMockInitialValues({'device_groups': '{bozuk'});
      final p = await SharedPreferences.getInstance();
      expect(DeviceGroupsStore(p).read(), isEmpty);
    });
  });

  group('PairedDevice.groupId', () {
    PairedDevice dev(String id, {String? group}) => PairedDevice(
          id: id,
          name: id,
          prefix: 'BF',
          pairedAt: DateTime(2026, 1, 1),
          groupId: group,
        );

    test('eski kayıtta alan yok → null (geriye uyum)', () {
      final legacy = PairedDevice.fromJson({
        'id': 'BF-1',
        'name': 'BF-1',
        'prefix': 'BF',
        'pairedAt': '2026-01-01T00:00:00.000',
      });
      expect(legacy.groupId, isNull);
    });

    test('JSON gidiş-dönüş', () {
      final d = dev('BF-1', group: 'g1');
      expect(PairedDevice.fromJson(d.toJson()).groupId, 'g1');
    });

    test('copyWith · null GEÇERLİ değer (gruptan çıkar)', () {
      final d = dev('BF-1', group: 'g1');
      expect(d.copyWith(groupId: null).groupId, isNull);
      // Parametre verilmezse korunur.
      expect(d.copyWith(name: 'x').groupId, 'g1');
    });

    test('grup silinince CİHAZLAR SİLİNMEZ, gruplanmamışa döner', () async {
      final store = PairedDevicesStore(prefs);
      await store.upsert(dev('BF-1', group: 'g1'));
      await store.upsert(dev('BF-2', group: 'g1'));
      await store.upsert(dev('LS-1', group: 'g2'));

      final moved = await store.detachGroup('g1');
      expect(moved, 2, reason: 'taşınan cihaz sayısı SnackBar\'a gidiyor');
      expect(store.read().length, 3, reason: 'hiçbir cihaz silinmedi');
      expect(store.read().where((d) => d.groupId == null).length, 2);
      expect(store.findById('LS-1')!.groupId, 'g2',
          reason: 'başka grubun cihazına dokunulmadı');
    });

    test('toplu taşıma tek yazmada', () async {
      final store = PairedDevicesStore(prefs);
      await store.upsert(dev('BF-1'));
      await store.upsert(dev('BF-2'));
      await store.upsert(dev('LS-1'));
      await store.setGroupMany({'BF-1', 'LS-1'}, 'g9');
      expect(store.findById('BF-1')!.groupId, 'g9');
      expect(store.findById('LS-1')!.groupId, 'g9');
      expect(store.findById('BF-2')!.groupId, isNull);
    });

    test('clearLastEndpoint grup bilgisini DÜŞÜRMEZ', () async {
      final store = PairedDevicesStore(prefs);
      await store.upsert(PairedDevice(
        id: 'BF-1',
        name: 'BF-1',
        prefix: 'BF',
        pairedAt: DateTime(2026, 1, 1),
        lastIp: '10.0.0.5',
        lastPort: 8080,
        groupId: 'g1',
      ));
      await store.clearLastEndpoint('BF-1');
      final d = store.findById('BF-1')!;
      expect(d.lastIp, isNull);
      expect(d.groupId, 'g1',
          reason: 'kayıt elle yeniden kuruluyor, alan sessizce düşmemeli');
    });
  });
}
