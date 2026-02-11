import 'package:flutter/material.dart';
import 'package:nyarios/domain/model/profile.dart';

class SettingsState {
  final Profile? profile;
  final ThemeMode themeMode;

  const SettingsState({this.profile, this.themeMode = ThemeMode.system});

  SettingsState copyWith({Profile? profile, ThemeMode? themeMode}) {
    return SettingsState(
      profile: profile ?? this.profile,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
