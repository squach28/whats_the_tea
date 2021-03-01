import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/service/user_service.dart';

// class that conatins widget for building the channel room view
class ChannelRoom extends StatefulWidget {
  @override
  ChannelRoomState createState() => ChannelRoomState();
}

class ChannelRoomState extends State<ChannelRoom> {
  final ChatService chatService = ChatService();

  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController messageController = TextEditingController();

  String channelID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat!'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
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
                    GestureDetector(
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

                        if (message.isEmpty) {
                          return;
                        }

                        chatService.sendMessage(message, auth.currentUser.uid,
                            'test'); // TODO replace test with actual channel id
                        messageController.clear();
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
