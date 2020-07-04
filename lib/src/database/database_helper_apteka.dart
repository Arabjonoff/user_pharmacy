import 'dart:async';

import 'package:path/path.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperApteka {
  static final DatabaseHelperApteka _instance = new DatabaseHelperApteka.internal();

  factory DatabaseHelperApteka() => _instance;

  final String tableNote = 'aptekaTable';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnOpen = 'open';
  final String columnNumber = 'number';
  final String columnLat = 'lat';
  final String columnLon = 'lon';

  static Database _db;

  DatabaseHelperApteka.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'apteka.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableNote('
        '$columnId INTEGER PRIMARY KEY, '
        '$columnName TEXT, '
        '$columnOpen TEXT, '
        '$columnNumber TEXT, '
        '$columnLat REAL, '
        '$columnLon REAL)');
  }

  Future<int> saveProducts(AptekaModel item) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableNote, item.toMap());
    return result;
  }

  Future<List> getAllProducts() async {
    var dbClient = await db;
    var result = await dbClient.query(tableNote, columns: [
      columnId,
      columnName,
      columnOpen,
      columnNumber,
      columnLat,
      columnLon,
    ]);

    return result.toList();
  }

  Future<List<AptekaModel>> getProduct() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $tableNote');
    List<AptekaModel> products = new List();
    for (int i = 0; i < list.length; i++) {
      var items = new AptekaModel(
        list[i][columnId],
        list[i][columnName],
        list[i][columnOpen],
        list[i][columnNumber],
        list[i][columnLat],
        list[i][columnLon],
        true
      );
      products.add(items);
    }
    return products;
  }

  Future<AptekaModel> getProducts(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableNote,
        columns: [
          columnId,
          columnName,
          columnOpen,
          columnNumber,
          columnLat,
          columnLon,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return AptekaModel.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteProducts(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateProduct(AptekaModel products) async {
    var dbClient = await db;
    return await dbClient.update(tableNote, products.toMap(),
        where: "$columnId = ?", whereArgs: [products.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
