import 'package:flutter/material.dart';
import 'package:nyarios/core/constants.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/language/widgets/language_item.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  int selectedLanguage = StorageServices.to.selectedLanguage == 'en_US' ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('Language'),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return LanguageItem(
            title: languages[index],
            selected: selectedLanguage == index,
            onTap: () {
              StorageServices.to.selectedLanguage = index == 0
                  ? 'en_US'
                  : 'id_ID';
              setState(() {
                selectedLanguage = index;
              });
            },
          );
        },
        itemCount: languages.length,
      ),
    );
  }
}
