import 'package:whats_the_tea/model/basic_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/model/channel.dart';
import 'package:whats_the_tea/model/message.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // sends a message into the specified channel
  Future<void> sendMessage(String content, String senderID, String channelID) {
    // create the message with the senderID, content, and channelID
    Message message = Message(
      senderID,
      channelID,
      content,
      DateTime.now(),
    );

    return firestore.collection('channels').doc(channelID).update({
      'messages': FieldValue.arrayUnion([message.toJson()])
    });
  }

  // creates a chat channel with a list of participants
  // chanel id will be added to both participants' lists of chat channels
  Future<Channel> createChannel(List<BasicUserInfo> participants) async {
    DocumentReference firestoreChannel = firestore
        .collection('channels')
        .doc(); // create a new document for the channel
    String channelID =
        firestoreChannel.id; // store the newly created document id
    CollectionReference users =
        firestore.collection('users'); // reference to users
    CollectionReference channels =
        firestore.collection('channels'); // reference to channels
    // add the newly created channel to the participants' list of channels
    for (BasicUserInfo participant in participants) {
      users.doc(participant.uid).update({
        'channels': FieldValue.arrayUnion([channelID])
      });
    }

    List<Map<String, dynamic>> participantsAsJson =
        []; // list to store the participants in json format
    // format all participants in json format
    for (var participant in participants) {
      participantsAsJson.add(participant.toJson());
    }

    // add channel to collection of channels
    channels.doc(channelID).set({
      'channelID': channelID,
      'participants': participantsAsJson,
      'messages': []
    });
    return Channel(
        channelID, participants, []); // return the newly created channel
  }
}
