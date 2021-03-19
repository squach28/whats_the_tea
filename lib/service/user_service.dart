import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_the_tea/model/basic_user.dart';
import 'package:whats_the_tea/model/channel.dart';
import 'package:whats_the_tea/model/user.dart' as m;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class UserService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // create instance of firestore
  final FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();

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
  void addFriend(BasicUserInfo currentUser, BasicUserInfo friendToAdd) async {
    CollectionReference users = firestore.collection('users');
    List<Map<String, dynamic>> friendToAddInfo = [friendToAdd.toJson()];
    List<Map<String, dynamic>> currentUserInfo = [currentUser.toJson()];

    // add each user to each other friend's list
    await users
        .doc(auth.currentUser.uid)
        .update({'friends': FieldValue.arrayUnion(friendToAddInfo)});
    await users
        .doc(friendToAdd.uid)
        .update({'friends': FieldValue.arrayUnion(currentUserInfo)});
  }

  // send a friend request
  // takes two params: the sender and the recipientuid
  void sendFriendRequest(BasicUserInfo sender, BasicUserInfo recipient) async {
    CollectionReference users = firestore.collection('users');

    // update the recipient's list of friend requests with the sender's info
    await users.doc(recipient.uid).update({
      'friendRequests': FieldValue.arrayUnion([sender.toJson()])
    });

    await users.doc(auth.currentUser.uid).update({
      'friendRequestsSent': FieldValue.arrayUnion([recipient.toJson()])
    });
  }

  // accepts a friend request
  // takes the user who sent the friend request as a param
  void acceptFriendRequest(BasicUserInfo friendRequest) async {
    BasicUserInfo currentUserInfo = await getUserInfo(auth.currentUser.uid);
    // remove the user from the list of friend requests
    await firestore.collection('users').doc(auth.currentUser.uid).update({
      'friendRequests': FieldValue.arrayRemove([friendRequest.toJson()])
    });

    await firestore.collection('users').doc(friendRequest.uid).update({
      'friendRequestsSent': FieldValue.arrayRemove([currentUserInfo.toJson()])
    });

    // add the user to the list of friends
    await firestore.collection('users').doc(auth.currentUser.uid).update({
      'friends': FieldValue.arrayUnion([friendRequest.toJson()])
    });

    await firestore.collection('users').doc(friendRequest.uid).update({
      'friends': FieldValue.arrayUnion([currentUserInfo.toJson()])
    });
  }

  // fetch the user's friends
  // param is the uid to search
  Future<List<BasicUserInfo>> fetchFriends(String uid) async {
    List<BasicUserInfo> friendsList = []; // initalize empty list of friends
    // look into database for the list of friends
    Stream<DocumentSnapshot> snapshot =
        firestore.collection('users').doc(auth.currentUser.uid).snapshots();
    print('fetching friends!!!');
    await snapshot.first.then((value) {
      var friends = value.data()['friends'];
      for (var friend in friends) {
        var friendInfo = BasicUserInfo.fromJson(friend);
        print(friendInfo.firstName + ' ' + friendInfo.lastName);
        friendsList.add(friendInfo);
      }
    });
    return friendsList;
  }

  // get information about current user from firestore
  // takes param uid: user to check info for
  Future<BasicUserInfo> getUserInfo(String uid) async {
    String firstName = '';
    // get first name from firestore
    await firestore.collection('users').doc(uid).get().then((value) {
      firstName = value.data()['firstName'];
    });
    String lastName = '';
    // get last name from
    await firestore.collection('users').doc(uid).get().then((value) {
      lastName = value.data()['lastName'];
    });
    String profilePictureURL = '';
    await firestore.collection('users').doc(uid).get().then((value) {
      profilePictureURL = value.data()['profilePictureURL'];
    });

    return BasicUserInfo(uid, firstName, lastName, profilePictureURL);
  }

  Future<String> getProfilePicture(String uid) async {
    String profilePictureURL = '';
    await firestore.collection('users').doc(uid).get().then((value) {
      return value.data()['profilePictureURL'];
    });
  }

  void updateProfilePicture(String uid, String downloadURL) async {
    await firestore
        .collection('users')
        .doc(uid)
        .update({'profilePictureURL': downloadURL});
  }

  void uploadImage() async {
    PickedFile image;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      image = await picker.getImage(source: ImageSource.gallery);

      if (image == null) {
        return;
      }
      var file = File(image.path);

      if (image != null) {
        var snapshot = await storage
            .ref()
            .child(
                'profilePictures/' + auth.currentUser.uid + '/profilePicture')
            .putFile(file);
        String downloadURL = await storage
            .ref()
            .child(
                'profilePictures/' + auth.currentUser.uid + '/profilePicture')
            .getDownloadURL();
        updateProfilePicture(auth.currentUser.uid, downloadURL);
        auth.currentUser.updateProfile(
          photoURL: downloadURL,
        );
      }
    }
  }
}
