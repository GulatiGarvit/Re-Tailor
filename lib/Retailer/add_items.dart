import 'package:firebase_core/firebase_core.dart';
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
  @override
  Widget build(BuildContext context) {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", false, ScanMode.DEFAULT)!
        .listen((barcode) {
      Fluttertoast.showToast(msg: barcode);
      processBarcode(barcode, context);
    });
    throw const Placeholder();
  }
}

void processBarcode(String barcode, BuildContext context) async {
  MyUtils.showLoaderDialog(context);
  final itemSnapshot = await checkIfItemExists(barcode);
  final shopItemSnapshot = await checkIfItemExistsForShop(barcode);
  TextEditingController? nameController,
      manufacturerController,
      mrpController,
      priceController,
      stockController;
  AlertDialog alert = AlertDialog(
    content: Container(
      margin: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            Text("${shopItemSnapshot.exists ? 'Change' : 'Add'} Item"),
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
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel")),
      TextButton(onPressed: () {}, child: Text("Save"))
    ],
  );
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  if (shopItemSnapshot.exists) {
    stockController!.text = shopItemSnapshot.child('stock').value.toString();
    priceController!.text = shopItemSnapshot.child('price').value.toString();
  }
  if (itemSnapshot.exists) {
    nameController!.text = itemSnapshot.child('name').value.toString();
    manufacturerController!.text =
        itemSnapshot.child('manufacturer').value.toString();
    mrpController!.text = itemSnapshot.child('mrp').value.toString();
  }
}

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
