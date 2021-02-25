import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/view/sign_up.dart';
import 'package:whats_the_tea/model/sign_in_result.dart';
import 'package:whats_the_tea/view/home_page.dart';

class SignInPage extends StatefulWidget {
  SignInPage({
    Key key,
  }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final auth = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  // validates an inputted string and returns true if the string is a valid email
  // returns false if the inputted string is not a valid email
  bool validateEmail(String email) {
    RegExp validEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return validEmail.hasMatch(email); // check if email is valid
  }

  // validates the fields in the sign up page
  SignInResult validateFields(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return SignInResult.EMPTY_FIELD;
    } else if (!validateEmail(email)) {
      return SignInResult.INVALID_EMAIL;
    } else {
      return SignInResult.SUCCESS;
    }
  }

  void showAlert(SignInResult signInResult) {
    switch (signInResult) {
      case SignInResult.EMPTY_FIELD:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Empty Field(s)'),
                content: Text('One or more of the fields is empty'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
        break;

      case SignInResult.INVALID_EMAIL:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid Email'),
                content: Text('The email entered is invalid'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
        break;

      default:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Something went wrong, please try again'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color.fromARGB(255, 250, 208, 196),
                Color.fromARGB(255, 241, 167, 241)
              ])),
          child: SafeArea(
            minimum: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 150.0, bottom: 10.0),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Caveat'),
                  ),
                ),
                Column(children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Color.fromARGB(255, 46, 25, 118)),
                    child: TextField(
                      focusNode: emailFocus,
                      controller: emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 46, 25, 118),
                              width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Theme(
                    data: Theme.of(context).copyWith(
                        primaryColor: Color.fromARGB(255, 46, 25, 118)),
                    child: TextField(
                      focusNode: passwordFocus,
                      controller: passwordController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 46, 25, 118),
                              width: 2.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                ]),
                SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: OutlinedButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 154, 162)),
                        elevation: MaterialStateProperty.all<double>(10.0),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25.0))),
                      ),
                      onPressed: () {
                        final String email = emailController.text.trim();
                        final String password = passwordController.text.trim();

                        SignInResult signInResult =
                            validateFields(email, password);

                        if (signInResult != SignInResult.SUCCESS) {
                          showAlert(signInResult);
                        } else {
                          auth.signIn(email, password);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()));
                        }
                      }),
                ),
                SizedBox(height: 40.0),
                TextButton(
                    child: Text("Don't have an Account? Sign up here"),
                    onPressed: () {
                      if (emailFocus.hasFocus) {
                        emailFocus.unfocus();
                      } else if (passwordFocus.hasFocus) {
                        passwordFocus.unfocus();
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
