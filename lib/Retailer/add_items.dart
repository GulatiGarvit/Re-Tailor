import 'package:firebase_auth/firebase_auth.dart';
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
  bool itemExists = false;
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              children: [
                const Text(
                  "Add/Change Item",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) {},
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  enabled: !itemExists,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  onChanged: (value) {},
                  controller: manufacturerController,
                  keyboardType: TextInputType.text,
                  enabled: !itemExists,
                  decoration: const InputDecoration(labelText: 'Manufacturer'),
                ),
                TextField(
                  onChanged: (value) {},
                  controller: mrpController,
                  keyboardType: TextInputType.number,
                  enabled: !itemExists,
                  decoration: const InputDecoration(labelText: 'MRP'),
                ),
                TextField(
                  onChanged: (value) {},
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Your price"),
                ),
                TextField(
                  onChanged: (value) {},
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Stock"),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         gradient: const LinearGradient(colors: [
                      //           Colors.grey,
                      //         ])),
                      //     child: const Center(
                      //       child: Text(
                      //         "Cancel",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   width: 8,
                      // ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: const Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void processBarcode(String barcode, BuildContext context) async {
    MyUtils.showLoaderDialog(context, isCancellable: false);
    DataSnapshot itemSnapshot = await checkIfItemExists(barcode);
    DataSnapshot shopItemSnapshot = await checkIfItemExistsForShop(barcode);
    if (shopItemSnapshot.exists) {
      stockController.text = shopItemSnapshot.child('stock').value.toString();
      priceController.text = shopItemSnapshot.child('price').value.toString();
    }
    if (itemSnapshot.exists) {
      itemExists = true;
      nameController.text = itemSnapshot.child('name').value.toString();
      mrpController.text = itemSnapshot.child('mrp').value.toString();
      manufacturerController.text =
          itemSnapshot.child('manufacturer').value.toString();
    }
    Navigator.pop(context);
    setState(() {});
  }
}

Future<DataSnapshot> checkIfItemExists(String barcode) async {
  final snapshot =
      await FirebaseDatabase.instance.ref().child("Items").child(barcode).get();
  return snapshot;
}

Future<DataSnapshot> checkIfItemExistsForShop(String barcode) async {
  final shopIdSnapshot = await FirebaseDatabase.instance
      .ref()
      .child("Users")
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('shopId')
      .get();
  String shopId = shopIdSnapshot.value.toString();
  final snapshot = await FirebaseDatabase.instance
      .ref()
      .child("ShopItems")
      .child(shopId)
      .child(barcode)
      .get();
  return snapshot;
}
