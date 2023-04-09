import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:random_string/random_string.dart';
import 'package:retailor/Animation/FadeAnimation.dart';
import 'package:retailor/Services/MyUtils.dart';
import 'package:retailor/Services/firebase_auth.dart';
import 'package:retailor/Services/firebase_db.dart';

import '../Login/login_screen.dart';
import 'Services/location.dart';

class RegisterShop extends StatelessWidget {
  String _shopName = "", _shopAddress = "", _regNo = "", shopId = "";
  String? latLong;
  @override
  Widget build(BuildContext context) {
    getLocation();
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
                              "Register your shop",
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
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                                  ),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  _shopName = value.trim();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Shop Name",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                keyboardType: TextInputType.streetAddress,
                                onChanged: (value) {
                                  _shopAddress = value.trim();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Address",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) {
                                  _regNo = value.trim();
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Registration No.",
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
                        onTap: () async {
                          if (latLong == null) {
                            Fluttertoast.showToast(
                                msg: "Please wait, fetching your location");
                            return;
                          }
                          shopId = randomAlpha(10);
                          await MyUtils.addToSharedRef("shopId", shopId);
                          MyFirebaseDatabase.addShop(shopId, _shopAddress,
                              _shopName, _regNo, latLong!);
                          Fluttertoast.showToast(
                              msg: "Data updated on database");
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
                              "Register",
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void getLocation() async {
    Position position = await determinePosition();
    latLong = "${position.latitude},${position.longitude}";
  }
}
