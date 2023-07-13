import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../data/model/chat.dart';
import '../../../services/storage_services.dart';
import '../../home/widgets/last_message_item.dart';
import '../nyarios_search_controller.dart';

class SearchResults extends StatelessWidget {
  final NyariosSearchController controller;

  const SearchResults({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filterLastMessage.isEmpty && controller.filterChat.isEmpty) {
        return Center(
          child: Text(controller.type == 'lastMessage'
              ? "empty_contact".tr
              : "empty_chat".tr),
        );
      } else {
        return Column(
          children: [
            const SizedBox(height: 48),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 85),
                itemBuilder: (context, index) {
                  if (controller.type == 'lastMessage') {
                    return LastMessageItem(
                        lastMessage: controller.filterLastMessage[index]);
                  } else {
                    return _chatSearchItem(
                      controller.filterChat[index],
                      controller.term,
                    );
                  }
                },
                itemCount: controller.type == 'lastMessage'
                    ? controller.filterLastMessage.length
                    : controller.filterChat.length,
              ),
            ),
          ],
        );
      }
    });
  }

  Widget _chatSearchItem(Chat chat, String term) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(chat.senderId == StorageServices.to.userId
                  ? 'you'.tr
                  : controller.user),
              Text(_lastMessageDate(chat.sendDatetime)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SubstringHighlight(
              text: chat.message!,
              term: term,
              textStyle: TextStyle(
                color: Get.theme.colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  String _lastMessageDate(int? datetime) {
    var date = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
    var today = DateTime.now();

    if (date.day == today.day) {
      return DateFormat("hh:mm a").format(date).toLowerCase();
    } else if ((today.day - date.day) == 1) {
      return "yesterday".tr;
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }
}
