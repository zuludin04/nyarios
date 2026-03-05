import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/profile/profile_edit_controller.dart';

import 'profile_edit_controller_test.mocks.dart';

@GenerateMocks([ProfileRepository, SharedLocalRepository])
void main() {
  late MockProfileRepository mockProfileRepo;
  late MockSharedLocalRepository mockLocalRepo;
  late ProviderContainer container;

  setUp(() {
    mockProfileRepo = MockProfileRepository();
    mockLocalRepo = MockSharedLocalRepository();
    container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(mockProfileRepo),
        sharedLocalRepositoryProvider.overrideWithValue(mockLocalRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ProfileEditController', () {
    test('build should initialize state with profile data', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      final profile = Profile(
        uid: 'u1',
        name: 'Test User',
        status: 'Online',
        email: 'test@test.com',
        photo: 'photo_url',
      );

      when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockProfileRepo.loadSingleProfile('u1'),
      ).thenAnswer((_) async => profile);

      final state = await container.read(profileEditControllerProvider.future);

      expect(state.name, 'Test User');
      expect(state.status, 'Online');
      expect(state.email, 'test@test.com');
      expect(state.photo, 'photo_url');
    });

    test('updateProfileName should update repository and state', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      final profile = Profile(uid: 'u1', name: 'Old Name');

      when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockProfileRepo.loadSingleProfile('u1'),
      ).thenAnswer((_) async => profile);
      when(
        mockProfileRepo.updateProfile('New Name', true),
      ).thenAnswer((_) async => {});

      final controller = container.read(profileEditControllerProvider.notifier);
      await container.read(profileEditControllerProvider.future);

      await controller.updateProfileName('New Name');

      final state = container.read(profileEditControllerProvider).value;
      expect(state?.name, 'New Name');
      verify(mockProfileRepo.updateProfile('New Name', true)).called(1);
    });

    test('updateProfileStatus should update repository and state', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      final profile = Profile(uid: 'u1', status: 'Old Status');

      when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
      when(
        mockProfileRepo.loadSingleProfile('u1'),
      ).thenAnswer((_) async => profile);
      when(
        mockProfileRepo.updateProfile('New Status', false),
      ).thenAnswer((_) async => {});

      final controller = container.read(profileEditControllerProvider.notifier);
      await container.read(profileEditControllerProvider.future);

      await controller.updateProfileStatus('New Status');

      final state = container.read(profileEditControllerProvider).value;
      expect(state?.status, 'New Status');
      verify(mockProfileRepo.updateProfile('New Status', false)).called(1);
    });
  });
}
