import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePagestate createState() => _MyHomePagestate();
}

class _MyHomePagestate extends State<MyHomePage> {
  String code = "";
  String getcode = "";

  Future scanbarcode() async {
    //etcode= await FlutterBarcodeScanner.scanBarcode("#009922", "cancel", true);
    getcode = await FlutterBarcodeScanner.scanBarcode(
        "#009922", "cancel", true, ScanMode.DEFAULT);
    setState(() {
      code = getcode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR code'),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.symmetric(),
          children: [
            // Center(
            //   child: Text(
            //     "Welcome !",
            //   ),
            // ),
            Image.asset(
              'assets/images/login.png',
              height: 333,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              child: FlatButton(
                color: Color.fromARGB(43,144,255,255),
                onPressed: () {
                  scanbarcode();
                },
                child: Text(
                  'SCAN QR-CODE',
                ),
              ),
            ),
            Text(code)
          ],
        ),
      ),
    );
  }
}
