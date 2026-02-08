import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/search/search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  @override
  Future<SearchState> build() async {
    return const SearchState();
  }

  Future<void> searchChat(String term) async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);

    final user = await localRepo.getUserProfile();
    // final chats = await chatRepo.loadDmChat(user.userId);
    // final chatProfiles = chats.map((e) async {
    //   return e;
    // });

    // final filtered = await Future.wait(chatProfiles);
    // final results = filtered
    //     .where(
    //       (e) => e.profile!.name!.toLowerCase().contains(term.toLowerCase()),
    //     )
    //     .toList();

    state = AsyncData(
      state.value!.copyWith(chatResult: [], userId: user.userId),
    );
  }

  Future<void> searchMessages(String roomId, String query) async {
    // final messageRepo = ref.watch(messageRepositoryProvider);
    // final localRepo = ref.watch(sharedLocalRepositoryProvider);

    // final user = await localRepo.getUserProfile();
    // final messages = await messageRepo.searchMessages(roomId);
    // final results = messages
    //     .where((e) => e.text!.toLowerCase().contains(query.toLowerCase()))
    //     .toList();
    // state = AsyncData(
    //   state.value!.copyWith(messageResult: results, userId: user.userId),
    // );
  }
}
