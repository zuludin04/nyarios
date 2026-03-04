import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/call_remote_source.dart';
import 'package:nyarios/data/sources/remote/chat_remote_source.dart';
import 'package:nyarios/data/sources/remote/contact_remote_source.dart';
import 'package:nyarios/data/sources/remote/profile_remote_source.dart';
import 'package:nyarios/di/shared_prefs_module.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  final remoteSource = ref.watch(profileRemoteSourceProvider);
  return ProfileRepository(
    localSource: sharedLocal,
    remoteSource: remoteSource,
    firebaseMessaging: FirebaseMessaging.instance,
  );
});

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  final remoteSource = ref.watch(callRemoteSourceProvider);
  return CallRepository(localSource: sharedLocal, remoteSource: remoteSource);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final localSource = ref.watch(sharedLocalSourceProvider);
  final remoteSource = ref.watch(chatRemoteSourceProvider);
  return ChatRepository(localSource: localSource, remoteSource: remoteSource);
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  final remoteSource = ref.watch(contactRemoteSourceProvider);
  return ContactRepository(
    localSource: sharedLocal,
    remoteSource: remoteSource,
  );
});

final sharedLocalRepositoryProvider = Provider<SharedLocalRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SharedLocalRepository(sharedPrefs: prefs);
});
