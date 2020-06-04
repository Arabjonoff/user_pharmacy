import 'dart:async';

import 'package:path/path.dart';
import 'package:pharmacy/model/item_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperStar {
  static final DatabaseHelperStar _instance = new DatabaseHelperStar.internal();

  factory DatabaseHelperStar() => _instance;

  final String tableNote = 'starTable';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnImage = 'image';
  final String columnTitle = 'title';
  final String columnAbout = 'about';
  final String columnPrice = 'price';
  final String columnCount = 'cardCount';

  static Database _db;

  DatabaseHelperStar.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'star.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableNote('
        '$columnId INTEGER PRIMARY KEY, '
        '$columnName TEXT, '
        '$columnImage TEXT, '
        '$columnTitle TEXT, '
        '$columnAbout TEXT, '
        '$columnPrice TEXT, '
        '$columnCount INTEGER)');
  }

  Future<int> saveProducts(ItemModel item) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableNote, item.toMap());
    return result;
  }

  Future<List> getAllProducts() async {
    var dbClient = await db;
    var result = await dbClient.query(tableNote, columns: [
      columnId,
      columnName,
      columnImage,
      columnTitle,
      columnAbout,
      columnPrice,
      columnCount,
    ]);

    return result.toList();
  }

  Future<List<ItemModel>> getProdu() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $tableNote');
    List<ItemModel> products = new List();
    for (int i = 0; i < list.length; i++) {
      var user = new ItemModel(
        list[i]["id"],
        list[i]["name"],
        list[i]["image"],
        list[i]["title"],
        list[i]["about"],
        list[i]["price"],
        list[i]["cardCount"],
      );
      products.add(user);
    }
    return products;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableNote'));
  }

  Future<ItemModel> getProducts(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableNote,
        columns: [
          columnId,
          columnName,
          columnImage,
          columnTitle,
          columnAbout,
          columnPrice,
          columnCount,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return ItemModel.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteProducts(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateProduct(ItemModel products) async {
    var dbClient = await db;
    return await dbClient.update(tableNote, products.toMap(),
        where: "$columnId = ?", whereArgs: [products.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
