import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {

  static Database? _database;
  static DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if(_database == null) _database = await initDB();

    return _database!;
    
  }

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

  Future<int> insertScan(ScanModel nouScan) async{
    final db = await database;

    final res = await db.insert("Scans", nouScan.toJson());
    print(res);
    return res;
  }

  Future<List<ScanModel>> getAllScans() async{
    final db = await database;
    final res = await db.query("Scans");

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  Future<ScanModel?> getScanById(int id) async{
    final db = await database;
    final res = await db.query("Scans", where: "id = ?", whereArgs: [id]);

    if (res.isNotEmpty){
      return ScanModel.fromJson(res.first);
    }
    return null;
  }


// a fer
  Future<List<ScanModel>> getScansByTipus(String tipus) async{
    final db = await database;
    final res = await db.query("Scans", where: "tipus = ?", whereArgs: [tipus]);

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  Future<int> updateScans(ScanModel nouScan) async {
    final db = await database;
    final res = await db.update("Scans", nouScan.toJson(), where: "id = ?", whereArgs: [nouScan.id]);

    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete("""
      DELETE FROM Scans
    """);

    return res;
  }

 // a fer
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete("Scans", where: "id = ?", whereArgs: [id]);

    return res;
  }

  Future<int> countHttp() async{
    final db =  await database;
    final res = await db.rawQuery("""
      SELECT COUNT(*) FROM Scans WHERE tipus = 'http'
    """);
    return res[0]['COUNT(*)'] as int;
  }

  Future<int> countGeo() async{
    final db =  await database;
    final res = await db.rawQuery("""
      SELECT COUNT(*) FROM Scans WHERE tipus = 'geo'
    """);
    return res[0]['COUNT(*)'] as int;
  }
}