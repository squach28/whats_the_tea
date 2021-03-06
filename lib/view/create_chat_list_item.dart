import 'package:whats_the_tea/view/channel_room.dart';
import 'package:flutter/material.dart';

class CreateChatListItem extends StatefulWidget {
  final String firstName;
  final String lastName;
  final bool isSelected;

  CreateChatListItem({Key key, this.firstName, this.lastName, this.isSelected})
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
                            widget.firstName + ' ' + widget.lastName,
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
