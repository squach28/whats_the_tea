import 'dart:convert';

import 'package:whats_the_tea/model/basic_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/model/channel.dart';
import 'package:whats_the_tea/model/message.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String content, String senderID, String channelID) {
    // create a new channel if no messages have been sent
    // else send to the channel between the users
    // user needs a reference of the room and the ids

    Message message = Message(
      senderID,
      channelID,
      content,
      DateTime.now(),
    );

    return firestore
        .collection('channels')
        .doc(channelID)
        .update({'messages': FieldValue.arrayUnion([message.toJson()])});
  }

  // creates a chat channel with a list of participants
  // chanel id will be added to both participants' lists of chat channels
  Future<Channel> createChannel(List<BasicUserInfo> participants) async {
    DocumentReference firestoreChannel = firestore.collection('channels').doc();
    String channelID = firestoreChannel.id;

    print('channel id: ' + channelID);
    CollectionReference users = firestore.collection('users');

    CollectionReference channels = firestore.collection('channels');
    for (BasicUserInfo participant in participants) {
      print('uid: ' + participant.uid);
      users.doc(participant.uid).update({
        'channels': FieldValue.arrayUnion([channelID])
      });
    }
    Channel channel = Channel(channelID, participants, []);

    List<Map<String, dynamic>> participantsAsJson = [];
    for (var participant in participants) {
      participantsAsJson.add(participant.toJson());
    }

    channels.doc(channelID).set({
      'channelID': channelID,
      'participants': participantsAsJson,
      'messages': []
    });
    return Channel(channelID, participants, []);
  }
}
