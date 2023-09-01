import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/core/widgets/bottom_navigation.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/data/model/call.dart';
import 'package:nyarios/data/model/notification.dart' as notif;
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/home/home_controller.dart';
import 'package:nyarios/ui/home/nav/call_history_navigation.dart';
import 'package:nyarios/ui/home/nav/recent_chat_navigation.dart';
import 'package:nyarios/ui/home/nav/settings_navigation.dart';

import '../../routes/app_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> notifStream;

  @override
  void initState() {
    super.initState();
    listenFirebaseNotification();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text(
              'Nyarios',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed(
                  AppRoutes.search,
                  arguments: {'type': 'lastMessage', 'roomId': '', 'user': ''},
                ),
                icon: ImageAsset(
                  assets: 'assets/icons/ic_search.png',
                  color: Get.theme.iconTheme.color!,
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.contactFriend),
            child: const ImageAsset(assets: 'assets/icons/ic_new_message.png'),
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex: controller.selectedIndex,
            navMenus: [
              NavMenu(label: 'Chat', icon: 'ic_chat'),
              NavMenu(label: 'Call', icon: 'ic_call_history'),
              NavMenu(label: 'Settings', icon: 'ic_settings'),
            ],
            onSelectedMenu: controller.changeNavIndex,
          ),
          body: IndexedStack(
            index: controller.selectedIndex,
            children: const [
              RecentChatNavigation(),
              CallHistoryNavigation(),
              SettingsNavigation(),
            ],
          ),
        );
      },
    );
  }

  void listenFirebaseNotification() {
    notifStream = FirebaseFirestore.instance
        .collection('notification')
        .doc(StorageServices.to.userId)
        .snapshots();

    notifStream.listen((event) {
      if (event.exists) {
        var notification = notif.Notification.fromMap(event.data()!);
        showCallNotification(notification);
      }
    });
  }

  void showCallNotification(notif.Notification notification) {
    Flushbar(
      boxShadows: [
        BoxShadow(
          color: Colors.grey.shade400,
          blurRadius: 1,
          spreadRadius: 1,
          offset: const Offset(1, 1),
          blurStyle: BlurStyle.outer,
        ),
      ],
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.all(16),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      messageText: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffb3404a),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: ImageAsset(
                  assets: notification.type == 'video_call'
                      ? 'assets/icons/ic_video.png'
                      : 'assets/icons/ic_call.png',
                  size: 18,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          notification.callerName!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat("HH:mm a").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                notification.callingTime!),
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    Text(notification.type == 'video_call'
                        ? 'Incoming video call'
                        : 'Incoming voice call'),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  notification.callerImage!,
                  width: 34,
                  height: 34,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: Get.back,
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    saveCallHistory(
                        notification.callId!, notification.callerUid!);
                    FirebaseFirestore.instance
                        .collection('notification')
                        .doc(StorageServices.to.userId)
                        .delete();
                    Get.back();
                  },
                  child: const Text(
                    'Answer',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      duration: const Duration(seconds: 100),
    ).show(context);
  }

  void saveCallHistory(String callId, String profileId) async {
    var callRepo = CallRepository();

    var call = Call(
        callDate: DateTime.now().millisecondsSinceEpoch,
        callId: callId,
        profileId: profileId,
        status: 'incoming_call',
        type: 'voice_call',
        isAccepted: true);

    callRepo.saveCallHistory(StorageServices.to.userId, call);
  }
}
