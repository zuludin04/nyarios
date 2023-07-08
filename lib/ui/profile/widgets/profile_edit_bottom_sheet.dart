import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/nyarios_repository.dart';
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
  final NyariosRepository _repository = NyariosRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter your name'),
          TextFormField(
            controller: _textEditingController..text = widget.initialValue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: Get.back,
                child: const Text('Cancel'),
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
                    Get.rawSnackbar(message: 'Please fill your data');
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
