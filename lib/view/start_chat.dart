import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/service/user_service.dart';

class StartChatPage extends StatefulWidget {
  @override
  StartChatPageState createState() => StartChatPageState();
}

class StartChatPageState extends State<StartChatPage> {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    ChatListItem(),
                    TextButton(
                        child: Text('Add Friend'),
                        onPressed: () {
                          BasicUserInfo user =
                              BasicUserInfo('1234567890', 'Johjn', 'Smikth');
                          // userService.addFriend(user);
                        }),
                  ],
                ),
              )),
            ])),
      ),
      // search bar to add person
      // container to show people being added
      // container for the list of people to add
    );
  }
}
