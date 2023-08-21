import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/main.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  late RtcEngine agoraEngine;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    _sendPort?.send('onHangUpCall');
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'hangUp') {
      _sendPort?.send('onHangUpCall');
    }
  }

  @override
  void onNotificationPressed() {}
}

class CallVideoScreen extends StatefulWidget {
  const CallVideoScreen({super.key});

  @override
  State<CallVideoScreen> createState() => _CallVideoScreenState();
}

class _CallVideoScreenState extends State<CallVideoScreen>
    with WidgetsBindingObserver {
  int tokenRole = 1;
  String serverUrl = "https://agoranyarios.up.railway.app";
  String token = "";

  Contact contact = Get.arguments;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  ReceivePort? _receivePort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      _initForegroundTask();

      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
    setupVideoSDKEngine();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    agoraEngine.leaveChannel();
    agoraEngine.release();
    _closeReceivePort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _remoteUid != null ? _remoteVideo() : _localPreview(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _remoteUid != null
                    ? SizedBox(
                        width: 140,
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _localPreview(),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
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
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Container(
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
                    onPressed: _stopForegroundTask,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.phone_disabled, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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

  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone, Permission.camera].request();

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
          _startForegroundTask();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
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
  }

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    final NotificationPermission notificationPermissionStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'agora_video_call_channel_id',
        channelName: 'Nyarios Call',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(
            id: 'hangUp',
            text: 'Hang Up',
            textColor: Colors.red,
          ),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Nyarios Call',
        notificationText: 'Video call with ${contact.profile!.name}',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    Get.back();
    return FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      if (data is String) {
        if (data == 'onHangUpCall') {
          _stopForegroundTask();
        }
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }
}
