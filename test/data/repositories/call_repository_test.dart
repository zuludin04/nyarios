import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/call_remote_source.dart';
import 'package:nyarios/domain/model/call.dart';
import 'package:nyarios/domain/model/local_user.dart';

import 'call_repository_test.mocks.dart';

@GenerateMocks([SharedLocalSource, CallRemoteSource])
void main() {
  late CallRepository callRepository;
  late MockSharedLocalSource mockLocalSource;
  late MockCallRemoteSource mockRemoteSource;

  setUp(() {
    mockLocalSource = MockSharedLocalSource();
    mockRemoteSource = MockCallRemoteSource();
    callRepository = CallRepository(
      localSource: mockLocalSource,
      remoteSource: mockRemoteSource,
    );
  });

  group('createCall', () {
    test('should call remote source with correct CallPost', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockRemoteSource.createCall(any),
      ).thenAnswer((_) async => 'token123');

      final result = await callRepository.createCall('video_call', 'r1', 'c1');

      expect(result, 'token123');
      verify(mockRemoteSource.createCall(any)).called(1);
    });
  });

  group('updateCallStatus', () {
    test('should call remote source updateCallStatus', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      
      // Stub the local source
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);
      
      // Stub the remote source method being called
      when(mockRemoteSource.updateCallStatus(any, any, any))
          .thenAnswer((_) async => true);

      await callRepository.updateCallStatus('call1', 'caller1');

      verify(
        mockRemoteSource.updateCallStatus('call1', user.userId!, 'caller1'),
      ).called(1);
    });
  });

  group('streamCallHistories', () {
    test('should return stream from remote source', () {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockRemoteSource.loadCallHistory('u1'),
      ).thenAnswer((_) => Stream.value([]));

      final stream = callRepository.streamCallHistories();

      expect(stream, emits(isA<List<Call>>()));
    });
  });
}
