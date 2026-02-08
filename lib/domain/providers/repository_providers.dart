import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/repositories/agora_repository.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/recent_chat_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/data/sources/firebase/firebase_chat_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_contact_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_recent_chat_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/di/dio_module.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/di/shared_prefs_module.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firebaseProfile = ref.watch(firebaseProfileSourceProvider);
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  return ProfileRepository(
    profileSource: firebaseProfile,
    localSource: sharedLocal,
  );
});

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return CallRepository(firestore: firestore);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatSource = ref.watch(firebaseChatSourceProvider);
  final localSource = ref.watch(sharedLocalSourceProvider);
  return ChatRepository(chatSource: chatSource, localSource: localSource);
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final contactSource = ref.watch(firebaseContactSourceProvider);
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  return ContactRepository(
    contactSource: contactSource,
    localSource: sharedLocal,
  );
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return GroupRepository(firestore: firestore);
});

final agoraRepositoryProvider = Provider<AgoraRepository>((ref) {
  final dio = dioProvider(ref);
  return AgoraRepository(dio: dio);
});

final sharedLocalRepositoryProvider = Provider<SharedLocalRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SharedLocalRepository(sharedPrefs: prefs);
});

final recentChatRepositoryProvider = Provider<RecentChatRepository>((ref) {
  final recentChat = ref.watch(firebaseRecentChatSourceProvider);
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  return RecentChatRepository(
    localSource: sharedLocal,
    recentChatSource: recentChat,
  );
});
