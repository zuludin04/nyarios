import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/storage_services.dart';

class Toolbar {
  static AppBar defaultToolbar(
    String title, {
    String subtitle = "",
    List<Widget> actions = const [],
    Function()? onTapTitle,
    double elevation = 0.8,
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
            if (subtitle != "")
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: StorageServices.to.darkMode
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
          ],
        ),
      ),
      actions: actions,
    );
  }
}
