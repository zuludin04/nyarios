class LastMessage {
  String? message;
  String? name;
  String? photo;
  String? receiverId;
  String? roomId;
  int? sendDatetime;
  bool? block;

  LastMessage({
    this.message,
    this.name,
    this.photo,
    this.receiverId,
    this.roomId,
    this.sendDatetime,
    this.block,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'receiverId': receiverId,
      'roomId': roomId,
      'sendDatetime': sendDatetime,
      'block': block,
    };
  }

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      message: map['message'] != null ? map['message'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
      sendDatetime:
          map['sendDatetime'] != null ? map['sendDatetime'] as int : null,
      block: map['block'] != null ? map['block'] as bool : null,
    );
  }
}
