import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/domain/model/recent_chat.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/home/recent_chat/recent_chat_controller.dart';

import 'recent_chat_controller_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late MockChatRepository mockChatRepo;
  late ProviderContainer container;

  setUp(() {
    mockChatRepo = MockChatRepository();
    container = ProviderContainer(
      overrides: [chatRepositoryProvider.overrideWithValue(mockChatRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('RecentChatAsyncController', () {
    test('build should stream recent chats from repository', () async {
      final recentChats = [
        RecentChat(
          chatId: '1',
          profileId: 'p1',
          isGroup: false,
          title: 'Title',
          iconUrl: '',
          lastMessage: 'Hi',
          lastMessageSenderId: 's1',
          lastMessageAt: '2023-10-27T10:00:00Z',
          unreadCount: 0,
        ),
      ];

      when(
        mockChatRepo.streamRecentChats(),
      ).thenAnswer((_) => Stream.value(recentChats));

      // Use listen to keep the autoDispose provider alive during the test
      final subscription = container.listen(
        recentChatControllerProvider,
        (previous, next) {},
      );

      final result = await container.read(recentChatControllerProvider.future);

      expect(result, recentChats);
      verify(mockChatRepo.streamRecentChats()).called(1);

      subscription.close();
    });
  });
}
