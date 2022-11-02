import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/chat.dart';
import '../../../services/storage_services.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;
  final bool isSelected;
  final bool selectionMode;
  final Function onSelect;

  const ChatItem({
    Key? key,
    required this.chat,
    required this.isSelected,
    required this.onSelect,
    this.selectionMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (selectionMode) {
          onSelect();
        }

        if (chat.type == "image") {
          showImageDialog(context);
        }

        if (chat.type == "text") {
          if (_isLink(chat.message!)) {
            launchUrl(Uri(path: chat.message!));
          }
        }

        if (chat.type == "file") {
          var savePath = await getExternalStorageDirectory();
          File file = File("${savePath!.path}/files/${chat.message}");
          bool exist = await file.exists();

          if (!exist) {
            _downloadFile(chat.url!, "${savePath.path}/files/${chat.message}");
          } else {
            Get.rawSnackbar(message: "File is already exist");
          }
        }
      },
      onLongPress: () {
        if (!selectionMode) {
          onSelect();
        }
      },
      child: Stack(
        children: [
          Align(
            alignment: chat.senderId != StorageServices.to.userId
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: chat.senderId != StorageServices.to.userId ? 16 : 75,
                right: chat.senderId != StorageServices.to.userId ? 75 : 16,
              ),
              decoration: BoxDecoration(
                color: chat.senderId != StorageServices.to.userId
                    ? Colors.grey
                    : const Color(0xffb3404a),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: Radius.circular(
                      chat.senderId != StorageServices.to.userId ? 0 : 10),
                  bottomRight: Radius.circular(
                      chat.senderId != StorageServices.to.userId ? 10 : 0),
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 1,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _showChatType(chat.type!),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat("hh:mm a")
                            .format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  chat.sendDatetime ?? 0),
                            )
                            .toLowerCase(),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      // const SizedBox(width: 4),
                      // Visibility(
                      //   visible: !chat.senderId != StorageServices.to.userId,
                      //   child: Icon(
                      //     _readStatusMessage(chat.status!),
                      //     size: 18,
                      //     color: Colors.black54,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isSelected,
            child: Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: const Color(0xffb3404a).withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showChatType(String type) {
    switch (type) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              Image.network(chat.url!),
              Positioned(
                bottom: 5,
                right: 10,
                child: Text(
                  chat.fileSize ?? "",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      case 'file':
        return Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.attach_file),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.message!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    chat.fileSize!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      default:
        return Text(
          chat.message!,
          style: TextStyle(
            color: _isLink(chat.message!) ? Colors.blueGrey : Colors.white,
            fontSize: 16,
            decoration: _isLink(chat.message!)
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        );
    }
  }

  // IconData _readStatusMessage(int status) {
  //   if (status == 3) {
  //     return Icons.done_all;
  //   } else if (status == 2) {
  //     return Icons.done;
  //   } else {
  //     return Icons.av_timer;
  //   }
  // }

  bool _isLink(String input) {
    final matcher = RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }

  void _downloadFile(String downloadUrl, String savePath) async {
    Dio dio = Dio();

    try {
      await dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            var downloadRatio = (count / total);
            var downloadIndicator =
                "${(downloadRatio * 100).toStringAsFixed(2)}%";
            if (downloadIndicator == "100.00%") {
              Get.back();
              Get.rawSnackbar(message: "success download");
            }
          } else {
            Get.rawSnackbar(message: "success download");
          }
        },
      );
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint("Request canceled ${e.message}");
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void showImageDialog(BuildContext context) async {
    var savePath = await getExternalStorageDirectory();
    File file = File("${savePath!.path}/images/${chat.message}");
    var exist = await file.exists();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: !exist,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () async {
                        if (!exist) {
                          _downloadFile(chat.url!,
                              "${savePath.path}/images/${chat.message}");
                        } else {
                          Get.rawSnackbar(message: "File is already exist");
                        }
                      },
                      icon: const Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Image.network(chat.url!),
          ],
        );
      },
    );
  }
}
