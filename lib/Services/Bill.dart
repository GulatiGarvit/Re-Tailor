import 'package:firebase_database/firebase_database.dart';

class Bill {
  Bill(DataSnapshot snapshot) {
    url = snapshot.child("url").value.toString();
    itemString = snapshot.child("itemString").value.toString();
    amount = snapshot.child("amount").value.toString();
    customerName = snapshot.child("customerName").value.toString();
  }
  String? url;
  String? itemString;
  String? customerName;
  String? amount;
}
