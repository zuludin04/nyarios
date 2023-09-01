import 'package:flutter/material.dart';
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
                    Text(
                      call.status ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          );
        }
      },
    );
  }
}
