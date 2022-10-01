import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../core/toolbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(context, "Settings"),
      body: SettingsList(
        lightTheme: const SettingsThemeData(
          titleTextColor: Color.fromRGBO(251, 127, 107, 1),
        ),
        sections: [
          SettingsSection(
            title: const Text("Common"),
            tiles: [
              SettingsTile.switchTile(
                activeSwitchColor: const Color(0xfffb7f6b),
                initialValue: darkMode,
                onToggle: (value) {
                  setState(() {
                    darkMode = value;
                  });
                },
                title: const Text("Dark Mode"),
                leading: const Icon(Icons.dark_mode),
              ),
            ],
          )
        ],
      ),
    );
  }
}
