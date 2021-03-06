import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';
import 'package:whats_the_tea/view/create_chat_list_item.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateChatPage extends StatefulWidget {
  // TODO put the gesture detector in this class, not create_chat_list_item
  final List<BasicUserInfo> friends;

  CreateChatPage({Key key, this.friends}) : super(key: key);

  @override
  CreateChatPageState createState() => CreateChatPageState();
}

class CreateChatPageState extends State<CreateChatPage> {
  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final ChatService chatService = ChatService();

  List<BasicUserInfo> participants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Chat'), actions: <Widget>[
        Container(
            child: participants.isEmpty
                ? Container(height: 0)
                : IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      print('create chat!');
                      participants.add(
                          userService.getCurrentUserInfo(auth.currentUser.uid));
                      chatService.createChannel(participants);
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
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.friends.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!participants
                                      .contains(widget.friends[index])) {
                                    participants.add(widget.friends[index]);
                                    print(participants.length);
                                  } else {
                                    participants.remove(widget.friends[index]);
                                    print(participants.length);
                                  }
                                });
                              },
                              child: CreateChatListItem(
                                firstName: widget.friends[index].firstName,
                                lastName: widget.friends[index].lastName,
                                isSelected:
                                    participants.contains(widget.friends[index])
                                        ? true
                                        : false,
                              ));
                        }),
                  ],
                ),
              )),
            ])),
      ),
    );
  }
}
