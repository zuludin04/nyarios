import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/core/widgets/empty_widget.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/ui/home/recent_chat/recent_chat_item.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchResultBody extends StatelessWidget {
  final List<Chat> chatResult;
  final List<Message> messageResult;
  final String typeResult;
  final String searchTerm;
  final String user;
  final String userId;

  const SearchResultBody({
    super.key,
    required this.chatResult,
    required this.messageResult,
    required this.typeResult,
    this.searchTerm = "",
    this.user = "",
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    if (chatResult.isEmpty && messageResult.isEmpty) {
      return Center(
        child: EmptyWidget(
          message: typeResult == 'lastMessage' ? "Empty Contact" : "Empty Chat",
          asset: 'assets/icons/ic_empty_search.png',
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 48),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 85),
              itemBuilder: (context, index) {
                if (typeResult == 'lastMessage') {
                  return LastMessageItem(lastMessage: chatResult[index]);
                } else {
                  return _ChatSearchItem(
                    chat: messageResult[index],
                    term: searchTerm,
                    user: user,
                    userId: userId,
                  );
                }
              },
              itemCount: typeResult == 'lastMessage'
                  ? chatResult.length
                  : messageResult.length,
            ),
          ),
        ],
      );
    }
  }
}

class _ChatSearchItem extends StatelessWidget {
  final Message chat;
  final String term;
  final String user;
  final String userId;

  const _ChatSearchItem({
    required this.chat,
    required this.term,
    required this.user,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(chat.profileId == userId ? 'You' : user),
              Text(_lastMessageDate(chat.sendDatetime)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SubstringHighlight(
              text: chat.message!,
              term: term,
              textStyle: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  String _lastMessageDate(int? datetime) {
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
