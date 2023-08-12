import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/message.dart';

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
}
