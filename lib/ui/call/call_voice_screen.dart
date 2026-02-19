import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/domain/model/data_call.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/call/widgets/call_action_button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CallVoiceScreen extends ConsumerStatefulWidget {
  final DataCall call;

  const CallVoiceScreen({super.key, required this.call});

  @override
  ConsumerState<CallVoiceScreen> createState() => _CallVoiceScreenState();
}

class _CallVoiceScreenState extends ConsumerState<CallVoiceScreen> {
  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  bool isMuted = false;
  bool isSpeaker = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    setupVoiceSDKEngine();
    super.initState();
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
                  widget.call.photo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.call.name,
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
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status() {
    if (!_isJoined) {
      return Text(
        AppLocalizations.of(context)!.connect_voice,
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

  Future<void> setupVoiceSDKEngine() async {
    agoraEngine = createAgoraRtcEngine();

    final appId = dotenv.env["AGORA_APP_ID"];
    await agoraEngine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await join();

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
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              leave();
            },
      ),
    );
  }

  Future<void> join() async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      autoSubscribeAudio: true,
      publishMicrophoneTrack: true,
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
    );

    await agoraEngine.joinChannel(
      token: widget.call.token,
      channelId: widget.call.chatId,
      options: options,
      uid: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void leave() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppPages.home);
    }
  }
}
