import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/data/model/call.dart';

class CallHistoryItem extends ConsumerWidget {
  final Call call;

  const CallHistoryItem({super.key, required this.call});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              _imageRecentChat(call.profile?.photo),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _nameRecentChat(call.profile?.name),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          call.status == 'incoming_call'
                              ? Icons.call_received
                              : Icons.call_made,
                          color: call.isAccepted! ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat("dd MMM yyyy, HH:mm").format(
                            DateTime.fromMillisecondsSinceEpoch(call.callDate!),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ImageAsset(
                assets: call.type == 'voice_call'
                    ? 'assets/icons/ic_call.png'
                    : 'assets/icons/ic_video.png',
                color: Theme.of(context).iconTheme.color!,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _imageRecentChat(String? imageUrl) {
    if (imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.network(
          imageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _nameRecentChat(String? name) {
    return Text(
      name ?? "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: call.isAccepted! ? Colors.green : Colors.red,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
