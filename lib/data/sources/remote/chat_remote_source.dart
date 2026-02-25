import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/sources/remote/post/chat_room_post.dart';
import 'package:nyarios/data/sources/remote/post/message_post.dart';
import 'package:nyarios/di/dio_module.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/recent_chat.dart';

final chatRemoteSourceProvider = Provider<ChatRemoteSource>((ref) {
  final dio = dioProvider(ref);
  final firestore = firestoreProvider(ref);
  return ChatRemoteSource(dio: dio, firestore: firestore);
});

class ChatRemoteSource {
  final Dio dio;
  final FirebaseFirestore firestore;

  const ChatRemoteSource({required this.dio, required this.firestore});

  Future<String> createChatRoom(ChatRoomPost chat) async {
    try {
      final response = await dio.post("chat/chat-room", data: chat.toMap());
      return response.data["data"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> sendMessage(MessagePost message) async {
    try {
      final response = await dio.post(
        "chat/send-message",
        data: message.toMap(),
      );
      return response.data["success"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Message>> getMessages(String chatId) async {
    try {
      final response = await dio.get(
        "chat/messages",
        queryParameters: {"chatId": chatId},
      );
      List results = response.data["data"];
      List<Message> messages = results.map((e) => Message.fromMap(e)).toList();
      return messages;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<RecentChat>> getRecentChats(String profileId) async {
    try {
      final response = await dio.get(
        "chat/recent-chats",
        queryParameters: {"profileId": profileId},
      );
      List results = response.data["data"];
      List<RecentChat> recentChats = results
          .map((e) => RecentChat.fromMap(e))
          .toList();
      return recentChats;
    } catch (e) {
      throw Exception(e.toString());
    }
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
