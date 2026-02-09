import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';

class GroupMemberPickScreen extends ConsumerStatefulWidget {
  final String source;

  const GroupMemberPickScreen({super.key, required this.source});

  @override
  ConsumerState<GroupMemberPickScreen> createState() =>
      _GroupMemberPickScreenState();
}

class _GroupMemberPickScreenState extends ConsumerState<GroupMemberPickScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.pick_member,
        elevation: 0,
      ),
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.check),
        ),
      ),
      // body: FutureBuilder<List<Contact>>(
      //   future: ref.watch(contactRepositoryProvider).loadContacts(false),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Center(child: Text('something_went_wrong'.tr));
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CustomIndicator());
      //     }

      //     if (snapshot.data!.isEmpty) {
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const ImageAsset(
      //               assets: 'assets/icons/ic_profile_not_found.png',
      //               size: 80,
      //             ),
      //             Text('No Friend'),
      //           ],
      //         ),
      //       );
      //     }

      //     return Column(
      //       children: [
      //         if (widget.source == 'add')
      //           Visibility(
      //             visible: controller.selectedMembers.isNotEmpty,
      //             child: Padding(
      //               padding: const EdgeInsets.all(16),
      //               child: SizedBox(
      //                 height: 80,
      //                 child: ListView.builder(
      //                   scrollDirection: Axis.horizontal,
      //                   itemBuilder: (context, index) {
      //                     return Padding(
      //                       padding: const EdgeInsets.only(right: 12),
      //                       child: GroupMemberItem(
      //                         profile: controller.selectedMembers[index],
      //                         onRemoveMember: (profile) {
      //                           controller.addRemoveMember(true, profile);
      //                         },
      //                       ),
      //                     );
      //                   },
      //                   itemCount: controller.selectedMembers.length,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         Expanded(
      //           child: ListView.builder(
      //             itemBuilder: (context, index) =>
      //                 _profileFriendItem(snapshot.data![index].profile),
      //             itemCount: snapshot.data!.length,
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }

  Widget profileFriendItem(Profile? profile) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    profile?.photo ?? "",
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    profile?.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
