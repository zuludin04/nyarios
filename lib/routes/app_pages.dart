import 'package:get/get.dart';

import '../ui/chat/chatting_screen.dart';
import '../ui/home/home_screen.dart';
import '../ui/language/language_setting_screen.dart';
import '../ui/settings/settings_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.home;

  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.chatting,
      page: () => const ChattingScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguageSettingScreen(),
    ),
  ];
}
