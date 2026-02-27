import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/ui/chat/widgets/voice_message_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChatItem extends StatelessWidget {
  final Message chat;
  final Function(String) onSelectMessage;
  final bool isSelectMode;
  final String userId;

  const ChatItem({
    super.key,
    required this.chat,
    required this.onSelectMessage,
    required this.isSelectMode,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isSelectMode) {
          onSelectMessage(chat.messageId);
        }
      },
      onLongPress: () {
        onSelectMessage(chat.messageId);
      },
      child: chat.type == 'info'
          ? Align(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 1,
                      spreadRadius: 1,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    chat.text,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                Align(
                  alignment: chat.senderProfileId != userId
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: chat.senderProfileId != userId ? 16 : 75,
                      right: chat.senderProfileId != userId ? 75 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: chat.senderProfileId != userId
                          ? Colors.grey
                          : const Color(0xffb3404a),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(
                          chat.senderProfileId != userId ? 0 : 10,
                        ),
                        bottomRight: Radius.circular(
                          chat.senderProfileId != userId ? 10 : 0,
                        ),
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
                        _showChatType(chat.type),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat("hh:mm a")
                                  .format(DateTime.parse(chat.createdAt))
                                  .toLowerCase(),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: chat.isSelected,
                  child: Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: const Color(0xffb3404a).withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _showChatType(String type) {
    switch (type) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              Image.network(chat.text),
              Positioned(
                bottom: 5,
                right: 10,
                child: Text(
                  chat.fileSize,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      case 'file':
        return Container(
          decoration: BoxDecoration(
            color: chat.senderProfileId != userId
                ? Colors.black.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 24,
                center: const Icon(Icons.attach_file),
                percent: 100,
                lineWidth: 2,
                progressColor: chat.senderProfileId != userId
                    ? Colors.black
                    : Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      chat.fileSize,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 'voice':
        return VoiceMessageWidget(url: chat.text);
      default:
        return Text(
          chat.text,
          style: TextStyle(
            color: _isLink(chat.text) ? Colors.blueGrey : Colors.white,
            fontSize: 16,
            decoration: _isLink(chat.text)
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        );
    }
  }

  bool _isLink(String input) {
    final matcher = RegExp(
      r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
    );
    return matcher.hasMatch(input);
  }
}
