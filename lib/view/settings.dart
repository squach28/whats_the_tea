import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/view/sign_in.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.all(5.0),
          child: Center(
              child: Column(
            children: [
              TextButton(child: Text('Profile'), onPressed: () {}),
              TextButton(child: Text('Friends'), onPressed: () {}),
              TextButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    authService.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SignInPage()));
                  })
            ],
          ))),
    );
  }
}
