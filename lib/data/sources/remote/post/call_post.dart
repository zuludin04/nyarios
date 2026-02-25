class CallPost {
  final String callId;
  final String chatId;
  final String receiverProfileId;
  final String callerProfileId;
  final String type;
  final String createdAt;

  CallPost({
    required this.callId,
    required this.chatId,
    required this.receiverProfileId,
    required this.callerProfileId,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["callId"] = callId;
    map["chatId"] = chatId;
    map["receiverProfileId"] = receiverProfileId;
    map["callerProfileId"] = callerProfileId;
    map["type"] = type;
    map["createdAt"] = createdAt;
    return map;
  }
}
