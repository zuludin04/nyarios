import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/profile/profile_edit_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_provider.g.dart';

@riverpod
class ProfileEditProvider extends _$ProfileEditProvider {
  late final profileRepo = ref.watch(profileRepositoryProvider);

  @override
  Future<ProfileEditState> build() async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final user = await localRepo.getUserProfile();
    final profile = await profileRepo.loadSingleProfile(user.userId);
    return ProfileEditState(
      photo: profile.photo,
      name: profile.name,
      status: profile.status,
      email: profile.email,
    );
  }

  Future<void> updateProfileName(String value) async {
    await profileRepo.updateProfile(value, true);
    state = AsyncData(state.value!.copyWith(name: value));
  }

  Future<void> updateProfileStatus(String value) async {
    await profileRepo.updateProfile(value, false);
    state = AsyncData(state.value!.copyWith(status: value));
  }
}
