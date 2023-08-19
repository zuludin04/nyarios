import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/main.dart';
import 'package:permission_handler/permission_handler.dart';

class CallVoiceScreen extends StatefulWidget {
  const CallVoiceScreen({super.key});

  @override
  State<CallVoiceScreen> createState() => _CallVoiceScreenState();
}

class _CallVoiceScreenState extends State<CallVoiceScreen> {
  String channelName = "callTesting";
  String token =
      "007eJxTYEh917rbreJF0Lm5L45z+wtH+ibefrr3qfUvTouwztBdGpEKDAYmRpYWFuYWlkkWRiYGieZJFhamBgZGqRYGFhaWBmZGniUPUhoCGRn2HHdiZGSAQBCfmyE5MScnJLW4JDMvnYEBAEsNIes=";

  int uid = 12;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  @override
  void initState() {
    super.initState();
    setupVoiceSDKEngine();
  }

  @override
  void dispose() async {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get started with Voice Calling'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          SizedBox(height: 40, child: Center(child: _status())),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: join,
                  child: const Text("Join"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: leave,
                  child: const Text("Leave"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _status() {
    String statusText;

    if (!_isJoined) {
      statusText = 'Join a channel';
    } else if (_remoteUid == null) {
      statusText = 'Waiting for a remote user to join...';
    } else {
      statusText = 'Connected to remote user, uid:$_remoteUid';
    }

    return Text(statusText);
  }

  Future<void> setupVoiceSDKEngine() async {
    await [Permission.microphone].request();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  void join() async {
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
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  void showMessage(String message) {
    Get.rawSnackbar(message: message);
  }
}
