import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retailor/Services/MyUtils.dart';

class AddItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", false, ScanMode.DEFAULT)!
        .listen((barcode) {
      processBarcode(barcode, context);
    });
    throw const Placeholder();
  }
}

void processBarcode(String barcode, BuildContext context) async {
  MyUtils.showLoaderDialog(context);
  bool exists = false;
  bool existsForShop = await checkIfItemExistsForShop(barcode);
  if (!existsForShop) exists = await checkIfItemExists(barcode);
  AlertDialog alert = AlertDialog();
  final DataSnapshot itemSnapshot, shopItemSnapshot;
  if (exists || existsForShop) {
    itemSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Items")
        .child(barcode)
        .get();
  }
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> checkIfItemExists(String barcode) async {
  final snapshot =
      await FirebaseDatabase.instance.ref().child("Items").child(barcode).get();
  return snapshot.exists;
}

Future<bool> checkIfItemExistsForShop(String barcode) async {
  String shopId = (await MyUtils.getFromSharedRef("shopId"))!;
  final snapshot = await FirebaseDatabase.instance
      .ref()
      .child("ShopItems")
      .child(shopId)
      .child(barcode)
      .get();
  return snapshot.exists;
}
