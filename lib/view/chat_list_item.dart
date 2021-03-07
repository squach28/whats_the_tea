import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/view/channel_room.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/channel.dart';
// list item that represents a channel
class ChatListItem extends StatefulWidget {
  final Channel channel; // associated channel for the chat list item

  ChatListItem({Key key, this.channel}) : super(key: key);

  @override
  ChatListItemState createState() => ChatListItemState();
}

class ChatListItemState extends State<ChatListItem> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String getParticipantName(List<BasicUserInfo> participants) {
    for (BasicUserInfo participant in participants) {
      if (participant.uid != auth.currentUser.uid) {
        return participant.firstName + ' ' + participant.lastName;
      }
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
        child: Card(
          color: const Color(0xfffdcece),
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
                        //backgroundImage: NetworkImage(widget.imageUrl),
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
                              Text(
                                // most recent message content
                                'messageText',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  // time stamp of most recently sent message
                  'time',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ));
  }
}
