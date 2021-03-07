import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/user.dart' as m;
import 'package:flutter/widgets.dart';

class UserService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // create instance of firestore
  final FirebaseAuth auth = FirebaseAuth.instance;

  // creates a user and stores it in firestore
  Future<void> createUserProfile(m.User user) {
    CollectionReference users = firestore.collection('users');

    // set the document as the user's uID
    return users
        .doc(user.uid)
        .set(user.toJson())
        .then((value) => print('User added!'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  // adds a user to a friend's list
  // also adds the current user to the friend's list
  // takes 2 params, the currentuser who initiated friend request and the requested friend
  void addFriend(BasicUserInfo currentUser, BasicUserInfo friendToAdd) {
    CollectionReference users = firestore.collection('users');
    List<Map<String, dynamic>> friendToAddInfo = [friendToAdd.toJson()];
    List<Map<String, dynamic>> currentUserInfo = [currentUser.toJson()];

    users
        .doc(auth.currentUser.uid)
        .update({'friends': FieldValue.arrayUnion(friendToAddInfo)});
    users
        .doc(friendToAdd.uid)
        .update({'friends': FieldValue.arrayUnion(currentUserInfo)});
  }

  // send friend request
  void sendFriendRequest(BasicUserInfo sender, String recipientuid) {
    CollectionReference users = firestore.collection('users');
    List<Map<String, dynamic>> senderInfo = [sender.toJson()];

    users
        .doc(recipientuid)
        .update({'friendRequests': FieldValue.arrayUnion(senderInfo)});
  }

  void acceptFriendRequest(BasicUserInfo friendRequest) async {
    await firestore.collection('users').doc(auth.currentUser.uid).update({
      'friendRequests': FieldValue.arrayRemove([friendRequest.toJson()])
    });

    await firestore.collection('users').doc(auth.currentUser.uid).update({
      'friends': FieldValue.arrayUnion([friendRequest.toJson()])
    });
  }

  Future<List<BasicUserInfo>> fetchFriends(String uid) async {
    List<BasicUserInfo> friendsList = [];

    await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      // value is representation of the user document
      for (var friend in value['friends']) {
        BasicUserInfo friendInfo = BasicUserInfo(
            friend['uID'], friend['firstName'], friend['lastName']);
        friendsList.add(friendInfo);
        print('added!');
      }
    });
    return friendsList;
  }

// get the current user's channels
// TODO use a stream to keep track of changes in channels
  Future<List<BasicUserInfo>> fetchChannels(String uid) async {
    var doc = await firestore.collection('users').doc(uid).get();
    List<BasicUserInfo> friends = [];
    for (var thing in doc.data().values.elementAt(0)) {
      var json = jsonEncode(thing); // list instead of map?
      Map<String, dynamic> decoded = jsonDecode(json);
    }

    return friends;
  }

  Future<BasicUserInfo> getCurrentUserInfo(String uid) async {
    String firstName = '';
    await firestore.collection('users').doc(uid).get().then((value) {
      firstName = value.data()['firstName'];
    });
    String lastName = '';
    await firestore.collection('users').doc(uid).get().then((value) {
      lastName = value.data()['lastName'];
    });

    return BasicUserInfo(uid, firstName, lastName);
  }

  // gets the first name of the current user
  Future<String> getFirstName(String uid) async {
    String firstName = '';
    await firestore.collection('users').doc(uid).get().then((value) {
      firstName = value.data()['firstName'];
      print('in function: ' + firstName);
    });
    print('before return: ' + firstName);
    return firstName;
  }

  // gets the last name of the current user
  Future<String> getLastName(String uid) async {
    String lastName = '';
    await firestore.collection('users').doc(uid).get().then((value) {
      lastName = value.data()['lastName'];
    });

    return lastName;
  }
}
