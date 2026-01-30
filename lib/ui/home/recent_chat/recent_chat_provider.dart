import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_chat_provider.g.dart';

@riverpod
class RecentChatProvider extends _$RecentChatProvider {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> build() async* {
    final repo = ref.watch(chatRepositoryProvider);
    yield* repo.loadRecentChat();
  }
}
