import 'package:firebase_database/firebase_database.dart';

class InventoryItem {
  InventoryItem(DataSnapshot itemSnapshot, DataSnapshot shopItemSnapshot) {
    name = itemSnapshot.child('name').value.toString();
    manufacturer = itemSnapshot.child('manufacturer').value.toString();
    mrp = itemSnapshot.child('mrp').value.toString();
    photoUrl = itemSnapshot.child('photoUrl').value.toString();
    price = shopItemSnapshot.child('price').value.toString();
    stock = shopItemSnapshot.child('stock').value.toString();
    barcode = shopItemSnapshot.key;
  }
  String? barcode;
  String? name;
  String? photoUrl;
  String? stock;
  String? mrp;
  String? price;
  String? manufacturer;
}
