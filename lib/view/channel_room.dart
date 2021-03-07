import 'package:flutter/material.dart';
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

  final TextEditingController messageController = TextEditingController(); // controller for the text field sending messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat!'), // TODO replace with the other user's name
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // StreamBuilder(); TODO do stream builder
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: Text('hi there'),
                  );
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(children: <Widget>[
                    GestureDetector( // gesture detector for sending images
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
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

                        if (message.isEmpty) { // if nothing is written, do nothing
                          return;
                        }
                        print(widget.channel.channelID == null);
                        print(widget.channel.participants.toString());

                        chatService.sendMessage(message, auth.currentUser.uid,
                            widget.channel.channelID); 
                        print('message sent');
                        messageController.clear(); // clear the text field when message is sent
                      },
                      child: Icon(Icons.send, color: Colors.white, size: 18),
                      backgroundColor: Colors.blue,
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
