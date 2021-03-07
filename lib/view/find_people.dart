import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/friend_status.dart';
import 'package:whats_the_tea/view/user_list_item.dart';
import 'package:whats_the_tea/service/user_service.dart';

class FindPeoplePage extends StatefulWidget {
  @override
  FindPeoplePageState createState() => FindPeoplePageState();
}

class FindPeoplePageState extends State<FindPeoplePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: const Color(0xffece6ff),
        ),
        body: Container(
            child: SafeArea(
                minimum: EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Find People',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: TextField()),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              List<QueryDocumentSnapshot> items =
                                  snapshot.data.docs;
                              
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot ds =
                                        snapshot.data.docs[index];
                                    
                                    if (ds.data()['uid'] ==
                                        auth.currentUser.uid) {
                                      return SizedBox(height: 0, width: 0);
                                    } else {
                                      FriendStatus friendStatus = FriendStatus.NOT_FRIENDS;
                                      var friends = ds.data()['friends'];
                                      var friendRequests =
                                          ds.data()['friendRequests'];
                                      for (var friend in friends) {
                                        print(friend['uid']);
                                        if (friends.contains(friend['uid'])) {
                                          friendStatus = FriendStatus.FRIENDS;
                                        }
                                      }

                                      for (var friendRequest
                                          in friendRequests) {
                                        if (friendRequest['uid'] ==
                                            auth.currentUser.uid) {
                                          friendStatus =
                                              FriendStatus.FRIEND_REQUEST_SENT;
                                        }
                                      }

                                      return UserListItem(
                                          uid: ds.data()['uid'],
                                          firstName: ds.data()['firstName'],
                                          lastName: ds.data()['lastName'],
                                          friendStatus: friendStatus);
                                    }
                                  });
                            }
                          }),
                    ]))));
  }
}
