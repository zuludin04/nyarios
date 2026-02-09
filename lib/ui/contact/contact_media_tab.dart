import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/core/widgets/empty_widget.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';

class ContactMediaTab extends StatefulWidget {
  final List<Message> messages;

  const ContactMediaTab({super.key, required this.messages});

  @override
  State<ContactMediaTab> createState() => _ContactMediaTabState();
}

class _ContactMediaTabState extends State<ContactMediaTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.messages.isEmpty) {
      return EmptyWidget(message: AppLocalizations.of(context)!.empty_media);
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          var message = widget.messages[index];
          if (message.type == "file") {
            return _buildDocItem(message);
          } else {
            return _buildMediaItem(message);
          }
        },
        itemCount: widget.messages.length,
      );
    }
  }

  Widget _buildDocItem(Message message) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.attach_file),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.text, style: const TextStyle(fontSize: 16)),
                  Text(
                    DateFormat(
                      "dd/MM/yyyy",
                    ).format(DateTime.parse(message.createdAt)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildMediaItem(Message message) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.network(
                "",
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat(
                  "dd/MM/yyyy",
                ).format(DateTime.parse(message.createdAt)),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
