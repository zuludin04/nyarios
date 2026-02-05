import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/splash/splash_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_controller.g.dart';

@riverpod
class SplashController extends _$SplashController {
  late final SharedLocalRepository repository;

  @override
  Future<SplashState> build() async {
    repository = ref.watch(sharedLocalRepositoryProvider);
    return SplashState();
  }

  Future<void> loadScreen() async {
    final result = await repository.isAlreadyLogin();
    state = AsyncData(state.value!.copyWith(isAlreadyLogin: result));
  }
}
