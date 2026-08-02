// BondStore.clear'ın save'in yazdığı case-varyant anahtarları da sildiğini
// sabitler. Eskiden yalnız exact key siliniyordu; tokenFor'un varyant
// sondası "başarıyla temizlenmiş" bond'u küçük/büyük harf alias'ından
// diriltebiliyordu.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/cli/bond_store.dart';
import 'package:skapp/core/storage/sk_secure_storage.dart';

class InMemorySecureStore implements SkSecureStore {
  final map = <String, String>{};

  @override
  Future<String?> read({required String key}) async => map[key];

  @override
  Future<void> write({required String key, required String value}) async {
    map[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    map.remove(key);
  }

  @override
  Future<Map<String, String>> readAll() async => Map.of(map);
}

void main() {
  final token = Uint8List.fromList(List.generate(32, (i) => i));

  test('clear also removes case-variant keys so tokenFor cannot resurrect',
      () async {
    final storage = InMemorySecureStore();
    final store = BondStore(storage: storage);

    // WiFi akışının yaptığı gibi: exact + lowercase alias.
    await store.save('BF-A06TMFSQT', token,
        aliasIds: const ['bf-a06tmfsqt']);
    expect(await store.tokenFor('BF-A06TMFSQT'), isNotNull);

    await store.clear('BF-A06TMFSQT');
    // Varyant sondası hiçbir anahtardan token bulamamalı.
    expect(await store.tokenFor('BF-A06TMFSQT'), isNull,
        reason: 'alias anahtarı bayat token\'ı diriltmemeli');
    expect(await store.tokenFor('bf-a06tmfsqt'), isNull);
  });
}
