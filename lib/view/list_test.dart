import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/chat_list_item.dart';

class ListTest extends StatelessWidget {
  final items = List<String>.generate(1000, (i) => "Item$i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ChatListItem();
          })),
    );
  }
}
