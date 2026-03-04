import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/contact_remote_source.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/profile.dart';

import 'contact_repository_test.mocks.dart';

@GenerateMocks([SharedLocalSource, ContactRemoteSource])
void main() {
  late ContactRepository contactRepository;
  late MockSharedLocalSource mockLocalSource;
  late MockContactRemoteSource mockRemoteSource;

  setUp(() {
    mockLocalSource = MockSharedLocalSource();
    mockRemoteSource = MockContactRemoteSource();
    contactRepository = ContactRepository(
      localSource: mockLocalSource,
      remoteSource: mockRemoteSource,
    );
  });

  group('loadContacts', () {
    test('should return List<Profile> from remote source', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockRemoteSource.getContactByStatus('u1', 'friend'),
      ).thenAnswer((_) async => []);

      final result = await contactRepository.loadContacts('friend');

      expect(result, isA<List<Profile>>());
    });
  });

  group('changeContactStatus', () {
    test('should call remote source updateContactStatus', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);

      when(
        mockRemoteSource.updateContactStatus('u1', 'u2', 'blocked'),
      ).thenAnswer((_) async => true);

      await contactRepository.changeContactStatus('u2', 'blocked');

      verify(
        mockRemoteSource.updateContactStatus('u1', 'u2', 'blocked'),
      ).called(1);
    });
  });

  group('loadSingleContact', () {
    test('should return Contact from remote source', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      final contact = Contact(
        userId: 'u1',
        chatId: 'u2',
        status: 'friend',
        createdAt: '2023-10-27T10:00:00Z',
      );
      when(mockLocalSource.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockRemoteSource.getContactDetail('u1', 'u2'),
      ).thenAnswer((_) async => contact);

      final result = await contactRepository.loadSingleContact('u2');

      expect(result, contact);
    });
  });
}
