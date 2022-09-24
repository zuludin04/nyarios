import 'package:flutter/material.dart';

import '../../data/chat.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  const ChatItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: chat.received! ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: chat.received! ? 16 : 75,
          right: chat.received! ? 75 : 16,
        ),
        decoration: BoxDecoration(
          color: chat.received ?? false ? Colors.white : Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: Radius.circular(chat.received! ? 0 : 10),
            bottomRight: Radius.circular(chat.received! ? 10 : 0),
          ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chat.message!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chat.time!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Visibility(
                  visible: !chat.received!,
                  child: Icon(
                    _readStatusMessage(chat.status!),
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _readStatusMessage(int status) {
    if (status == 3) {
      return Icons.done_all;
    } else if (status == 2) {
      return Icons.done;
    } else {
      return Icons.av_timer;
    }
  }
}
