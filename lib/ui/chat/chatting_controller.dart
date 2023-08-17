import 'package:get/get.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';

class ChattingController extends GetxController {
  var contactRepo = ContactRepository();

  Contact contact = Get.arguments['contact'];

  bool blocked = false;
  bool alreadyAdded = true;

  @override
  void onInit() {
    loadFriendBlockStatus();
    super.onInit();
  }

  void loadFriendBlockStatus() async {
    var contact = await contactRepo.loadSingleContact(this.contact.profileId);
    blocked = contact?.blocked ?? false;
    alreadyAdded = contact?.alreadyFriend ?? false;
    update();
  }

  void addChatToContact() async {
    var contact = Contact(
      profileId: this.contact.profileId,
      chatId: this.contact.chatId,
      blocked: blocked,
      alreadyFriend: true,
    );
    await contactRepo.saveContact(contact, this.contact.profileId!);
    alreadyAdded = !alreadyAdded;
    update();
  }

  void changeBlockStatus() async {
    blocked = !blocked;
    await contactRepo.changeBlockStatus(contact.profileId, blocked);
    update();
  }
}
