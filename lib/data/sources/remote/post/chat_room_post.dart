class ChatRoomPost {
  final bool isGroup;
  final String title;
  final List<String> participants;
  final String createdAt;
  final String senderProfileId;
  final String receiverProfileId;

  ChatRoomPost({
    required this.isGroup,
    required this.title,
    required this.participants,
    required this.createdAt,
    required this.senderProfileId,
    required this.receiverProfileId,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["isGroup"] = isGroup;
    map["title"] = title;
    map["participants"] = participants;
    map["createdAt"] = createdAt;
    map["senderProfileId"] = senderProfileId;
    map["receiverProfileId"] = receiverProfileId;
    return map;
  }
}
