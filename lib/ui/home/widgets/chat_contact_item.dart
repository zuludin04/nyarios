import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/contact.dart';
import '../../../data/model/profile.dart';
import '../../../routes/app_pages.dart';
import '../../../services/storage_services.dart';

class ChatContactItem extends StatelessWidget {
  final Contact contact;

  const ChatContactItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        AppRoutes.chatting,
        arguments: Profile.fromContact(contact),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    contact.photo ?? "",
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
                        contact.name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.message ?? "",
                        style: TextStyle(
                          color: StorageServices.to.darkMode
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      contact.sendDatetime ?? "",
                      style: TextStyle(
                        color: StorageServices.to.darkMode
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    ),
                    // const SizedBox(height: 4),
                    // const Icon(Icons.check, size: 16),
                  ],
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
