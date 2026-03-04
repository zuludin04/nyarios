import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/chat_remote_source.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/recent_chat.dart';

import 'chat_repository_test.mocks.dart';

@GenerateMocks([SharedLocalSource, ChatRemoteSource])
void main() {
  late ChatRepository chatRepository;
  late MockSharedLocalSource mockLocalSource;
  late MockChatRemoteSource mockRemoteSource;

  setUp(() {
    mockLocalSource = MockSharedLocalSource();
    mockRemoteSource = MockChatRemoteSource();
    chatRepository = ChatRepository(
      localSource: mockLocalSource,
      remoteSource: mockRemoteSource,
    );
  });

  group('createChatRoom', () {
    test('should return chat ID from remote source', () async {
      final chat = Chat(
        title: 'Room 1',
        isGroup: false,
        participants: ['u1', 'u2'],
        createdAt: '2023-10-27T10:00:00Z',
        createdBy: 'u1',
        lastMessage: LastMessage(
          text: 'text',
          senderId: 'senderId',
          createdAt: '2023-10-27T10:00:00Z',
        ),
      );
      when(mockRemoteSource.createChatRoom(any)).thenAnswer((_) async => 'c1');

      final result = await chatRepository.createChatRoom(chat, 'u2');

      expect(result, 'c1');
      verify(mockRemoteSource.createChatRoom(any)).called(1);
    });
  });

  group('sendMessage', () {
    test('should call remote source with correct MessagePost', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);

      when(mockRemoteSource.sendMessage(any)).thenAnswer((_) async => true);

      await chatRepository.sendMessage('c1', 'text', 'hi', '', 'u2', '0');

      verify(mockRemoteSource.sendMessage(any)).called(1);
    });
  });

  group('streamChatMessages', () {
    test('should return stream from remote source', () {
      when(
        mockRemoteSource.streamMessages('c1'),
      ).thenAnswer((_) => Stream.value([]));
      final stream = chatRepository.streamChatMessages('c1');
      expect(stream, emits(isA<List<Message>>()));
    });
  });

  group('loadRecentChats', () {
    test('should return List<RecentChat> from remote source', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);
      when(mockRemoteSource.getRecentChats('u1')).thenAnswer((_) async => []);

      final result = await chatRepository.loadRecentChats();

      expect(result, isA<List<RecentChat>>());
    });
  });
}
