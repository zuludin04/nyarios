class Call {
  int? callDate;
  String? callId;
  String? profileId;
  String? status;
  String? type;

  Call({this.callDate, this.callId, this.profileId, this.status, this.type});

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callDate: map['callDate'],
      callId: map['callId'],
      profileId: map['profileId'],
      status: map['status'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['callDate'] = callDate;
    map['callId'] = callId;
    map['profileId'] = profileId;
    map['status'] = status;
    map['type'] = type;
    return map;
  }

  @override
  String toString() {
    return 'Call{callDate: $callDate, callId: $callId, profileId: $profileId, status: $status, type: $type}';
  }
}
