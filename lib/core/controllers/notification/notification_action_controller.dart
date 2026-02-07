import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationActionControllerProvider =
    StreamProvider<NotificationResponse>((ref) {
      final controller = StreamController<NotificationResponse>();
      NotificationActionController.onAction = controller.add;
      ref.onDispose(controller.close);
      return controller.stream;
    });

class NotificationActionController {
  static void Function(NotificationResponse)? onAction;

  static void handle(NotificationResponse response) {
    if (response.actionId == 'id_1') {
      onAction?.call(response);
    }
  }
}
