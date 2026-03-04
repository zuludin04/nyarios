import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/sources/remote/profile_remote_source.dart';
import 'package:nyarios/domain/model/profile.dart';

import 'profile_remote_source_test.mocks.dart';

@GenerateMocks([
  Dio,
  FirebaseFirestore,
  FirebaseAuth,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  User,
  UserCredential,
])
void main() {
  late ProfileRemoteSource profileRemoteSource;
  late MockDio mockDio;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockDio = MockDio();
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    profileRemoteSource = ProfileRemoteSource(
      dio: mockDio,
      firestore: mockFirestore,
      auth: mockAuth,
    );
  });

  group('signInCredential', () {
    test('should return User when successful', () async {
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      when(
        mockAuth.signInWithCredential(any),
      ).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final result = await profileRemoteSource.signInCredential('at', 'it');

      expect(result, mockUser);
    });
  });

  group('saveProfile', () {
    test('should return Profile when successful', () async {
      final profile = Profile(uid: '1', name: 'Test', email: 't@t.com');
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'data': profile.toMap()},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await profileRemoteSource.saveProfile(profile);

      expect(result.uid, '1');
    });
  });

  group('getProfile', () {
    test('should return Profile when successful', () async {
      final profileData = {'uid': '1', 'name': 'Test', 'email': 't@t.com'};
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: {'data': profileData},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await profileRemoteSource.getProfile('1');

      expect(result.uid, '1');
    });
  });

  group('updateProfile', () {
    test('should return success boolean when successful', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await profileRemoteSource.updateProfile(
        '1',
        'New Name',
        'Active',
      );

      expect(result, true);
    });
  });

  group('changeOnlineStatus', () {
    test('should return success boolean when successful', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await profileRemoteSource.changeOnlineStatus('1', true);

      expect(result, true);
    });
  });

  group('Firestore operations', () {
    test('getOnlineStatus should emit visibility boolean', () {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDocument = MockDocumentReference<Map<String, dynamic>>();
      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection("profile")).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(
        mockDocument.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));
      when(mockSnapshot.data()).thenReturn({
        'profileId': '1',
        'visibility': true,
        'name': 'Test',
        'email': 't@t.com',
      });

      final stream = profileRemoteSource.getOnlineStatus('1');

      expect(stream, emits(true));
    });

    test('loadStreamProfile should emit Profile objects', () {
      final mockCollection = MockCollectionReference<Map<String, dynamic>>();
      final mockDocument = MockDocumentReference<Map<String, dynamic>>();
      final mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      when(mockFirestore.collection("profile")).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(
        mockDocument.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));
      when(
        mockSnapshot.data(),
      ).thenReturn({'profileId': '1', 'name': 'Test', 'email': 't@t.com'});

      final stream = profileRemoteSource.loadStreamProfile('1');

      expect(stream, emits(isA<Profile>()));
    });
  });
}
