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
    baseUrl: "http://10.0.2.2:4000/api/v1/",
  );
  dio.options = options;
  return dio;
}
