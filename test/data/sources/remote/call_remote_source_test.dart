import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/sources/remote/call_remote_source.dart';
import 'package:nyarios/data/sources/remote/post/call_post.dart';
import 'package:nyarios/domain/model/call.dart';

import 'call_remote_source_test.mocks.dart';

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
  late CallRemoteSource callRemoteSource;
  late MockDio mockDio;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockDio = MockDio();
    mockFirestore = MockFirebaseFirestore();
    callRemoteSource = CallRemoteSource(dio: mockDio, firestore: mockFirestore);
  });

  group('createCall', () {
    final call = CallPost(
      callId: 'call1',
      chatId: 'chat1',
      receiverProfileId: 'rp1',
      callerProfileId: 'cp1',
      type: 'video_call',
      createdAt: '2023-10-27T10:00:00Z',
    );

    test('should return Agora Token when response successful', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'data': 'abc123'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await callRemoteSource.createCall(call);

      expect(result, 'abc123');
      verify(mockDio.post('call/create-call', data: call.toMap()));
    });

    test('should throw exception when Dio error occurs', () async {
      when(
        mockDio.post(any, data: anyNamed('data')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
        () => callRemoteSource.createCall(call),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateCallStatus', () {
    const callId = 'call1';
    const receiverProfileId = 'rp1';
    const callerProfileId = 'cp1';

    test('should return true when update is successful', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await callRemoteSource.updateCallStatus(
        callId,
        receiverProfileId,
        callerProfileId,
      );

      // assert
      expect(result, true);
      verify(mockDio.post(
        'call/update-status',
        data: {
          'callId': callId,
          'receiverProfileId': receiverProfileId,
          'callerProfileId': callerProfileId,
        },
      ));
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
      final result = await callRemoteSource.updateCallStatus(
        callId,
        receiverProfileId,
        callerProfileId,
      );

      // assert
      expect(result, false);
    });

    test('should throw Exception on Dio error', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      // act & assert
      expect(
        () => callRemoteSource.updateCallStatus(
          callId,
          receiverProfileId,
          callerProfileId,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('loadCallHistory', () {
    test('call history should return filtered stream', () {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDocument = MockDocumentReference<Map<String, dynamic>>();
      final mockSubCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockQuery = MockQuery<Map<String, dynamic>>();
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection('recentChat')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.collection('calls')).thenReturn(mockSubCollection);
      when(
        mockSubCollection.orderBy('createdAt', descending: true),
      ).thenReturn(mockQuery);
      when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockSnapshot));
      when(mockSnapshot.docs).thenReturn([]);

      final stream = callRemoteSource.loadCallHistory('userId');
      expect(stream, emits(isA<List<Call>>()));
    });
  });
}
