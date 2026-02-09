import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';

class GroupEditBottomSheet extends ConsumerStatefulWidget {
  const GroupEditBottomSheet({super.key});

  @override
  ConsumerState<GroupEditBottomSheet> createState() =>
      _GroupEditBottomSheetState();
}

class _GroupEditBottomSheetState extends ConsumerState<GroupEditBottomSheet> {
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
          Text(AppLocalizations.of(context)!.group_name),
          TextFormField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: context.pop,
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: const Color(0xffb3404a)),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    // ref
                    //     .watch(groupRepositoryProvider)
                    //     .updateGroupName(
                    //       widget.group.groupId!,
                    //       _textEditingController.text,
                    //     )
                    //     .then((value) async {
                    //       await _updateGroupRecentMessage(widget.group);
                    //       await _addGroupInfoMessage(widget.group.chatId!);
                    //       if (context.mounted) {
                    //         context.pop();
                    //       }
                    //     });
                  } else {
                    Flushbar(
                      message: AppLocalizations.of(context)!.fill_message,
                    ).show(context);
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: TextStyle(color: const Color(0xffb3404a)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
