import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/model/profile.dart';

class MessageRepository {
  final FirebaseFirestore firestore;

  MessageRepository({required this.firestore});

  void sendNewMessage(Message message) {
    firestore
        .collection('message')
        .doc(message.chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadChatMessages(String? roomId) {
    return firestore
        .collection('message')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .snapshots();
  }

  Future<List<Message>> loadMessageMedia(String? roomId) async {
    var chats = await firestore
        .collection('message')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs.map((e) => Message.fromMap(e.data())).toList();
  }

  Future<void> messagesBatchDelete(
    String roomId,
    List<Message> chatMessages,
    Profile profile,
  ) async {
    CollectionReference messages = firestore
        .collection('message')
        .doc(roomId)
        .collection('messages');

    for (var message in chatMessages) {
      messages.doc(message.messageId).delete();
    }
  }

  Future<List<Message>> loadMessages(String? roomId) async {
    var chats = await firestore
        .collection('message')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs
        .map((e) => Message.fromMapWithMessageId(e.data(), e.id))
        .toList();
  }
}
