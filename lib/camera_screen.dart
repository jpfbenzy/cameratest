import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late Future<void> _cameraInitFuture;
  String _qrCodeData = "";
  String _scanResult = "";
  @override
  void initState() {
    super.initState();

    // Obtain the list of available cameras on the device
    final camerasFuture = availableCameras();

    // Initialize the camera controller and set the cameraInitFuture to the result of the camerasFuture
    _cameraInitFuture = camerasFuture.then((cameras) {
      // Use the front camera if available, otherwise use the first available camera
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(frontCamera, ResolutionPreset.medium);

      // Initialize the camera controller
      return _cameraController.initialize();
    });
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the page is disposed
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,centerTitle: true,
        title: const Text("BLAH",style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20
        ),),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _cameraInitFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the camera initialization is complete, display the camera preview
                return Container(padding:EdgeInsets.all(30),width: 400,height: 400,child: CameraPreview(_cameraController));
              } else {
                // Otherwise, display a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            },
          ),QrImageView(
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
