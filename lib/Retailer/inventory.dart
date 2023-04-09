import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:retailor/Retailer/add_items.dart';
import 'package:retailor/Retailer/change_item.dart';
import 'package:retailor/Services/InventoryItem.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  var items = <InventoryItem>[];
  bool isLoading = false;
  int? currValue;

  @override
  void initState() {
    fetchInventory("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var backgroundHeight = MediaQuery.of(context).size.height / 6;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inventory",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddItemsScreen();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(79, 84, 201, 1),
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
                horizontal: 16.0, vertical: (backgroundHeight * 6) / 9),
            elevation: 6,
            child: Container(
              child: TextField(
                keyboardType: TextInputType.name,
                onSubmitted: (value) {
                  fetchInventory(value);
                },
                onChanged: (value) {},
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey[400])),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: backgroundHeight + 26),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      fetchInventory("");
                    },
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, pos) {
                          InventoryItem item = items[pos];
                          return InkWell(
                            splashFactory: InkRipple.splashFactory,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeItemScreen(item.barcode!)));
                            },
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
                                      Text("${item.name!} (${item.stock})"),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        item.manufacturer!,
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
                                      Text(
                                        "₹${item.mrp}",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            decoration: int.parse(item.mrp!) >
                                                    int.parse(item.price!)
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "₹${item.price}",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
          ),
        ],
      ),
    );
  }

  void fetchInventory(String searchTerm) async {
    items = <InventoryItem>[];
    isLoading = true;
    setState(() {});
    final shopIdSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('shopId')
        .get();
    String shopId = shopIdSnapshot.value.toString();

    final inventorySnapshot = await FirebaseDatabase.instance
        .ref()
        .child("ShopItems")
        .child(shopId)
        .get();

    DataSnapshot itemSnapshot;

    inventorySnapshot.children.forEach((element) async {
      itemSnapshot = await FirebaseDatabase.instance
          .ref()
          .child("Items")
          .child(element.key!)
          .get();
      if (itemSnapshot
              .child('name')
              .value
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase()) ||
          itemSnapshot
              .child('manufacturer')
              .value
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
        items.add(InventoryItem(itemSnapshot, element));
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
