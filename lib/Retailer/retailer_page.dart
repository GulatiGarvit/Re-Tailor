import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:retailor/Retailer/inventory.dart';
import 'package:retailor/Services/firebase_auth.dart';

class RetailerPage extends StatelessWidget {
  Map<String, double> dataMap = {
    "Oreo": 5,
    "Lays Cr..": 3,
    "Doritos": 2,
    "Aashirvad..": 2,
    'Papad': 2,
    'Matches': 5
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(79, 84, 201, 1),
                  Color.fromRGBO(111, 117, 227, 1),
                ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Inventory'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return InventoryScreen();
                }));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromRGBO(79, 84, 201, 1),
        child: Icon(Icons.add_shopping_cart),
      ),
      backgroundColor: kDefaultIconLightColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 148, 251, .6),
        elevation: 0,
        title: const Text(
          "Retailor",
          style: TextStyle(color: Colors.white),
        ),
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              MyFirebaseAuth.signOut(context);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Hi, Garvit!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Here's your weekly sale analysis so far",
                    style: TextStyle(
                        color: Color.fromARGB(211, 255, 255, 255),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PieChart(
                          dataMap: dataMap,
                          animationDuration: const Duration(milliseconds: 2000),
                          chartValuesOptions: const ChartValuesOptions(
                            decimalPlaces: 0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Recent Bills",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.receipt),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Ishita"),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Ma chuda",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                "₹50",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.receipt),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Ishita"),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Ma chuda",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                "₹50",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.receipt),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Ishita"),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Ma chuda",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                "₹50",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashFactory: InkRipple.splashFactory,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.receipt),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Ishita"),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Ma chuda",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                "₹50",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
