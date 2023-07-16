import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/routes/app_pages.dart';

class FriendItem extends StatelessWidget {
  final LastMessage lastMessage;

  const FriendItem({super.key, required this.lastMessage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.chatting, arguments: lastMessage),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    lastMessage.profile?.photo ?? "",
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastMessage.profile?.name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(lastMessage.profile?.status ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
