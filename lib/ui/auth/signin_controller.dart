import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/auth/signin_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signin_controller.g.dart';

@riverpod
class SignInController extends _$SignInController {
  @override
  Future<SignInState> build() async {
    return SignInState();
  }

  Future<void> signIn(String? accessToken, String? idToken) async {
    final currentState = state.value ?? SignInState();
    state = AsyncData(currentState.copyWith(isLoading: true));

    final profileRepo = ref.read(profileRepositoryProvider);
    final success = await profileRepo.signInUser(
      accessToken: accessToken,
      idToken: idToken,
    );

    if (success) {
      state = AsyncData(
        currentState.copyWith(successLogin: true, isLoading: false),
      );
    } else {
      state = AsyncData(
        currentState.copyWith(
          successLogin: false,
          isLoading: false,
          message: "An error occurred",
        ),
      );
    }
  }
}
