import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyarios/core/controllers/theme/theme_controller.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/home/settings/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsProvider extends _$SettingsProvider {
  StreamSubscription<Profile>? profileSub;

  @override
  FutureOr<SettingsState> build() async {
    final profileRepo = ref.watch(profileRepositoryProvider);
    final themeController = ref.watch(themeControllerProvider);

    state = const AsyncData(SettingsState());

    profileSub = profileRepo.loadStreamProfile().listen((profile) {
      final current = state.value!;
      state = AsyncData(
        current.copyWith(profile: profile, themeMode: themeController.value),
      );
    });

    ref.onDispose(() {
      profileSub?.cancel();
    });

    return const SettingsState();
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final theme = mode.toString().split(".")[1];
    await ref.read(themeControllerProvider.notifier).changeThemeMode(theme);
    state = AsyncData(state.value!.copyWith(themeMode: mode));
  }
}
