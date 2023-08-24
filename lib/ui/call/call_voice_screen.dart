import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CallVoiceScreen extends StatefulWidget {
  const CallVoiceScreen({super.key});

  @override
  State<CallVoiceScreen> createState() => _CallVoiceScreenState();
}

class _CallVoiceScreenState extends State<CallVoiceScreen> {
  int tokenRole = 1;
  String serverUrl = "https://agoranyarios.up.railway.app";
  String token = "";

  Contact contact = Get.arguments;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    setupVoiceSDKEngine();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(flex: 1),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  contact.profile!.photo!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                contact.profile!.name!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _status(),
              const Spacer(flex: 7),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 1,
                      spreadRadius: 1,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: leave,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.phone_disabled, color: Colors.white),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status() {
    if (!_isJoined) {
      return const Text(
        'Connecting voice call',
        style: TextStyle(color: Colors.white),
      );
    } else if (_remoteUid == null) {
      return LoadingAnimationWidget.waveDots(color: Colors.white, size: 40);
    } else {
      return StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: 0,
        builder: (context, snap) {
          final value = snap.data;
          final displayTime =
              StopWatchTimer.getDisplayTime(value!, milliSecond: false);
          _stopWatchTimer.onStartTimer();
          return Text(
            displayTime,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          );
        },
      );
    }
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/userAccount/${uid.toString()}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      join(newToken, channelName, uid);
    } else {
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  Future<void> setupVoiceSDKEngine() async {
    await [Permission.microphone].request();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    fetchToken(contact.profile!.id!, contact.chatId!, tokenRole);

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          Get.back();
        },
      ),
    );
  }

  void join(String token, String channelName, int uid) async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    agoraEngine.release();
    agoraEngine.leaveChannel();
    Get.back();
  }
}
