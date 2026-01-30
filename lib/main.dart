import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nyarios/core/widgets/lifecycle_listener/lifecycle_listener_wrapper.dart';
import 'package:nyarios/firebase_options.dart';

import 'core/utils/custom_theme.dart';
import 'routes/app_pages.dart';
import 'services/language_service.dart';
import 'services/storage_services.dart';

const String appId = "042988789b8240a7b885002e80889062";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  runApp(const ProviderScope(child: LifecycleListnerWrapper(child: MyApp())));
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
      debugShowCheckedModeBanner: false,
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
