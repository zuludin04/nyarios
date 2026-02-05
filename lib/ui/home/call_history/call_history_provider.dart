import 'package:nyarios/domain/model/call.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'call_history_provider.g.dart';

@riverpod
class CallHistoryProvider extends _$CallHistoryProvider {
  @override
  Stream<List<Call>> build() async* {
    final callRepo = ref.watch(callRepositoryProvider);
    final profileRepo = ref.watch(profileRepositoryProvider);
    final localRepo = ref.watch(sharedLocalRepositoryProvider);

    final user = await localRepo.getUserProfile();
    final calls$ = callRepo.loadCallHistory(user.userId);
    final users$ = profileRepo.streamProfiles();
    yield* Rx.combineLatest2(calls$, users$, (callSnap, usersSnap) {
      final users = {
        for (final u in usersSnap.docs) u.id: Profile.fromMap(u.data()),
      };

      return callSnap.docs.map((p) {
        final chats = Call.fromMap(p.data());
        chats.profile = users[chats.profileId];
        return chats;
      }).toList();
    });
  }
}
