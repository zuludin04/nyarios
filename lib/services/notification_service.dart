import 'dart:convert';

import 'package:flutter/material.dart';
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
    actions: [
      AndroidNotificationAction(
        'id_1',
        'Accept',
        titleColor: Colors.green,
        icon: DrawableResourceAndroidBitmap('call_accept'),
        contextual: true,
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        'id_2',
        'Reject',
        titleColor: Color.fromARGB(255, 255, 0, 0),
        icon: DrawableResourceAndroidBitmap('call_reject'),
        contextual: true,
        showsUserInterface: true,
      ),
    ],
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
    await show(title: data['title'], body: data['body'], payload: data);
  }
}
