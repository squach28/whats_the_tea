import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/view/me_page.dart';
import 'package:whats_the_tea/view/chat_list.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final UserService userService = UserService();
  final List<Widget> children = [ChatListPage(), MePage()];
  int currentIndex = 0;

  // display chats
  // widget for user chat


  void onTabTapped(int index) {
    print('tab tapped!');
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffece6d6),
      body: children[currentIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(primaryColor: Theme.of(context).accentColor),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Me'
            ),
          ],
          currentIndex: currentIndex,
          onTap: onTabTapped,
        ),
      ),
    );
  }
}
