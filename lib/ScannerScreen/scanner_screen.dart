import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:retailor/Retailer/cart_page.dart';
import 'package:retailor/Services/MyUtils.dart';

import '../Services/CartItem.dart';

class ScannerScreen extends StatefulWidget {
  String cartId;
  ScannerScreen(this.cartId);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState(cartId);
}

class _ScannerScreenState extends State<ScannerScreen> {
  String? cartId;
  _ScannerScreenState(this.cartId);
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  String? shopId;
  CartItem? currentItem;

  @override
  void initState() {
    super.initState();
  }

  int dropDownValue = 1;
  MobileScannerController controller =
      MobileScannerController(detectionTimeoutMs: 1000);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          MobileScanner(
            controller: controller,
            // fit: BoxFit.contain,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              final barcode = barcodes.first;
              Fluttertoast.showToast(msg: barcode.rawValue!);
              processBarcode(barcode.rawValue!);
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.all(16),
              child: FloatingActionButton(
                onPressed: () async {
                  await currentItem!.updateOnDatabse(cartId!);
                  controller.stop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CartPage(cartId!);
                  }));
                },
                child: Icon(Icons.done),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: currentItem != null
                  ? Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.85),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 12.0),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  // imageUrl: item.photoUrl!,
                                  imageUrl: currentItem!.photoUrl!,
                                  width: 50,
                                  height: 50,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Text(item.name!),
                                    Text(
                                      "${currentItem!.name}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      // item.manufacturer!,
                                      "₹${currentItem!.price}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      items: numbers
                                          .map<DropdownMenuItem>((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            '$value',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          dropDownValue = value!;
                                          currentItem!.quantity = value;
                                        });
                                      },
                                      value: dropDownValue,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    )
                  : null)
        ]),
      ),
    );
  }

  void processBarcode(String barcode) async {
    if (shopId == null) {
      final shopIdSnapshot = await FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("shopId")
          .get();
      shopId = shopIdSnapshot.value.toString();
    }
    if (currentItem != null) {
      await currentItem!.updateOnDatabse(cartId!);
    }
    final itemSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Items")
        .child(barcode)
        .get();
    CartItem cartItem = CartItem();
    cartItem.barcode = barcode;
    cartItem.name = itemSnapshot.child('name').value.toString();
    cartItem.photoUrl = itemSnapshot.child('photoUrl').value.toString();
    final shopItemSnapshot = await FirebaseDatabase.instance
        .ref()
        .child('ShopItems')
        .child(shopId!)
        .child(barcode)
        .get();
    cartItem.price = shopItemSnapshot.child('price').value.toString();
    final cartItemSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Carts")
        .child(cartId!)
        .child('items')
        .child(barcode)
        .get();
    if (cartItemSnapshot.exists)
      cartItem.quantity = int.parse(cartItemSnapshot.value.toString()) + 1;
    else
      cartItem.quantity = 1;
    dropDownValue = cartItem.quantity!;
    currentItem = cartItem;
    setState(() {});
  }
}
