import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retailor/Services/MyUtils.dart';
import 'package:retailor/Services/firebase_auth.dart';
import 'package:retailor/Services/firebase_db.dart';
import 'package:retailor/customer_page.dart';
import 'package:retailor/Retailer/retailer_page.dart';

class LoginScreen extends StatelessWidget {
  String _email = "", _password = "";
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
                              "Login",
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
                              BoxShadow(
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
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
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
                          signInUser(_email, _password, context);
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
                              "Login",
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

  void signInUser(String email, String password, BuildContext context) async {
    if (!MyFirebaseAuth.isValid(email, password)) return;
    MyUtils.showLoaderDialog(context);
    MyFirebaseAuth auth = await MyFirebaseAuth().init();
    Code response = await auth.signInUser(email, password);
    switch (response) {
      case Code.userNotFound:
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "User not found. Kindly sign up");
        break;
      case Code.wrongPassword:
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Incorrect password. Try again");
        break;
      case Code.unknownError:
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Unknown error");
        break;
      case Code.successful:
        Fluttertoast.showToast(msg: "Signed In Succesfully");
        if (FirebaseAuth.instance.currentUser != null) {
          String role = await MyFirebaseDatabase.getRole(
              FirebaseAuth.instance.currentUser!.uid);
          Navigator.pop(context);
          if (role.isEmpty) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => RetailerPage()),
                (Route<dynamic> route) => false);
          } else {
            if (role == "retailer") {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => RetailerPage()),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const CustomerPage()),
                  (Route<dynamic> route) => false);
            }
          }
        }
        break;
      case Code.weakPassword:
        // Not possible
        break;
      case Code.emailInUse:
        // Not possible
        break;
    }
  }
}
