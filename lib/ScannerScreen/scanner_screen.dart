import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          MobileScanner(
            // fit: BoxFit.contain,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                Fluttertoast.showToast(msg: barcode.rawValue!);
              }
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.85),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12.0),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          // imageUrl: item.photoUrl!,
                          imageUrl:
                              "https://m.media-amazon.com/images/W/IMAGERENDERING_521856-T1/images/I/71G1kVHN0-L._SL1500_.jpg",
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
                              "Lays",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              // item.manufacturer!,
                              "Rs. 20",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
