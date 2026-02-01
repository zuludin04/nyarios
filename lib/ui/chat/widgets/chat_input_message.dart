import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/utils/helper.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/domain/model/picked_message_file.dart';

class ChatInputMessage extends StatefulWidget {
  final bool isBlocked;
  final Function({
    required String type,
    String? message,
    PickedMessageFile? file,
  })
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

  @override
  Widget build(BuildContext context) {
    return widget.isBlocked
        ? Container(
            color: Get.theme.colorScheme.surface,
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
                            widget.onSendMessage(type: 'text', message: value);
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _pickFileMenu(
                                    'File',
                                    'assets/icons/ic_attach_file.png',
                                  ),
                                  _pickFileMenu(
                                    'Gallery',
                                    'assets/icons/ic_gallery.png',
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Get.theme.colorScheme.surface,
                          );
                        },
                        icon: ImageAsset(
                          assets: 'assets/icons/ic_attach_file.png',
                          color: Get.theme.iconTheme.color!,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final image = await pickImage(false);
                          if (image != null) {
                            widget.onSendMessage(type: 'image', file: image);
                          }
                        },
                        icon: ImageAsset(
                          assets: 'assets/icons/ic_camera.png',
                          color: Get.theme.iconTheme.color!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (_messageEditingController.text.isNotEmpty) {
                    widget.onSendMessage(
                      type: 'text',
                      message: _messageEditingController.text,
                    );
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
                  child: const ImageAsset(assets: 'assets/icons/ic_send.png'),
                ),
              ),
              const SizedBox(width: 8),
            ],
          );
  }

  Widget _pickFileMenu(String title, String icon) {
    return InkWell(
      onTap: () async {
        Get.back();
        if (title == 'Gallery') {
          final image = await pickImage(true);
          if (image != null) {
            widget.onSendMessage(type: 'image', file: image);
          }
        } else {
          final file = await pickFile();
          if (file != null) {
            widget.onSendMessage(type: 'file', file: file);
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageAsset(assets: icon, color: Get.theme.iconTheme.color!, size: 32),
          const SizedBox(height: 8),
          Text(title.toLowerCase().tr),
        ],
      ),
    );
  }
}
