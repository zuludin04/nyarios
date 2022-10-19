import 'package:flutter/material.dart';

class LanguageItem extends StatelessWidget {
  final String title;
  final bool selected;
  final Function() onTap;

  const LanguageItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        Icons.check,
        color:
            selected ? Theme.of(context).iconTheme.color : Colors.transparent,
      ),
      onTap: onTap,
    );
  }
}
