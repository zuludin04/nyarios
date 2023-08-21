import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CallChatController extends GetxController {
  String token = '';
  bool loadToken = true;

  String channelName = Get.arguments['channel'];
  int userId = Get.arguments['userId'];

  @override
  void onInit() {
    loadAgoraToken();
    super.onInit();
  }

  Future<void> loadAgoraToken() async {
    loadToken = true;
    update();

    var serverUrl = 'https://agoranyarios.up.railway.app';
    String url = '$serverUrl/rtc/$channelName/publisher/userAccount/$userId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      token = newToken;
      loadToken = false;

      update();
    } else {
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }
}
