import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ChatRepository {
  final CollectionReference roomReference =
      FirebaseFirestore.instance.collection('room');
  final CollectionReference chatReference =
      FirebaseFirestore.instance.collection('chat');

  final ProfileRepository profileRepository = ProfileRepository();
  final ContactRepository contactRepository = ContactRepository();

  Stream<QuerySnapshot<Map<String, dynamic>>> loadUserChatsByRoomId(
      String? roomId) {
    return roomReference
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .snapshots();
  }

  Stream<List<LastMessage>> loadUsersLastMessages() async* {
    var lastMessageStream = chatReference
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .orderBy('sendDatetime', descending: true)
        .snapshots();

    var lastMessages = <LastMessage>[];

    await for (var snapshot in lastMessageStream) {
      for (var doc in snapshot.docs) {
        var message = doc.data()['message'];
        var sendDateTime = doc.data()['sendDatetime'];
        var receiverId = doc.data()['receiverId'];
        var profile = await profileRepository.loadSingleProfile(receiverId);
        var friend = await contactRepository.loadSingleFriend(receiverId);

        var lastMessage = LastMessage(
          message: message,
          sendDatetime: sendDateTime,
          receiverId: receiverId,
          profile: profile,
          roomId: friend?.roomId,
        );

        lastMessages.clear();
        lastMessages.add(lastMessage);
      }
      yield lastMessages;
    }
  }

  void sendNewMessage(String? roomId, Chat chat) {
    CollectionReference newMessage =
        roomReference.doc(roomId).collection('messages');
    newMessage.add(chat.toMap());
  }

  void updateLastMessage(
    bool fromSender,
    String profileId,
    String message, {
    int? sendDateTime,
  }) {
    chatReference
        .doc(fromSender ? StorageServices.to.userId : profileId)
        .collection('receiver')
        .doc(fromSender ? profileId : StorageServices.to.userId)
        .set({
      'message': message,
      'receiverId': fromSender ? profileId : StorageServices.to.userId,
      'sendDatetime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> batchDelete(
      String roomId, List<Chat> chatMessages, Profile profile) async {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages');

    for (var message in chatMessages) {
      messages.doc(message.messageId).delete();
    }

    var updatedMessages = await loadChats(roomId);
    var selectedMessage = updatedMessages[updatedMessages.length - 1];
    updateLastMessage(true, profile.uid!, selectedMessage.message!,
        sendDateTime: selectedMessage.sendDatetime);
    updateLastMessage(false, profile.uid!, selectedMessage.message!,
        sendDateTime: selectedMessage.sendDatetime);
  }

  Future<List<Chat>> loadChats(String? roomId) async {
    var chats = await FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs.map((e) => Chat.fromMap(e.data(), "")).toList();
  }
}
