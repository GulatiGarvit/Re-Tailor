import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retailor/Animation/FadeAnimation.dart';
import 'package:retailor/Services/MyUtils.dart';
import 'package:retailor/Services/firebase_auth.dart';
import 'package:retailor/Services/firebase_db.dart';
import 'package:retailor/choice_page.dart';

import '../Login/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  String _email = "", _password = "", _name = "", _phoneNo = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-2.png'))),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/clock.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text(
                              "SIGNUP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              const BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                              decoration: const BoxDecoration(
                                  //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                                  ),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  _name = value.trim();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Name",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                                  ),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  _phoneNo = value.trim();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Phone number",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                                  ),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  _email = value.trim();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                              child: TextField(
                                obscureText: true,
                                onChanged: (value) {
                                  _password = value;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUpUser(_email, _password, context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: const Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      const Text(
                        "Forgot Password?",
                        style:
                            TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void signUpUser(String email, String password, BuildContext context) async {
    MyUtils.showLoaderDialog(context);
    if (!MyFirebaseAuth.isValid(email, password)) return;
    MyFirebaseAuth auth = await MyFirebaseAuth().init();
    Code response = await auth.signUpUser(email, password);
    switch (response) {
      case Code.emailInUse:
        Fluttertoast.showToast(
            msg: "Email already exists. Try signing in instead");
        Navigator.pop(context);
        break;
      case Code.weakPassword:
        Fluttertoast.showToast(msg: "Weak password. Set a stronger password");
        Navigator.pop(context);
        break;
      case Code.unknownError:
        Fluttertoast.showToast(msg: "Unknown error");
        Navigator.pop(context);
        break;
      case Code.successful:
        if (FirebaseAuth.instance.currentUser != null) {
          await MyFirebaseDatabase.addUser(
              FirebaseAuth.instance.currentUser!.uid, email, _name, _phoneNo);
          Fluttertoast.showToast(msg: "Signed Up Succesfully");
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => ChoicePage()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()));
        }
        break;
      case Code.userNotFound:
        // Not possible
        break;
      case Code.wrongPassword:
        // Not possible
        break;
    }
  }
}
