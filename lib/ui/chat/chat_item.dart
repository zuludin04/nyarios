import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          color: chat.received ?? false
              ? Colors.white
              : const Color.fromRGBO(251, 127, 107, 1),
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
            _showChatType(chat.type!),
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

  Widget _showChatType(String type) {
    switch (type) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.file(File(chat.message!)),
        );
      case 'file':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 213, 116, 101),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.attach_file),
              Text(chat.message!),
            ],
          ),
        );
      default:
        return GestureDetector(
          onTap: () {
            if (_isLink(chat.message!)) {
              launchUrl(Uri(path: chat.message!));
            }
          },
          child: Text(
            chat.message!,
            style: TextStyle(
              color: _isLink(chat.message!) ? Colors.blueGrey : Colors.black54,
              fontSize: 16,
              decoration: _isLink(chat.message!)
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        );
    }
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

  bool _isLink(String input) {
    final matcher = RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }
}
