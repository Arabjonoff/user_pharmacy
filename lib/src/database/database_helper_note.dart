import 'dart:async';

import 'package:path/path.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperNote {
  static final DatabaseHelperNote _instance = new DatabaseHelperNote.internal();

  factory DatabaseHelperNote() => _instance;

  final String tableNote = 'noteTable';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnDoza = 'doza';
  final String columnEda = 'eda';
  final String columnTime = 'time';
  final String columnGroupName = 'groupsName';
  final String columnDateItem = 'dateItem';
  final String columnMark = 'mark';

  static Database _db;

  DatabaseHelperNote.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notetab.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableNote('
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnName TEXT, '
        '$columnDoza TEXT, '
        '$columnEda TEXT, '
        '$columnTime TEXT, '
        '$columnGroupName TEXT, '
        '$columnDateItem TEXT, '
        '$columnMark INTEGER)');
  }

  Future<int> saveProducts(NoteModel item) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableNote, item.toJson());
    return result;
  }

  Future<List> getAllProducts() async {
    var dbClient = await db;
    var result = await dbClient.query(tableNote, columns: [
      columnId,
      columnName,
      columnDoza,
      columnEda,
      columnTime,
      columnGroupName,
      columnDateItem,
      columnMark,
    ]);

    return result.toList();
  }

  Future<List<NoteModel>> getProduct() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $tableNote');
    List<NoteModel> products = new List();
    for (int i = 0; i < list.length; i++) {
      var items = new NoteModel(
        id: list[i][columnId],
        name: list[i][columnName],
        doza: list[i][columnDoza],
        eda: list[i][columnEda],
        time: list[i][columnTime],
        groupsName: list[i][columnGroupName],
        dateItem: list[i][columnDateItem],
        mark: list[i][columnMark],
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

  Future<NoteModel> getProducts(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableNote,
        columns: [
          columnId,
          columnName,
          columnDoza,
          columnEda,
          columnTime,
          columnGroupName,
          columnDateItem,
          columnMark,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return NoteModel.fromJson(result.first);
    }

    return null;
  }

  Future<List<NoteModel>> getProductsGroup(String id) async {
    var dbClient = await db;
    List<NoteModel> products = new List();
    List<Map> result = await dbClient.query(tableNote,
        columns: [
          columnId,
          columnName,
          columnDoza,
          columnEda,
          columnTime,
          columnGroupName,
          columnDateItem,
          columnMark,
        ],
        where: '$columnGroupName = ?',
        whereArgs: [id]);

    for (int i = 0; i < result.length; i++) {
      var items = new NoteModel(
        id: result[i][columnId],
        name: result[i][columnName],
        doza: result[i][columnDoza],
        eda: result[i][columnEda],
        time: result[i][columnTime],
        groupsName: result[i][columnGroupName],
        dateItem: result[i][columnDateItem],
        mark: result[i][columnMark],
      );
      products.add(items);
    }

    // if (result.length > 0) {
    //   return NoteModel.fromJson(result.first);
    // }

    return products;
  }

  Future<int> deleteProducts(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteProductsGroup(String id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNote, where: '$columnGroupName = ?', whereArgs: [id]);
  }

  Future<int> updateProduct(NoteModel products) async {
    var dbClient = await db;
    return await dbClient.update(tableNote, products.toJson(),
        where: "$columnId = ?", whereArgs: [products.id]);
  }

  Future<void> clear() async {
    var dbClient = await db;
    await dbClient.rawQuery('DELETE FROM $tableNote');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
