import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/chat.dart';
import '../../../services/storage_services.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  const ChatItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (chat.type == "image") {
          var savePath = await getExternalStorageDirectory();
          _downloadFile(chat.url!, "${savePath!.path}/${chat.message}");
        }

        if (chat.type == "text") {
          if (_isLink(chat.message!)) {
            launchUrl(Uri(path: chat.message!));
          }
        }
      },
      child: Align(
        alignment: chat.senderId != StorageServices.to.userId
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: chat.senderId != StorageServices.to.userId ? 16 : 75,
            right: chat.senderId != StorageServices.to.userId ? 75 : 16,
          ),
          decoration: BoxDecoration(
            color: chat.senderId != StorageServices.to.userId
                ? Colors.white
                : const Color.fromRGBO(251, 127, 107, 1),
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
                      color: Colors.black54,
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
    );
  }

  Widget _showChatType(String type) {
    switch (type) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(chat.url!),
        );
      case 'file':
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 213, 116, 101),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.attach_file),
              Text(chat.message!),
            ],
          ),
        );
      default:
        return SubstringHighlight(
          text: chat.message!,
          term: 'f',
          textStyle: TextStyle(
            color: _isLink(chat.message!) ? Colors.blueGrey : Colors.black54,
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
            debugPrint("download progress $downloadIndicator");
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
}
