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
    yield* repo.loadStreamProfile();
  }

  Future<void> updateProfile(String value, bool isName) async {
    final repo = ref.watch(profileRepositoryProvider);
    await repo.updateProfile(value, isName);
  }
}
