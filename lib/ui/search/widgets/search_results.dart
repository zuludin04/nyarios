import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/widgets/chat_contact_item.dart';
import '../search_controller.dart';

class SearchResults extends StatelessWidget {
  final SearchController controller;

  const SearchResults({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.filterContact.isEmpty) {
        return const Center(
          child: Text("There are no contact"),
        );
      } else {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 85),
          itemBuilder: (context, index) => ChatContactItem(
            contact: controller.filterContact[index],
          ),
          itemCount: controller.filterContact.length,
        );
      }
    });
  }
}
