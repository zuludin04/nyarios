import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/ui/chat/chatting_controller.dart';
import 'package:nyarios/ui/chat/widgets/chat_input_message.dart';
import 'package:nyarios/ui/chat/widgets/contact_friend_info.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../core/widgets/custom_indicator.dart';
import '../../core/widgets/toolbar.dart';
import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';
import 'widgets/chat_item.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final chatRepo = ChatRepository();

  final chattingController = Get.find<ChattingController>();

  Contact contact = Get.arguments['contact'];
  String type = Get.arguments['type'];

  List<Message> selectedChat = [];
  bool selectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        selectedChat.isEmpty
            ? type == 'dm'
                ? contact.profile?.name ?? ""
                : contact.group?.name ?? ""
            : "${selectedChat.length} ${"selected_chat".tr}",
        leading: selectedChat.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    selectedChat.clear();
                    selectionMode = false;
                  });
                },
                icon: const Icon(Icons.close),
              ),
        stream: true,
        uid: contact.profileId,
        onTapTitle: () => Get.toNamed(
          AppRoutes.contactDetail,
          arguments: contact,
        ),
        elevation: 0,
        actions: !selectionMode
            ? [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Text('view_contact'.tr),
                      ),
                      if (type != 'dm')
                        const PopupMenuItem(
                          value: 3,
                          child: Text('Add Member'),
                        ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('search'.tr),
                      ),
                      if (type == 'dm')
                        PopupMenuItem(
                          value: 2,
                          child: Text(chattingController.blocked
                              ? 'unblock'.tr
                              : 'block'.tr),
                        ),
                      if (type != 'dm')
                        const PopupMenuItem(
                          value: 4,
                          child: Text('Leave Group'),
                        ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        Get.toNamed(
                          AppRoutes.contactDetail,
                          arguments: contact,
                        );
                        break;
                      case 1:
                        Get.toNamed(
                          AppRoutes.search,
                          arguments: {
                            'type': 'chats',
                            'roomId': contact.chatId,
                            'user': type == 'dm'
                                ? contact.profile?.name ?? ""
                                : contact.group?.name ?? "",
                          },
                        );
                        break;
                      case 2:
                        chattingController.changeBlockStatus();
                        break;
                      case 3:
                        Get.toNamed(AppRoutes.groupMemberPick, arguments: {
                          'source': 'add',
                          'group': contact.group,
                        });
                        break;
                      case 4:
                        Chat chat = Chat(
                          profileId: contact.group?.groupId,
                          lastMessage:
                              '${StorageServices.to.userName} left group',
                          lastMessageSent:
                              DateTime.now().millisecondsSinceEpoch,
                          chatId: contact.chatId,
                          type: type,
                        );
                        chatRepo
                            .updateGroupRecentChat(contact.group!, chat)
                            .then((value) async {
                          contact.group!.members!
                              .remove(StorageServices.to.userId);
                          await GroupRepository().updateGroupMember(
                              contact.group!.groupId!, contact.group!.members!);
                          await chatRepo
                              .deleteGroupChat(contact.group!.groupId!);
                          Get.back();
                        });
                        break;
                    }
                  },
                )
              ]
            : _selectedChatActions(),
      ),
      body: Column(
        children: [
          GetBuilder<ChattingController>(
            builder: (controller) {
              return Visibility(
                visible: controller.upload,
                child: LinearPercentIndicator(
                  percent: double.parse(controller.uploadProgress) / 100,
                  progressColor: Colors.red,
                  padding: const EdgeInsets.all(0),
                  lineHeight: 3,
                ),
              );
            },
          ),
          const ContactFriendInfo(),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: chattingController.messageRepo
                  .loadChatMessages(contact.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('something_went_wrong'.tr));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomIndicator());
                }

                return _buildChatMessages(snapshot.data!.docs
                    .map((e) => Message.fromMap(e.data()))
                    .toList());
              },
            ),
          ),
          const ChatInputMessage(),
        ],
      ),
    );
  }

  Widget _buildChatMessages(List<Message> chats) {
    return GroupedListView<Message, DateTime>(
      physics: const BouncingScrollPhysics(),
      elements: chats,
      order: GroupedListOrder.DESC,
      reverse: true,
      floatingHeader: true,
      useStickyGroupSeparators: true,
      groupBy: (Message chat) {
        var date = DateTime.fromMillisecondsSinceEpoch(chat.sendDatetime!);
        return DateTime(date.year, date.month, date.day);
      },
      groupHeaderBuilder: _createGroupHeader,
      itemBuilder: (_, Message chat) => ChatItem(
        chat: chat,
        isSelected: selectedChat.contains(chat),
        onSelect: () {
          setState(() {
            if (selectedChat.contains(chat)) {
              selectedChat.remove(chat);
            } else {
              selectedChat.add(chat);
            }
            selectionMode = selectedChat.isNotEmpty;
          });
        },
        selectionMode: selectionMode,
        key: Key(chat.sendDatetime.toString()),
      ),
    );
  }

  Widget _createGroupHeader(Message chat) {
    return SizedBox(
      height: 40,
      child: Align(
        child: Container(
          width: 120,
          decoration: const BoxDecoration(
            color: Color(0xffb3404a),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _messageDate(chat.sendDatetime),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _selectedChatActions() {
    return [
      IconButton(
        onPressed: () {
          var messages =
              selectedChat.map((e) => _copiedMessage(e)).toList().join();
          FlutterClipboard.copy(messages).then((value) {
            Get.rawSnackbar(
                message: "${selectedChat.length} ${"messages_copied".tr}");
            setState(() {
              selectedChat.clear();
              selectionMode = false;
            });
          });
        },
        icon: const Icon(Icons.copy),
      ),
      IconButton(
        onPressed: () {
          // chatRepo
          //     .batchDelete(
          //         contact.roomId!, selectedChat, contact.profile!)
          //     .then((value) {
          //   setState(() {
          //     selectedChat.clear();
          //     selectionMode = false;
          //   });
          // });
        },
        icon: const Icon(Icons.delete),
      ),
    ];
  }

  String _messageDate(int? datetime) {
    var date = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
    var today = DateTime.now();

    if (date.day == today.day) {
      return "today".tr;
    } else if ((today.day - date.day) == 1) {
      return "yesterday".tr;
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }

  String _copiedMessage(Message chat) {
    var date = DateFormat("MM/dd, hh:mm a")
        .format(DateTime.fromMillisecondsSinceEpoch(chat.sendDatetime!));
    var user = chat.chatId == StorageServices.to.userId
        ? StorageServices.to.userName
        : type == 'dm'
            ? contact.profile?.name ?? ""
            : contact.group?.name ?? "";
    return "[$date] $user: ${chat.message}\n";
  }
}
