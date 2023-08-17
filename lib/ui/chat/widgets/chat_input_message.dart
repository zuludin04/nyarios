import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyarios/ui/chat/chatting_controller.dart';

class ChatInputMessage extends StatefulWidget {
  const ChatInputMessage({super.key});

  @override
  State<ChatInputMessage> createState() => _ChatInputMessageState();
}

class _ChatInputMessageState extends State<ChatInputMessage> {
  final _messageEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChattingController>(
      builder: (controller) {
        return controller.blocked
            ? Container(
                color: Get.theme.colorScheme.background,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'user_blocked'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : Row(
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
                            child: TextFormField(
                              controller: _messageEditingController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16),
                                hintText: 'message'.tr,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              focusNode: FocusNode(),
                              cursorColor: const Color(0xffb3404a),
                              textInputAction: TextInputAction.send,
                              onEditingComplete: () {},
                              onFieldSubmitted: (value) {
                                controller.sendMessage(value, 'text');
                                _messageEditingController.clear();
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                SizedBox(
                                  height: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _pickFileMenu('File', Icons.attach_file,
                                          controller),
                                      _pickFileMenu(
                                          'Gallery', Icons.image, controller),
                                    ],
                                  ),
                                ),
                                backgroundColor:
                                    Get.theme.colorScheme.background,
                              );
                            },
                            icon: const Icon(Icons.attach_file),
                          ),
                          IconButton(
                            onPressed: () {
                              _pickImage(false, controller);
                            },
                            icon: const Icon(Icons.camera_alt),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_messageEditingController.text.isNotEmpty) {
                        controller.sendMessage(
                            _messageEditingController.text, 'text');
                        _messageEditingController.clear();
                      }
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffb3404a),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              );
      },
    );
  }

  Widget _pickFileMenu(
      String title, IconData icon, ChattingController controller) {
    return InkWell(
      onTap: () async {
        Get.back();
        if (title == 'Gallery') {
          _pickImage(true, controller);
        } else {
          _pickFile(controller);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          Text(title.toLowerCase().tr),
        ],
      ),
    );
  }

  void _pickImage(bool fromGallery, ChattingController controller) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      var file = File(pickedFile.path);
      var fileSize = await getFileSize(file);

      controller.uploadSendFile(
        'nyarios/images',
        pickedFile.name,
        fileSize,
        File(pickedFile.path),
        'image',
      );
    }
  }

  void _pickFile(ChattingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      var fileSize = await getFileSize(file);

      controller.uploadSendFile(
        'nyarios/files',
        file.path.split("/").last,
        fileSize,
        File(file.path),
        'file',
      );
    }
  }

  Future<String> getFileSize(File file) async {
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}
