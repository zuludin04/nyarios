import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/recent_chat.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/search/search_controller.dart';

import 'search_controller_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late MockChatRepository mockChatRepository;
  late ProviderContainer container;

  setUp(() {
    mockChatRepository = MockChatRepository();
    container = ProviderContainer(
      overrides: [chatRepositoryProvider.overrideWithValue(mockChatRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SearchController', () {
    test('initial state should be empty SearchState', () async {
      final state = await container.read(searchControllerProvider.future);

      expect(state.messageResult, isEmpty);
      expect(state.chatResult, isEmpty);
    });

    test('searchChat should update chatResult with filtered results', () async {
      final chats = [
        RecentChat(
          chatId: '1',
          title: 'Apple',
          isGroup: false,
          profileId: 'p1',
          iconUrl: '',
          lastMessage: '',
          lastMessageSenderId: '',
          lastMessageAt: '',
          unreadCount: 0,
        ),
        RecentChat(
          chatId: '2',
          title: 'Banana',
          isGroup: false,
          profileId: 'p2',
          iconUrl: '',
          lastMessage: '',
          lastMessageSenderId: '',
          lastMessageAt: '',
          unreadCount: 0,
        ),
      ];

      when(mockChatRepository.loadRecentChats()).thenAnswer((_) async => chats);

      final controller = container.read(searchControllerProvider.notifier);
      await controller.searchChat('app');

      final state = container.read(searchControllerProvider).value;

      expect(state?.chatResult.length, 1);
      expect(state?.chatResult[0].title, 'Apple');
    });

    test(
      'searchMessages should update messageResult with filtered results',
      () async {
        final messages = [
          Message(
            messageId: '1',
            chatId: 'c1',
            senderProfileId: 's1',
            type: 'text',
            text: 'Hello world',
            createdAt: '',
            fileSize: '0',
            replyToMessageId: '',
          ),
          Message(
            messageId: '2',
            chatId: 'c1',
            senderProfileId: 's1',
            type: 'text',
            text: 'Goodbye',
            createdAt: '',
            fileSize: '0',
            replyToMessageId: '',
          ),
        ];

        when(
          mockChatRepository.loadMessages('c1'),
        ).thenAnswer((_) async => messages);

        final controller = container.read(searchControllerProvider.notifier);
        await controller.searchMessages('c1', 'hello');

        final state = container.read(searchControllerProvider).value;

        expect(state?.messageResult.length, 1);
        expect(state?.messageResult[0].text, 'Hello world');
      },
    );
  });
}
