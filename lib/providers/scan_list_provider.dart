import 'package:flutter/foundation.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

/*
Aquest provider ens permetra carregar una llista de scans.
A mes del nombre de scans que tenim de cada tipus.
*/

class ScanListProvider extends ChangeNotifier{
  List<ScanModel> scans = [];

  int httpScans = 0;
  int geoScans = 0;

  String tipusSeleccionat = "http";

  /*
  Funcio per afegir un nou scan a la llista i a la base
  de dades.
  */

  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if( nouScan.tipus == tipusSeleccionat){
      this.scans.add(nouScan);
    }
    notifyListeners();
    return nouScan;
  }

  /*
  Funcio per carregar tots els scans de la base de dades.
  */

  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

  /*
  Funcio per carregar els scans de la base de dades a partir del tipus.
  */

  carregaScansPerTipus(String tipus) async{
    final scans = await DBProvider.db.getScansByTipus(tipus);
    this.scans = [...scans];
    notifyListeners();
  }

  /*
  Funcio per esborrar tots els scans de la base de dades.
  */

  esborraTots() async {
    final res = await DBProvider.db.deleteAll();
    scans = [];
    notifyListeners();
  }

  /*
  Funcio per esborrar un scan a partir de la seva id.
  */

  esborraPerID(int id) async {
    final res = await DBProvider.db.deleteScan(id);
  }

  /*
  Funcio per actualitzar el total de scans de tipus http.
  */

  carregaTotalHttp() async {
    final scans = await DBProvider.db.countHttp();
    this.httpScans = scans;
    notifyListeners();
  }

  /*
  Funcio per actualitzar el total de scans de tipus geo.
  */

  carregaTotalGeo() async {
    final scans = await DBProvider.db.countGeo();
    this.geoScans = scans;
    notifyListeners();
  }
}