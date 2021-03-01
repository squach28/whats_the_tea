import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/create_chat_list_item.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateChatPage extends StatefulWidget {
  final List<BasicUserInfo> friends;

  CreateChatPage({Key key, this.friends}) : super(key: key);

  @override
  CreateChatPageState createState() => CreateChatPageState();
}

class CreateChatPageState extends State<CreateChatPage> {
  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    print(widget.friends.length);
  }

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
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.friends.length,
                        itemBuilder: (context, index) {
                          return CreateChatListItem(
                            firstName: widget.friends[index]
                                .firstName, //friends[index].firstName,
                            lastName: widget.friends[index]
                                .lastName, //friends[index].lastName,
                          );
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
