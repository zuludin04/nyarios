import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/friend/friend_controller.dart';

class FriendScreen extends ConsumerWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(friendControllerProvider);

    return Scaffold(
      appBar: Toolbar.defaultToolbar('Contact'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.pushNamed(AppPages.groupCreate),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: const Color(0xffb3404a),
                            child: const ImageAsset(
                              assets: 'assets/icons/ic_group_2.png',
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Create Group",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'Your Friend',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          controller.when(
            data: (List<Contact> data) {
              if (data.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ImageAsset(
                          assets: 'assets/icons/ic_profile_not_found.png',
                          size: 80,
                        ),
                        Text('No Friend'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.pushNamed(AppPages.qrCodeProfile),
                          child: Text('Add Friend'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SliverList.separated(
                  itemBuilder: (context, index) =>
                      _FriendItem(contact: data[index]),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => Divider(),
                );
              }
            },
            error: (_, _) => SliverFillRemaining(
              child: Center(child: Text('Something Went Wrong')),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CustomIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendItem extends StatelessWidget {
  final Contact contact;

  const _FriendItem({required this.contact});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed("${AppPages.chatting}/dm", extra: contact),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                contact.profile?.photo ?? "",
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.profile?.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(contact.profile?.status ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
