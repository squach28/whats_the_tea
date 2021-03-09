import 'package:whats_the_tea/model/message.dart';
import 'package:whats_the_tea/model/basic_user.dart';

// class to contain info about a channel
class Channel {
  String channelID; // id of the chat channel
  List<BasicUserInfo> participants;
  List<Message> messages;

  Channel.empty();

  Channel(this.channelID, this.participants, this.messages);

  Channel.fromJson(Map<String, dynamic> json) :
    channelID = json['channelID'],
    participants = json['participants'],
    messages = json['messages'];

    Map<String, dynamic> toJson() => {
      'channelID': channelID,
      'participants': participants, 
      'messages' : messages
    };

}
