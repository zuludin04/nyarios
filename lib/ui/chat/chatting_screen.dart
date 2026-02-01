import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nyarios/core/utils/helper.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/chat/chatting_provider.dart';
import 'package:nyarios/ui/chat/chatting_state.dart';
import 'package:nyarios/ui/chat/widgets/chat_input_message.dart';
import 'package:nyarios/ui/chat/widgets/chat_item.dart';
import 'package:nyarios/ui/chat/widgets/contact_friend_info.dart';

class ChattingScreen extends ConsumerStatefulWidget {
  const ChattingScreen({super.key});

  @override
  ConsumerState<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends ConsumerState<ChattingScreen> {
  Contact contact = Get.arguments['contact'];
  String type = Get.arguments['type'];

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(
      chattingAsyncControllerProvider(contact.chatId!, contact.profileId!),
    );
    final controller = ref.read(
      chattingAsyncControllerProvider(
        contact.chatId!,
        contact.profileId!,
      ).notifier,
    );

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        "",
        titleWidget: Text(contact.profile?.name ?? ""),
        leading: chatAsync.value!.isSelectMode
            ? IconButton(
                onPressed: controller.clearSelectedChat,
                icon: const Icon(Icons.close),
              )
            : IconButton(
                onPressed: Get.back,
                icon: ImageAsset(
                  assets: 'assets/icons/ic_back.png',
                  color: Get.theme.iconTheme.color!,
                ),
              ),
        stream: true,
        uid: contact.profileId,
        onTapTitle: () =>
            Get.toNamed(AppRoutes.contactDetail, arguments: contact),
        elevation: 0,
        actions: [
          Visibility(
            visible: type == 'dm',
            child: IconButton(
              onPressed: () {},
              icon: ImageAsset(
                assets: 'assets/icons/ic_video.png',
                color: Get.theme.iconTheme.color!,
              ),
            ),
          ),
          Visibility(
            visible: type == 'dm',
            child: IconButton(
              onPressed: () {},
              icon: ImageAsset(
                assets: 'assets/icons/ic_call.png',
                color: Get.theme.iconTheme.color!,
              ),
            ),
          ),
          Visibility(
            visible: !chatAsync.value!.isSelectMode,
            child: PopupMenuButton(
              icon: ImageAsset(
                assets: 'assets/icons/ic_vert_more.png',
                color: Get.theme.iconTheme.color!,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(value: 0, child: Text('view_contact'.tr)),
                  if (type != 'dm')
                    PopupMenuItem(value: 3, child: Text('add_member'.tr)),
                  PopupMenuItem(value: 1, child: Text('search'.tr)),
                  if (type == 'dm')
                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        chatAsync.value!.isBlocked ? 'unblock'.tr : 'block'.tr,
                      ),
                    ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    Get.toNamed(AppRoutes.contactDetail, arguments: contact);
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
                    controller.blockFriend(contact.profileId);
                    break;
                  case 3:
                    Get.toNamed(
                      AppRoutes.groupMemberPick,
                      arguments: {'source': 'add', 'group': contact.group},
                    );
                    break;
                }
              },
            ),
          ),
          Visibility(
            visible: chatAsync.value!.isSelectMode,
            child: IconButton(
              onPressed: () {
                final messages = chatAsync.value!.messages
                    .where((e) => e.isSelected)
                    .toList();
                final copiedMessages = messages
                    .map((e) {
                      final name = e.chatId == StorageServices.to.userId
                          ? StorageServices.to.userName
                          : type == 'dm'
                          ? contact.profile?.name ?? ""
                          : contact.group?.name ?? "";
                      return copiedMessage(e, name);
                    })
                    .toList()
                    .join();
                FlutterClipboard.copy(copiedMessages).then((value) {
                  Get.rawSnackbar(
                    message: "${copiedMessages.length} ${"messages_copied".tr}",
                  );
                  controller.clearSelectedChat();
                });
              },
              icon: ImageAsset(
                assets: 'assets/icons/ic_copy.png',
                color: Get.theme.iconTheme.color!,
              ),
            ),
          ),
          Visibility(
            visible: chatAsync.value!.isSelectMode,
            child: IconButton(
              onPressed: () {
                controller.clearMessages(contact.chatId!);
              },
              icon: ImageAsset(
                assets: 'assets/icons/ic_delete.png',
                color: Get.theme.iconTheme.color!,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          chatAsync.when(
            data: (ChattingState data) => ContactFriendInfo(
              isAlreadyFriend: data.isAlreadyFriend,
              isBlocked: data.isBlocked,
              onAddFriend: () {
                controller.addToContact(contact.profileId, contact.chatId);
              },
              onBlock: () {
                controller.blockFriend(contact.profileId);
              },
            ),
            error: (_, _) => SizedBox(),
            loading: () => SizedBox(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: chatAsync.when(
              data: (ChattingState data) {
                return GroupedListView<Message, DateTime>(
                  physics: const BouncingScrollPhysics(),
                  elements: data.messages,
                  reverse: false,
                  floatingHeader: true,
                  useStickyGroupSeparators: true,
                  groupBy: (Message chat) {
                    var date = DateTime.fromMillisecondsSinceEpoch(
                      chat.sendDatetime!,
                    );
                    return DateTime(date.year, date.month, date.day);
                  },
                  groupHeaderBuilder: (Message chat) {
                    return SizedBox(
                      height: 40,
                      child: Align(
                        child: Container(
                          width: 120,
                          decoration: const BoxDecoration(
                            color: Color(0xffb3404a),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              messageDate(chat.sendDatetime),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemBuilder: (_, Message chat) => ChatItem(
                    chat: chat,
                    key: Key(chat.sendDatetime.toString()),
                    progress: data.uploadProgress[chat.messageId],
                    onSelectMessage: (messageId) =>
                        controller.selectMessage(messageId),
                    isSelectMode: data.isSelectMode,
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) =>
                  Center(child: Text('something_went_wrong'.tr)),
              loading: () => const Center(child: CustomIndicator()),
            ),
          ),
          chatAsync.when(
            data: (ChattingState data) => ChatInputMessage(
              isBlocked: data.isBlocked,
              onSendMessage: ({required type, message, file}) {
                if (type != 'text') {
                  controller.uploadFile(
                    file!.file,
                    'nyarios/files',
                    file.path.split("/").last,
                    contact.chatId!,
                    contact.profileId!,
                    file.size,
                  );
                } else {
                  controller.sendMessage(
                    message ?? "",
                    type,
                    contact.chatId!,
                    contact.profileId!,
                  );
                }
              },
            ),
            error: (_, _) => SizedBox(),
            loading: () => SizedBox(),
          ),
        ],
      ),
    );
  }
}
