class Chat {
  String? message;
  int? sendDatetime;
  String? senderId;
  String? type;

  Chat({
    this.message,
    this.sendDatetime,
    this.senderId,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sendDatetime': sendDatetime,
      'senderId': senderId,
      'type': type,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      message: map['message'] != null ? map['message'] as String : null,
      sendDatetime:
          map['sendDatetime'] != null ? map['sendDatetime'] as int : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }
}
