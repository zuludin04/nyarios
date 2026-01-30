import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/di/firebase_module.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return ProfileRepository(firestore: firestore);
});

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return CallRepository(firestore: firestore);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return ChatRepository(firestore: firestore);
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return ContactRepository(firestore: firestore);
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return GroupRepository(firestore: firestore);
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final firestore = firestoreProvider(ref);
  return MessageRepository(firestore: firestore);
});
