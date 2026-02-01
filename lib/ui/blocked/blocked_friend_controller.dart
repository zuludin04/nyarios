import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_friend_controller.g.dart';

@riverpod
class BlockedFriendController extends _$BlockedFriendController {
  @override
  Future<List<Contact>> build() async {
    final profileRepo = ref.watch(profileRepositoryProvider);
    final contactRepo = ref.watch(contactRepositoryProvider);

    final contacts = await contactRepo.loadContacts(true);
    final blocked = contacts.map((e) async {
      final profile = await profileRepo.loadSingleProfile(e.profileId);
      e.profile = profile;
      return e;
    });
    return Future.wait(blocked);
  }
}
