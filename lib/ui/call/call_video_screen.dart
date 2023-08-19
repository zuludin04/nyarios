import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/main.dart';
import 'package:permission_handler/permission_handler.dart';

class CallVideoScreen extends StatefulWidget {
  const CallVideoScreen({super.key});

  @override
  State<CallVideoScreen> createState() => _CallVideoScreenState();
}

class _CallVideoScreenState extends State<CallVideoScreen> {
  String channelName = "callTesting";
  String token =
      "007eJxTYEh917rbreJF0Lm5L45z+wtH+ibefrr3qfUvTouwztBdGpEKDAYmRpYWFuYWlkkWRiYGieZJFhamBgZGqRYGFhaWBmZGniUPUhoCGRn2HHdiZGSAQBCfmyE5MScnJLW4JDMvnYEBAEsNIes=";

  int uid = 32;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  @override
  void initState() {
    super.initState();
    setupVideoSDKEngine();
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get started with Video Calling'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _localPreview()),
          ),
          const SizedBox(height: 10),
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _remoteVideo()),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined ? null : join,
                  child: const Text("Join"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined ? leave : null,
                  child: const Text("Leave"),
                ),
              ),
            ],
          ),
          // Button Row ends
        ],
      ),
    );
  }

  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone, Permission.camera].request();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

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
    await agoraEngine.startPreview();

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
