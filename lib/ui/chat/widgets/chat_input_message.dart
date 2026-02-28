import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/core/utils/helper.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatInputMessage extends StatefulWidget {
  final bool isBlocked;
  final Function({required String type, String? message, String? fileSize})
  onSendMessage;

  const ChatInputMessage({
    super.key,
    required this.isBlocked,
    required this.onSendMessage,
  });

  @override
  State<ChatInputMessage> createState() => _ChatInputMessageState();
}

class _ChatInputMessageState extends State<ChatInputMessage> {
  final _messageEditingController = TextEditingController();
  final _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isTextEmpty = true;
  Timer? _timer;
  Duration _recordingDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _messageEditingController.addListener(() {
      if (mounted) {
        setState(() {
          _isTextEmpty = _messageEditingController.text.isEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageEditingController.dispose();
    _audioRecorder.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration += const Duration(seconds: 1);
          });
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopAndSendRecording() async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      final file = File(path);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final supabase = Supabase.instance.client;

      try {
        await supabase.storage
            .from('voice')
            .upload(
              'uploads/$fileName.m4a',
              file,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        final publicUrl = supabase.storage
            .from('voice')
            .getPublicUrl('uploads/$fileName.m4a');

        final fileSize = await getFileSize(file);

        widget.onSendMessage(
          type: 'voice',
          message: publicUrl,
          fileSize: fileSize,
        );
      } catch (e) {
        debugPrint('Error uploading voice message: $e');
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBlocked) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.user_blocked,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: Colors.black12,
                ),
              ],
            ),
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: _isRecording
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Recording... ${_formatDuration(_recordingDuration)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : TextFormField(
                          controller: _messageEditingController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: AppLocalizations.of(context)!.message,
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              widget.onSendMessage(
                                type: 'text',
                                message: value,
                              );
                              _messageEditingController.clear();
                            }
                          },
                        ),
                ),
                if (!_isRecording) ...[
                  IconButton(
                    onPressed: () => _showPickerMenu(context),
                    icon: ImageAsset(
                      assets: 'assets/icons/ic_attach_file.png',
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final image = await pickImage(false);
                      if (image != null) {
                        _uploadAndSendFile(image, 'image');
                      }
                    },
                    icon: ImageAsset(
                      assets: 'assets/icons/ic_camera.png',
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        GestureDetector(
          onLongPress: _isTextEmpty ? _startRecording : null,
          onLongPressEnd: (details) {
            if (_isRecording) _stopAndSendRecording();
          },
          onTap: () {
            if (!_isTextEmpty) {
              widget.onSendMessage(
                type: 'text',
                message: _messageEditingController.text,
              );
              _messageEditingController.clear();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              _isTextEmpty ? Icons.mic : Icons.send,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showPickerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _pickFileMenu(
              context,
              AppLocalizations.of(context)!.file,
              'assets/icons/ic_attach_file.png',
            ),
            _pickFileMenu(
              context,
              AppLocalizations.of(context)!.gallery,
              'assets/icons/ic_gallery.png',
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _pickFileMenu(BuildContext context, String title, String icon) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        if (title == AppLocalizations.of(context)!.gallery) {
          final image = await pickImage(true);
          if (image != null) _uploadAndSendFile(image, 'image');
        } else {
          final file = await pickFile();
          if (file != null) _uploadAndSendFile(file, 'file');
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageAsset(
            assets: icon,
            color: Theme.of(context).iconTheme.color!,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  Future<void> _uploadAndSendFile(File file, String type) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final supabase = Supabase.instance.client;
    final bucket = type == 'image' ? 'image' : 'file';

    try {
      await supabase.storage
          .from(bucket)
          .upload(
            'uploads/$fileName.jpg',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final publicUrl = supabase.storage
          .from(bucket)
          .getPublicUrl('uploads/$fileName.jpg');
      final fileSize = await getFileSize(file);

      widget.onSendMessage(type: type, message: publicUrl, fileSize: fileSize);
    } catch (e) {
      debugPrint('Upload error: $e');
    }
  }
}
