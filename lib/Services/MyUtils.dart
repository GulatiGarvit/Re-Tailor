import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyUtils {
  static showLoaderDialog(BuildContext context, {bool isCancellable = true}) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 16),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: isCancellable,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<void> addToSharedRef(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getFromSharedRef(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
