import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class MyFirebaseDatabase {
  static Future<void> addUser(
      String uid, String email, String name, String phoneNo) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(uid)
        .set({"email": email, "name": name, "phoneNo": phoneNo});
  }

  static Future<void> setRole(String uid, String role) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(uid)
        .child("role")
        .set(role);
  }

  static Future<void> addShop(String uid, String address, String name,
      String regNo, String latlong) async {
    await FirebaseDatabase.instance.ref().child("Shops").child(uid).set({
      'name': name,
      'address': address,
      'registration': regNo,
      'latlong': latlong
    });
  }

  static Future<String> getRole(String uid) async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(uid)
        .child("role")
        .get();
    return snapshot.value == null ? "" : snapshot.value.toString();
  }
}
