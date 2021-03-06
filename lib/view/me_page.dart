import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/view/find_people.dart';
import 'package:whats_the_tea/view/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/view/friends.dart';
import 'package:whats_the_tea/view/settings.dart';

class MePage extends StatefulWidget {
  @override
  MePageState createState() => MePageState();
}

class MePageState extends State<MePage> {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffece6ff),
      body: SafeArea(
          minimum: EdgeInsets.all(5.0),
          child: Center(
              child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/tyler.jpg'),
                        ),
                      ),
                      Text(authService.auth.currentUser.displayName,
                          style: TextStyle(fontSize: 25.0)),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: OutlinedButton(
                        child: Text(
                          'Friends',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                             // Color.fromARGB(255, 255, 154, 162)),
                                                            const Color(0xff8060e6)),
                          elevation: MaterialStateProperty.all<double>(10.0),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(25.0))),
                        ),
                        onPressed: () async {
                          print('pressed!');
                          var friendsList = await userService
                              .fetchFriends(auth.currentUser.uid);
                          print(friendsList.length);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FriendsPage(friends: friendsList)));
                        }),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextButton(
                        child: Text(
                          'Find People',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FindPeoplePage()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                             // Color.fromARGB(255, 255, 154, 162)),
                                                            const Color(0xff8060e6)),
                          elevation: MaterialStateProperty.all<double>(10.0),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(25.0))),
                        ),
                      ))),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextButton(
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SettingsPage()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                             // Color.fromARGB(255, 255, 154, 162)),
                                                            const Color(0xff8060e6)),
                          elevation: MaterialStateProperty.all<double>(10.0),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(25.0))),
                        ),
                      ))),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextButton(
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                               // Color.fromARGB(255, 255, 154, 162)),
                               const Color(0xff8060e6)),
                            elevation: MaterialStateProperty.all<double>(10.0),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0))),
                          ),
                          onPressed: () {
                            authService.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignInPage()));
                          })))
            ],
          ))),
    );
  }
}
