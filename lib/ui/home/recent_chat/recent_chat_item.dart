import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/l10n/app_localizations.dart';

class LastMessageItem extends ConsumerWidget {
  final Chat lastMessage;

  const LastMessageItem({super.key, required this.lastMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(40),
            //   child: Image.network(
            //     lastMessage.profile?.photo ?? "",
            //     width: 40,
            //     height: 40,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("", maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_lastMessageDate(context, 0)),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _lastMessageDate(BuildContext context, int? datetime) {
    var date = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
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
