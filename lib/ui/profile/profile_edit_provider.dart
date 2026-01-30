import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_provider.g.dart';

@riverpod
class ProfileEditProvider extends _$ProfileEditProvider {
  @override
  void build() {}

  Stream<Profile> loadStreamProfile(String userId) async* {
    final repo = ref.watch(profileRepositoryProvider);
    yield* repo.loadStreamProfile(userId);
  }

  Future<void> updateImageProfile(String profileId, String url) async {
    final repo = ref.watch(profileRepositoryProvider);
    await repo.updateImageProfile(profileId, url);
  }

  Future<void> updateProfile(
    String profileId,
    String value,
    bool isName,
  ) async {
    final repo = ref.watch(profileRepositoryProvider);
    await repo.updateProfile(profileId, value, isName);
  }
}
