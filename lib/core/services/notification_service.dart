import 'dart:convert';

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nyarios/core/controllers/notification/notification_action_controller.dart';
import 'package:nyarios/main.dart';

class NotificationService {
  static const channel = AndroidNotificationChannel(
    'hig_importance_channel',
    'High Important Channel',
    description: 'This channer is for important notification',
    importance: Importance.high,
  );

  static AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    groupAlertBehavior: GroupAlertBehavior.all,
    setAsGroupSummary: false,
  );

  static NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    await notificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: initializationSettingsAndroid,
      ),
      onDidReceiveBackgroundNotificationResponse:
          NotificationActionController.handle,
      onDidReceiveNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> show({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    await notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(payload),
    );
  }

  static Future<void> showFromFCM(Map<String, dynamic> data) async {
    await show(
      title: data['name'],
      body: "There are new message",
      payload: data,
    );
  }

  static Future<void> showCallNotification(Map<String, dynamic> data) async {
    await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams(
        id: 'call_i1',
        nameCaller: data['name'],
        avatar: data['image'],
        appName: 'Nyarios',
        handle: 'Incoming Call',
        type: data['type'] == 'voice_call' ? 0 : 1,
        duration: 300000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        extra: data,
        missedCallNotification: NotificationParams(
          showNotification: true,
          isShowCallback: true,
          subtitle: 'Missed call',
          callbackText: 'Call back',
        ),
        callingNotification: const NotificationParams(
          showNotification: true,
          isShowCallback: true,
          subtitle: 'Calling...',
          callbackText: 'Hang Up',
        ),
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          actionColor: '#4CAF50',
          textColor: '#ffffff',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call",
          isShowCallID: false,
        ),
      ),
    );
  }
}
