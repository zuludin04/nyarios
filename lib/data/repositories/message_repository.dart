import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/model/profile.dart';

class MessageRepository {
  final CollectionReference messageReference =
      FirebaseFirestore.instance.collection('message');

  void sendNewMessage(Message message) {
    messageReference
        .doc(message.chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadChatMessages(String? roomId) {
    return messageReference
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .snapshots();
  }

  Future<List<Message>> loadMessageMedia(String? roomId) async {
    var chats = await messageReference
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs.map((e) => Message.fromMap(e.data())).toList();
  }

  Future<void> messagesBatchDelete(
      String roomId, List<Message> chatMessages, Profile profile) async {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages');

    for (var message in chatMessages) {
      messages.doc('message.messageId').delete();
    }

    var updatedMessages = await loadChats(roomId);
    var selectedMessage = updatedMessages[updatedMessages.length - 1];
    // updateLastMessage(true, profile.uid!, selectedMessage.message!,
    //     sendDateTime: selectedMessage.sendDatetime);
    // updateLastMessage(false, profile.uid!, selectedMessage.message!,
    //     sendDateTime: selectedMessage.sendDatetime);
  }

  Future<List<Message>> loadChats(String? roomId) async {
    var chats = await messageReference
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs.map((e) => Message.fromMap(e.data())).toList();
  }
}
