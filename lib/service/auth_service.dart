import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:whats_the_tea/model/sign_in_result.dart';
import 'package:whats_the_tea/model/sign_up_result.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/model/user.dart' as m;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

// class that handles authentication for sign in and login
class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final UserService userService = UserService();

  final storage = firebase_storage.FirebaseStorage.instance;

  // signs the user in with email and password
  Future<SignInResult> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SignInResult.SUCCESS;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        // user doesn't exist
        print('no user found for that email');
        return SignInResult.USER_NOT_FOUND;
      } else if (e.code == 'wrong-password') {
        // wrong password entered
        print('wrong password provided for the user');
        return SignInResult.WRONG_PASSWORD;
      } else {
        // other source of auth fail
        print('error: ' + e.code);
        return SignInResult.FAIL;
      }
    } on PlatformException catch (error) {
      // platform exception handling
      print(error.message);
      return SignInResult.FAIL;
    }
  }

  // signs the user up for an account with email and password
  Future<SignUpResult> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        value.user.updateProfile(
            displayName:
                firstName + ' ' + lastName); // set the user's name in auth

        value.user.updateProfile(photoURL: await downloadURL());
        return;


      });

      // create a user
      m.User user = m.User(
        auth.currentUser.uid, // uid taken from auth
        firstName,
        lastName,
        await downloadURL(), // TODO profile picture url goes here
        [], // empty list of friends
        [], // empty list of channels
        [],
        [], // empty list of friend requests
      );

      // create user profile in firestore
      userService.createUserProfile(user);

      return SignUpResult.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // weak password, must be 6 characters or longer
        print('the password is too weak');
        return SignUpResult.WEAK_PASSWORD;
      } else if (e.code == 'email-already-in-use') {
        // email already in database
        print('email is already in use');
        return SignUpResult.EMAIL_IN_USE;
      } else {
        // other source of auth fail
        return SignUpResult.FAIL;
      }
    } on PlatformException catch (e) {
      // platform exception handling
      print(e.message);
      return SignUpResult.FAIL;
    }
  }

  Future<void> uploadProfilePicture(String filePath, String uid) async {

    File file = File(filePath);

    firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
      customMetadata: <String, String> {
        'uid': uid,
      },
      );

      try {
        await firebase_storage.FirebaseStorage.instance.ref('uploads/file-to-upload.png').putFile(file, metadata);
      } on FirebaseException catch(e) {
        print(e.message);
      }
  }
  
  Future<String> downloadURL() async {
    String downloadURL = await storage.ref('profilePictures/kevin.the.shiba.jpg').getDownloadURL();
    return downloadURL;
  }

  // signs the user out of the current session
  Future<void> signOut() {
    try {
      return auth.signOut();
    } on FirebaseAuthException catch (e) {
      // auth exception
      print(e.message);
    }
  }
}
