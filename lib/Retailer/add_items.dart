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
  String? shopId, currentBarcode;
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
        if (barcode == "-1") {
          Navigator.pop(context);
          return;
        }
        isBarcodeScanned = true;
        Fluttertoast.showToast(msg: barcode);
        processBarcode(barcode, context);
      });
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add/Change Item",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(143, 148, 251, .6),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color.fromRGBO(79, 84, 201, 1),
                    Color.fromRGBO(111, 117, 227, 1),
                  ]),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              children: [
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
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            isBarcodeScanned = false;
                            itemExists = false;
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 192, 192, 192)),
                            child: const Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            updateOnDatabse();
                          },
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
    currentBarcode = barcode;
    MyUtils.showLoaderDialog(context, isCancellable: false);
    DataSnapshot itemSnapshot = await checkIfItemExists(barcode);
    DataSnapshot shopItemSnapshot = await checkIfItemExistsForShop(barcode);
    if (shopItemSnapshot.exists) {
      stockController.text = shopItemSnapshot.child('stock').value.toString();
      priceController.text =
          "₹${shopItemSnapshot.child('price').value.toString()}";
    }
    if (itemSnapshot.exists) {
      itemExists = true;
      nameController.text = itemSnapshot.child('name').value.toString();
      mrpController.text = "₹${itemSnapshot.child('mrp').value.toString()}";
      manufacturerController.text =
          itemSnapshot.child('manufacturer').value.toString();
    }
    Navigator.pop(context);
    setState(() {});
  }

  void updateOnDatabse() async {
    MyUtils.showLoaderDialog(context);
    if (!itemExists) {
      await FirebaseDatabase.instance
          .ref()
          .child('Items')
          .child(currentBarcode!)
          .set({
        'name': nameController.text,
        'mrp': mrpController.text.replaceAll("₹", ""),
        'manufacturer': manufacturerController.text
      });
    }
    await FirebaseDatabase.instance
        .ref()
        .child('ShopItems')
        .child(shopId!)
        .child(currentBarcode!)
        .update({
      'price': priceController.text.replaceAll("₹", ""),
      'stock': stockController.text,
    });
    Navigator.pop(context);
    isBarcodeScanned = false;
    itemExists = false;
    currentBarcode = null;
    setState(() {});
  }

  Future<DataSnapshot> checkIfItemExistsForShop(String barcode) async {
    final shopIdSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('shopId')
        .get();
    shopId = shopIdSnapshot.value.toString();
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("ShopItems")
        .child(shopId!)
        .child(barcode)
        .get();
    return snapshot;
  }

  Future<DataSnapshot> checkIfItemExists(String barcode) async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("Items")
        .child(barcode)
        .get();
    return snapshot;
  }
}
