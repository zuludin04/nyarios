import 'package:go_router/go_router.dart';
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
        name: AppPages.contactFriend,
        builder: (context, state) => FriendScreen(),
      ),
      GoRoute(path: AppPages.home, builder: (context, state) => HomeScreen()),
      GoRoute(
        path: AppPages.chatting,
        name: AppPages.chatting,
        builder: (context, state) {
          final String chatId = state.uri.queryParameters["chatId"] ?? "";
          final String profileId = state.uri.queryParameters["profileId"] ?? "";
          final String username = state.uri.queryParameters["username"] ?? "";
          return ChattingScreen(
            chatId: chatId,
            profileId: profileId,
            userName: username,
          );
        },
      ),
      GoRoute(
        path: AppPages.language,
        name: AppPages.language,
        builder: (context, state) => LanguageSettingScreen(),
      ),
      GoRoute(
        path: AppPages.profileEdit,
        name: AppPages.profileEdit,
        builder: (context, state) => ProfileEditScreen(),
      ),
      GoRoute(
        path: AppPages.contactDetail,
        name: AppPages.contactDetail,
        builder: (context, state) {
          final String chatId = state.uri.queryParameters['chatId'] ?? '';
          final String userId = state.uri.queryParameters['userId'] ?? '';
          return ContactDetailScreen(chatId: chatId, userId: userId);
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
        name: AppPages.qrCodeProfile,
        builder: (context, state) => QrCodeProfileScreen(),
      ),
      GoRoute(
        path: AppPages.contactBlock,
        name: AppPages.contactBlock,
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
          return GroupMemberPickScreen(source: source);
        },
      ),
      GoRoute(
        path: AppPages.groupEdit,
        builder: (context, state) {
          return GroupEditScreen();
        },
      ),
      GoRoute(
        path: AppPages.callVideo,
        name: AppPages.callVideo,
        builder: (context, state) {
          final String token = state.uri.queryParameters['token'] ?? "";
          final String username = state.uri.queryParameters['username'] ?? "";
          final String chatId = state.uri.queryParameters['chatId'] ?? "";
          return CallVideoScreen(
            token: token,
            username: username,
            chatId: chatId,
          );
        },
      ),
      GoRoute(
        path: AppPages.callVoice,
        name: AppPages.callVoice,
        builder: (context, state) {
          final String token = state.uri.queryParameters['token'] ?? "";
          final String username = state.uri.queryParameters['username'] ?? "";
          final String chatId = state.uri.queryParameters['chatId'] ?? "";
          return CallVoiceScreen(
            token: token,
            username: username,
            chatId: chatId,
          );
        },
      ),
    ],
    redirect: (context, state) {
      return null;
    },
  );
});
