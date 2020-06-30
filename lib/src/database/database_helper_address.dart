import 'dart:async';

import 'package:path/path.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperAddress {
  static final DatabaseHelperAddress _instance =
      new DatabaseHelperAddress.internal();

  factory DatabaseHelperAddress() => _instance;

  final String tableNote = 'addressTable';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnFlat = 'flat';
  final String columnPadez = 'padez';
  final String columnEtaj = 'etaj';
  final String columnKomment = 'komment';

  static Database _db;

  DatabaseHelperAddress.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'address.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableNote('
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnName TEXT, '
        '$columnFlat TEXT, '
        '$columnPadez TEXT, '
        '$columnEtaj TEXT, '
        '$columnKomment TEXT)');
  }

  Future<int> saveProducts(AddressModel item) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableNote, item.toMap());
    return result;
  }

  Future<List> getAllProducts() async {
    var dbClient = await db;
    var result = await dbClient.query(tableNote, columns: [
      columnId,
      columnName,
      columnFlat,
      columnPadez,
      columnEtaj,
      columnKomment,
    ]);

    return result.toList();
  }

  Future<List<AddressModel>> getProduct() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $tableNote');
    List<AddressModel> products = new List();
    for (int i = 0; i < list.length; i++) {
      var items = new AddressModel(
        list[i][columnId],
        list[i][columnName],
        list[i][columnFlat],
        list[i][columnPadez],
        list[i][columnEtaj],
        list[i][columnKomment],
      );
      products.add(items);
    }
    return products;
  }

  Future<List<AddressModel>> getProdu(bool card) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $tableNote');
    List<AddressModel> products = new List();
    for (int i = 0; i < list.length; i++) {
      var items = new AddressModel(
        list[i][columnId],
        list[i][columnName],
        list[i][columnFlat],
        list[i][columnPadez],
        list[i][columnEtaj],
        list[i][columnKomment],
      );
      products.add(items);
    }
    return products;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableNote'));
  }

  Future<AddressModel> getProducts(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableNote,
        columns: [
          columnId,
          columnName,
          columnFlat,
          columnPadez,
          columnEtaj,
          columnKomment,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return AddressModel.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteProducts(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateProduct(AddressModel products) async {
    var dbClient = await db;
    return await dbClient.update(tableNote, products.toMap(),
        where: "$columnId = ?", whereArgs: [products.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
