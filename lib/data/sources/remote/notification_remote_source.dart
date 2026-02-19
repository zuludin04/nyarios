import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/dio_module.dart';

final notificationRemoteSourceProvider = Provider<NotificationRemoteSource>((
  ref,
) {
  final dio = dioProvider(ref);
  return NotificationRemoteSource(dio: dio);
});

class NotificationRemoteSource {
  final Dio dio;

  const NotificationRemoteSource({required this.dio});

  Future<String> sendCallNotification({
    required String userId,
    required String name,
    required String image,
    required String type,
    required String chatId,
    required String agoraToken,
  }) async {
    try {
      final options = BaseOptions(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        baseUrl: "https://nyarios-api.netlify.app/api/v1/",
      );
      dio.options = options;
      final response = await dio.post(
        "firebase/sendCallNotification/$userId",
        data: {
          "name": name,
          "image": image,
          "type": type,
          "chatId": chatId,
          "agoraToken": agoraToken,
        },
      );

      return response.data["data"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> sendMessageNotification({
    required String uid,
    required String name,
    required String image,
    required String chatId,
  }) async {
    try {
      final options = BaseOptions(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        baseUrl: "https://nyarios-api.netlify.app/api/v1/",
      );
      dio.options = options;
      final response = await dio.post(
        "firebase/sendChatNotification/$uid",
        data: {"name": name, "photo": image, "chatId": chatId},
      );

      return response.data["data"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
