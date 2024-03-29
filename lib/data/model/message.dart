class Message {
  String? messageId;
  String? message;
  String? type;
  int? sendDatetime;
  String? url;
  String? fileSize;
  String? chatId;
  String? profileId;

  Message({
    this.messageId,
    this.message,
    this.type,
    this.sendDatetime,
    this.url,
    this.fileSize,
    this.profileId,
    this.chatId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'type': type,
      'sendDatetime': sendDatetime,
      'url': url,
      'fileSize': fileSize,
      'profileId': profileId,
      'chatId': chatId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'] != null ? map['messageId'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      sendDatetime:
          map['sendDatetime'] != null ? map['sendDatetime'] as int : null,
      url: map['url'] != null ? map['url'] as String : null,
      fileSize: map['fileSize'] != null ? map['fileSize'] as String : null,
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
    );
  }

  factory Message.fromMapWithMessageId(Map<String, dynamic> map, String messageId) {
    return Message(
      messageId: messageId,
      message: map['message'] != null ? map['message'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      sendDatetime:
      map['sendDatetime'] != null ? map['sendDatetime'] as int : null,
      url: map['url'] != null ? map['url'] as String : null,
      fileSize: map['fileSize'] != null ? map['fileSize'] as String : null,
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
    );
  }
}
