import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/channel.dart';
import 'package:whats_the_tea/model/message.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/view/create_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/service/user_service.dart';

// page that contains the list of chats that a user has
class ChatListPage extends StatefulWidget {
  ChatListPage({
    Key key,
  }) : super(key: key);

  @override
  ChatListPageState createState() => ChatListPageState();
}

class ChatListPageState extends State<ChatListPage> {
  final AuthService authService = AuthService();

  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffece6ff),
      body: SafeArea(
          minimum: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      child: Text('Chats', style: TextStyle(fontSize: 50.0)), // chat header
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 20.0),
                      child: TextField( // search text field
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder( // stream builder for loading users collection
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(auth.currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) { // no data --> show progress indicator
                            return Center(child: CircularProgressIndicator());
                          } else {
                            List<dynamic> chats = snapshot.data['channels']; // list of all users

                            return StreamBuilder( // stream builder for channels collection
                                stream: FirebaseFirestore.instance
                                    .collection('channels')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) { // no data --> show progress indicator
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    QuerySnapshot channels = snapshot.data; // list of all channels
                                    Map<String, Channel> allChannels = {}; // map of all channels with key value pair {channelID: Channel}
                                    Map<String, Channel> userChannels = {}; // map of user channels with key value pair {channelID: Channel}
                                    
                                    for (var channel in channels.docs) {
                                      List<BasicUserInfo> participants = [];
                                      List<Message> messages = [];
                                      // find the participants in each channel
                                      for (var participant
                                          in channel.data()['participants']) {
                                        BasicUserInfo participantInfo =
                                            BasicUserInfo(
                                                participant['uid'],
                                                participant['firstName'],
                                                participant['lastName']);
                                        participants.add(participantInfo); // add participant info to list of participants
                                      }

                                      // find the messages in each channel
                                      for (var message
                                          in channel.data()['messages']) {
                                        Message messageInfo = Message(
                                            message['channelID'],
                                            message['content'],
                                            message['senderID'],
                                            message['sentAt'].toDate());
                                        messages.add(messageInfo); // add message info to list of messages
                                      }


                                      // create channelInfo as channel object
                                      Channel channelInfo = Channel(
                                          channel.data()['channelID'],
                                          participants,
                                          messages);
                                      allChannels[channel.data()['channelID']] = channelInfo;
                                    }
                                    // fill userChannels with channel info if match is found
                                    for (var channelID in chats) {
                                      userChannels[channelID] = allChannels[channelID];
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: userChannels.length,
                                      itemBuilder: (context, index) {
                                        
                                        Channel key = userChannels.values.elementAt(index);
                                        if(key == null) {
                                          return SizedBox(height:0, width: 0);
                                        } else {
                                          // chat list item with channel info included
                                        return ChatListItem( 
                                          channel: key
                                        );
                                      }
                                      }
                                    );
                                  }
                                });
                          }
                        }),
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton(
          child: Container(
            width: 60,
            height: 60,
            child: IconTheme(
              data: IconThemeData(color: Colors.black),
              child: Icon(Icons.add),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xffa88beb),
                    const Color(0xfff8ceec),
                  ]),
            ),
          ),
          onPressed: () async {
            print('pressed!');
            var friendsList =
                await userService.fetchFriends(auth.currentUser.uid);
            print(friendsList.length);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreateChatPage()));
          }),
    );
  }
}
