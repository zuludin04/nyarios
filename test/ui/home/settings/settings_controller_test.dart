import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/home/settings/settings_controller.dart';

import 'settings_controller_test.mocks.dart';

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

  group('SettingsProvider', () {
    test(
      'build should initialize state and listen to profile stream',
      () async {
        final profile = Profile(uid: 'u1', name: 'Test User');
        when(
          mockProfileRepo.loadStreamProfile(),
        ).thenAnswer((_) => Stream.value(profile));

        // Control ThemeController through SharedLocalRepository
        when(mockLocalRepo.getAppTheme()).thenAnswer((_) async => 'light');

        // Use listen to keep provider alive
        final subscription = container.listen(
          settingsControllerProvider,
          (prev, next) {},
        );

        await container.read(settingsControllerProvider.future);
        await Future.delayed(Duration.zero);

        final state = container.read(settingsControllerProvider).value;

        expect(state?.profile, profile);
        expect(state?.themeMode, ThemeMode.light);

        subscription.close();
      },
    );

    test('changeTheme should update theme controller and state', () async {
      final profile = Profile(uid: 'u1', name: 'Test User');
      when(
        mockProfileRepo.loadStreamProfile(),
      ).thenAnswer((_) => Stream.value(profile));
      when(mockLocalRepo.getAppTheme()).thenAnswer((_) async => 'light');
      when(mockLocalRepo.setAppTheme(any)).thenAnswer((_) async => {});

      final controller = container.read(settingsControllerProvider.notifier);
      await container.read(settingsControllerProvider.future);

      await controller.changeTheme(ThemeMode.dark);

      final state = container.read(settingsControllerProvider).value;
      expect(state?.themeMode, ThemeMode.dark);
      verify(mockLocalRepo.setAppTheme('dark')).called(1);
    });
  });
}
