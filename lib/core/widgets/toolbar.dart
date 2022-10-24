import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/data/nyarios_repository.dart';

import '../../services/storage_services.dart';

class Toolbar {
  static AppBar defaultToolbar(
    String title, {
    String subtitle = "",
    List<Widget> actions = const [],
    Function()? onTapTitle,
    double elevation = 0.8,
    bool stream = false,
    String? uid = "",
  }) {
    return AppBar(
      leading: IconButton(
        onPressed: Get.back,
        icon: const Icon(Icons.chevron_left),
      ),
      elevation: elevation,
      title: InkWell(
        onTap: onTapTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            _buildSubtitleWidget(stream, subtitle, uid),
          ],
        ),
      ),
      actions: actions,
    );
  }

  static Widget _buildSubtitleWidget(
    bool stream,
    String subtitle,
    String? uid,
  ) {
    if (stream) {
      return StreamBuilder(
        stream: NyariosRepository().getOnlineStatus(uid),
        builder: (context, snapshot) {
          String status = snapshot.data?.data()?["visibility"] ?? "";
          return Visibility(
            visible: snapshot.connectionState == ConnectionState.active && status == "Online",
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                color: StorageServices.to.darkMode
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
          );
        },
      );
    } else {
      return Visibility(
        visible: subtitle != "",
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color:
                StorageServices.to.darkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      );
    }
  }
}
