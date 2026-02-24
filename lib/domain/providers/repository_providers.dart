import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/recent_chat_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/data/sources/firebase/firebase_call_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_chat_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_contact_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_recent_chat_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/agora_remote_source.dart';
import 'package:nyarios/data/sources/remote/chat_remote_source.dart';
import 'package:nyarios/data/sources/remote/notification_remote_source.dart';
import 'package:nyarios/data/sources/remote/profile_remote_source.dart';
import 'package:nyarios/di/shared_prefs_module.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firebaseProfile = ref.watch(firebaseProfileSourceProvider);
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  final remoteSource = ref.watch(profileRemoteSourceProvider);
  return ProfileRepository(
    profileSource: firebaseProfile,
    localSource: sharedLocal,
    remoteSource: remoteSource,
  );
});

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final callSource = ref.watch(firebaseCallSourceProvider);
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  final firebaseProfile = ref.watch(firebaseProfileSourceProvider);
  final agoraSource = ref.watch(agoraRemoteSourceProvider);
  final notificationSource = ref.watch(notificationRemoteSourceProvider);
  return CallRepository(
    callSource: callSource,
    localSource: sharedLocal,
    profileSource: firebaseProfile,
    agoraSource: agoraSource,
    notificationSource: notificationSource,
  );
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatSource = ref.watch(firebaseChatSourceProvider);
  final localSource = ref.watch(sharedLocalSourceProvider);
  final notificationSource = ref.watch(notificationRemoteSourceProvider);
  final firebaseProfile = ref.watch(firebaseProfileSourceProvider);
  final remoteSource = ref.watch(chatRemoteSourceProvider);
  return ChatRepository(
    chatSource: chatSource,
    localSource: localSource,
    notificationSource: notificationSource,
    profileSource: firebaseProfile,
    remoteSource: remoteSource,
  );
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final contactSource = ref.watch(firebaseContactSourceProvider);
  final sharedLocal = ref.watch(sharedLocalSourceProvider);
  return ContactRepository(
    contactSource: contactSource,
    localSource: sharedLocal,
  );
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
