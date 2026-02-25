import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/sources/remote/post/call_post.dart';
import 'package:nyarios/di/dio_module.dart';

final callRemoteSourceProvider = Provider<CallRemoteSource>((ref) {
  final dio = dioProvider(ref);
  return CallRemoteSource(dio: dio);
});

class CallRemoteSource {
  final Dio dio;

  const CallRemoteSource({required this.dio});

  Future<String> createCall(CallPost call) async {
    try {
      final response = await dio.post("call/create-call", data: call.toMap());
      return response.data["data"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
