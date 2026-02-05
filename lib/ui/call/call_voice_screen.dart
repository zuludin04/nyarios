import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/ui/call/widgets/call_action_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CallVoiceScreen extends ConsumerStatefulWidget {
  final String token;
  final Contact contact;

  const CallVoiceScreen({
    super.key,
    required this.contact,
    required this.token,
  });

  @override
  ConsumerState<CallVoiceScreen> createState() => _CallVoiceScreenState();
}

class _CallVoiceScreenState extends ConsumerState<CallVoiceScreen> {
  int? _remoteUid;
  bool _isJoined = false;
  RtcEngine? agoraEngine;

  bool isMuted = false;
  bool isSpeaker = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    handleCallPermission();
  }

  @override
  void dispose() async {
    if (agoraEngine != null) {
      agoraEngine?.leaveChannel();
      agoraEngine?.release();
    }
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
                  widget.contact.profile!.photo!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.contact.profile!.name!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _status(),
              const Spacer(flex: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CallActionButton(
                    icon: isMuted ? Icons.mic_off_outlined : Icons.mic_none,
                    color: Colors.white,
                    iconColor: Colors.black,
                    onPressed: () {
                      setState(() {
                        isMuted = !isMuted;
                      });
                      agoraEngine?.muteLocalAudioStream(isMuted);
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
                      agoraEngine?.setEnableSpeakerphone(isSpeaker);
                    },
                  ),
                ],
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
          final displayTime = StopWatchTimer.getDisplayTime(
            value!,
            milliSecond: false,
          );
          _stopWatchTimer.onStartTimer();
          return Text(
            displayTime,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          );
        },
      );
    }
  }

  Future<void> handleCallPermission() async {
    await [Permission.microphone].request();

    if (await Permission.microphone.isDenied) {
      if (mounted) {
        context.pop();
        Flushbar(
          message: 'Need microphone permission to make a call',
        ).show(context);
      }
    } else {
      setupVoiceSDKEngine();
    }
  }

  Future<void> setupVoiceSDKEngine() async {
    await [Permission.microphone].request();

    agoraEngine = createAgoraRtcEngine();

    final appId = dotenv.env["AGORA_APP_ID"];
    await agoraEngine?.initialize(RtcEngineContext(appId: appId));

    join(widget.token, widget.contact.chatId!, widget.contact.profile!.id!);

    agoraEngine?.registerEventHandler(
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
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              context.pop();
            },
      ),
    );
  }

  void join(String token, String channelName, int uid) async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine?.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    agoraEngine?.leaveChannel();
    agoraEngine?.release();
    context.pop();
  }
}
