class Contact {
  String? message;
  String? name;
  String? photo;
  String? receiverId;
  String? roomId;
  int? sendDatetime;
  bool? block;
  int? unreadMessage;

  Contact({
    this.message,
    this.name,
    this.photo,
    this.receiverId,
    this.roomId,
    this.sendDatetime,
    this.block,
    this.unreadMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'name': name,
      'photo': photo,
      'receiverId': receiverId,
      'roomId': roomId,
      'sendDatetime': sendDatetime,
      'block': block,
      'unreadMessage': unreadMessage,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      message: map['message'] != null ? map['message'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
      sendDatetime:
          map['sendDatetime'] != null ? map['sendDatetime'] as int : null,
      block: map['block'] != null ? map['block'] as bool : null,
      unreadMessage:
          map['unreadMessage'] != null ? map['unreadMessage'] as int : null,
    );
  }
}
