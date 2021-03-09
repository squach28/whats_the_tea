import 'package:flutter/material.dart';
import 'package:whats_the_tea/view/sign_in.dart';
import 'package:whats_the_tea/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffece6ff),
        accentColor: const Color(0xff8060e6),
        fontFamily: 'OpenSans',
      ),
      home:
          FirebaseAuth.instance.currentUser != null ? HomePage() : SignInPage(),
    );
  }
}
