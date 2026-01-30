import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/di/firebase_module.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return ProfileRepository(firestore: firestore);
});
