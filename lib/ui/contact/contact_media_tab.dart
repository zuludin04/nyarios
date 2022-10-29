import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/custom_indicator.dart';
import 'contact_media_controller.dart';

class ContactMediaTab extends StatefulWidget {
  final String type;

  const ContactMediaTab({super.key, required this.type});

  @override
  State<ContactMediaTab> createState() => _ContactMediaTabState();
}

class _ContactMediaTabState extends State<ContactMediaTab>
    with AutomaticKeepAliveClientMixin {
  final ContactMediaController controller = Get.find();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    controller.loadChats(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ContactMediaController>(
      id: widget.type,
      builder: (controller) {
        if (controller.loading) {
          return const Center(child: CustomIndicator());
        } else if (controller.loading) {
          return const Center(child: Text("Empty Media"));
        } else {
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text(controller.mediaChats[index].message ?? ""),
            ),
            itemCount: controller.mediaChats.length,
          );
        }
      },
    );
  }
}
