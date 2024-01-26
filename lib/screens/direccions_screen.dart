import 'package:flutter/material.dart';
import 'package:qr_scan/widgets/scan_tiles.dart';

/*
Pantalla per mostrar els scans de tipus http.
*/

class DireccionsScreen extends StatelessWidget {
  const DireccionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScanTiles(tipus: 'http');
  }
}
