import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'update_service.dart';

/// Singleton [UpdateService] (owns one http.Client, closed on dispose).
final updateServiceProvider = Provider<UpdateService>((ref) {
  final svc = UpdateService();
  ref.onDispose(svc.dispose);
  return svc;
});
