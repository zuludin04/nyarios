import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/ui/contact/friend/friend_item.dart';

class ContactFriends extends StatelessWidget {
  const ContactFriends({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = ContactRepository();

    return Scaffold(
      appBar: Toolbar.defaultToolbar('contact'.tr),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.toNamed(AppRoutes.groupCreate),
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
                          "create_group".tr,
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
                    'your_friend'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Contact>>(
            future: repository.loadContacts(false),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('something_went_wrong'.tr)),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CustomIndicator()),
                );
              }

              if (snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ImageAsset(
                          assets: 'assets/icons/ic_profile_not_found.png',
                          size: 80,
                        ),
                        Text('no_friend'.tr),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Get.toNamed(AppRoutes.qrCodeProfile),
                          child: Text('add_friend'.tr),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList.builder(
                itemBuilder: (context, index) =>
                    FriendItem(contact: snapshot.data![index]),
                itemCount: snapshot.data!.length,
              );
            },
          )
        ],
      ),
    );
  }
}
