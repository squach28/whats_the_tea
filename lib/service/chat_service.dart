import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        .collection('messages')
        .add(message.toJson());
  }

  // creates a chat channel with a list of participants
  // chanel id will be added to both participants' lists of chat channels
  Future<void> createChannel(List<BasicUserInfo> participants) async {
    String channelID = firestore.collection('channels').doc().id;

    List<String> channelIDAsList = [channelID];

    CollectionReference users = firestore.collection('users');

    for (BasicUserInfo participant in participants) {
      await users.where('uid', isEqualTo: participant.uid).get().then((value) {
        for (QueryDocumentSnapshot queries in value.docs) {
          queries.reference
              .update({'channels': FieldValue.arrayUnion(channelIDAsList)});
        }
      });
    }
    return channelID;
  }
}
