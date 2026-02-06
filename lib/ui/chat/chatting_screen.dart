import 'package:another_flushbar/flushbar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nyarios/core/utils/helper.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/l10n/app_localizations.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/chat/chatting_provider.dart';
import 'package:nyarios/ui/chat/chatting_state.dart';
import 'package:nyarios/ui/chat/widgets/chat_input_message.dart';
import 'package:nyarios/ui/chat/widgets/chat_item.dart';
import 'package:nyarios/ui/chat/widgets/contact_friend_info.dart';

class ChattingScreen extends ConsumerStatefulWidget {
  final Contact contact;
  final String type;

  const ChattingScreen({super.key, required this.contact, required this.type});

  @override
  ConsumerState<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends ConsumerState<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(
      chattingAsyncControllerProvider(
        widget.contact.chatId!,
        widget.contact.profileId!,
      ),
    );
    final controller = ref.read(
      chattingAsyncControllerProvider(
        widget.contact.chatId!,
        widget.contact.profileId!,
      ).notifier,
    );

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        "",
        titleWidget: Text(widget.contact.profile?.name ?? ""),
        leading: chatAsync.value!.isSelectMode
            ? IconButton(
                onPressed: controller.clearSelectedChat,
                icon: const Icon(Icons.close),
              )
            : IconButton(
                onPressed: context.pop,
                icon: ImageAsset(
                  assets: 'assets/icons/ic_back.png',
                  color: Theme.of(context).iconTheme.color!,
                ),
              ),
        stream: true,
        uid: widget.contact.profileId,
        onTapTitle: () =>
            context.pushNamed(AppPages.contactDetail, extra: widget.contact),
        elevation: 0,
        actions: [
          Visibility(
            visible: widget.type == 'dm',
            child: IconButton(
              onPressed: () async {
                final token = await controller.generateAgoraToken(
                  channelName: widget.contact.chatId!,
                  uid: widget.contact.profile!.id!.toString(),
                );

                if (context.mounted) {
                  context.pushNamed(
                    "${AppPages.callVideo}/$token",
                    extra: widget.contact,
                  );
                }
              },
              icon: ImageAsset(
                assets: 'assets/icons/ic_video.png',
                color: Theme.of(context).iconTheme.color!,
              ),
            ),
          ),
          Visibility(
            visible: widget.type == 'dm',
            child: IconButton(
              onPressed: () async {
                final token = await controller.generateAgoraToken(
                  channelName: widget.contact.chatId!,
                  uid: widget.contact.profile!.id!.toString(),
                );

                if (context.mounted) {
                  context.pushNamed(
                    "${AppPages.callVoice}/$token",
                    extra: widget.contact,
                  );
                }
              },
              icon: ImageAsset(
                assets: 'assets/icons/ic_call.png',
                color: Theme.of(context).iconTheme.color!,
              ),
            ),
          ),
          Visibility(
            visible: !chatAsync.value!.isSelectMode,
            child: PopupMenuButton(
              icon: ImageAsset(
                assets: 'assets/icons/ic_vert_more.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(value: 0, child: Text('View Contact')),
                  if (widget.type != 'dm')
                    PopupMenuItem(value: 3, child: Text('Add Member')),
                  PopupMenuItem(value: 1, child: Text('Search')),
                  if (widget.type == 'dm')
                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        chatAsync.value!.isBlocked ? 'Unblock' : 'Block',
                      ),
                    ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    context.pushNamed(
                      AppPages.contactDetail,
                      extra: widget.contact,
                    );
                    break;
                  case 1:
                    context.pushNamed(
                      "${AppPages.search}?type=chats&roomId=${widget.contact.chatId}&user=${widget.type == 'dm' ? widget.contact.profile?.name ?? "" : widget.contact.group?.name ?? ""}",
                    );
                    break;
                  case 2:
                    controller.blockFriend(widget.contact.profileId);
                    break;
                  case 3:
                    context.pushNamed(
                      "${AppPages.groupMemberPick}/add",
                      extra: widget.contact.group,
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
                      final name = e.chatId == chatAsync.value!.user!.userId
                          ? chatAsync.value!.user!.userName
                          : widget.type == 'dm'
                          ? widget.contact.profile?.name ?? ""
                          : widget.contact.group?.name ?? "";
                      return copiedMessage(e, name);
                    })
                    .toList()
                    .join();
                FlutterClipboard.copy(copiedMessages).then((value) {
                  if (context.mounted) {
                    Flushbar(
                      message:
                          "${copiedMessages.length} ${AppLocalizations.of(context)!.messages_copied}",
                    ).show(context);
                  }
                  controller.clearSelectedChat();
                });
              },
              icon: ImageAsset(
                assets: 'assets/icons/ic_copy.png',
                color: Theme.of(context).iconTheme.color!,
              ),
            ),
          ),
          Visibility(
            visible: chatAsync.value!.isSelectMode,
            child: IconButton(
              onPressed: () {
                controller.clearMessages(widget.contact.chatId!);
              },
              icon: ImageAsset(
                assets: 'assets/icons/ic_delete.png',
                color: Theme.of(context).iconTheme.color!,
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
                controller.addToContact(
                  widget.contact.profileId,
                  widget.contact.chatId,
                );
              },
              onBlock: () {
                controller.blockFriend(widget.contact.profileId);
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
                    userId: chatAsync.value!.user?.userId ?? "",
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) => Center(
                child: Text(AppLocalizations.of(context)!.something_wrong),
              ),
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
                    widget.contact.chatId!,
                    widget.contact.profileId!,
                    file.size,
                  );
                } else {
                  controller.sendMessage(
                    message ?? "",
                    type,
                    widget.contact.chatId!,
                    widget.contact.profileId!,
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
