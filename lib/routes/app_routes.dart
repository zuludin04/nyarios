import 'package:go_router/go_router.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/group.dart';
import 'package:nyarios/ui/auth/signin_screen.dart';
import 'package:nyarios/ui/blocked/blocked_friend_screen.dart';
import 'package:nyarios/ui/call/call_video_screen.dart';
import 'package:nyarios/ui/call/call_voice_screen.dart';
import 'package:nyarios/ui/chat/chatting_screen.dart';
import 'package:nyarios/ui/contact/contact_detail_screen.dart';
import 'package:nyarios/ui/friend/friend_screen.dart';
import 'package:nyarios/ui/group/group_create_screen.dart';
import 'package:nyarios/ui/group/group_edit_screen.dart';
import 'package:nyarios/ui/group/group_member_pick_screen.dart';
import 'package:nyarios/ui/home/home_screen.dart';
import 'package:nyarios/ui/language/language_setting_screen.dart';
import 'package:nyarios/ui/profile/profile_edit_screen.dart';
import 'package:nyarios/ui/qrcode/qr_code_profile_screen.dart';
import 'package:nyarios/ui/search/search_screen.dart';
import 'package:nyarios/ui/splash/splash_screen.dart';
import 'package:riverpod/riverpod.dart';

part 'app_pages.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppPages.splash,
    routes: [
      GoRoute(
        path: AppPages.splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppPages.signIn,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: AppPages.contactFriend,
        builder: (context, state) => FriendScreen(),
      ),
      GoRoute(path: AppPages.home, builder: (context, state) => HomeScreen()),
      GoRoute(
        path: '${AppPages.chatting}/:type',
        builder: (context, state) {
          final String type = state.pathParameters['type'] ?? "";
          final contact = state.extra as Contact;
          return ChattingScreen(type: type, contact: contact);
        },
      ),
      GoRoute(
        path: AppPages.language,
        builder: (context, state) => LanguageSettingScreen(),
      ),
      GoRoute(
        path: AppPages.profileEdit,
        builder: (context, state) => ProfileEditScreen(),
      ),
      GoRoute(
        path: AppPages.contactDetail,
        builder: (context, state) {
          final Contact contact = state.extra as Contact;
          return ContactDetailScreen(contact: contact);
        },
      ),
      GoRoute(
        path: AppPages.search,
        builder: (context, state) {
          final String type = state.uri.queryParameters['type'] ?? "";
          final String roomId = state.uri.queryParameters['roomId'] ?? "";
          final String user = state.uri.queryParameters['user'] ?? "";
          return SearchScreen(type: type, roomId: roomId, user: user);
        },
      ),
      GoRoute(
        path: AppPages.qrCodeProfile,
        builder: (context, state) => QrCodeProfileScreen(),
      ),
      GoRoute(
        path: AppPages.contactBlock,
        builder: (context, state) => BlockedFriendScreen(),
      ),
      GoRoute(
        path: AppPages.groupCreate,
        builder: (context, state) => GroupCreateScreen(),
      ),
      GoRoute(
        path: '${AppPages.groupMemberPick}/:source',
        builder: (context, state) {
          final String source = state.pathParameters['source'] ?? "";
          final group = state.extra as Group;
          return GroupMemberPickScreen(group: group, source: source);
        },
      ),
      GoRoute(
        path: AppPages.groupEdit,
        builder: (context, state) {
          final group = state.extra as Group;
          return GroupEditScreen(group: group);
        },
      ),
      GoRoute(
        path: AppPages.callVideo,
        builder: (context, state) {
          final String token = state.pathParameters['token'] ?? "";
          final contact = state.extra as Contact;
          return CallVideoScreen(contact: contact, token: token);
        },
      ),
      GoRoute(
        path: AppPages.callVoice,
        builder: (context, state) {
          final String token = state.pathParameters['token'] ?? "";
          final contact = state.extra as Contact;
          return CallVoiceScreen(contact: contact, token: token);
        },
      ),
    ],
    redirect: (context, state) {
      return null;
    },
  );
});
