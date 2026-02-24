import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/sources/remote/post/chat_room_post.dart';
import 'package:nyarios/data/sources/remote/post/message_post.dart';
import 'package:nyarios/di/dio_module.dart';

final chatRemoteSourceProvider = Provider<ChatRemoteSource>((ref) {
  final dio = dioProvider(ref);
  return ChatRemoteSource(dio: dio);
});

class ChatRemoteSource {
  final Dio dio;

  const ChatRemoteSource({required this.dio});

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
      final response = await dio.post("chat/send-message", data: message.toMap());
      return response.data["success"];
    } catch (e) {
      if (e is DioException) {
        print("error send message ${e.response}");
      }
      throw Exception(e.toString());
    }
  }
}
