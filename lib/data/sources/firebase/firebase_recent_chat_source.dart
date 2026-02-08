import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/recent_chat.dart';

final firebaseRecentChatSourceProvider = Provider<FirebaseRecentChatSource>((
  ref,
) {
  final firestore = firestoreProvider(ref);
  return FirebaseRecentChatSource(firestore: firestore);
});

class FirebaseRecentChatSource {
  final FirebaseFirestore firestore;

  const FirebaseRecentChatSource({required this.firestore});

  Future<void> createRecentChat(String userId, RecentChat chat) async {
    await firestore
        .collection('recentChat')
        .doc(userId)
        .collection('items')
        .doc(chat.chatId)
        .set(chat.toMap());
  }

  Future<void> updateRecentChat(String userId, RecentChat chat) async {
    await firestore
        .collection('recentChat')
        .doc(userId)
        .collection('items')
        .doc(chat.chatId)
        .update({
          "lastMessage": chat.lastMessage,
          "lastMessageSenderId": chat.lastMessageSenderId,
          "lastMessageAt": chat.lastMessageAt,
        });
  }

  Stream<List<RecentChat>> streamRecentChats(String? userId) {
    return firestore
        .collection('recentChat')
        .doc(userId)
        .collection('items')
        .where("lastMessageAt", isNotEqualTo: "")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((e) => RecentChat.fromMap(e.data()))
              .toList();
        });
  }
}
