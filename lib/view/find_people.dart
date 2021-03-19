import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/friend_status.dart';
import 'package:whats_the_tea/view/user_list_item.dart';
import 'package:whats_the_tea/service/user_service.dart';

// page that allows the user to find other users on the app
// friend statuses are shown based on the current user
// friend requests can be made
class FindPeoplePage extends StatefulWidget {
  @override
  FindPeoplePageState createState() => FindPeoplePageState();
}

class FindPeoplePageState extends State<FindPeoplePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
  }

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
                              return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(auth.currentUser.uid)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong :((');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      List<BasicUserInfo> friends = [];
                                      List<BasicUserInfo> friendRequests = [];
                                      List<BasicUserInfo> friendRequestsSent =
                                          [];
                                      Map<String, dynamic> data =
                                          snapshot.data.data();
                                      for (var friend in data['friends']) {
                                        BasicUserInfo friendInfo =
                                            BasicUserInfo(
                                                friend['uid'],
                                                friend['firstName'],
                                                friend['lastName'],
                                                friend['profilePictureURL'],
                                                );
                                        friends.add(friendInfo);
                                      }

                                      for (var friendRequest
                                          in data['friendRequests']) {
                                        BasicUserInfo friendRequestInfo =
                                            BasicUserInfo(
                                                friendRequest['uid'],
                                                friendRequest['firstName'],
                                                friendRequest['lastName'],
                                                friendRequest['profilePictureURL']);
                                        friendRequests.add(friendRequestInfo);
                                      }

                                      for (var friendRequestSent
                                          in data['friendRequestsSent']) {
                                        BasicUserInfo friendRequestSentInfo =
                                            BasicUserInfo(
                                                friendRequestSent['uid'],
                                                friendRequestSent['firstName'],
                                                friendRequestSent['lastName'],
                                                friendRequestSent['profilePictureURL']);
                                        friendRequestsSent
                                            .add(friendRequestSentInfo);
                                      }

                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot ds = items[index];

                                            if (items[index].data()['uid'] ==
                                                auth.currentUser.uid) {
                                              return SizedBox(
                                                  width: 0, height: 0);
                                            } else {
                                              FriendStatus friendStatus =
                                                  FriendStatus.NOT_FRIENDS;

                                              BasicUserInfo user =
                                                  BasicUserInfo(
                                                      ds.data()['uid'],
                                                      ds.data()['firstName'],
                                                      ds.data()['lastName'],
                                                      ds.data()['profilePictureURL']);

                                              if (friends.contains(user)) {
                                                friendStatus =
                                                    FriendStatus.FRIENDS;
                                              }

                                              if(friendRequests.contains(user)) {
                                                friendStatus = FriendStatus.INCOMING_FRIEND_REQUEST;
                                              }

                                              if (friendRequestsSent
                                                  .contains(user)) {
                                                friendStatus = FriendStatus
                                                    .FRIEND_REQUEST_SENT;
                                              }

                                              BasicUserInfo userInfo =
                                                  BasicUserInfo(
                                                ds.data()['uid'],
                                                ds.data()['firstName'],
                                                ds.data()['lastName'],
                                                ds.data()['profilePictureURL'],
                                              );

                                              return UserListItem(
                                                  userInfo: userInfo,
                                                  friendStatus: friendStatus);
                                            }
                                          });
                                    }

                                    return Center(child: Text('Loading (☞ﾟ∀ﾟ)☞'));
                                  });
                            }
                          }),
                    ]))));
  }
}
