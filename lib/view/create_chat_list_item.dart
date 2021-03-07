import 'package:whats_the_tea/model/basic_user.dart';
import 'package:flutter/material.dart';

class CreateChatListItem extends StatefulWidget {
  final BasicUserInfo friendInfo;
  final bool isSelected;

  CreateChatListItem({Key key, this.friendInfo, this.isSelected})
      : super(key: key);

  @override
  CreateChatListItemState createState() => CreateChatListItemState();
}

class CreateChatListItemState extends State<CreateChatListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xfffdcece),
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
                            widget.friendInfo.firstName + ' ' + widget.friendInfo.lastName,
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
              child: widget.isSelected == true
                  ? Icon(Icons.check)
                  : Container(height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
