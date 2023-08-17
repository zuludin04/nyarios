import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/ui/chat/chatting_controller.dart';

class ContactFriendInfo extends StatelessWidget {
  const ContactFriendInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChattingController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.alreadyAdded && controller.type == 'dm',
          child: Container(
            color: Get.theme.colorScheme.background,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!controller.blocked)
                  _friendNotAddedAction(
                    controller.addChatToContact,
                    Icons.add,
                    'add_friend'.tr,
                  ),
                _friendNotAddedAction(
                  controller.changeBlockStatus,
                  Icons.block_rounded,
                  controller.blocked ? 'unblock'.tr : 'block'.tr,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _friendNotAddedAction(Function() onTap, IconData icon, String title) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}
