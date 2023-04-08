import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retailor/Services/MyUtils.dart';

class AddItemsScreen extends StatefulWidget {
  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  bool isBarcodeScanned = false;
  TextEditingController nameController = TextEditingController(),
      manufacturerController = TextEditingController(),
      mrpController = TextEditingController(),
      priceController = TextEditingController(),
      stockController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (!isBarcodeScanned) {
      FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", false, ScanMode.DEFAULT)
          .then((barcode) {
        isBarcodeScanned = true;
        Fluttertoast.showToast(msg: barcode);
        processBarcode(barcode, context);
      });
    }
    return Center(
      child: Column(
        children: [
          const Text("Add/Change Item"),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: const BoxDecoration(
                //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                ),
            child: TextField(
              onChanged: (value) {},
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: const BoxDecoration(
                //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                ),
            child: TextField(
              onChanged: (value) {},
              controller: manufacturerController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Manufacturer",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: const BoxDecoration(
                //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                ),
            child: TextField(
              onChanged: (value) {},
              controller: mrpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "MRP",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: const BoxDecoration(
                //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                ),
            child: TextField(
              onChanged: (value) {},
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your price",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: const BoxDecoration(
                //border: Border(bottom: BorderSide(color: Colors.grey[400]))!
                ),
            child: TextField(
              onChanged: (value) {},
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Stock",
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
        ],
      ),
    );
  }
}

void processBarcode(String barcode, BuildContext context) async {}

Future<DataSnapshot> checkIfItemExists(String barcode) async {
  final snapshot =
      await FirebaseDatabase.instance.ref().child("Items").child(barcode).get();
  return snapshot;
}

Future<DataSnapshot> checkIfItemExistsForShop(String barcode) async {
  String shopId = (await MyUtils.getFromSharedRef("shopId"))!;
  final snapshot = await FirebaseDatabase.instance
      .ref()
      .child("ShopItems")
      .child(shopId)
      .child(barcode)
      .get();
  return snapshot;
}
