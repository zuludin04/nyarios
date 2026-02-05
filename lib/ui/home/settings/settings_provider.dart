import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsProvider extends _$SettingsProvider {
  @override
  Stream<Profile> build() async* {
    final repo = ref.watch(profileRepositoryProvider);
    final localRepo = ref.watch(sharedLocalRepositoryProvider);

    final user = await localRepo.getUserProfile();
    yield* repo.loadStreamProfile(user.userId);
  }
}
