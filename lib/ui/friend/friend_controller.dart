import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_controller.g.dart';

@riverpod
class FriendController extends _$FriendController {
  @override
  Future<List<Profile>> build() async {
    final profileRepo = ref.watch(profileRepositoryProvider);
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final chatRepo = ref.watch(chatRepositoryProvider);

    final user = await localRepo.getUserProfile();
    final chats = await chatRepo.loadChatFriend(user.userId);

    final profiles = chats.map((e) async {
      final profileId = e.participants.where((e) => e != user.userId).first;
      final profile = await profileRepo.loadSingleProfile(profileId);
      return profile;
    }).toList();

    return Future.wait(profiles);
  }
}
