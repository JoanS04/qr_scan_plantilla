import 'package:flutter/foundation.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier{
  List<ScanModel> scans = [];

  int httpScans = 0;
  int geoScans = 0;

  String tipusSeleccionat = "http";

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

  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

//a fer
  carregaScansPerTipus(String tipus) async{
    final scans = await DBProvider.db.getScansByTipus(tipus);
    this.scans = [...scans];
    notifyListeners();
  }


//a fer
  esborraTots() async {
    final res = await DBProvider.db.deleteAll();
    scans = [];
    notifyListeners();
  }

//a fer
  esborraPerID(int id) async {
    final res = await DBProvider.db.deleteScan(id);
  }

//a fer
  carregaTotalHttp() async {
    final scans = await DBProvider.db.countHttp();
    this.httpScans = scans;
    notifyListeners();
  }

//a fer
  carregaTotalGeo() async {
    final scans = await DBProvider.db.countGeo();
    this.geoScans = scans;
    notifyListeners();
  }
}