import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageServices extends GetxService {
  static StorageServices get to => Get.find();

  final GetStorage _storage = GetStorage();

  bool get darkMode => _storage.read('DARK_MODE') ?? false;
  set darkMode(bool value) {
    _storage.write('DARK_MODE', value);
  }

  // String get selectedLanguage => _storage.read('SELECTED_LANGUAGE') ?? 'en_US';
  // set selectedLanguage(String value) {
  //   _storage.write('SELECTED_LANGUAGE', value);
  // }
}
