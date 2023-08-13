import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/data/model/message.dart';

import '../../core/widgets/custom_indicator.dart';
import '../../core/widgets/empty_widget.dart';
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
        } else if (controller.empty) {
          return Center(child: EmptyWidget(message: 'empty_media'.tr));
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              var message = controller.mediaMessages[index];
              if (widget.type == "file") {
                return _buildDocItem(message);
              } else {
                return _buildMediaItem(message);
              }
            },
            itemCount: controller.mediaMessages.length,
          );
        }
      },
    );
  }

  Widget _buildDocItem(Message message) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.attach_file),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          message.sendDatetime ?? 0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildMediaItem(Message message) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.network(
                message.url ?? "",
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat("dd/MM/yyyy").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        message.sendDatetime ?? 0)),
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
