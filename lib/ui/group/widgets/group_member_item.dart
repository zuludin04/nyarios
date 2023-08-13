import 'package:flutter/material.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/services/storage_services.dart';

class GroupMemberItem extends StatelessWidget {
  final Profile profile;
  final Function(Profile) onRemoveMember;

  const GroupMemberItem({
    super.key,
    required this.profile,
    required this.onRemoveMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                profile.photo!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            Visibility(
              visible: profile.uid != StorageServices.to.userId,
              child: Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () => onRemoveMember(profile),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          profile.name!,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
