import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/profile_remote_source.dart';
import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/profile.dart';

import 'profile_repository_test.mocks.dart';

@GenerateMocks([
  SharedLocalSource,
  ProfileRemoteSource,
  firebase_auth.User,
  FirebaseMessaging,
])
void main() {
  late ProfileRepository profileRepository;
  late MockSharedLocalSource mockLocalSource;
  late MockProfileRemoteSource mockRemoteSource;
  late MockFirebaseMessaging mockFirebaseMessaging;

  setUp(() {
    mockLocalSource = MockSharedLocalSource();
    mockRemoteSource = MockProfileRemoteSource();
    mockFirebaseMessaging = MockFirebaseMessaging();
    profileRepository = ProfileRepository(
      localSource: mockLocalSource,
      remoteSource: mockRemoteSource,
      firebaseMessaging: mockFirebaseMessaging,
    );
  });

  group('signInUser', () {
    test('should return true and save profile when successful', () async {
      final mockUser = MockUser();

      when(
        mockFirebaseMessaging.getToken(),
      ).thenAnswer((_) async => 'mock_fcm_token');

      // Stub all accessed properties on MockUser
      when(mockUser.uid).thenReturn('u1');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
      when(mockUser.email).thenReturn('test@example.com');

      when(
        mockRemoteSource.signInCredential(any, any),
      ).thenAnswer((_) async => mockUser);

      when(mockRemoteSource.saveProfile(any)).thenAnswer(
        (_) async => Profile(
          uid: mockUser.uid,
          name: mockUser.displayName,
          photo: mockUser.photoURL,
          status: 'Hey there',
          email: mockUser.email,
          visibility: true,
          fcmToken: 'mock_fcm_token',
        ),
      );

      final result = await profileRepository.signInUser(
        accessToken: 'at',
        idToken: 'it',
      );

      expect(result, true);
      verify(mockFirebaseMessaging.getToken()).called(1);
      verify(mockRemoteSource.saveProfile(any)).called(1);
      verify(mockLocalSource.setUserLocal(any)).called(1);
      verify(mockLocalSource.setAlreadyLogin(true)).called(1);
    });
  });

  group('loadSingleProfile', () {
    test('should return Profile from remote source', () async {
      final profile = Profile(uid: 'u1');
      when(mockRemoteSource.getProfile('u1')).thenAnswer((_) async => profile);

      final result = await profileRepository.loadSingleProfile('u1');

      expect(result, profile);
    });
  });

  group('setOnlineStatus', () {
    test('should call remote source changeOnlineStatus', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);

      when(
        mockRemoteSource.changeOnlineStatus('u1', true),
      ).thenAnswer((_) async => true);

      await profileRepository.setOnlineStatus(true);

      verify(mockRemoteSource.changeOnlineStatus('u1', true)).called(1);
    });
  });

  group('updateProfile', () {
    test('should call remote source updateProfile', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);

      when(
        mockRemoteSource.updateProfile('u1', 'New Name', ''),
      ).thenAnswer((_) async => true);

      await profileRepository.updateProfile('New Name', true);

      verify(mockRemoteSource.updateProfile('u1', 'New Name', '')).called(1);
    });
  });
}
