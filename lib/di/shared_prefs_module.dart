import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/services/shared_prefs_service.dart';

final sharedPrefsProvider = Provider((ref) {
  final SharedPrefsService storage = SharedPrefsService();
  storage.init();
  return storage;
});
