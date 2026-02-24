import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
Dio dioProvider(Ref ref) {
  final dio = Dio();
  final options = BaseOptions(
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    baseUrl: "https://nyarios-api.netlify.app/api/v1/",
  );
  dio.options = options;
  return dio;
}
