import 'dart:async';

import 'package:nyarios/domain/model/recent_chat.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_chat_provider.g.dart';

@riverpod
class RecentChatProvider extends _$RecentChatProvider {
  StreamSubscription<List<RecentChat>>? messageSub;
  @override
  Stream<List<RecentChat>> build() {
    final recentChatRepo = ref.watch(recentChatRepositoryProvider);
    return recentChatRepo.streamRecentChats();
  }
}
