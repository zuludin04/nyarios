import 'package:get/get.dart';
import 'package:nyarios/ui/group/controllers/group_member_pick_controller.dart';

class GroupMemberPickBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupMemberPickController());
  }
}
