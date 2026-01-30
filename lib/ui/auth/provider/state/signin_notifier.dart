import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/ui/auth/provider/state/signin_state.dart';

class SignInNotifier extends StateNotifier<SignInState> {
  final ProfileRepository repository;

  SignInNotifier({required this.repository})
    : super(const SignInState.initial());

  Future<void> signIn(String? accessToken, String? idToken) async {
    try {
      final user = await repository.signInCredential(accessToken, idToken);
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

        await repository.saveUserProfile(profile);

        state = const SignInState.success();
      }
    } on FirebaseAuthException catch (e) {
      state = SignInState.error(e.message ?? "An error occurred");
    }
  }
}
