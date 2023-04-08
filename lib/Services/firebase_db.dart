import 'package:firebase_database/firebase_database.dart';

class MyFirebaseDatabase {
  static Future<void> addUser(String uid, String email) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(uid)
        .child("email")
        .set(email);
  }

  static Future<void> setRole(String uid, String role) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(uid)
        .child("role")
        .set(role);
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
