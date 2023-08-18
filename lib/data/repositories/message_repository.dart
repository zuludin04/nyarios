import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';

class MessageRepository {
  final CollectionReference messageReference =
      FirebaseFirestore.instance.collection('message');

  ChatRepository chatRepo = ChatRepository();

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
    CollectionReference messages =
        messageReference.doc(roomId).collection('messages');

    for (var message in chatMessages) {
      messages.doc(message.messageId).delete();
    }

    var updatedMessages = await loadChats(roomId);
    var selectedMessage = updatedMessages[updatedMessages.length - 1];
    Chat chat = Chat(
      profileId: profile.uid,
      lastMessage: selectedMessage.message,
      lastMessageSent: selectedMessage.sendDatetime,
      chatId: selectedMessage.chatId,
      type: 'dm',
    );

    chatRepo.updateRecentChat(true, chat);
    chatRepo.updateRecentChat(false, chat);
  }

  Future<List<Message>> loadChats(String? roomId) async {
    var chats = await messageReference
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs
        .map((e) => Message.fromMapWithMessageId(e.data(), e.id))
        .toList();
  }
}
