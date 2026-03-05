import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/chat/chatting_controller.dart';

import 'chatting_controller_test.mocks.dart';

@GenerateMocks([
  ChatRepository,
  ContactRepository,
  SharedLocalRepository,
  CallRepository,
])
void main() {
  late MockChatRepository mockChatRepo;
  late MockContactRepository mockContactRepo;
  late MockSharedLocalRepository mockLocalRepo;
  late MockCallRepository mockCallRepo;
  late ProviderContainer container;

  setUp(() {
    mockChatRepo = MockChatRepository();
    mockContactRepo = MockContactRepository();
    mockLocalRepo = MockSharedLocalRepository();
    mockCallRepo = MockCallRepository();

    container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(mockChatRepo),
        contactRepositoryProvider.overrideWithValue(mockContactRepo),
        sharedLocalRepositoryProvider.overrideWithValue(mockLocalRepo),
        callRepositoryProvider.overrideWithValue(mockCallRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ChattingAsyncController', () {
    const chatId = 'chat_123';
    const profileId = 'profile_456';

    test(
      'build should initialize state with user, contact status, and stream messages',
      () async {
        final user = LocalUser(
          id: 1,
          userId: 'u1',
          userName: 'User 1',
          email: 'email1',
          userImage: 'image1',
        );
        final contact = Contact(
          userId: 'user_1',
          chatId: 'ch1',
          status: 'friend',
          createdAt: '2023-01-01',
        );
        final messages = [
          Message(
            messageId: 'm1',
            chatId: chatId,
            senderProfileId: profileId,
            type: 'text',
            text: 'Hello',
            createdAt: '2023-01-01T10:00:00',
            fileSize: '0',
            replyToMessageId: '',
          ),
        ];

        when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
        when(
          mockContactRepo.loadSingleContact(profileId),
        ).thenAnswer((_) async => contact);
        when(
          mockChatRepo.streamChatMessages(chatId),
        ).thenAnswer((_) => Stream.value(messages));

        // Listen to keep provider alive if autoDispose (though @riverpod default is autoDispose)
        final subscription = container.listen(
          chattingControllerProvider(chatId, profileId),
          (previous, next) {},
        );

        await container.read(
          chattingControllerProvider(chatId, profileId).future,
        );

        // Give some time for stream listener to update state
        await Future.delayed(Duration.zero);

        final currentState = container
            .read(chattingControllerProvider(chatId, profileId))
            .requireValue;

        expect(currentState.user, user);
        expect(currentState.status, 'friend');
        expect(currentState.messages, messages);

        subscription.close();
      },
    );

    test('sendMessage should call chatRepo.sendMessage', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockContactRepo.loadSingleContact(any),
      ).thenAnswer((_) async => null);
      when(
        mockChatRepo.streamChatMessages(any),
      ).thenAnswer((_) => const Stream.empty());

      final controller = container.read(
        chattingControllerProvider(chatId, profileId).notifier,
      );
      await container.read(
        chattingControllerProvider(chatId, profileId).future,
      );

      await controller.sendMessage(
        'Hello',
        'text',
        chatId,
        'user_target',
        '100',
      );

      verify(
        mockChatRepo.sendMessage(
          chatId,
          'text',
          'Hello',
          '-',
          'user_target',
          '100',
        ),
      ).called(1);
    });

    test(
      'changeContactStatus should call contactRepo.changeContactStatus and update state',
      () async {
        final user = LocalUser(
          id: 1,
          userId: 'u1',
          userName: 'User 1',
          email: 'email1',
          userImage: 'image1',
        );
        when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
        when(
          mockContactRepo.loadSingleContact(any),
        ).thenAnswer((_) async => null);
        when(
          mockChatRepo.streamChatMessages(any),
        ).thenAnswer((_) => const Stream.empty());

        final controller = container.read(
          chattingControllerProvider(chatId, profileId).notifier,
        );
        await container.read(
          chattingControllerProvider(chatId, profileId).future,
        );

        await controller.changeContactStatus(profileId, 'blocked');

        verify(
          mockContactRepo.changeContactStatus(profileId, 'blocked'),
        ).called(1);
        final state = container
            .read(chattingControllerProvider(chatId, profileId))
            .requireValue;
        expect(state.status, 'blocked');
      },
    );

    test(
      'selectMessage should toggle selection and enter select mode',
      () async {
        final user = LocalUser(
          id: 1,
          userId: 'u1',
          userName: 'User 1',
          email: 'email1',
          userImage: 'image1',
        );
        final messages = [
          Message(
            messageId: 'm1',
            chatId: chatId,
            senderProfileId: profileId,
            type: 'text',
            text: 'Hello',
            createdAt: '2023-01-01T10:00:00',
            fileSize: '0',
            replyToMessageId: '',
          ),
        ];

        when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
        when(
          mockContactRepo.loadSingleContact(any),
        ).thenAnswer((_) async => null);
        when(
          mockChatRepo.streamChatMessages(chatId),
        ).thenAnswer((_) => Stream.value(messages));

        // Use listen to keep provider alive
        final subscription = container.listen(
          chattingControllerProvider(chatId, profileId),
          (previous, next) {},
        );

        final controller = container.read(
          chattingControllerProvider(chatId, profileId).notifier,
        );

        await container.read(
          chattingControllerProvider(chatId, profileId).future,
        );

        // Wait for the stream update
        await Future.delayed(Duration.zero);

        await controller.selectMessage('m1');

        final state = container
            .read(chattingControllerProvider(chatId, profileId))
            .requireValue;

        expect(state.isSelectMode, true);
        expect(
          state.messages.any((m) => m.messageId == 'm1' && m.isSelected),
          true,
        );

        subscription.close();
      },
    );

    test('createCallConversation should return token from callRepo', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockContactRepo.loadSingleContact(any),
      ).thenAnswer((_) async => null);
      when(
        mockChatRepo.streamChatMessages(any),
      ).thenAnswer((_) => const Stream.empty());

      when(
        mockCallRepo.createCall(any, any, any),
      ).thenAnswer((_) async => 'fake_token');

      final controller = container.read(
        chattingControllerProvider(chatId, profileId).notifier,
      );
      await container.read(
        chattingControllerProvider(chatId, profileId).future,
      );

      final token = await controller.createCallConversation(
        channelName: 'chan1',
        type: 'video',
        receiverUserId: 'r1',
      );

      expect(token, 'fake_token');
      verify(mockCallRepo.createCall('video', 'r1', 'chan1')).called(1);
    });
  });
}
