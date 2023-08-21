import 'package:get/get.dart';
import 'package:nyarios/ui/call/controller/call_chat_controller.dart';

class CallChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallChatController());
  }
}
