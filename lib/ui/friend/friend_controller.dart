import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_controller.g.dart';

@riverpod
class FriendController extends _$FriendController {
  @override
  Future<List<Contact>> build() async {
    final contactRepo = ref.watch(contactRepositoryProvider);
    final profileRepo = ref.watch(profileRepositoryProvider);

    final contacts = await contactRepo.loadContacts(false);
    final friends = contacts.map((e) async {
      final profile = await profileRepo.loadSingleProfile(e.profileId);
      e.profile = profile;
      return e;
    });
    return Future.wait(friends);
  }
}
