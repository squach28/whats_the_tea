import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/channel_room.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';
import 'package:whats_the_tea/view/create_chat_list_item.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateChatPage extends StatefulWidget {
  @override
  CreateChatPageState createState() => CreateChatPageState();
}

class CreateChatPageState extends State<CreateChatPage> {
  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final ChatService chatService = ChatService();

  List<BasicUserInfo> participants = [];

  List<BasicUserInfo> friends = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Chat'), actions: <Widget>[
        Container(
            child: participants.isEmpty
                ? Container(height: 0)
                : IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      print('create chat!');
                      participants.add(await userService
                          .getCurrentUserInfo(auth.currentUser.uid));
                      var channel =
                          await chatService.createChannel(participants);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChannelRoom(channel: channel)));
                    },
                  ))
      ]),
      body: Container(
        child: SafeArea(
            minimum: EdgeInsets.all(5.0),
            child: Stack(children: [
              Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade50,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(auth.currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            List<dynamic> friends = snapshot.data['friends'];
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                  var friend = friends[index];
                                  BasicUserInfo friendInfo = BasicUserInfo(
                                      friend['uid'],
                                      friend['firstName'],
                                      friend['lastName']);

                                  this.friends.add(friendInfo);
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (!participants
                                              .contains(this.friends[index])) {
                                            participants
                                                .add(this.friends[index]);
                                          } else {
                                            participants
                                                .remove(this.friends[index]);
                                          }
                                        });
                                      },
                                      child: CreateChatListItem(
                                        friendInfo: friendInfo,
                                        isSelected: participants
                                                .contains(this.friends[index])
                                            ? true
                                            : false,
                                      ));
                                });
                          }
                        }),
                  ],
                ),
              )),
            ])),
      ),
    );
  }
}
