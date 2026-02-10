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
    final recentChatRepo = ref.watch(recentChatRepositoryProvider);
    final chats = await recentChatRepo.loadRecentChats();
    final results = chats
        .where((e) => e.title.toLowerCase().contains(term.toLowerCase()))
        .toList();

    state = AsyncData(state.value!.copyWith(chatResult: results));
  }

  Future<void> searchMessages(String chatId, String query) async {
    final chatRepo = ref.watch(chatRepositoryProvider);
    final messages = await chatRepo.loadMessages(chatId);
    final results = messages
        .where((e) => e.text.toLowerCase().contains(query.toLowerCase()))
        .toList();

    state = AsyncData(state.value!.copyWith(messageResult: results));
  }
}
