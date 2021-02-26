import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/user.dart' as m;

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
  Future<void> addFriend(BasicUserInfo currentUser, BasicUserInfo friendToAdd) {
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
  Future<void> sendFriendRequest(User sender, User recipient) {
    
  }
}
