import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retailor/Services/MyUtils.dart';

class ChangeItemScreen extends StatefulWidget {
  String barcode;
  ChangeItemScreen(this.barcode);
  @override
  State<ChangeItemScreen> createState() => _ChangeItemScreen();
}

class _ChangeItemScreen extends State<ChangeItemScreen> {
  String? shopId;
  TextEditingController nameController = TextEditingController(),
      manufacturerController = TextEditingController(),
      mrpController = TextEditingController(),
      priceController = TextEditingController(),
      stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadData(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Change Item",
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
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  onChanged: (value) {},
                  controller: manufacturerController,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Manufacturer'),
                ),
                TextField(
                  onChanged: (value) {},
                  controller: mrpController,
                  keyboardType: TextInputType.number,
                  enabled: false,
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
                            Navigator.pop(context);
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
                            updateData();
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

  void loadData(BuildContext context) async {
    final shopIdSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("shopId")
        .get();
    shopId = shopIdSnapshot.value.toString();
    final itemSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Items")
        .child(widget.barcode)
        .get();
    final shopItemSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("ShopItems")
        .child(shopId!)
        .child(widget.barcode)
        .get();
    nameController.text = itemSnapshot.child('name').value.toString();
    manufacturerController.text =
        itemSnapshot.child('manufacturer').value.toString();
    mrpController.text = "₹${itemSnapshot.child('mrp').value.toString()}";
    stockController.text = shopItemSnapshot.child('stock').value.toString();
    priceController.text =
        "₹${shopItemSnapshot.child('price').value.toString()}";
  }

  void updateData() async {
    MyUtils.showLoaderDialog(context);
    await FirebaseDatabase.instance
        .ref()
        .child("ShopItems")
        .child(shopId!)
        .child(widget.barcode)
        .update({
      'price': priceController.text.replaceAll("₹", ""),
      'stock': stockController.text,
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
