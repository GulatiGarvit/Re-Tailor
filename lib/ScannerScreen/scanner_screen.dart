import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int dropDownValue = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MobileScanner(
          controller: MobileScannerController(
            detectionTimeoutMs: 1000,
          ),
          // fit: BoxFit.contain,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            final barcode = barcodes.first;
          },
        ),
      ),
    );
  }
}
