import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';

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
    Widget? leading,
    Widget? titleWidget,
  }) {
    return AppBar(
      leading: leading ??
          IconButton(
            onPressed: Get.back,
            icon: ImageAsset(
              assets: 'assets/icons/ic_back.png',
              color: Get.theme.iconTheme.color!,
            ),
          ),
      elevation: elevation,
      title: InkWell(
        onTap: onTapTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget ?? Text(title),
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
        stream: ProfileRepository().getOnlineStatus(uid),
        builder: (context, snapshot) {
          bool online = snapshot.data?.data()?["visibility"] ?? false;
          return Visibility(
            visible:
                snapshot.connectionState == ConnectionState.active && online,
            child: Text(
              online ? "Online" : "Offline",
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
