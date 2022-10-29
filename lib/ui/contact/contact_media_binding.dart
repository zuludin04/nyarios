import 'package:get/get.dart';

import 'contact_media_controller.dart';

class ContactMediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactMediaController());
  }
}
