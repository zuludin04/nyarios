class Contact {
  String? message;
  String? name;
  String? photo;
  String? receiverId;
  String? roomId;
  int? sendDatetime;

  Contact({
    this.message,
    this.name,
    this.photo,
    this.receiverId,
    this.roomId,
    this.sendDatetime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'name': name,
      'photo': photo,
      'receiverId': receiverId,
      'roomId': roomId,
      'send_datetime': sendDatetime,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      message: map['message'] != null ? map['message'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
      sendDatetime:
          map['send_datetime'] != null ? map['send_datetime'] as int : null,
    );
  }
}
