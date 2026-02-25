import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_friend_controller.g.dart';

@riverpod
class BlockedFriendController extends _$BlockedFriendController {
  @override
  Future<List<Profile>> build() async {
    final contactRepo = ref.watch(contactRepositoryProvider);
    final contacts = await contactRepo.loadContacts('blocked');
    return contacts;
  }
}
