import 'dart:async';

import 'package:nyarios/domain/model/recent_chat.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_chat_controller.g.dart';

@riverpod
class RecentChatController extends _$RecentChatController {
  StreamSubscription<List<RecentChat>>? messageSub;

  @override
  Stream<List<RecentChat>> build() {
    final repo = ref.watch(chatRepositoryProvider);
    return repo.streamRecentChats();
  }
}
