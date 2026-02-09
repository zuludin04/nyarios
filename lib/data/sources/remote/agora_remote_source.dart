import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/dio_module.dart';

final agoraRemoteSourceProvider = Provider<AgoraRemoteSource>((ref) {
  final dio = dioProvider(ref);
  return AgoraRemoteSource(dio: dio);
});

class AgoraRemoteSource {
  final Dio dio;

  const AgoraRemoteSource({required this.dio});

  Future<String> loadAgoraToken({
    required String channel,
    required int uid,
  }) async {
    try {
      final options = BaseOptions(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        baseUrl: "http://localhost:4000/api/v1/",
      );
      dio.options = options;
      final response = await dio.get(
        "agora?channelName=test&uid=1",
        queryParameters: {"channelName": channel, "uid": uid},
      );

      return response.data["key"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
