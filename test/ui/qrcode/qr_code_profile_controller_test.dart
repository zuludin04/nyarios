import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/qrcode/qr_code_profile_controller.dart';

import 'qr_code_profile_controller_test.mocks.dart';

@GenerateMocks([ProfileRepository, SharedLocalRepository, ChatRepository])
void main() {
  late MockProfileRepository mockProfileRepo;
  late MockSharedLocalRepository mockLocalRepo;
  late MockChatRepository mockChatRepo;
  late ProviderContainer container;

  setUp(() {
    mockProfileRepo = MockProfileRepository();
    mockLocalRepo = MockSharedLocalRepository();
    mockChatRepo = MockChatRepository();
    container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(mockProfileRepo),
        sharedLocalRepositoryProvider.overrideWithValue(mockLocalRepo),
        chatRepositoryProvider.overrideWithValue(mockChatRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('QrCodeProfileController', () {
    test('build should initialize state with current user ID', () async {
      final user = LocalUser(
        id: 1,
        userId: 'u1',
        userName: 'User 1',
        email: 'email1',
        userImage: 'image1',
      );
      when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);

      final state = await container.read(
        qrCodeProfileControllerProvider.future,
      );

      expect(state.userId, 'u1');
    });

    test(
      'loadProfile should update state with profile and showProfileDialog',
      () async {
        final user = LocalUser(
          id: 1,
          userId: 'u1',
          userName: 'User 1',
          email: 'email1',
          userImage: 'image1',
        );
        when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);

        final profile = Profile(uid: 'p2', name: 'Friend');
        when(
          mockProfileRepo.loadSingleProfile('p2'),
        ).thenAnswer((_) async => profile);

        final controller = container.read(
          qrCodeProfileControllerProvider.notifier,
        );
        await container.read(qrCodeProfileControllerProvider.future);

        await controller.loadProfile('p2');

        final state = container.read(qrCodeProfileControllerProvider).value;

        expect(state?.profile?.uid, 'p2');
        expect(state?.showProfileDialog, true);
      },
    );

    test(
      'saveChatRoom should update state with chatId and successLoadContact',
      () async {
        final user = LocalUser(
          id: 1,
          userId: 'u1',
          userName: 'User 1',
          email: 'email1',
          userImage: 'image1',
        );
        when(mockLocalRepo.getUserProfile()).thenAnswer((_) async => user);
        when(
          mockChatRepo.createChatRoom(any, any),
        ).thenAnswer((_) async => 'c1');

        final controller = container.read(
          qrCodeProfileControllerProvider.notifier,
        );
        await container.read(qrCodeProfileControllerProvider.future);

        await controller.saveChatRoom('p2');

        final state = container.read(qrCodeProfileControllerProvider).value;

        expect(state?.chatId, 'c1');
        expect(state?.showProfileDialog, false);
        expect(state?.successLoadContact, true);
      },
    );
  });
}
