import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

/*
Classe per a mostrar els scans en forma de llista.

Aquesta classe es reutilitza per a mostrar els scans de tipus http i geo.
Per aixo, li passem el tipus de scan que volem mostrar.

A mes, li afegim la funcio Dismissible per a poder esborrar els scans.
Un cop esborrat, actualitzam la llista de scans.

Tambe, si fem click en un scan, cridam a la funcio launchURL per a obrir la URL del scan.
*/

class ScanTiles extends StatelessWidget {
  final String tipus;
  const ScanTiles({Key? key, required this.tipus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length, 
      itemBuilder: (_, index) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.delete_forever)
            ),
        ),
        onDismissed: (direction) {
          Provider.of<ScanListProvider>(context, listen: false).esborraPerID(scans[index].id!);
        },
        child: ListTile(
          leading: Icon(
            this.tipus == "http" ? Icons.home_outlined : Icons.map_outlined
          ),
          title: Text(scans[index].valor),
          subtitle: Text(scans[index].id.toString()),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
          onTap: () {
            launchURL(context, scans[index]);
          },
        ),
      ));
  }
}