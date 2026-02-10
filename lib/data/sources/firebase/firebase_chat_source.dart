import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/message.dart';

final firebaseChatSourceProvider = Provider<FirebaseChatSource>((ref) {
  final firestore = firestoreProvider(ref);
  return FirebaseChatSource(firestore: firestore);
});

class FirebaseChatSource {
  final FirebaseFirestore firestore;

  FirebaseChatSource({required this.firestore});

  Future<String> saveNewChat(Chat chat) async {
    final doc = firestore.collection('chats').doc();
    doc.set(chat.toMap());
    return doc.id;
  }

  Future<Chat> loadChatDetail(String chatId) async {
    final ref = await firestore.collection('chats').doc(chatId).get();
    return Chat.fromMap(ref.data()!);
  }

  Future<void> sendChatMessage(Message message) async {
    await firestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .doc(message.messageId)
        .set(message.toMap());
  }

  Stream<List<Message>> streamMessages(String? roomId) {
    return firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) => Message.fromMap(e.data())).toList();
        });
  }

  Future<List<Message>> loadChatMessages(String chatId) async {
    final results = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();
    final messages = results.docs
        .map((e) => Message.fromMap(e.data()))
        .toList();
    return messages;
  }

  Future<void> messagesBatchDelete(
    String roomId,
    List<Message> chatMessages,
  ) async {
    CollectionReference messages = firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages');

    for (var message in chatMessages) {
      messages.doc(message.messageId).delete();
    }
  }
}
