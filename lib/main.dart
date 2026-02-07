import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/controllers/language/language_controller.dart';
import 'package:nyarios/core/controllers/notification/notification_action_controller.dart';
import 'package:nyarios/core/utils/custom_theme.dart';
import 'package:nyarios/core/widgets/lifecycle_listener/lifecycle_listener_wrapper.dart';
import 'package:nyarios/firebase_options.dart';
import 'package:nyarios/l10n/app_localizations.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/services/notification_service.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.showFromFCM(message.data);
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
    FirebaseMessaging.onMessage.listen((message) async {
      await NotificationService.showFromFCM(message.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(languageControllerProvider);
    final router = ref.watch(routerProvider);

    return controller.when(
      data: (data) => MaterialApp.router(
        title: 'Nyarios',
        theme: CustomTheme.defaultTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(data),
        builder: (context, child) {
          return Stack(children: [child!, const NotificationListenerWidget()]);
        },
      ),
      error: (_, _) => SizedBox(),
      loading: () => SizedBox(),
    );
  }
}

class NotificationListenerWidget extends ConsumerWidget {
  const NotificationListenerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notificationActionControllerProvider, (_, next) {
      final router = ref.read(routerProvider);
      router.go("${AppPages.callVoice}/12213412");
    });
    return const SizedBox.shrink();
  }
}
