import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/friend_status.dart';

// represents a widget about a user's info as an item
// used in the Find People page
class UserListItem extends StatefulWidget {
  final BasicUserInfo userInfo;
  final FriendStatus friendStatus;

  UserListItem(
      {Key key, this.userInfo, this.friendStatus})
      : super(key: key);

  @override
  UserListItemState createState() => UserListItemState();
}

class UserListItemState extends State<UserListItem> {
  final UserService userService = UserService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget initFriendStatusWidget(FriendStatus friendStatus) {
    switch (friendStatus) {
      case FriendStatus.NOT_FRIENDS:
        {
          return TextButton(
              child: Text('Add Friend'),
              onPressed: () async {

                BasicUserInfo currentUserInfo = await userService.getUserInfo(auth.currentUser.uid);
                    
                userService.sendFriendRequest(currentUserInfo, widget.userInfo); 
              });
        }

        case FriendStatus.FRIEND_REQUEST_SENT: {
          return Text('Friend Request Sent!');
        }

        case FriendStatus.INCOMING_FRIEND_REQUEST: {
          return Text('Incoming Friend Request!');
        }

        case FriendStatus.FRIENDS: {
          return Text('Friend');
        }

        default: {
          return SizedBox(width:0, height: 0);
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
                            widget.userInfo.firstName + ' ' + widget.userInfo.lastName,
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
              child: initFriendStatusWidget(widget.friendStatus),
            ),
          ],
        ),
      ),
    );
  }
}
