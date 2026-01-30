import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@riverpod
class SplashProvider extends _$SplashProvider {
  @override
  Future<void> build(bool status) async {
    final repository = ref.watch(profileRepositoryProvider);
    await repository.updateOnlineStatus(status);
  }
}
