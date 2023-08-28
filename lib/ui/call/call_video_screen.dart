import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/main.dart';
import 'package:nyarios/ui/call/widgets/call_action_button.dart';
import 'package:permission_handler/permission_handler.dart';

class CallVideoScreen extends StatefulWidget {
  const CallVideoScreen({super.key});

  @override
  State<CallVideoScreen> createState() => _CallVideoScreenState();
}

class _CallVideoScreenState extends State<CallVideoScreen> {
  int tokenRole = 1;
  String serverUrl = "https://agoranyarios.up.railway.app";
  String token = "";

  Contact contact = Get.arguments;

  bool isMuted = false;
  bool isSpeaker = false;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  @override
  void initState() {
    super.initState();
    handleVideoCallPermission();
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _remoteUid != null ? _remoteVideo() : _localPreview(),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _remoteUid != null
                        ? Container(
                            width: 140,
                            height: 180,
                            margin: const EdgeInsets.only(right: 32),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _localPreview(),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(right: 32),
                            padding: const EdgeInsets.all(16),
                            width: 120,
                            height: 160,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    color: Colors.black26,
                                  ),
                                ]),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    contact.profile!.photo!,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  contact.profile!.name!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CallActionButton(
                          icon:
                              isMuted ? Icons.mic_off_outlined : Icons.mic_none,
                          color: Colors.white,
                          iconColor: Colors.black,
                          onPressed: () {
                            setState(() {
                              isMuted = !isMuted;
                            });
                            agoraEngine.muteLocalAudioStream(isMuted);
                          },
                        ),
                        CallActionButton(
                          icon: Icons.phone_disabled,
                          color: Colors.red.shade800,
                          iconColor: Colors.white,
                          onPressed: leave,
                        ),
                        CallActionButton(
                          icon: isSpeaker
                              ? Icons.volume_up_outlined
                              : Icons.volume_off,
                          color: Colors.white,
                          iconColor: Colors.black,
                          onPressed: () {
                            setState(() {
                              isSpeaker = !isSpeaker;
                            });
                            agoraEngine.setEnableSpeakerphone(isSpeaker);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      return const Center(
        child: Text(
          'Connecting video call',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _remoteVideo() {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: agoraEngine,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: RtcConnection(channelId: contact.chatId!),
      ),
    );
  }

  Future<void> handleVideoCallPermission() async {
    await [Permission.microphone, Permission.camera].request();

    if (await Permission.microphone.isDenied) {
      Get.back();
      Get.rawSnackbar(message: 'Need microphone permission to make a call');
    } else if (await Permission.camera.isDenied) {
      Get.back();
      Get.rawSnackbar(message: 'Need camera permission to make a video call');
    } else {
      setupVideoSDKEngine();
    }
  }

  Future<void> setupVideoSDKEngine() async {
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();
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

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/userAccount/${uid.toString()}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      setToken(newToken);
    } else {
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken) async {
    token = newToken;
    join(token);
  }

  void join(String token) async {
    await agoraEngine.startPreview();

    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: contact.chatId!,
      options: options,
      uid: contact.profile!.id!,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    Get.back();
  }
}
