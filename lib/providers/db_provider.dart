import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
Classe que ens permetraa interactuar amb la base de dades.
*/

class DBProvider {

  // Patro singleton per crear una unica instancia de la base de dades.
  static Database? _database;
  static DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if(_database == null) _database = await initDB();

    return _database!;
    
  }

  /*
  Funcio per crear la base de dades.
  */
  Future<Database> initDB() async{
  
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: ((db) {}),
      onCreate: (Database db, int version) async{
        await db.execute("""
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipus TEXT,
            valor TEXT
          );
        """);
      },
      );
  }

  /*
  Funcions per inserir a la base de dades.
  Amb rawInsert podem fer una insercio directa a la base de dades.
  */

  Future<int> insertRawScan(ScanModel nouScan) async{
    final id = nouScan.id;
    final tipus = nouScan.tipus;
    final valor = nouScan.valor;

    final db = await database;

    final res = await db.rawInsert("""
      INSERT INTO Scans (id, tipus, valor)
      VALUES ($id, $tipus, $valor)
    """);

    return res;
  }

  /*
  Amb insert podem fer una insercio a la base de dades a partir d'un mapa.
  */

  Future<int> insertScan(ScanModel nouScan) async{
    final db = await database;

    final res = await db.insert("Scans", nouScan.toJson());
    print(res);
    return res;
  }

  /*
  Funcions per obtenir dades de la base de dades.
  Amb rawQuery podem fer una consulta directa a la base de dades.
  */

  Future<List<ScanModel>> getAllScans() async{
    final db = await database;
    final res = await db.query("Scans");

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  /*
  Amb query podem fer una consulta a la base de dades sense utilitzar la 
  sintaxis SQL.
  */

  Future<ScanModel?> getScanById(int id) async{
    final db = await database;
    final res = await db.query("Scans", where: "id = ?", whereArgs: [id]);

    if (res.isNotEmpty){
      return ScanModel.fromJson(res.first);
    }
    return null;
  }


  /*
  Funcions per obtenir una llista de scans a partir del tipus.
  */

  Future<List<ScanModel>> getScansByTipus(String tipus) async{
    final db = await database;
    final res = await db.query("Scans", where: "tipus = ?", whereArgs: [tipus]);

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  /*
  Funcio per actualitzar un scan a la base de dades.
  */

  Future<int> updateScans(ScanModel nouScan) async {
    final db = await database;
    final res = await db.update("Scans", nouScan.toJson(), where: "id = ?", whereArgs: [nouScan.id]);

    return res;
  }

  /*
  Funcio per esborrar tota la taula Scans de la base dedades.
  */

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete("""
      DELETE FROM Scans
    """);

    return res;
  }

  /*
  Funcio per esborrar un scan a partir de la seva id.
  */

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete("Scans", where: "id = ?", whereArgs: [id]);

    return res;
  }

  /*
  Funcions per obtenir el nombre de scans de tipus http.
  */

  Future<int> countHttp() async{
    final db =  await database;
    final res = await db.rawQuery("""
      SELECT COUNT(*) FROM Scans WHERE tipus = 'http'
    """);
    return res[0]['COUNT(*)'] as int;
  }

  /*
  Funcions per obtenir el nombre de scans de tipus geo.
  */

  Future<int> countGeo() async{
    final db =  await database;
    final res = await db.rawQuery("""
      SELECT COUNT(*) FROM Scans WHERE tipus = 'geo'
    """);
    return res[0]['COUNT(*)'] as int;
  }
}