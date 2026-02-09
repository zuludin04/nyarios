import 'package:nyarios/core/constants.dart';
import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/core/services/shared_prefs_service.dart';

class SharedLocalRepository {
  final SharedPrefsService sharedPrefs;

  SharedLocalRepository({required this.sharedPrefs});

  Future<void> setDarkMode(bool value) async {
    await sharedPrefs.setBool(darkModeKey, value);
  }

  Future<bool> isDarkMode() async {
    final result = await sharedPrefs.getBool(darkModeKey);
    return result ?? false;
  }

  Future<void> setAlreadyLogin(bool value) async {
    await sharedPrefs.setBool(alreadyLoginKey, value);
  }

  Future<bool> isAlreadyLogin() async {
    final result = await sharedPrefs.getBool(alreadyLoginKey);
    return result ?? false;
  }

  Future<void> setLanguage(String value) async {
    await sharedPrefs.setString(selectedLanguageKey, value);
  }

  Future<String> gelectedLanguage() async {
    final result = await sharedPrefs.getString(selectedLanguageKey);
    return result ?? 'en';
  }

  Future<void> setUserLocal(Profile profile) async {
    await sharedPrefs.setString(userIdKey, profile.uid ?? '');
    await sharedPrefs.setString(userNameKey, profile.name ?? '');
    await sharedPrefs.setString(userImageKey, profile.photo ?? '');
    await sharedPrefs.setString(userEmailKey, profile.email ?? '');
  }

  Future<LocalUser> getUserProfile() async {
    final userId = await sharedPrefs.getString(userIdKey);
    final userName = await sharedPrefs.getString(userNameKey);
    final image = await sharedPrefs.getString(userImageKey);
    final email = await sharedPrefs.getString(userEmailKey);
    final id = await sharedPrefs.getInt(userIdIntKey);

    return LocalUser(
      userId: userId,
      userName: userName,
      email: email,
      userImage: image,
      id: id,
    );
  }
}
