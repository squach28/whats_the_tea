import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/message.dart';
import 'package:whats_the_tea/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/model/channel.dart';

// class that conatins widget for building the channel room view
class ChannelRoom extends StatefulWidget {
  final Channel channel;

  ChannelRoom({Key key, this.channel}) : super(key: key);
  @override
  ChannelRoomState createState() => ChannelRoomState();
}

class ChannelRoomState extends State<ChannelRoom> {
  final ChatService chatService = ChatService();

  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final ScrollController scrollController = ScrollController();

  final TextEditingController messageController =
      TextEditingController(); // controller for the text field sending messages

  Widget fetchHeader(List<BasicUserInfo> participants) {
    for (var participant in participants) {
      if (participant.uid != auth.currentUser.uid) {
        return Text(participant.firstName + ' ' + participant.lastName);
      }
    }
    return Text('Chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (fetchHeader(widget
            .channel.participants)), // TODO replace with the other user's name
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('channels')
                    .doc(widget.channel.channelID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<dynamic> messagesData = snapshot.data['messages'];
                    List<Message> messages = [];
                    for (var messageJson in messagesData) {
                      Message message = Message(
                          messageJson['senderID'],
                          messageJson['channelID'],
                          messageJson['content'],
                          messageJson['sentAt'].toDate());
                      messages.add(message);
                    }
                    print(messages.length);
                    return Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                controller: scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  messages.sort();
                                  var message = messages.elementAt(index);

                                  return Container(
                                      padding: EdgeInsets.only(
                                          top: 2.0, left: 10.0, right: 10.0),
                                      alignment: message.senderID ==
                                              auth.currentUser.uid
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: message.senderID ==
                                                        auth.currentUser.uid
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey[200]),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: message.senderID ==
                                                    auth.currentUser.uid
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey[200],
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(message.content,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17.0,
                                                  )))));
                                })));
                  }
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(children: <Widget>[
                    GestureDetector(
                      // gesture detector for sending images
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Write message...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    FloatingActionButton(
                      // button to send messages
                      onPressed: () {
                        // String content, String senderID, String channelID
                        String message = messageController.text;

                        if (message.isEmpty) {
                          // if nothing is written, do nothing
                          return;
                        }
                        print(widget.channel.channelID == null);
                        print(widget.channel.participants.toString());

                        chatService.sendMessage(message, auth.currentUser.uid,
                            widget.channel.channelID);
                        print('message sent');
                        messageController
                            .clear(); // clear the text field when message is sent
                            
                      },
                      child: Icon(Icons.send, color: Colors.white, size: 18),
                      backgroundColor: Theme.of(context).accentColor,

                      elevation: 0,
                    ),
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
