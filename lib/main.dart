import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/controllers/language/language_controller.dart';
import 'package:nyarios/core/controllers/notification/notification_action_controller.dart';
import 'package:nyarios/core/controllers/theme/theme_controller.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/core/services/notification_service.dart';
import 'package:nyarios/core/utils/custom_theme.dart';
import 'package:nyarios/core/utils/text_theme.dart';
import 'package:nyarios/core/widgets/lifecycle_listener/lifecycle_listener_wrapper.dart';
import 'package:nyarios/domain/model/data_call.dart';
import 'package:nyarios/domain/model/data_chat.dart';
import 'package:nyarios/firebase_options.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.data['type'] == 'voice_call' ||
      message.data['type'] == 'video_call') {
    await NotificationService.showCallNotification(message.data);
  } else {
    await NotificationService.showFromFCM(message.data);
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  NotificationActionController.handle(notificationResponse);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? "",
    anonKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? "",
  );

  await NotificationService.init();

  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    NotificationActionController.handle(
      NotificationResponse(
        payload: jsonEncode(initialMessage.data),
        notificationResponseType: NotificationResponseType.selectedNotification,
      ),
    );
  }

  runApp(const ProviderScope(child: LifecycleListnerWrapper(child: MyApp())));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    listenCallkitEvents(ref);

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.data['type'] == 'voice_call' ||
          message.data['type'] == 'video_call') {
        await NotificationService.showCallNotification(message.data);
      } else {
        await NotificationService.showFromFCM(message.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(languageControllerProvider);
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeControllerProvider);

    TextTheme textTheme = createTextTheme(context, "Nunito", "Nunito");
    CustomTheme theme = CustomTheme(textTheme);

    return MaterialApp.router(
      title: 'Nyarios',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: themeMode.value,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: controller.value != null ? Locale(controller.value!) : null,
      builder: (context, child) {
        return Stack(children: [child!, const NotificationListenerWidget()]);
      },
    );
  }

  void listenCallkitEvents(WidgetRef ref) {
    FlutterCallkitIncoming.onEvent.listen((event) {
      final router = ref.read(routerProvider);
      if (event?.event == Event.actionCallAccept) {
        final data = event!.body;
        final call = DataCall(
          token: data['extra']['agoraToken'],
          name: data['nameCaller'],
          chatId: data['extra']['chatId'],
          photo: data['extra']['image'],
        );
        if (data['extra']['type'] == 'voice_call') {
          router.go(AppPages.callVoice, extra: call);
        } else if (data['extra']['type'] == 'video_call') {
          router.go(AppPages.callVideo, extra: call);
        }
      }
    });
  }
}

class NotificationListenerWidget extends ConsumerWidget {
  const NotificationListenerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationActionControllerProvider, (_, next) {
      final router = ref.read(routerProvider);

      final data = jsonDecode(next.value!.payload!);
      router.go(AppPages.chatting, extra: DataChat.fromMap(data));
    });
    return const SizedBox.shrink();
  }
}
