import 'package:flutter/material.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/friend_status.dart';
import 'package:whats_the_tea/view/friend_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/view/user_list_item.dart';

// page that shows a user's friends
// top of the page will allow user to see incoming friend requests
class FriendsPage extends StatefulWidget {
  final List<BasicUserInfo> friends;

  FriendsPage({Key key, this.friends}) : super(key: key);
  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xfffbfcf7),
      body: SafeArea(
          minimum: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(auth.currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            List<dynamic> friendRequests =
                                snapshot.data['friendRequests'];
                            int numOfFriendRequests = friendRequests.length;

                            if (friendRequests.length == 0) {
                              return SizedBox(height: 0, width: 0);
                            } else if (friendRequests.length == 1) {
                              return Center(
                                  child: TextButton(
                                      child: Text(
                                          '$numOfFriendRequests incoming friend request'),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        FriendRequestsPage()));
                                      }));
                            } else {
                              return Center(
                                  child: TextButton(
                                      child: Text(
                                          '$numOfFriendRequests incoming friend requests'),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        FriendRequestsPage()));
                                      }));
                            }
                          }
                        }),
                    Padding(
                      child: Text('Friends', style: TextStyle(fontSize: 50.0)),
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(auth.currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            print('wack');
                            List<dynamic> friends = snapshot.data['friends'];

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                  var friendRequest = friends[index];
                                  BasicUserInfo friendRequestInfo =
                                      BasicUserInfo(
                                    friendRequest['uid'],
                                    friendRequest['firstName'],
                                    friendRequest['lastName'],
                                  );
                                  return UserListItem(
                                      userInfo: friendRequestInfo,
                                      friendStatus: FriendStatus.FRIENDS);
                                });
                          }
                        })
                  ],
                ),
              ))),
    );
  }
}
