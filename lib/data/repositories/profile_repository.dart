import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/domain/model/profile.dart';

class ProfileRepository {
  final FirebaseProfileSource profileSource;
  final SharedLocalSource localSource;

  const ProfileRepository({
    required this.profileSource,
    required this.localSource,
  });

  Future<bool> signInUser({
    required String? accessToken,
    required String? idToken,
  }) async {
    try {
      final user = await profileSource.signInCredential(accessToken, idToken);
      final profile = await profileSource.loadSingleProfile(user?.uid);
      final fcmToken = await profileSource.loadFcmToken();

      if (profile == null) {
        final newProfile = Profile(
          uid: user?.uid,
          name: user?.displayName,
          photo: user?.photoURL,
          status: 'Hey there! Let\'s be friend',
          email: user?.email,
          visibility: true,
          fcmToken: fcmToken,
        );

        await profileSource.saveUserProfile(newProfile);
        await localSource.setUserLocal(newProfile);
      } else {
        await localSource.setUserLocal(profile);
      }
      await localSource.setAlreadyLogin(true);

      return true;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("Google SignIn Error : ${e.message}");
      return false;
    }
  }

  Future<Profile> loadSingleProfile(String? userId) async {
    final profile = await profileSource.loadSingleProfile(userId);
    return profile!;
  }

  Stream<bool> getOnlineStatus() async* {
    final user = await localSource.getUserProfile();
    yield* profileSource.getOnlineStatus(user.userId);
  }

  Stream<Profile> loadStreamProfile() async* {
    final user = await localSource.getUserProfile();
    yield* profileSource.loadStreamProfile(user.userId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamProfiles() async* {
    yield* profileSource.streamProfiles();
  }

  Future<void> setOnlineStatus(bool status) async {
    final user = await localSource.getUserProfile();
    await profileSource.updateOnlineStatus(status, user.userId);
  }

  Future<void> updateProfile(String value, bool updateName) async {
    final user = await localSource.getUserProfile();
    await profileSource.updateProfile(user.userId, value, updateName);
  }
}
