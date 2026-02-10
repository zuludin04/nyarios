import 'package:flutter/material.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/ui/profile/widgets/profile_edit_bottom_sheet.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String data;
  final Function(String) onUpdateProfile;

  const ProfileInfoWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.data,
    required this.onUpdateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title != 'E-Mail') {
          showModalBottomSheet(
            context: context,
            builder: (context) => ProfileEditBottomSheet(
              initialValue: data,
              updateName: title == 'Name',
              onUpdateProfile: (value) {
                onUpdateProfile(value);
              },
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ImageAsset(assets: icon, color: Theme.of(context).iconTheme.color!),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodySmall),
                  Text(data, style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
