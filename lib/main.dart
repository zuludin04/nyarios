import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nyarios/core/widgets/lifecycle_listener/lifecycle_listener_wrapper.dart';
import 'package:nyarios/firebase_options.dart';

import 'core/utils/custom_theme.dart';
import 'routes/app_pages.dart';
import 'services/language_service.dart';
import 'services/storage_services.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotifications(message);
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'hig_importance_channel',
    'High Important Channel',
    description: 'This channer is for important notification',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotifications(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  await GetStorage.init();

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(const ProviderScope(child: LifecycleListnerWrapper(child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = GetStorage();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    bool darkMode = storage.read('DARK_MODE') ?? false;
    Get.changeThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
    firebaseMessaging.requestPermission(provisional: true);
    FirebaseMessaging.onMessage.listen(showFlutterNotifications);
    firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        showFlutterNotifications(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("message is clicked ${message.messageId}");
    });
    loadToken();
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

  Future<void> loadToken() async {
    final token = await firebaseMessaging.getToken();
    print("token $token");
  }
}
