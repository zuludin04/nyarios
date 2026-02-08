class RecentChat {
  final String chatId;
  final String profileId;
  final bool isGroup;
  final String title;
  final String iconUrl;
  final String lastMessage;
  final String lastMessageSenderId;
  final String lastMessageAt;
  final int unreadCount;

  const RecentChat({
    required this.chatId,
    required this.profileId,
    required this.isGroup,
    required this.title,
    required this.iconUrl,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory RecentChat.fromMap(Map<String, dynamic> json) {
    return RecentChat(
      chatId: json['chatId'],
      profileId: json['profileId'],
      isGroup: json['isGroup'],
      title: json['title'],
      iconUrl: json['iconUrl'],
      lastMessage: json['lastMessage'],
      lastMessageSenderId: json['lastMessageSenderId'],
      lastMessageAt: json['lastMessageAt'],
      unreadCount: json['unreadCount'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['profileId'] = profileId;
    data['isGroup'] = isGroup;
    data['title'] = title;
    data['iconUrl'] = iconUrl;
    data['lastMessage'] = lastMessage;
    data['lastMessageSenderId'] = lastMessageSenderId;
    data['lastMessageAt'] = lastMessageAt;
    data['unreadCount'] = unreadCount;
    return data;
  }
}
