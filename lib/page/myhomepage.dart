import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrcodepeminjaman/model/Barang.dart';

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key ? key, required this.barangs}) : super(key: key);
  //final Future<List<Barang>> barangs;
  @override
  _MyHomePagestate createState() => _MyHomePagestate();
}

class _MyHomePagestate extends State<MyHomePage> {
  String code = "";
  String getcode = "";
  List barang = [];

  Future scanbarcode() async {
    //etcode= await FlutterBarcodeScanner.scanBarcode("#009922", "cancel", true);
    getcode = await FlutterBarcodeScanner.scanBarcode(
        "#009922", "cancel", true, ScanMode.DEFAULT);
    setState(() {
      code = getcode;
    });
    getbarang(code);
  }
//  List<Barang> parseBarangs(String responseBody) {
//    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//    return parsed.map<Barang>((json) =>Barang.fromMap(json)).toList();
// }

  void getbarang(String idbarang) async {
    final String uri =
        'http://168.138.13.2/PeminjamanBarangMenggunakanQCode/api/api_tampil.php?idbarang=' +
            idbarang;

    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == 200) {
      print("Sukses");
      final jsonResponse = json.decode(result.body);
      // final barangMap = jsonResponse[0]['data'];
      List barangs = jsonResponse.map((i) => Barang.fromMap(i)).toList();
      setState(() {
        barang = barangs;
      });
    }
  }

  void setbarang(String idBarang, String nama, String swKelas, String brgNama,
      String spesifikasi, int qty, String tglPinjam) async {
    final String uri =
        'http://168.138.13.2/PeminjamanBarangMenggunakanQCode/api/api_tambah.php';
    Map data = {
      
      'IdBarang': idBarang,
      'Nama': nama,
      'SwKelas': swKelas,
      'BrgNama': brgNama,
      'Spesifikasi': spesifikasi,
      'qty': qty,
      'TglPinjam': tglPinjam,
      'status': 'pinjam',
    };
    var body = json.encode(data);
    http.Response result = await http.post(
      Uri.parse(uri),
      headers: {
          'Content-Type': 'application/json',
        },
        body: body

    );
    if (result.statusCode == 200) {
      print("Sukses");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //fetchBarangs();
    //getbarang();
    super.initState();
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
                color: Color.fromARGB(43, 144, 255, 255),
                onPressed: () {
                  scanbarcode();
                },
                child: Text(
                  'SCAN QR-CODE',
                ),
              ),
            ),
            Text(code),
            Text(barang.length > 0 ? barang[0].BrgNama : 'tidak ada'),
            Text(barang.length > 0 ? barang[0].BrgMerk : 'tidak ada'),
            Text(barang.length > 0 ? barang[0].BrgJumlah : 'tidak ada'),

            InkWell(
              onTap: barang.length > 0
                  ? () {
                      setbarang(barang[0].IdBarang, 'Nama','SwKelas', barang[0].BrgNama,
                       'Spesifikasi', 1 , 'TglPinjam');
                    }
                  : () {},
              child: Text('Pinjam'),
            )
          ],
        ),
      ),
    );
  }
}
