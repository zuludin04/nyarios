import 'package:nyarios/data/sources/firebase/firebase_recent_chat_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/domain/model/recent_chat.dart';

class RecentChatRepository {
  final FirebaseRecentChatSource recentChatSource;
  final SharedLocalSource localSource;

  const RecentChatRepository({
    required this.recentChatSource,
    required this.localSource,
  });

  Future<void> createRecentChat(String userId, RecentChat chat) async {
    await recentChatSource.createRecentChat(userId, chat);
  }

  Future<void> updateRecentChat(String userId, RecentChat chat) async {
    await recentChatSource.updateRecentChat(userId, chat);
  }

  Stream<List<RecentChat>> streamRecentChats() async* {
    final user = await localSource.getUserProfile();
    yield* recentChatSource.streamRecentChats(user.userId);
  }

  Future<List<RecentChat>> loadRecentChats() async {
    final user = await localSource.getUserProfile();
    return recentChatSource.loadRecentChats(user.userId!);
  }
}
