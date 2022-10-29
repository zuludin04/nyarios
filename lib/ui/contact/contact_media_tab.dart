import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/custom_indicator.dart';
import '../../data/model/chat.dart';
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
            itemBuilder: (context, index) {
              var chat = controller.mediaChats[index];
              if (widget.type == "file") {
                return _buildDocItem(chat);
              } else {
                return _buildMediaItem(chat);
              }
            },
            itemCount: controller.mediaChats.length,
          );
        }
      },
    );
  }

  Widget _buildDocItem(Chat chat) {
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
                    chat.message ?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          chat.sendDatetime ?? 0),
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

  Widget _buildMediaItem(Chat chat) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.network(
                chat.url ?? "",
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat("dd/MM/yyyy").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        chat.sendDatetime ?? 0)),
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
