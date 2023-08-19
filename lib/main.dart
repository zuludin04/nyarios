import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/utils/custom_theme.dart';
import 'routes/app_pages.dart';
import 'services/language_service.dart';
import 'services/storage_services.dart';

const String appId = "042988789b8240a7b885002e80889062";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = GetStorage();

  @override
  void initState() {
    bool darkMode = storage.read('DARK_MODE') ?? false;
    Get.changeThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nyarios',
      theme: CustomTheme.defaultTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: BindingsBuilder(() {
        Get.put(StorageServices());
      }),
      getPages: AppPages.pages,
      translations: LanguageService(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
