import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/group.dart';

class ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepository({required this.firestore});

  Future<String> saveNewChat(Chat chat) async {
    final doc = firestore.collection('chats').doc();
    doc.set(chat.toMap());
    return doc.id;
  }

  Future<List<Chat>> loadChatFriend(String? userId) async {
    final results = await firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    final chats = results.docs.map((e) => Chat.fromMap(e.data())).toList();
    return chats;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadRecentChat(
    String? userId,
  ) async* {
    yield* firestore
        .collection('chat')
        .doc(userId)
        .collection('receiver')
        .orderBy('lastMessageSent', descending: true)
        .snapshots();
  }

  Future<List<Chat>> loadDmChat(String? userId) async {
    var results = await firestore
        .collection('chat')
        .doc(userId)
        .collection('receiver')
        .where('type', isEqualTo: 'dm')
        .get();
    var result = results.docs.map((e) {
      var chat = Chat.fromMap(e.data());
      return chat;
    }).toList();
    return result;
  }

  void updateRecentChat(bool fromSender, Chat lastMessage, String? userId) {
    // firestore
    //     .collection('chat')
    //     .doc(fromSender ? userId : lastMessage.profileId)
    //     .collection('receiver')
    //     .doc(fromSender ? lastMessage.profileId : userId)
    //     .set(lastMessage.toMap(fromSender, userId));
  }

  Future<void> updateGroupRecentChat(Group group, Chat chat) async {
    // for (var element in group.members!) {
    //   await firestore
    //       .collection('chat')
    //       .doc(element)
    //       .collection('receiver')
    //       .doc(group.groupId)
    //       .set(chat.toMapGroup());
    // }
  }

  Future<void> deleteGroupChat(String groupId, String userId) async {
    // await firestore
    //     .collection('chat')
    //     .doc(userId)
    //     .collection('receiver')
    //     .doc(groupId)
    //     .delete();
  }
}
