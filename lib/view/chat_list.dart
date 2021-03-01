import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/view/create_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/service/user_service.dart';

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
      backgroundColor: Color(0xffbcfdc9),
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
                      child: Text('Chats', style: TextStyle(fontSize: 50.0)),
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 20.0),
                      child: TextField(
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
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5, // TODO replace with stream of channels
                        itemBuilder: (context, index) {
                          return ChatListItem();
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
                    builder: (BuildContext context) =>
                        CreateChatPage(friends: friendsList)));
          }),
    );
  }
}
