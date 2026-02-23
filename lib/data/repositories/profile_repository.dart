import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/profile_remote_source.dart';
import 'package:nyarios/domain/model/profile.dart';

class ProfileRepository {
  final FirebaseProfileSource profileSource;
  final SharedLocalSource localSource;
  final ProfileRemoteSource remoteSource;

  const ProfileRepository({
    required this.profileSource,
    required this.localSource,
    required this.remoteSource,
  });

  Future<bool> signInUser({
    required String? accessToken,
    required String? idToken,
  }) async {
    try {
      final user = await profileSource.signInCredential(accessToken, idToken);
      final fcmToken = await profileSource.loadFcmToken();
      final profile = Profile(
        uid: user?.uid,
        name: user?.displayName,
        photo: user?.photoURL,
        status: 'Hey there! Let\'s be friend',
        email: user?.email,
        visibility: true,
        fcmToken: fcmToken,
      );

      final response = await remoteSource.saveProfile(profile);
      await localSource.setUserLocal(response);
      await localSource.setAlreadyLogin(true);

      return true;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("Google SignIn Error : ${e.message}");
      return false;
    }
  }

  Future<Profile> loadSingleProfile(String? profileId) async {
    try {
      final result = await remoteSource.getProfile(profileId!);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Stream<bool> getOnlineStatus(String userId) async* {
    yield* profileSource.getOnlineStatus(userId);
  }

  Stream<Profile> loadStreamProfile() async* {
    final user = await localSource.getUserProfile();
    yield* profileSource.loadStreamProfile(user.userId);
  }

  Future<void> setOnlineStatus(bool status) async {
    final user = await localSource.getUserProfile();
    await remoteSource.changeOnlineStatus(user.userId!, status);
  }

  Future<void> updateProfile(String value, bool updateName) async {
    final user = await localSource.getUserProfile();
    await remoteSource.updateProfile(
      user.userId!,
      updateName ? value : "",
      updateName ? "" : value,
    );
  }
}
