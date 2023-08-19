import 'package:get/get.dart';
import 'package:nyarios/ui/call/call_video_screen.dart';
import 'package:nyarios/ui/call/call_voice_screen.dart';
import 'package:nyarios/ui/chat/chatting_binding.dart';
import 'package:nyarios/ui/contact/block/contact_block_screen.dart';
import 'package:nyarios/ui/contact/friend/contact_friends_screen.dart';
import 'package:nyarios/ui/group/group_create_screen.dart';
import 'package:nyarios/ui/group/group_member_pick_screen.dart';
import 'package:nyarios/ui/qrcode/qr_code_profile_screen.dart';

import '../ui/auth/signin_screen.dart';
import '../ui/chat/chatting_screen.dart';
import '../ui/contact/contact_detail_screen.dart';
import '../ui/contact/contact_media_binding.dart';
import '../ui/home/home_screen.dart';
import '../ui/language/language_setting_screen.dart';
import '../ui/profile/profile_edit_screen.dart';
import '../ui/search/search_binding.dart';
import '../ui/search/search_screen.dart';
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
      name: AppRoutes.contactFriend,
      page: () => const ContactFriends(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.chatting,
      page: () => const ChattingScreen(),
      binding: ChattingBinding(),
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
      name: AppRoutes.profileEdit,
      page: () => const ProfileEditScreen(),
    ),
    GetPage(
      name: AppRoutes.contactDetail,
      page: () => const ContactDetailScreen(),
      binding: ContactMediaBinding(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.qrCodeProfile,
      page: () => const QrCodeProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.contactBlock,
      page: () => const ContactBlockScreen(),
    ),
    GetPage(
      name: AppRoutes.groupCreate,
      page: () => const GroupCreateScreen(),
    ),
    GetPage(
      name: AppRoutes.groupMemberPick,
      page: () => const GroupMemberPickScreen(),
    ),
    GetPage(
      name: AppRoutes.callVideo,
      page: () => const CallVideoScreen(),
    ),
    GetPage(
      name: AppRoutes.callVoice,
      page: () => const CallVoiceScreen(),
    ),
  ];
}
