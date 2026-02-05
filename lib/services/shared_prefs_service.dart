import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  SharedPreferences? _prefs;

  final Completer<SharedPreferences> initCompleter = Completer();

  void init() {
    initCompleter.complete(SharedPreferences.getInstance());
  }

  bool get hasInitialized => _prefs != null;

  Future<String?> getString(String key) async {
    _prefs = await initCompleter.future;
    return _prefs!.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    _prefs = await initCompleter.future;
    return _prefs!.setString(key, value);
  }

  Future<bool?> getBool(String key) async {
    _prefs = await initCompleter.future;
    return _prefs!.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    _prefs = await initCompleter.future;
    return _prefs!.setBool(key, value);
  }

  Future<int?> getInt(String key) async {
    _prefs = await initCompleter.future;
    return _prefs!.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    _prefs = await initCompleter.future;
    return _prefs!.setInt(key, value);
  }

  Future<bool> has(String key) async {
    _prefs = await initCompleter.future;
    return _prefs!.containsKey(key);
  }

  Future<bool> remove(String key) async {
    _prefs = await initCompleter.future;
    return _prefs!.remove(key);
  }
}
