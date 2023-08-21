import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    join(token, channelName, uid);

    // Register the event handler
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

  String channelName = Get.arguments;

  int uid = 32;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  ReceivePort? _receivePort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      _initForegroundTask();

      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
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
                  onPressed: () {
                    fetchToken(uid, channelName, tokenRole);
                  },
                  child: const Text("Join"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _stopForegroundTask,
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

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.

    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
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
        channelName: 'Hallaw Client Call',
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
    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'agoraToken', value: token);
    await FlutterForegroundTask.saveData(
        key: 'agoraChannel', value: channelName);
    await FlutterForegroundTask.saveData(key: 'agoraUid', value: uid);

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Hallaw Consultation',
        notificationText: 'Consultation with partner',
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
          setState(() {
            _remoteUid = null;
          });
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

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/userAccount/${uid.toString()}';

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      // Use the token to join a channel or renew an expiring token
      _startForegroundTask(newToken);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken) async {
    token = newToken;

    // Join a channel.
    showMessage("Token received, joining a channel...");

    join(token);
  }

  void join(String token) async {
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
