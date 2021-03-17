import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/message.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/view/channel_room.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/channel.dart';
import 'package:intl/intl.dart';

// list item that represents a channel
class ChatListItem extends StatefulWidget {
  final Channel channel; // associated channel for the chat list item

  ChatListItem({Key key, this.channel}) : super(key: key);

  @override
  ChatListItemState createState() => ChatListItemState();
}

class ChatListItemState extends State<ChatListItem> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final UserService userService = UserService();

  Message fetchMostRecentMessage(Channel channel) {
    List<Message> messages = channel.messages;
    print('messages size: ' + messages.length.toString());
    if (messages.length == 0) {
      return null;
    } else {
      messages.sort();
      return messages.last;
    }
  }

  String getParticipantName(List<BasicUserInfo> participants) {
    for (BasicUserInfo participant in participants) {
      if (participant.uid != auth.currentUser.uid) {
        return participant.firstName + ' ' + participant.lastName;
      }
    }
    return '';
  }

    String getParticipantInfo(List<BasicUserInfo> participants) {
    for (BasicUserInfo participant in participants) {
      if (participant.uid != auth.currentUser.uid) {
        return participant.profilePictureURL;
      }
    }
    return '';
  }

  Widget formatMessageTime(Message message) {
    return fetchMostRecentMessage(widget.channel) != null ? Text(
      // time stamp of most recently sent message
      DateFormat('h:mm a')
          .format(fetchMostRecentMessage(widget.channel).sentAt),

      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    ) : SizedBox(width: 0, height: 0);
  }

  Widget formatMessageContent(Channel channel) {
    Map<String, BasicUserInfo> participantsInfo = {};
    for (var participant in channel.participants) {
      participantsInfo[participant.uid] = participant;
    }

    Message mostRecentMessage = fetchMostRecentMessage(channel);
    if(mostRecentMessage == null) {
      return SizedBox(height: 0, width: 0);
    } else if (mostRecentMessage.senderID == auth.currentUser.uid) {
      return Text(
        'You: ' + mostRecentMessage.content,
        style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal),
      );
    } else {
      return Text(
        participantsInfo[mostRecentMessage.senderID].firstName +
            ': ' +
            mostRecentMessage.content,
        style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChannelRoom(channel: widget.channel);
          }));
        },
        child: Container(
            child: Card(
          elevation: 10.0,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(getParticipantInfo(widget.channel.participants)), // TODO make it fetch profile picture of most recent person that sent a message
                        maxRadius: 30,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                // other user's name
                                getParticipantName(widget.channel.participants),
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              // most recent message content
                              formatMessageContent(widget.channel),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                formatMessageTime(fetchMostRecentMessage(widget.channel)),
              ],
            ),
          ),
        )));
  }
}
