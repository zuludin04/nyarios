import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/friend/friend_controller.dart';

import 'friend_controller_test.mocks.dart';

@GenerateMocks([ContactRepository])
void main() {
  late MockContactRepository mockContactRepo;
  late ProviderContainer container;

  setUp(() {
    mockContactRepo = MockContactRepository();
    container = ProviderContainer(
      overrides: [contactRepositoryProvider.overrideWithValue(mockContactRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('FriendController', () {
    test('build should fetch friends from repository', () async {
      final friends = [
        Profile(uid: '1', name: 'Friend 1'),
        Profile(uid: '2', name: 'Friend 2'),
      ];

      when(
        mockContactRepo.loadContacts('friend'),
      ).thenAnswer((_) async => friends);

      final result = await container.read(friendControllerProvider.future);

      expect(result, friends);
      verify(mockContactRepo.loadContacts('friend')).called(1);
    });

    test('build should return empty list if no friends', () async {
      when(mockContactRepo.loadContacts('friend')).thenAnswer((_) async => []);

      final result = await container.read(friendControllerProvider.future);

      expect(result, isEmpty);
      verify(mockContactRepo.loadContacts('friend')).called(1);
    });
  });
}
