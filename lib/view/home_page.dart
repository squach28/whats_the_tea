import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';
import 'package:whats_the_tea/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/view/sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();

  // display chats
  // widget for user chat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffbcfdc9),
      body: SafeArea(
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
                    Column(
                      children: <Widget>[
                        ChatListItem(),
                        ChatListItem(),
                        ChatListItem(),
                        ChatListItem(),
                        ChatListItem(),
                        ChatListItem(),
                        ChatListItem(),
                        ChatListItem(),
                        Text('hello world'),
                        TextButton(
                            onPressed: () {
                              ChatService chatService = ChatService();
                              Future<DocumentReference> chat = chatService
                                  .sendMessage('test1', 'test2', 'lmao xdddd');
                              chat.then((DocumentReference value) =>
                                  print(value.path));
                            },
                            child: Text('Chat Test')),
                        TextButton(
                          onPressed: () {
                            authService.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignInPage()));
                          },
                          child: Text('Sign Out'),
                        )
                      ],
                    ),
                  ],
                ),
              ))),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats2',
          ),
        ],
      ),
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
          onPressed: () {
            print('pressed!');
          }),
    );
  }
}
