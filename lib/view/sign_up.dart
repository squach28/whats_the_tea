import 'package:whats_the_tea/model/sign_up_result.dart';
import 'package:flutter/material.dart';
import 'package:whats_the_tea/service/auth_service.dart';
import 'package:whats_the_tea/service/user_service.dart';
import 'package:whats_the_tea/view/home_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({
    Key key,
  }) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final auth = AuthService(); // service to handle authentication
  final userService = UserService(); // service to handle firestore requests

  // validates an inputted string and returns true if the string is a valid email
  // returns false if the inputted string is not a valid email
  bool validateEmail(String email) {
    RegExp validEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return validEmail.hasMatch(email); // check if email is valid
  }

  // validates the fields in the sign up page
  // returns a SignUpResult based on the fields
  SignUpResult validateFields(String firstName, String lastName, String email,
      String password, String confirmPassword) {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return SignUpResult.EMPTY_FIELD;
    } else if (!validateEmail(email)) {
      return SignUpResult.INVALID_EMAIL;
    } else if (password != confirmPassword) {
      return SignUpResult.UNMATCHED_PASSWORDS;
    } else if (password.length < 6 || confirmPassword.length < 6) {
      return SignUpResult.WEAK_PASSWORD;
    } else {
      return SignUpResult.SUCCESS;
    }
  }

  // display an alert based on a SignUpResult
  void showAlert(SignUpResult signUpResult) {
    switch (signUpResult) {
      case SignUpResult.EMPTY_FIELD:
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

      case SignUpResult.INVALID_EMAIL:
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

      case SignUpResult.UNMATCHED_PASSWORDS:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Unmatched Passwords'),
                content: Text('The entered passwords do not match'),
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

      case SignUpResult.WEAK_PASSWORD:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Weak Password'),
                content: Text('Your password must be 6 characters or longer'),
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

      case SignUpResult.EMAIL_IN_USE:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Email in Use'),
                content: Text('Please use a different email to sign up'),
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

  Future<bool> signUp() async {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    SignUpResult result =
        validateFields(firstName, lastName, email, password, confirmPassword);
    FocusManager.instance.primaryFocus.unfocus();
    if (result != SignUpResult.SUCCESS) {
      print('oh no');
      showAlert(result);
      return false;
    } else {
      SignUpResult signUpResult =
          await auth.signUp(email, password, firstName, lastName);
      if (signUpResult != SignUpResult.SUCCESS) {
        showAlert(signUpResult);
        return false;
      } else {
        print('yay!!!!');
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 236, 210),
                Color.fromARGB(255, 252, 182, 159)
              ]),
        ),
      ),
      SingleChildScrollView(
          child: SafeArea(
        minimum: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 20.0),
              child: Text(
                // title at the top
                'Sign Up',
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Caveat'),
              ),
            ),
            Column(children: <Widget>[
              Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Color.fromARGB(255, 46, 25, 118)),
                child: TextField(
                  // first name text field
                  textCapitalization: TextCapitalization.sentences,
                  controller: firstNameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    hintText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 46, 25, 118), width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Color.fromARGB(255, 46, 25, 118)),
                child: TextField(
                  // last name text field
                  textCapitalization: TextCapitalization.sentences,
                  controller: lastNameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 46, 25, 118), width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Color.fromARGB(255, 46, 25, 118)),
                child: TextField(
                  // email text field
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
                          color: Color.fromARGB(255, 46, 25, 118), width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Color.fromARGB(255, 46, 25, 118)),
                child: TextField(
                  // password text field
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
                          color: Color.fromARGB(255, 46, 25, 118), width: 2.0),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 10.0),
              Theme(
                data: Theme.of(context)
                    .copyWith(primaryColor: Color.fromARGB(255, 46, 25, 118)),
                child: TextField(
                  // confirm password text field
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 46, 25, 118), width: 2.0),
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
                  // sign up button
                  child: Text(
                    'Sign Up',
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
                  onPressed: () async {
                    bool signUpSuccess = await signUp();
                    if (signUpSuccess) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()));
                    }
                  }),
            ),
            SizedBox(height: 40.0),
            TextButton(
                // button to navigate to sign up page TODO make it look pretty
                child: Text("Already have an account? Sign in here"),
                onPressed: () {
                  Navigator.pop(this.context);
                }),
          ],
        ),
      )),
    ]));
  }
}
