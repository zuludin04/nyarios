class Chat {
  final bool isGroup;
  final String title;
  final List<String> participants;
  final String createdBy;
  final String createdAt;
  final LastMessage lastMessage;

  Chat({
    required this.isGroup,
    required this.title,
    required this.participants,
    required this.createdBy,
    required this.createdAt,
    required this.lastMessage,
  });

  factory Chat.fromMap(Map<String, dynamic> json) {
    return Chat(
      isGroup: json['isGroup'],
      title: json['title'],
      participants: json['participants'].cast<String>(),
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      lastMessage: LastMessage.fromJson(json['lastMessage']),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isGroup'] = isGroup;
    data['title'] = title;
    data['participants'] = participants;
    data['createdBy'] = createdBy;
    data['createdAt'] = createdAt;
    data['lastMessage'] = lastMessage.toJson();
    return data;
  }
}

class LastMessage {
  final String text;
  final String senderId;
  final String createdAt;

  LastMessage({
    required this.text,
    required this.senderId,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      text: json['text'],
      senderId: json['senderId'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['senderId'] = senderId;
    data['createdAt'] = createdAt;
    return data;
  }
}
