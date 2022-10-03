import 'dart:ui';

import 'package:get/get.dart';

import '../core/utils/language.dart';
import 'storage_services.dart';

class LanguageService extends Translations {
  static Locale get deviceLocale =>
      StorageServices.to.selectedLanguage == 'en_US'
          ? const Locale('en', 'US')
          : const Locale('id', 'ID');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'id_ID': idID,
      };
}
