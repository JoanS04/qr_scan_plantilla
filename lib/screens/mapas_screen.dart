import 'package:flutter/material.dart';
import 'package:qr_scan/widgets/scan_tiles.dart';

/*
Pantalla per mostrar els scans de tipus geo.
*/

class MapasScreen extends StatelessWidget {
  const MapasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScanTiles(tipus: 'geo'),
    );
  }
}
