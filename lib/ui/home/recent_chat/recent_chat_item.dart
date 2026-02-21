import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/domain/model/data_chat.dart';
import 'package:nyarios/domain/model/recent_chat.dart';
import 'package:nyarios/routes/app_routes.dart';

class LastMessageItem extends ConsumerWidget {
  final RecentChat recentChat;

  const LastMessageItem({super.key, required this.recentChat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppPages.chatting,
        extra: DataChat(
          chatId: recentChat.chatId,
          profileId: recentChat.profileId,
          username: recentChat.title,
          photo: recentChat.iconUrl,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                recentChat.iconUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recentChat.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recentChat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_lastMessageDate(context, recentChat.lastMessageAt)),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _lastMessageDate(BuildContext context, String datetime) {
    var date = DateTime.parse(datetime);
    var today = DateTime.now();

    if (date.day == today.day) {
      return DateFormat("hh:mm a").format(date).toLowerCase();
    } else if ((today.day - date.day) == 1) {
      return AppLocalizations.of(context)!.yesterday;
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }
}
