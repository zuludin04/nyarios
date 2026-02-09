class Call {
  final String callId;
  final String username;
  final String image;
  final String type;
  final String status;
  final String createdAt;

  const Call({
    required this.callId,
    required this.username,
    required this.image,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callId: map['callId'],
      username: map['username'],
      image: map['image'],
      status: map['status'],
      type: map['type'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['callId'] = callId;
    map['username'] = username;
    map['image'] = image;
    map['status'] = status;
    map['type'] = type;
    map['createdAt'] = createdAt;
    return map;
  }
}
