import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:retailor/Services/CartItem.dart';
import 'package:retailor/Services/MyUtils.dart';

class CartPage extends StatefulWidget {
  String cartId;
  CartPage(this.cartId);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int discount = 0, total = 0, subtotal = 0;
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  bool isLoading = false;
  String? shopId;
  var items = <CartItem>[];
  @override
  void initState() {
    fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var backgroundHeight = MediaQuery.of(context).size.height / 6;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
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
      body: Stack(
        children: [
          Container(
            height: backgroundHeight,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill)),
          ),
          Card(
            margin: EdgeInsets.symmetric(
                horizontal: 16.0, vertical: (backgroundHeight * 3) / 9),
            elevation: 6,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Text(
                        "Total items",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text("${items.length}")
                    ]),
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text("Subtotal",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text("₹${subtotal}")
                    ]),
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text("Discount",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text(
                        "- ₹${discount}",
                        style: TextStyle(color: Colors.green),
                      )
                    ]),
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text("Amount to pay",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text("₹$total")
                    ]),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: backgroundHeight + 40),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      fetchCart();
                    },
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, pos) {
                          CartItem item = items[pos];
                          return InkWell(
                            splashFactory: InkRipple.splashFactory,
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16.0),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: item.photoUrl!,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(item.name!),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "₹${item.price}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
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
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                item.quantity = value!;
                                              });
                                            },
                                            value: item.quantity,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            style: const TextStyle(
                                                color: Colors.deepPurple),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  generateBill();
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
                      "Generate Bill",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void fetchCart() async {
    items = <CartItem>[];
    isLoading = true;
    setState(() {});
    final shopIdSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('shopId')
        .get();
    shopId = shopIdSnapshot.value.toString();

    final cartSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Carts")
        .child(widget.cartId)
        .get();

    for (DataSnapshot snapshot in cartSnapshot.child("items").children) {
      CartItem item = CartItem();
      final itemSnapshot = await FirebaseDatabase.instance
          .ref()
          .child("Items")
          .child(snapshot.key!)
          .get();
      item.quantity = int.parse(snapshot.value.toString());
      item.name = itemSnapshot.child('name').value.toString();
      item.manufacturer = itemSnapshot.child('manufacturer').value.toString();
      item.photoUrl = itemSnapshot.child('photoUrl').value.toString();
      item.mrp = itemSnapshot.child('mrp').value.toString();
      final shopItemSnapshot = await FirebaseDatabase.instance
          .ref()
          .child("ShopItems")
          .child(shopId!)
          .child(snapshot.key!)
          .get();
      item.price = shopItemSnapshot.child('price').value.toString();
      items.add(item);
    }
    setState(() {
      isLoading = false;
      discount = calculateDiscount();
      subtotal = calculatesubTotal();
      total = calculateTotal(subtotal, discount);
    });
  }

  int calculateDiscount() {
    int discount = 0;
    for (var element in items) {
      discount += int.parse(element.mrp!) - int.parse(element.price!);
    }
    return discount;
  }

  int calculatesubTotal() {
    int subTotal = 0;
    for (var element in items) {
      subTotal += int.parse(element.mrp!);
    }
    return subTotal;
  }

  int calculateTotal(int subTotal, int discount) {
    int total = 0;
    for (var element in items) {
      total += subTotal - discount;
    }
    return total;
  }

  void generateBill() async {
    MyUtils.showLoaderDialog(context);
    final billRef = FirebaseDatabase.instance.ref().child("Bills").push();
    await billRef.set({
      'amount': total,
      'customerName': 'Dummy User',
      'itemString': calculateItemString(),
      'shopId': shopId,
      'url': 'https://google.com'
    });
  }

  calculateItemString() {
    return "${items[0].name}, ${items[1].name}...";
  }
}
