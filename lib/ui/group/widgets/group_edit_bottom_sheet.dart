import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class GroupEditBottomSheet extends StatefulWidget {
  final String initialValue;
  final String groupId;

  const GroupEditBottomSheet({
    super.key,
    required this.initialValue,
    required this.groupId,
  });

  @override
  State<GroupEditBottomSheet> createState() => _GroupEditBottomSheetState();
}

class _GroupEditBottomSheetState extends State<GroupEditBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();
  final GroupRepository _repository = GroupRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('group_name'.tr),
          TextFormField(
            controller: _textEditingController..text = widget.initialValue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  'cancel'.tr,
                  style: TextStyle(
                    color: StorageServices.to.darkMode
                        ? Colors.white
                        : const Color(0xffb3404a),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    _repository.updateGroupName(
                      widget.groupId,
                      _textEditingController.text,
                    );
                    Get.back();
                  } else {
                    Get.rawSnackbar(message: 'fill_message'.tr);
                  }
                },
                child: Text(
                  'save'.tr,
                  style: TextStyle(
                    color: StorageServices.to.darkMode
                        ? Colors.white
                        : const Color(0xffb3404a),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}