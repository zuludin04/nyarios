import 'dart:io';

class Message {
  final String messageId;
  final String chatId;
  final String senderProfileId;
  final String type;
  final String text;
  final String replyToMessageId;
  final String fileSize;
  final String createdAt;
  bool isUploading;
  bool isSelected;

  Message({
    required this.messageId,
    required this.chatId,
    required this.senderProfileId,
    required this.type,
    required this.text,
    required this.replyToMessageId,
    required this.createdAt,
    required this.fileSize,
    this.isUploading = false,
    this.isSelected = false,
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
    return data;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      chatId: map['chatId'],
      senderProfileId: map['senderProfileId'],
      type: map['type'],
      text: map['text'],
      replyToMessageId: map['replyToMessageId'],
      createdAt: map['createdAt'],
      fileSize: map['fileSize'],
    );
  }

  factory Message.uploading({
    required String uploadId,
    required File localFile,
    required int sendDatetime,
    required String userId,
  }) {
    return Message(
      messageId: uploadId,
      isUploading: true,
      type: 'image',
      chatId: '',
      senderProfileId: '',
      text: '',
      replyToMessageId: '',
      createdAt: '',
      fileSize: '',
    );
  }
}
