import 'package:flutter/material.dart';
import 'package:nyarios/core/constants.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/ui/language/widgets/language_item.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(context, 'Language'),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return LanguageItem(
            title: languages[index],
            selected: true,
            onTap: () {},
          );
        },
        itemCount: languages.length,
      ),
    );
  }
}
