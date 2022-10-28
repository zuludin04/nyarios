import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../data/model/chat.dart';
import '../../../services/storage_services.dart';
import '../../home/widgets/chat_contact_item.dart';
import '../search_controller.dart';

class SearchResults extends StatelessWidget {
  final SearchController controller;

  const SearchResults({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filterContact.isEmpty && controller.filterChat.isEmpty) {
        return Center(
          child: Text(controller.type == 'contacts'
              ? "There are no contact"
              : "There are no chat"),
        );
      } else {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 85),
          itemBuilder: (context, index) {
            if (controller.type == 'contacts') {
              return ChatContactItem(contact: controller.filterContact[index]);
            } else {
              return _chatSearchItem(
                controller.filterChat[index],
                controller.term,
              );
            }
          },
          itemCount: controller.type == 'contacts'
              ? controller.filterContact.length
              : controller.filterChat.length,
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
                  ? 'You'
                  : controller.user),
              Text(_contactLastChat(chat.sendDatetime)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SubstringHighlight(
              text: chat.message!,
              term: term,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  String _contactLastChat(int? datetime) {
    var date = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
    var today = DateTime.now();

    if (date.day == today.day) {
      return DateFormat("hh:mm a").format(date).toLowerCase();
    } else if ((today.day - date.day) == 1) {
      return "Yesterday";
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }
}
