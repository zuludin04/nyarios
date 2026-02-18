import 'package:another_flushbar/flushbar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/core/utils/helper.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/data_call.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/chat/chatting_provider.dart';
import 'package:nyarios/ui/chat/chatting_state.dart';
import 'package:nyarios/ui/chat/widgets/chat_input_message.dart';
import 'package:nyarios/ui/chat/widgets/chat_item.dart';
import 'package:nyarios/ui/chat/widgets/contact_friend_info.dart';

class ChattingScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String profileId;
  final String userName;

  const ChattingScreen({
    super.key,
    required this.chatId,
    required this.profileId,
    required this.userName,
  });

  @override
  ConsumerState<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends ConsumerState<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(
      chattingAsyncControllerProvider(widget.chatId, widget.profileId),
    );
    final controller = ref.read(
      chattingAsyncControllerProvider(widget.chatId, widget.profileId).notifier,
    );

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        "",
        titleWidget: Text(widget.userName),
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
        onTapTitle: () => context.pushNamed(
          AppPages.contactDetail,
          queryParameters: {
            'chatId': widget.chatId,
            'userId': widget.profileId,
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              final token = await controller.createCallConversation(
                channelName: widget.chatId,
                type: 'video_call',
                receiverUserId: widget.profileId,
              );

              if (context.mounted) {
                context.pushNamed(
                  AppPages.callVideo,
                  extra: DataCall(
                    token: token,
                    name: widget.userName,
                    chatId: widget.chatId,
                  ),
                );
              }
            },
            icon: ImageAsset(
              assets: 'assets/icons/ic_video.png',
              color: Theme.of(context).iconTheme.color!,
            ),
          ),
          IconButton(
            onPressed: () async {
              final token = await controller.createCallConversation(
                channelName: widget.chatId,
                type: 'voice_call',
                receiverUserId: widget.profileId,
              );

              if (context.mounted) {
                context.pushNamed(
                  AppPages.callVoice,
                  extra: DataCall(
                    token: token,
                    name: widget.userName,
                    chatId: widget.chatId,
                  ),
                );
              }
            },
            icon: ImageAsset(
              assets: 'assets/icons/ic_call.png',
              color: Theme.of(context).iconTheme.color!,
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
                  PopupMenuItem(value: 1, child: Text('Search')),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      chatAsync.value!.status == 'blocked'
                          ? 'Unblock'
                          : 'Block',
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    context.pushNamed(
                      AppPages.contactDetail,
                      queryParameters: {
                        'chatId': widget.chatId,
                        'userId': widget.profileId,
                      },
                    );
                    break;
                  case 1:
                    context.pushNamed(
                      AppPages.search,
                      queryParameters: {
                        'type': 'chat',
                        'roomId': widget.chatId,
                        'username': widget.userName,
                        'userId': widget.profileId,
                      },
                    );
                    break;
                  case 2:
                    final status = chatAsync.value!.status == 'blocked'
                        ? 'pending'
                        : 'blocked';
                    controller.changeContactStatus(widget.profileId, status);
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
                      final name = controller.getNameCopy(
                        e.senderProfileId,
                        widget.userName,
                      );
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
                controller.clearMessages(widget.chatId);
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
            data: (ChattingState data) {
              return ContactFriendInfo(
                isAlreadyFriend: data.status == 'friend',
                isBlocked: data.status == 'blocked',
                onAddFriend: () {
                  controller.changeContactStatus(widget.profileId, 'friend');
                },
                onBlock: () {
                  controller.changeContactStatus(
                    widget.profileId,
                    data.status != 'blocked' ? 'blocked' : 'pending',
                  );
                },
              );
            },
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
                    var date = DateTime.parse(chat.createdAt);
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
                              messageDate(chat.createdAt),
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
                    key: Key(chat.createdAt),
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
              isBlocked: data.status == 'blocked',
              onSendMessage: ({required type, message}) {
                controller.sendMessage(
                  message ?? "",
                  type,
                  widget.chatId,
                  widget.profileId,
                );
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
