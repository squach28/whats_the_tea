import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';
import 'package:whats_the_tea/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/view/sign_in.dart';
import 'package:whats_the_tea/view/settings.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage({
    Key key,
  }) : super(key: key);

  @override
  ChatListPageState createState() => ChatListPageState();
}

class ChatListPageState extends State<ChatListPage> {
  final AuthService authService = AuthService();

  final items = List<String>.generate(100, (i) => "Item $i");

  // display chats
  // widget for user chat

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
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          return ChatListItem();
                        }),
                  ],
                ),
              ))),
    );
  }
}
