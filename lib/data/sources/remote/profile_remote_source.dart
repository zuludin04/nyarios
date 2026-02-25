import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/dio_module.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/profile.dart';

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  final dio = dioProvider(ref);
  final firestore = firestoreProvider(ref);
  final auth = firebaseAuthProvider(ref);
  return ProfileRemoteSource(dio: dio, firestore: firestore, auth: auth);
});

class ProfileRemoteSource {
  final Dio dio;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const ProfileRemoteSource({
    required this.dio,
    required this.firestore,
    required this.auth,
  });

  Future<User?> signInCredential(String? accessToken, String? idToken) async {
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    var credentialAuth = await auth.signInWithCredential(credential);
    return credentialAuth.user;
  }

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

  Stream<bool> getOnlineStatus(String? uid) {
    return firestore.collection("profile").doc(uid).snapshots().map((snapshot) {
      Profile profile = Profile.fromMap(snapshot.data()!);
      return profile.visibility ?? false;
    });
  }

  Stream<Profile> loadStreamProfile(String? uid) async* {
    var profile = firestore.collection("profile").doc(uid).snapshots();
    yield* profile.map((event) => Profile.fromMap(event.data()!));
  }
}
