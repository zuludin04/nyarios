import 'package:get/get.dart';
import 'package:nyarios/ui/chat/chatting_controller.dart';

class ChattingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChattingController());
  }
}
