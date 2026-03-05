import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/blocked/blocked_friend_controller.dart';

import 'blocked_friend_controller_test.mocks.dart';

@GenerateMocks([ContactRepository])
void main() {
  late MockContactRepository mockContactRepo;
  late ProviderContainer container;

  setUp(() {
    mockContactRepo = MockContactRepository();
    container = ProviderContainer(
      overrides: [
        contactRepositoryProvider.overrideWithValue(mockContactRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('BlockedFriendController', () {
    test('build should fetch blocked contacts from repository', () async {
      final blockedProfiles = [
        Profile(uid: '1', name: 'Blocked User 1'),
        Profile(uid: '2', name: 'Blocked User 2'),
      ];

      when(mockContactRepo.loadContacts('blocked'))
          .thenAnswer((_) async => blockedProfiles);

      final result = await container.read(blockedFriendControllerProvider.future);

      expect(result, blockedProfiles);
      verify(mockContactRepo.loadContacts('blocked')).called(1);
    });

    test('build should return empty list if no contacts are blocked', () async {
      when(mockContactRepo.loadContacts('blocked'))
          .thenAnswer((_) async => []);

      final result = await container.read(blockedFriendControllerProvider.future);

      expect(result, isEmpty);
      verify(mockContactRepo.loadContacts('blocked')).called(1);
    });
  });
}
