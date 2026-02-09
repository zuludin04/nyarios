import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/group/widgets/group_member_item.dart';

class GroupCreateScreen extends ConsumerStatefulWidget {
  const GroupCreateScreen({super.key});

  @override
  ConsumerState<GroupCreateScreen> createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends ConsumerState<GroupCreateScreen> {
  final _groupTitleController = TextEditingController();
  File? _imageFile;
  List<Profile> members = [];

  @override
  void dispose() {
    _groupTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.create_group,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _imageFile == null
                        ? Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/group.png'),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              _imageFile!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _groupTitleController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.group_name,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.member,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () async {
                        var result = await context.pushNamed(
                          "${AppPages.groupMemberPick}/create",
                        );
                        if (result != null) {
                          if (result is Profile) {
                            members.add(result);
                            setState(() {});
                          }
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black38),
                            ),
                            child: const Icon(Icons.add, color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.add_member,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return GroupMemberItem(
                      profile: members[index - 1],
                      onRemoveMember: (profile) {
                        members.remove(profile);
                        setState(() {});
                      },
                    );
                  }
                },
                itemCount: members.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: ImageAsset(
          assets: 'assets/icons/ic_done.png',
          color: Theme.of(context).iconTheme.color!,
        ),
      ),
    );
  }
}
