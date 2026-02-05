import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'recent_chat_provider.g.dart';

@riverpod
class RecentChatProvider extends _$RecentChatProvider {
  @override
  Stream<List<Chat>> build() async* {
    final chatRepo = ref.watch(chatRepositoryProvider);
    final profileRepo = ref.watch(profileRepositoryProvider);
    final localRepo = ref.watch(sharedLocalRepositoryProvider);

    final user = await localRepo.getUserProfile();

    final chats$ = chatRepo.loadRecentChat(user.userId);
    final users$ = profileRepo.streamProfiles();

    yield* Rx.combineLatest2(chats$, users$, (chatSnap, usersSnap) {
      final users = {
        for (final u in usersSnap.docs) u.id: Profile.fromMap(u.data()),
      };

      return chatSnap.docs.map((p) {
        final chats = Chat.fromMap(p.data());
        chats.profile = users[chats.profileId];
        return chats;
      }).toList();
    });
  }
}
