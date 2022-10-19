import 'package:flutter/material.dart';

class ActionMenuItem extends StatelessWidget {
  final IconData icon;
  final Function() onTap;

  const ActionMenuItem({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}
