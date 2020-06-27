import 'dart:async';

import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';

import 'pharmacy_api_provider.dart';

class Repository {
  final moviesApiProvider = PharmacyApiProvider();

  DatabaseHelper databaseHelper = new DatabaseHelper();

  Future<SaleModel> fetchAllSales() => moviesApiProvider.fetchSaleList();

  Future<ItemModel> fetchBestItem() => moviesApiProvider.fetchBestItemList();

  Future<List<ItemResult>> databaseItem() => databaseHelper.getProduct();
}
