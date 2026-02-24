class MessagePost {
  final String messageId;
  final String chatId;
  final String senderProfileId;
  final String type;
  final String text;
  final String replyToMessageId;
  final String fileSize;
  final String createdAt;
  final String receiverProfileId;

  MessagePost({
    required this.messageId,
    required this.chatId,
    required this.senderProfileId,
    required this.type,
    required this.text,
    required this.replyToMessageId,
    required this.createdAt,
    required this.fileSize,
    required this.receiverProfileId,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageId'] = messageId;
    data['chatId'] = chatId;
    data['senderProfileId'] = senderProfileId;
    data['type'] = type;
    data['text'] = text;
    data['replyToMessageId'] = replyToMessageId;
    data['createdAt'] = createdAt;
    data['fileSize'] = fileSize;
    data['receiverProfileId'] = receiverProfileId;
    return data;
  }
}
