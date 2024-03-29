import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

/*
Classe per a mostrar el boto de scan.

En aquesta cridam a la llibreria FlutterBarcodeScanner per a escanejar el codi QR.

Un cop escanejat el codi QR, el guardam a la base de dades i actualitzam la llista de scans.

A mes, cridam a la funcio launchURL per a obrir la URL del scan.
*/

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () async {

        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#3D8BEF', 
          'Cancela', 
          false, 
          ScanMode.QR);
        if (barcodeScanRes == '-1') return;

        var scan = ScanModel(valor: barcodeScanRes); 
        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
        scanListProvider.nouScan(barcodeScanRes);
        launchURL(context, scan);
      },
    );
  }
}
