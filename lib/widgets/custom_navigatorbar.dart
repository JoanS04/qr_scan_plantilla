import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';

/*
Classe per a mostrar la barra de navegacio personalitzada.
*/

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uIProvider = Provider.of<UIProvider>(context);
    final currentIndex = uIProvider.selectedMenuOpt;
    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
    scanListProvider.carregaTotalGeo();
    scanListProvider.carregaTotalHttp();

    return BottomNavigationBar(
      onTap: (int i) => uIProvider.selectedMenuOpt = i,
        elevation: 0,
        currentIndex: currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa (' + scanListProvider.geoScans.toString() + ')',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration),
            label: 'Direccions (' + scanListProvider.httpScans.toString() + ')',
          )
        ]);
  }
}
