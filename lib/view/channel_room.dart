import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/chat_service.dart';

// class that conatins widget for building the channel room view
class ChannelRoom extends StatefulWidget {
  String channelID;

  @override
  ChannelRoomState createState() => ChannelRoomState();
}

class ChannelRoomState extends State<ChannelRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat!'),
      ),
      body: SafeArea(
        child: Align(
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
                    decoration: InputDecoration(
                      hintText: 'Write message',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                FloatingActionButton(
                  // button to send messages
                  onPressed: () {
                    // use chat service
                  },
                  child: Icon(Icons.send, color: Colors.white, size: 18),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ])),
        ),
      ),
    );
  }
}
