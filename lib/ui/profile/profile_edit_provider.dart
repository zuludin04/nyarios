import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_provider.g.dart';

@riverpod
class ProfileEditProvider extends _$ProfileEditProvider {
  @override
  void build() {}

  Stream<Profile> loadStreamProfile() async* {
    final repo = ref.watch(profileRepositoryProvider);
    final local = ref.watch(sharedLocalRepositoryProvider);

    final user = await local.getUserProfile();
    yield* repo.loadStreamProfile(user.userId);
  }

  Future<void> updateImageProfile(String url) async {
    final repo = ref.watch(profileRepositoryProvider);
    final local = ref.watch(sharedLocalRepositoryProvider);

    final user = await local.getUserProfile();
    await repo.updateImageProfile(user.userId, url);
  }

  Future<void> updateProfile(String value, bool isName) async {
    final repo = ref.watch(profileRepositoryProvider);
    final local = ref.watch(sharedLocalRepositoryProvider);

    final user = await local.getUserProfile();
    await repo.updateProfile(user.userId, value, isName);
  }
}
