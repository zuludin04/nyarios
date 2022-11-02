class Chat {
  String? messageId;
  String? message;
  int? sendDatetime;
  String? senderId;
  String? type;
  String? url;
  String? fileSize;

  Chat({
    this.messageId,
    this.message,
    this.sendDatetime,
    this.senderId,
    this.type,
    this.url,
    this.fileSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sendDatetime': sendDatetime,
      'senderId': senderId,
      'type': type,
      'url': url,
      'fileSize': fileSize,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map, String messageId) {
    return Chat(
      messageId: messageId,
      message: map['message'] != null ? map['message'] as String : null,
      sendDatetime:
          map['sendDatetime'] != null ? map['sendDatetime'] as int : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      fileSize: map['fileSize'] != null ? map['fileSize'] as String : null,
    );
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.sendDatetime == sendDatetime &&
        other.senderId == senderId &&
        other.type == type &&
        other.url == url;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        sendDatetime.hashCode ^
        senderId.hashCode ^
        type.hashCode ^
        url.hashCode;
  }
}
