import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/dio_module.dart';
import 'package:nyarios/domain/model/profile.dart';

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  final dio = dioProvider(ref);
  return ProfileRemoteSource(dio: dio);
});

class ProfileRemoteSource {
  final Dio dio;

  const ProfileRemoteSource({required this.dio});

  Future<Profile> saveProfile(Profile profile) async {
    try {
      final response = await dio.post("profile/save", data: profile.toMap());
      return Profile.fromMap(response.data["data"]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Profile> getProfile(String profileId) async {
    try {
      final response = await dio.get("profile/$profileId");
      return Profile.fromMap(response.data["data"]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> updateProfile(
    String profileId,
    String name,
    String status,
  ) async {
    try {
      final response = await dio.post(
        "profile/update",
        data: {"profileId": profileId, "name": name, "status": status},
      );

      return response.data["success"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> changeOnlineStatus(String profileId, bool status) async {
    try {
      final response = await dio.post(
        "profile/online-status",
        data: {"profileId": profileId, "isOnline": status},
      );

      return response.data["success"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
