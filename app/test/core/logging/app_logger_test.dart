import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/logging/app_logger.dart';

void main() {
  test('warn/error land in dump with level tags', () async {
    final log = AppLogger.instance;
    log.warn('pair.test', 'greeting skipped');
    log.error('pair.test', StateError('boom'), StackTrace.current);
    final text = await log.dump();
    expect(text, contains(' W [pair.test] greeting skipped'));
    expect(text, contains(' E [pair.test] Bad state: boom'));
    expect(text, contains('#0')); // stack ilk karesi
  });
}
