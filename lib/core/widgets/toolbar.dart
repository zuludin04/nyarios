import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/widgets/image_asset.dart';

class Toolbar {
  static AppBar defaultToolbar(
    BuildContext context,
    String title, {
    String subtitle = "",
    List<Widget> actions = const [],
    Function()? onTapTitle,
    double elevation = 0.8,
    bool stream = false,
    Widget? leading,
    Widget? titleWidget,
  }) {
    return AppBar(
      leading:
          leading ??
          IconButton(
            onPressed: context.pop,
            icon: ImageAsset(
              assets: 'assets/icons/ic_back.png',
              color: Theme.of(context).iconTheme.color!,
            ),
          ),
      elevation: elevation,
      title: InkWell(
        onTap: onTapTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget ?? Text(title),
            _buildSubtitleWidget(context, stream, subtitle),
          ],
        ),
      ),
      actions: actions,
    );
  }

  static Widget _buildSubtitleWidget(
    BuildContext context,
    bool stream,
    String subtitle,
  ) {
    if (stream) {
      // return StreamBuilder(
      //   stream: ProfileRepository().getOnlineStatus(uid),
      //   builder: (context, snapshot) {
      //     bool online = snapshot.data?.data()?["visibility"] ?? false;
      //     return Visibility(
      //       visible:
      //           snapshot.connectionState == ConnectionState.active && online,
      //       child: Text(
      //         online ? "Online" : "Offline",
      //         style: TextStyle(
      //           fontSize: 14,
      //           color: StorageServices.to.darkMode
      //               ? Colors.white70
      //               : Colors.black54,
      //         ),
      //       ),
      //     );
      //   },
      // );
      return Visibility(
        visible: false,
        child: Text(
          "Offline",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      );
    } else {
      return Visibility(
        visible: subtitle != "",
        child: Text(subtitle, style: Theme.of(context).textTheme.displayMedium),
      );
    }
  }
}
