import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/ui/auth/provider/state/signin_state.dart';

class SignInNotifier extends StateNotifier<SignInState> {
  final ProfileRepository profileRepo;
  final SharedLocalRepository localRepo;

  SignInNotifier({required this.profileRepo, required this.localRepo})
    : super(const SignInState.initial());

  Future<void> signIn(String? accessToken, String? idToken) async {
    try {
      final user = await profileRepo.signInCredential(accessToken, idToken);
      await localRepo.setAlreadyLogin(true);
      if (mounted) {
        state = const SignInState.loading();

        var profile = Profile(
          uid: user?.uid,
          name: user?.displayName,
          photo: user?.photoURL,
          status: 'Hey there! Let\'s be friend',
          email: user?.email,
          visibility: true,
        );

        await profileRepo.saveUserProfile(profile);
        await localRepo.setUserLocal(profile);

        state = const SignInState.success();
      }
    } on FirebaseAuthException catch (e) {
      state = SignInState.error(e.message ?? "An error occurred");
    }
  }
}
