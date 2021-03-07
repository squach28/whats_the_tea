import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_the_tea/view/friend_request_item.dart';

// page that contains the list of friend requests a user has
class FriendRequestsPage extends StatefulWidget {
  @override
  FriendRequestsPageState createState() => FriendRequestsPageState();
}

class FriendRequestsPageState extends State<FriendRequestsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: SafeArea(
            minimum: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Friend Requests', style: TextStyle(fontSize: 40.0)),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(auth.currentUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            print('wack');
                            List<dynamic> friendRequests =
                                snapshot.data['friendRequests'];

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: friendRequests.length,
                                itemBuilder: (context, index) {
                                  var friendRequest = friendRequests[index];
                                  var friendRequestInfo = friendRequest.fromJson();
                                  return FriendRequestItem(
                                      friendRequestInfo: friendRequestInfo);
                                });
                          }
                        }))
              ],
            )),
      ),
    );
  }
}
