import 'package:flutter/material.dart';

class ContactFriendInfo extends StatelessWidget {
  final bool isAlreadyFriend;
  final bool isBlocked;
  final Function() onAddFriend;
  final Function() onBlock;

  const ContactFriendInfo({
    super.key,
    required this.isAlreadyFriend,
    required this.isBlocked,
    required this.onAddFriend,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isAlreadyFriend,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!isBlocked)
              _FriendNotAddedAction(
                onTap: onAddFriend,
                icon: Icons.add,
                title: 'Add Friend',
              ),
            _FriendNotAddedAction(
              onTap: onBlock,
              icon: Icons.block_rounded,
              title: isBlocked ? 'Unblock' : 'Block',
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendNotAddedAction extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final String title;

  const _FriendNotAddedAction({
    required this.onTap,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [Icon(icon), const SizedBox(height: 5), Text(title)],
      ),
    );
  }
}
