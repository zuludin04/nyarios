import 'package:flutter/material.dart';
import 'package:nyarios/core/toolbar.dart';

import '../../core/constants.dart';
import 'chat_item.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        "Zulfikar Mauludin",
        subtitle: "Online",
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('View Contact'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => ChatItem(chat: chatDemo[index]),
              itemCount: chatDemo.length,
            ),
          ),
        ],
      ),
    );
  }
}
