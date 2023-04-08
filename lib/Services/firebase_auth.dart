import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retailor/firebase_options.dart';

enum Code {
  weakPassword,
  emailInUse,
  successful,
  unknownError,
  userNotFound,
  wrongPassword,
}

class MyFirebaseAuth {
  Future<MyFirebaseAuth> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    return this;
  }

  Future<Code> signUpUser(String email, String password) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Code.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Code.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return Code.emailInUse;
      } else {
        print(e.message);
        return Code.unknownError;
      }
    } catch (e) {
      print(e);
      return Code.unknownError;
    }
  }

  Future<Code> signInUser(email, password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Code.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Code.userNotFound;
      } else if (e.code == 'wrong-password') {
        return Code.wrongPassword;
      } else {
        return Code.unknownError;
      }
    }
  }

  static bool isValid(String email, String password) {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your email");
      return false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return false;
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your password");
      return false;
    }
    return true;
  }

  static void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
