import 'package:flutter/material.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_controller.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  @override
  Future<ThemeMode> build() async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final theme = await localRepo.getAppTheme();
    if (theme == 'light') {
      return ThemeMode.light;
    } else if (theme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  Future<void> changeThemeMode(String mode) async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    await localRepo.setAppTheme(mode);
    late ThemeMode themeMode;

    if (mode == 'light') {
      themeMode = ThemeMode.light;
    } else if (mode == 'dark') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.system;
    }

    state = AsyncData(themeMode);
  }
}
