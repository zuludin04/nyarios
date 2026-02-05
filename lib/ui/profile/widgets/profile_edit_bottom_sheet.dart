import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileEditBottomSheet extends StatefulWidget {
  final bool updateName;
  final String initialValue;
  final Function(String) onUpdateProfile;

  const ProfileEditBottomSheet({
    super.key,
    required this.updateName,
    required this.initialValue,
    required this.onUpdateProfile,
  });

  @override
  State<ProfileEditBottomSheet> createState() => _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState extends State<ProfileEditBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.updateName ? 'Enter Name' : 'Enter Status'),
          TextFormField(
            controller: _textEditingController..text = widget.initialValue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: context.pop,
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    widget.onUpdateProfile(_textEditingController.text);
                    context.pop();
                  } else {
                    Flushbar(message: 'Fill message').show(context);
                  }
                },
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
