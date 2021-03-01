import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/view/settings.dart';
import 'package:whats_the_tea/view/chat_list.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();
  final List<Widget> children = [ChatListPage(), SettingsPage()];
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
      backgroundColor: Color(0xffbcfdc9),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
