import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/friend_status.dart';

// represents an incoming friend request item
class FriendRequestItem extends StatefulWidget {
  final BasicUserInfo friendRequestInfo;

  FriendRequestItem({Key key, this.friendRequestInfo})
      : super(key: key);

  @override
  FriendRequestItemState createState() => FriendRequestItemState();
}

class FriendRequestItemState extends State<FriendRequestItem> {
  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget initFriendStatusWidget(FriendStatus friendStatus) {
    switch (friendStatus) {
      case FriendStatus.NOT_FRIENDS:
        {
          return TextButton(
              child: Text('Add Friend'),
              onPressed: () async {
                /*
                final String firstName =
                    await userService.getUserInfo(auth.currentUser.uid).then((value) => value.firstName);
                final String lastName =
                    await userService.getUserInfo(auth.currentUser.uid).then((value) => value.lastName); */
                final BasicUserInfo currentUserInfo = await userService.getUserInfo(auth.currentUser.uid);
                print('first name: ' + currentUserInfo.firstName);
                //BasicUserInfo currentUserInfo =
                //    BasicUserInfo(auth.currentUser.uid, firstName, lastName);
                userService.sendFriendRequest(currentUserInfo, widget.friendRequestInfo);
              });
        }

      case FriendStatus.FRIEND_REQUEST_SENT:
        {
          return Text('Friend Request Sent!');
        }

      case FriendStatus.FRIENDS:
        {
          return Text('Friend');
        }

      default:
        {
          return SizedBox(width: 0, height: 0);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    //backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.friendRequestInfo.firstName + ' ' + widget.friendRequestInfo.lastName,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                child: Row(
              children: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            CircleBorder())),
                    child: IconTheme(
                        data: IconThemeData(color: Colors.white),
                        child: Icon(Icons.check)),
                    onPressed: () {
                      BasicUserInfo friendRequest = BasicUserInfo(
                        widget.friendRequestInfo.uid,
                        widget.friendRequestInfo.firstName,
                        widget.friendRequestInfo.lastName,
                        widget.friendRequestInfo.profilePictureURL,
                      );
                      userService.acceptFriendRequest(friendRequest);
                    }),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            CircleBorder())),
                    child: IconTheme(
                        data: IconThemeData(color: Colors.white),
                        child: Icon(Icons.cancel_sharp)),
                    onPressed: () {}),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
