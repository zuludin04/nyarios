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

  Future<ThemeMode> changeThemeMode() async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final theme = await localRepo.getAppTheme();
    final currentTheme = theme == 'dark' ? 'light' : 'dark';
    await localRepo.setAppTheme(currentTheme);
    final mode = currentTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    state = AsyncData(mode);
    return mode;
  }
}
