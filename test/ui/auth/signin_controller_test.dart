import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/auth/signin_controller.dart';

import 'signin_controller_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockProfileRepo;
  late ProviderContainer container;

  setUp(() {
    mockProfileRepo = MockProfileRepository();
    container = ProviderContainer(
      overrides: [profileRepositoryProvider.overrideWithValue(mockProfileRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SignInController', () {
    test('initial state should be SignInState', () async {
      final state = await container.read(signInControllerProvider.future);
      expect(state.isLoading, false);
      expect(state.successLogin, false);
    });

    test('signIn should update state on success', () async {
      when(
        mockProfileRepo.signInUser(
          accessToken: anyNamed('accessToken'),
          idToken: anyNamed('idToken'),
        ),
      ).thenAnswer((_) async => true);

      final controller = container.read(signInControllerProvider.notifier);
      await controller.signIn('at', 'it');

      final state = container.read(signInControllerProvider).value;
      expect(state?.isLoading, false);
      expect(state?.successLogin, true);
    });

    test('signIn should update state on failure', () async {
      when(
        mockProfileRepo.signInUser(
          accessToken: anyNamed('accessToken'),
          idToken: anyNamed('idToken'),
        ),
      ).thenAnswer((_) async => false);

      final controller = container.read(signInControllerProvider.notifier);
      await controller.signIn('at', 'it');

      final state = container.read(signInControllerProvider).value;
      expect(state?.isLoading, false);
      expect(state?.successLogin, false);
      expect(state?.message, "An error occurred");
    });
  });
}
