import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/screens.dart';
import 'package:qr_scan/widgets/widgets.dart';

/*
Pantalla principal de l'aplicacio.

En aquesta disposam de la barra de navegacio, el boto per escanejar i el cos de la pantalla.
*/

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<ScanListProvider>(context, listen: false).esborraTots();
            },
          )
        ],
      ),
      body: _HomeScreenBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/*
Classe per a mostrar el cos de la pantalla
depenent de la opcio seleccionada a la barra de navegacio.
*/
class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uIProvider = Provider.of<UIProvider>(context);
    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
    // Canviar per a anar canviant entre pantalles
    final currentIndex = uIProvider.selectedMenuOpt;

    DBProvider.db.database;
    

    switch (currentIndex) {
      case 0:
        scanListProvider.carregaScansPerTipus('geo');
        return MapasScreen();

      case 1:
        scanListProvider.carregaScansPerTipus('http');
        return DireccionsScreen();

      default:
        scanListProvider.carregaScansPerTipus('geo');
        return MapasScreen();
    }
  }
}
