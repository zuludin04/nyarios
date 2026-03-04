import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/sources/remote/chat_remote_source.dart';
import 'package:nyarios/data/sources/remote/post/chat_room_post.dart';
import 'package:nyarios/data/sources/remote/post/message_post.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/recent_chat.dart';

import 'chat_remote_source_test.mocks.dart';

@GenerateMocks([
  Dio,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
  DocumentSnapshot,
])
void main() {
  late ChatRemoteSource chatRemoteSource;
  late MockDio mockDio;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockDio = MockDio();
    mockFirestore = MockFirebaseFirestore();
    chatRemoteSource = ChatRemoteSource(dio: mockDio, firestore: mockFirestore);
  });

  group('createChatRoom', () {
    final chatRoomPost = ChatRoomPost(
      isGroup: false,
      title: 'Test Room',
      participants: ['user1', 'user2'],
      createdAt: '2023-10-27T10:00:00Z',
      senderProfileId: 'user1',
      receiverProfileId: 'user2',
    );

    test('should return chat room ID when successful', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'data': 'roomId123'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await chatRemoteSource.createChatRoom(chatRoomPost);

      // assert
      expect(result, 'roomId123');
      verify(mockDio.post("chat/chat-room", data: chatRoomPost.toMap()));
    });

    test('should throw Exception when Dio error occurs', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      // act & assert
      expect(
        () => chatRemoteSource.createChatRoom(chatRoomPost),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('sendMessage', () {
    final messagePost = MessagePost(
      messageId: 'msg1',
      chatId: 'chat1',
      senderProfileId: 'sender1',
      type: 'text',
      text: 'Hello',
      replyToMessageId: '',
      createdAt: '2023-10-27T10:05:00Z',
      fileSize: '0',
      receiverProfileId: 'receiver1',
    );

    test('should return true when successful', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await chatRemoteSource.sendMessage(messagePost);

      // assert
      expect(result, true);
    });

    test('should return false when server returns success: false', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': false},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await chatRemoteSource.sendMessage(messagePost);

      // assert
      expect(result, false);
    });
  });

  group('getMessages', () {
    const chatId = 'chat123';
    final messagesData = [
      {
        'messageId': '1',
        'chatId': chatId,
        'senderProfileId': 'u1',
        'type': 'text',
        'text': 'hi',
        'createdAt': '2023-10-27T10:00:00Z',
        'isUploading': false,
        'receiverProfileId': 'u2',
        'fileSize': '0',
        'replyToMessageId': '',
      }
    ];

    test('should return List<Message> when successful', () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer(
        (_) async => Response(
          data: {'data': messagesData},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await chatRemoteSource.getMessages(chatId);

      // assert
      expect(result, isA<List<Message>>());
      expect(result.length, 1);
      expect(result[0].messageId, '1');
    });

    test('should return empty list when no messages', () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer(
        (_) async => Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await chatRemoteSource.getMessages(chatId);

      // assert
      expect(result, isEmpty);
    });
  });

  group('getRecentChats', () {
    const profileId = 'prof123';
    final recentChatsData = [
      {
        'chatId': 'c1',
        'profileId': 'p2',
        'isGroup': false,
        'title': 'Chat 1',
        'iconUrl': '',
        'lastMessage': 'last msg',
        'lastMessageSenderId': 'p2',
        'lastMessageAt': '2023-10-27T10:10:00Z',
        'unreadCount': 0,
      }
    ];

    test('should return List<RecentChat> when successful', () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer(
        (_) async => Response(
          data: {'data': recentChatsData},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await chatRemoteSource.getRecentChats(profileId);

      // assert
      expect(result, isA<List<RecentChat>>());
      expect(result.length, 1);
      expect(result[0].chatId, 'c1');
    });
  });

  group('Firestore operations', () {
    test('streamMessages should return stream of messages', () {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDocument = MockDocumentReference<Map<String, dynamic>>();
      final mockSubCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockQuery = MockQuery<Map<String, dynamic>>();
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('chats')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.collection('messages')).thenReturn(mockSubCollection);
      when(mockSubCollection.orderBy('createdAt')).thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockSnapshot));
      when(mockSnapshot.docs).thenReturn([]);

      final stream = chatRemoteSource.streamMessages('room1');

      expect(stream, emits(isA<List<Message>>()));
    });

    test('messagesBatchDelete should call delete for each message', () async {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDocument = MockDocumentReference<Map<String, dynamic>>();
      final mockSubCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockMsgDoc = MockDocumentReference<Map<String, dynamic>>();

      final messagesToDelete = [
        Message(
          messageId: 'm1',
          chatId: 'c1',
          senderProfileId: 's1',
          type: 'text',
          text: 'hi',
          createdAt: '2023-10-27T10:00:00Z',
          fileSize: '0',
          replyToMessageId: '',
        )
      ];

      when(mockFirestore.collection('chats')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.collection('messages')).thenReturn(mockSubCollection);
      when(mockSubCollection.doc('m1')).thenReturn(mockMsgDoc);

      await chatRemoteSource.messagesBatchDelete('room1', messagesToDelete);

      verify(mockMsgDoc.delete()).called(1);
    });

    test('streamRecentChats should return filtered stream', () {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDocument = MockDocumentReference<Map<String, dynamic>>();
      final mockSubCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockQuery = MockQuery<Map<String, dynamic>>();
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('recentChat')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.collection('items')).thenReturn(mockSubCollection);
      when(mockSubCollection.where("lastMessageAt", isNotEqualTo: ""))
          .thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockSnapshot));
      when(mockSnapshot.docs).thenReturn([]);

      final stream = chatRemoteSource.streamRecentChats('user1');

      expect(stream, emits(isA<List<RecentChat>>()));
    });
  });
}
