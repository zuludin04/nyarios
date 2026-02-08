import 'package:flutter_riverpod/legacy.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/ui/auth/provider/state/signin_state.dart';

class SignInNotifier extends StateNotifier<SignInState> {
  final ProfileRepository profileRepo;

  SignInNotifier({required this.profileRepo})
    : super(const SignInState.initial());

  Future<void> signIn(String? accessToken, String? idToken) async {
    state = const SignInState.loading();
    final success = await profileRepo.signInUser(
      accessToken: accessToken,
      idToken: idToken,
    );
    if (success) {
      state = const SignInState.success();
    } else {
      state = const SignInState.error("An error occurred");
    }
  }
}
