import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/view/find_people.dart';
import 'package:whats_the_tea/view/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/view/friends.dart';
import 'package:whats_the_tea/view/settings.dart';

// page that includes options for the user to see friends, find people, adjust settings, and sign out
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
      backgroundColor: Colors.white70,
      body: SafeArea(
          minimum: EdgeInsets.all(5.0),
          child: Center(
              child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: auth.userChanges(),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            User currentUser = snapshot.data;
                            print('photoURL: ' + currentUser.photoURL);
                            return Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    userService.uploadImage();
                                  },
                                  child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          currentUser.photoURL)),
                                ));
                          }),
                      Text(authService.auth.currentUser.displayName,
                          style: TextStyle(fontSize: 25.0)),
                    ],
                  )),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(auth.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: OutlinedButton(
                                child: Text(
                                  'Friends',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor),
                                  elevation:
                                      MaterialStateProperty.all<double>(10.0),
                                  shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
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
                                              FriendsPage(
                                                  friends: friendsList)));
                                }),
                          ));
                    } else {
                      List<dynamic> friendRequests =
                          snapshot.data['friendRequests'];
                      return Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: OutlinedButton(
                                child: friendRequests.isEmpty
                                    ? Text('Friends',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                        ))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            Text('Friends',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                )),
                                            SizedBox(width: 10.0),
                                            Text('!',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                )),
                                          ]),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor),
                                  elevation:
                                      MaterialStateProperty.all<double>(10.0),
                                  shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
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
                                              FriendsPage(
                                                  friends: friendsList)));
                                }),
                          ));
                    }
                  }),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextButton(
                        child: Text(
                          'Find People',
                          style: TextStyle(
                            color: Colors.black,
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
                              Theme.of(context).primaryColor),
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
                            color: Colors.black,
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
                              Theme.of(context).primaryColor),
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                // Color.fromARGB(255, 255, 154, 162)),
                                Theme.of(context).primaryColor),
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
