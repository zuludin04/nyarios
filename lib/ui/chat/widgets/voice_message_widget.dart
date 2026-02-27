import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoiceMessageWidget extends StatefulWidget {
  final String url;

  const VoiceMessageWidget({super.key, required this.url});

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  StreamSubscription? durationSub;
  StreamSubscription? positionSub;
  StreamSubscription? playerStateSub;
  StreamSubscription? completeSub;

  @override
  void initState() {
    super.initState();

    playerStateSub = player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    durationSub = player.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    positionSub = player.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });

    completeSub = player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    durationSub?.cancel();
    positionSub?.cancel();
    playerStateSub?.cancel();
    completeSub?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            if (isPlaying) {
              await player.pause();
            } else {
              await player.play(UrlSource(widget.url));
            }
          },
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
        ),
        Expanded(
          child: Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await player.seek(position);
              await player.resume();
            },
          ),
        ),
      ],
    );
  }
}
