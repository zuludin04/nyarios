import 'package:get/get.dart';

import '../../data/model/contact.dart';
import '../../data/nyarios_repository.dart';

class SearchController extends GetxController {
  final repository = NyariosRepository();

  var filterContact = <Contact>[].obs;
  var contacts = <Contact>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadContacts();
  }

  void searchContact(String term) {
    if (term.isNotEmpty) {
      var filter = contacts
          .where((element) =>
              element.name!.toLowerCase().contains(term.toLowerCase()))
          .toList();
      print("search result ${filter.length}");
      filterContact.value = filter;
    } else {
      filterContact.value = contacts;
    }
  }

  void loadContacts() async {
    var contacts = await repository.loadContacts();
    filterContact.value = contacts;
    this.contacts.value = contacts;
  }
}
