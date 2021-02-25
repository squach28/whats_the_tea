import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/model/user.dart' as m;

// class that handles authentication for sign in and login
class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final DatabaseController databaseController = DatabaseController();

  // signs the user in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        print('no user found for that email');
      } else if (e.code == 'wrong-password') {
        print('wrong password provided for the user');
      } else {
        print('error: ' + e.code);
      }
    } on PlatformException catch (error) {
      print(error.message);
    }
  }

  // signs the user up for an account with email and password
  Future<void> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a user
      m.User user = m.User(
        auth.currentUser.uid, // uid taken from auth
        firstName,
        lastName,
        [],
        [], // empty list of friends on user creation
      );

      // create user profile an store in firestore
      databaseController.createUserProfile(user);

      print('successfully created account!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('the password is too weak');
      } else if (e.code == 'email-already-in-use') {
        print('email is already in use');
      }
    }
  }

  Future<void> signOut() {
    return auth.signOut();
  }
}
