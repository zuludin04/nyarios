import 'package:get/get.dart';

import '../ui/auth/signin_screen.dart';
import '../ui/auth/signup_screen.dart';
import '../ui/chat/chatting_screen.dart';
import '../ui/home/home_screen.dart';
import '../ui/language/language_setting_screen.dart';
import '../ui/profile/profile_screen.dart';
import '../ui/settings/settings_screen.dart';
import '../ui/splash/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
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
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
    ),
  ];
}
