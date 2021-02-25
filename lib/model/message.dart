class Message {
  String senderID;
  String channelID;
  String content;
  DateTime sentAt;

  Message(this.senderID, this.channelID, this.content, this.sentAt);

  Message.fromJson(Map<String, dynamic> json)
      : senderID = json['senderID'],
        channelID = json['channelID'],
        content = json['content'],
        sentAt = json['sentAt'];

  Map<String, dynamic> toJson() => {
        'senderID': senderID,
        'channelID': channelID,
        'content': content,
        'sentAt': sentAt,
      };
}
