import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/l10n/app_localizations.dart';

class GroupEditScreen extends ConsumerStatefulWidget {
  const GroupEditScreen({super.key});

  @override
  ConsumerState<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends ConsumerState<GroupEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.edit_group,
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: StreamBuilder(
          //     stream: ref
          //         .watch(groupRepositoryProvider)
          //         .loadStreamGroup(widget.group.groupId!),
          //     builder: (context, snapshot) {
          //       return Column(
          //         children: [
          //           const SizedBox(height: 16),
          //           Center(
          //             child: ImageProfile(
          //               url: snapshot.data?.photo,
          //               onTap: () {
          //                 _pickImage(false, widget.group.name!);
          //               },
          //             ),
          //           ),
          //           const SizedBox(height: 32),
          //           InkWell(
          //             onTap: () {
          //               showBottomSheet(
          //                 context: context,
          //                 builder: (context) =>
          //                     GroupEditBottomSheet(group: widget.group),
          //               );
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(vertical: 12),
          //               child: Row(
          //                 children: [
          //                   ImageAsset(
          //                     assets: 'assets/icons/ic_group_2.png',
          //                     color: Theme.of(context).iconTheme.color!,
          //                   ),
          //                   const SizedBox(width: 16),
          //                   Expanded(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           AppLocalizations.of(context)!.name,
          //                           style: Theme.of(
          //                             context,
          //                           ).textTheme.bodySmall,
          //                         ),
          //                         Text(
          //                           snapshot.data?.name ?? "-",
          //                           style: Theme.of(
          //                             context,
          //                           ).textTheme.titleMedium,
          //                         ),
          //                         const Divider(),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ImageProfile extends StatelessWidget {
  final String? url;
  final Function() onTap;

  const ImageProfile({super.key, required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: url == null || url == "-"
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Image.network(
                      url!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: 0,
            child: ImageAsset(
              assets: 'assets/icons/ic_edit.png',
              color: Theme.of(context).iconTheme.color!,
            ),
          ),
        ],
      ),
    );
  }
}
