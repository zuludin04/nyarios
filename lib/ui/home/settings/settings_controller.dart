import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nyarios/core/controllers/theme/theme_controller.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/home/settings/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  StreamSubscription<Profile>? profileSub;

  @override
  FutureOr<SettingsState> build() async {
    final profileRepo = ref.read(profileRepositoryProvider);
    final themeMode = await ref.watch(themeControllerProvider.future);

    profileSub = profileRepo.loadStreamProfile().listen((profile) {
      if (state.hasValue) {
        state = AsyncData(
          state.value!.copyWith(profile: profile, themeMode: themeMode),
        );
      }
    });

    ref.onDispose(() {
      profileSub?.cancel();
    });

    return SettingsState(themeMode: themeMode);
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final theme = mode.toString().split(".")[1];
    await ref.read(themeControllerProvider.notifier).changeThemeMode(theme);
    state = AsyncData(state.value!.copyWith(themeMode: mode));
  }
}
