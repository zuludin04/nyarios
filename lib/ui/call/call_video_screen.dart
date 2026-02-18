import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/domain/model/data_call.dart';
import 'package:nyarios/ui/call/widgets/call_action_button.dart';

class CallVideoScreen extends ConsumerStatefulWidget {
  final DataCall call;

  const CallVideoScreen({super.key, required this.call});

  @override
  ConsumerState<CallVideoScreen> createState() => _CallVideoScreenState();
}

class _CallVideoScreenState extends ConsumerState<CallVideoScreen> {
  bool isMuted = false;
  bool isSpeaker = false;

  int? _remoteUid;
  bool _isJoined = false;
  late RtcEngine agoraEngine;

  @override
  void initState() {
    setupVideoSDKEngine();
    super.initState();
  }

  @override
  void dispose() {
    agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.call.name,
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
                          icon: isMuted
                              ? Icons.mic_off_outlined
                              : Icons.mic_none,
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
      return Center(
        child: Text(
          AppLocalizations.of(context)!.connect_video,
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
        connection: RtcConnection(channelId: widget.call.chatId),
      ),
    );
  }

  Future<void> setupVideoSDKEngine() async {
    agoraEngine = createAgoraRtcEngine();
    final appId = dotenv.env["AGORA_APP_ID"];
    await agoraEngine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await agoraEngine.enableVideo();
    join();

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
              context.pop();
            },
      ),
    );
  }

  void join() async {
    await agoraEngine.startPreview();

    ChannelMediaOptions options = const ChannelMediaOptions(
      autoSubscribeVideo: true,
      autoSubscribeAudio: true,
      publishCameraTrack: true,
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
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    context.pop();
  }
}
