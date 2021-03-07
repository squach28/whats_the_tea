// represents a message sent by a user
class Message {
  String senderID;
  String channelID;
  String content;
  DateTime sentAt; // firestore parses as TimeStamp

  Message(this.senderID, this.channelID, this.content, this.sentAt);

  // converts from json to a Message object
  Message.fromJson(Map<String, dynamic> json)
      : senderID = json['senderID'],
        channelID = json['channelID'],
        content = json['content'],
        sentAt = json['sentAt'];

  // converts from a Message object to json
  Map<String, dynamic> toJson() => {
        'senderID': senderID,
        'channelID': channelID,
        'content': content,
        'sentAt': sentAt,
      };
}
