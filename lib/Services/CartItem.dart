import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class CartItem {
  String? cartId;
  String? barcode;
  String? name;
  String? photoUrl;
  String? price;
  int? quantity;
  String? amount;
  String? manufacturer;
  String? mrp;

  Future<void> updateOnDatabse(String cartId) async {
    FirebaseDatabase.instance
        .ref()
        .child("Carts")
        .child(cartId)
        .child("items")
        .update({"$barcode": quantity});
  }
}
