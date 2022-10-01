import 'package:flutter/material.dart';

import '../services/storage_services.dart';

class Toolbar {
  static AppBar defaultToolbar(
    BuildContext context,
    String title, {
    String subtitle = "",
    List<Widget> actions = const [],
  }) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.chevron_left),
      ),
      title: Column(
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
      actions: actions,
    );
  }
}
