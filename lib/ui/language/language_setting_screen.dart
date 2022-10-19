import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants.dart';
import '../../core/widgets/toolbar.dart';
import '../../services/storage_services.dart';
import 'widgets/language_item.dart';

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
      appBar: Toolbar.defaultToolbar('language'.tr),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return LanguageItem(
            title: languages[index],
            selected: selectedLanguage == index,
            onTap: () {
              StorageServices.to.selectedLanguage =
                  index == 0 ? 'en_US' : 'id_ID';
              Get.updateLocale(
                  Locale(index == 0 ? "en" : "id", index == 0 ? "US" : "ID"));
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
