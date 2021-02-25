import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/model/user.dart';

class DatabaseController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // create instance of firestore

  // creates a user and stores it in firestore
  Future<void> createUserProfile(User user) {
    CollectionReference users = firestore.collection('users');

    // set the document as the user's uID
    return users
        .doc(user.uID)
        .set(user.toJson())
        .then((value) => print('User added!'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  // adds a user to a friend's list
  Future<void> addFriend(User user, User friendToAdd) {
    CollectionReference users = firestore.collection('users');
  }

  // send friend request
  Future<void> sendFriendRequest(User sender, User recipient) {}
}
