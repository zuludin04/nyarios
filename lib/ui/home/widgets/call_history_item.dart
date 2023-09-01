import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/data/model/call.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';

class CallHistoryItem extends StatelessWidget {
  final Call call;

  const CallHistoryItem({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              _imageRecentChat(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _nameRecentChat(),
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

  Widget _imageRecentChat() {
    return StreamBuilder(
      stream: ProfileRepository().loadStreamProfile(call.profileId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              snapshot.data!.photo!,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }

  Widget _nameRecentChat() {
    return StreamBuilder(
      stream: ProfileRepository().loadStreamProfile(call.profileId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          return Text(
            snapshot.data?.name ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: call.isAccepted! ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          );
        }
      },
    );
  }
}
