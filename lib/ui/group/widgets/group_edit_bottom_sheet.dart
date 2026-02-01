import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/group.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/services/storage_services.dart';

class GroupEditBottomSheet extends ConsumerStatefulWidget {
  final Group group;

  const GroupEditBottomSheet({super.key, required this.group});

  @override
  ConsumerState<GroupEditBottomSheet> createState() =>
      _GroupEditBottomSheetState();
}

class _GroupEditBottomSheetState extends ConsumerState<GroupEditBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('group_name'.tr),
          TextFormField(
            controller: _textEditingController..text = widget.group.name!,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  'cancel'.tr,
                  style: TextStyle(
                    color: StorageServices.to.darkMode
                        ? Colors.white
                        : const Color(0xffb3404a),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    ref
                        .watch(groupRepositoryProvider)
                        .updateGroupName(
                          widget.group.groupId!,
                          _textEditingController.text,
                        )
                        .then((value) async {
                          await _updateGroupRecentMessage(widget.group);
                          await _addGroupInfoMessage(widget.group.chatId!);
                          Get.back();
                        });
                  } else {
                    Get.rawSnackbar(message: 'fill_message'.tr);
                  }
                },
                child: Text(
                  'save'.tr,
                  style: TextStyle(
                    color: StorageServices.to.darkMode
                        ? Colors.white
                        : const Color(0xffb3404a),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addGroupInfoMessage(String chatId) async {
    var repo = ref.read(messageRepositoryProvider);

    Message newMessage = Message(
      message: '${StorageServices.to.userName} update group name',
      type: 'info',
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      url: '',
      fileSize: '',
      profileId: StorageServices.to.userId,
      chatId: chatId,
    );

    repo.sendNewMessage(newMessage);
  }

  Future<void> _updateGroupRecentMessage(Group group) async {
    var repo = ref.read(chatRepositoryProvider);

    var chat = Chat(
      profileId: group.groupId,
      lastMessage: '${StorageServices.to.userName} update group image',
      lastMessageSent: DateTime.now().millisecondsSinceEpoch,
      chatId: group.chatId,
      type: 'group',
    );

    await repo.updateGroupRecentChat(group, chat);
  }
}
