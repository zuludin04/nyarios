import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageServices extends GetxService {
  static StorageServices get to => Get.find();

  final GetStorage _storage = GetStorage();

  bool get darkMode => _storage.read('DARK_MODE') ?? false;
  set darkMode(bool value) {
    _storage.write('DARK_MODE', value);
  }

  String get selectedLanguage => _storage.read('SELECTED_LANGUAGE') ?? 'en_US';
  set selectedLanguage(String value) {
    _storage.write('SELECTED_LANGUAGE', value);
  }

  String get userId => _storage.read('USER_ID') ?? '106829103416030296046';
  set userId(String value) {
    _storage.write('USER_ID', value);
  }

  String get userName => _storage.read('USER_NAME') ?? 'Dorky 004';
  set userName(String value) {
    _storage.write('USER_NAME', value);
  }

  String get userImage =>
      _storage.read('USER_IMAGE') ??
      'https://lh3.googleusercontent.com/a/ALm5wu3qsh6QWRPkuciJob84N9ivMIxzxc8AnieaPcX4=s96-c';
  set userImage(String value) {
    _storage.write('USER_IMAGE', value);
  }

  bool get alreadyLogin => _storage.read('ALREADY_LOGIN') ?? false;
  set alreadyLogin(bool value) {
    _storage.write('ALREADY_LOGIN', value);
  }
}
