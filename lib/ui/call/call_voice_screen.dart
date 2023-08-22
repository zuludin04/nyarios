import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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

    final token =
        await FlutterForegroundTask.getData<String>(key: 'agoraToken');
    final channel =
        await FlutterForegroundTask.getData<String>(key: 'agoraChannel');
    final uid = await FlutterForegroundTask.getData<int>(key: 'agoraUid');
    setupVoiceSDKEngine(token!, channel!, uid!);
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    leave();
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'hangUp') {
      leave();
      FlutterForegroundTask.stopService();
    }
  }

  @override
  void onNotificationPressed() {}

  Future<void> setupVoiceSDKEngine(
      String token, String channelName, int uid) async {
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    join(token, channelName, uid);

    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _sendPort?.send('onJoinChannelSuccess');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _sendPort?.send(remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _sendPort?.send('onUserOffline');
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
  }
}

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

  ReceivePort? _receivePort;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    setupCallPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      _initForegroundTask();

      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }

      fetchToken(contact.profile!.id!, contact.chatId!, tokenRole);
    });
  }

  @override
  void dispose() async {
    _closeReceivePort();
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
                  onPressed: _stopForegroundTask,
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
        channelId: 'agora_call_channel_id',
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

  Future<bool> _startForegroundTask(String token) async {
    await FlutterForegroundTask.saveData(key: 'agoraToken', value: token);
    await FlutterForegroundTask.saveData(
        key: 'agoraChannel', value: contact.chatId!);
    await FlutterForegroundTask.saveData(
        key: 'agoraUid', value: contact.profile!.id!);

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
        notificationText: 'Voice call with ${contact.profile!.name}',
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
        if (data == 'onJoinChannelSuccess') {
          setState(() {
            _isJoined = true;
          });
        } else if (data == 'onUserOffline') {
          _stopForegroundTask();
        }
      } else if (data is int) {
        setState(() {
          _remoteUid = data;
        });
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  Future<void> setupCallPermission() async {
    await [Permission.microphone].request();
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/userAccount/${uid.toString()}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      _startForegroundTask(newToken);
    } else {
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }
}
