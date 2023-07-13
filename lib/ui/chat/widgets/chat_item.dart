import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/chat.dart';
import '../../../services/storage_services.dart';

class ChatItem extends StatefulWidget {
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
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  var downloadIndicator = "0";

  @override
  void initState() {
    checkFileAlreadyExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.selectionMode) {
          widget.onSelect();
        }

        if (widget.chat.type == "image") {
          showImageDialog(context);
        }

        if (widget.chat.type == "text") {
          if (_isLink(widget.chat.message!)) {
            launchUrl(Uri(path: widget.chat.message!));
          }
        }

        if (widget.chat.type == "file") {
          var savePath = await getExternalStorageDirectory();
          File file = File("${savePath!.path}/files/${widget.chat.message}");
          bool exist = await file.exists();

          if (!exist) {
            _downloadFile(
              widget.chat.url!,
              "${savePath.path}/files/${widget.chat.message}",
              () {},
            );
          } else {
            Get.rawSnackbar(message: "File is already exist");
          }
        }
      },
      onLongPress: () {
        if (!widget.selectionMode) {
          widget.onSelect();
        }
      },
      child: Stack(
        children: [
          Align(
            alignment: widget.chat.senderId != StorageServices.to.userId
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left:
                    widget.chat.senderId != StorageServices.to.userId ? 16 : 75,
                right:
                    widget.chat.senderId != StorageServices.to.userId ? 75 : 16,
              ),
              decoration: BoxDecoration(
                color: widget.chat.senderId != StorageServices.to.userId
                    ? Colors.grey
                    : const Color(0xffb3404a),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: Radius.circular(
                      widget.chat.senderId != StorageServices.to.userId
                          ? 0
                          : 10),
                  bottomRight: Radius.circular(
                      widget.chat.senderId != StorageServices.to.userId
                          ? 10
                          : 0),
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
                  _showChatType(widget.chat.type!),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat("hh:mm a")
                            .format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  widget.chat.sendDatetime ?? 0),
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
            visible: widget.isSelected,
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
              Image.network(widget.chat.url!),
              Positioned(
                bottom: 5,
                right: 10,
                child: Text(
                  widget.chat.fileSize ?? "",
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
            color: widget.chat.senderId != StorageServices.to.userId
                ? Colors.black.withOpacity(0.1)
                : Colors.red.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 24,
                center: const Icon(Icons.attach_file),
                percent: double.parse(downloadIndicator) / 100,
                lineWidth: 2,
                progressColor: widget.chat.senderId != StorageServices.to.userId
                    ? Colors.black
                    : Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.message!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.chat.fileSize!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return Text(
          widget.chat.message!,
          style: TextStyle(
            color:
                _isLink(widget.chat.message!) ? Colors.blueGrey : Colors.white,
            fontSize: 16,
            decoration: _isLink(widget.chat.message!)
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        );
    }
  }

  bool _isLink(String input) {
    final matcher = RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }

  void _downloadFile(
      String downloadUrl, String savePath, Function() downloadCallback) async {
    Dio dio = Dio();

    try {
      await dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            var downloadRatio = (count / total);
            setState(() {
              downloadIndicator = (downloadRatio * 100).toStringAsFixed(0);
            });
            if (downloadIndicator == "100") {
              downloadCallback();
            }
          }
        },
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint("Request canceled ${e.message}");
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void showImageDialog(BuildContext context) async {
    var savePath = await getExternalStorageDirectory();
    File file = File("${savePath!.path}/images/${widget.chat.message}");
    var exist = await file.exists();

    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Column(
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
                          _downloadFile(
                            widget.chat.url!,
                            "${savePath.path}/images/${widget.chat.message}",
                            () {
                              Get.back();
                              Get.rawSnackbar(
                                  message: "Success downloading file");
                            },
                          );
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
            Image.network(widget.chat.url!),
          ],
        ),
      ),
    );
  }

  void checkFileAlreadyExist() async {
    var savePath = await getExternalStorageDirectory();
    File file = File("${savePath!.path}/files/${widget.chat.message}");
    bool exist = await file.exists();

    if (exist) {
      setState(() {
        downloadIndicator = "100";
      });
    }
  }
}
