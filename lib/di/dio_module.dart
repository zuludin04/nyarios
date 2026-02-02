import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
Dio dioProvider(Ref ref) {
  final dio = Dio();
  return dio;
}
