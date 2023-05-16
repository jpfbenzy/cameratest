import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  String _qrCodeData = "";
  String _scanResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImageView(
              data: _qrCodeData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _scanQRCode(),
              child: Text("Scan QR Code"),
            ),
            SizedBox(height: 20.0),
            Text(_scanResult),
          ],
        ),
      ),
    );
  }

  Future<void> _scanQRCode() async {
    String scanResult = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.QR,
    );

    if (!mounted) return;

    setState(() {
      _scanResult = scanResult;
    });
  }
}
