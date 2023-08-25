import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';

import '../../../services/storage_services.dart';

class ProfileEditBottomSheet extends StatefulWidget {
  final bool updateName;
  final String initialValue;

  const ProfileEditBottomSheet({
    super.key,
    required this.updateName,
    required this.initialValue,
  });

  @override
  State<ProfileEditBottomSheet> createState() => _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState extends State<ProfileEditBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();
  final ProfileRepository _repository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.updateName ? 'enter_name'.tr : 'enter_status'.tr),
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
                    _repository.updateProfile(
                      StorageServices.to.userId,
                      _textEditingController.text,
                      widget.updateName,
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
