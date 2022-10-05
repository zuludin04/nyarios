import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../core/constants.dart';
import '../../core/widgets/toolbar.dart';
import '../../data/chat.dart';
import 'chat_item.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController _messageEditingController =
      TextEditingController();

  List<Chat> chats = chatDemo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        "Zulfikar Mauludin",
        subtitle: "Online",
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('view_contact'.tr),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => ChatItem(chat: chats[index]),
              itemCount: chats.length,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Get.theme.colorScheme.surface,
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
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'message'.tr,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          cursorColor: const Color.fromRGBO(251, 127, 107, 1),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            builder: (context) => Container(
                              color: Colors.white,
                              height: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _pickFileMenu('File', Icons.attach_file),
                                  _pickFileMenu('Gallery', Icons.image),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.attach_file),
                      ),
                      IconButton(
                        onPressed: () {
                          _pickImage(false);
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
                    var newMessage = Chat(
                        message: _messageEditingController.text,
                        time: '10:45',
                        status: 1,
                        received: false,
                        type: 'text');

                    chats.add(newMessage);
                    setState(() {});
                    _messageEditingController.clear();
                  }
                },
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(251, 127, 107, 1),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.send),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickFileMenu(String title, IconData icon) {
    return InkWell(
      onTap: () async {
        Get.back();
        if (title == 'Gallery') {
          _pickImage(true);
        } else {
          _pickFile();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Text(title.toLowerCase().tr),
        ],
      ),
    );
  }

  void _pickImage(bool fromGallery) async {
    final file = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    if (file != null) {
      var newMessage = Chat(
        message: file.path,
        time: '10:45',
        status: 1,
        received: false,
        type: 'image',
      );
      chats.add(newMessage);
      setState(() {});
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      var newMessage = Chat(
        message: result.files.single.name,
        time: '10:45',
        status: 1,
        received: false,
        type: 'file',
      );
      chats.add(newMessage);
      setState(() {});
    }
  }
}
