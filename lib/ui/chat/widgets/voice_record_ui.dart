import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoiceRecorderUI extends StatefulWidget {
  final Function(String path) onSend;

  const VoiceRecorderUI({super.key, required this.onSend});

  @override
  State<VoiceRecorderUI> createState() => _VoiceRecorderUIState();
}

class _VoiceRecorderUIState extends State<VoiceRecorderUI> {
  bool _isRecording = false;
  late final AudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final path = '${dir.path}/$fileName.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      final fileName = p.basename(path);
      await Supabase.instance.client.storage
          .from('voice')
          .upload(
            'uploads/$fileName',
            File(path),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final publicUrl = Supabase.instance.client.storage
          .from('voice')
          .getPublicUrl('uploads/$fileName');
      widget.onSend(publicUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: _isRecording
          ? IconButton(
              icon: Icon(
                Icons.stop,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: _stopRecording,
            )
          : Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: _startRecording,
              ),
            ),
    );
  }
}
