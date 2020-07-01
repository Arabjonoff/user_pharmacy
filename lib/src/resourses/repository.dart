import 'dart:async';

import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';

import 'pharmacy_api_provider.dart';

class Repository {
  final pharmacyApiProvider = PharmacyApiProvider();

  DatabaseHelper databaseHelper = new DatabaseHelper();

  Future<SaleModel> fetchAllSales() => pharmacyApiProvider.fetchSaleList();

  Future<ItemModel> fetchBestItem(int page, int per_page) =>
      pharmacyApiProvider.fetchBestItemList(page, per_page);

  Future<CategoryModel> fetchCategoryItem() =>
      pharmacyApiProvider.fetchCategoryList();

  Future<CategoryModel> fetchSearchItem() =>
      pharmacyApiProvider.fetchCategoryList();

  Future<List<ItemResult>> databaseItem() => databaseHelper.getProduct();

  Future<ItemModel> fetchCategryItemList(String id) =>
      pharmacyApiProvider.fetchCategoryItemsList(id);

  Future<ItemModel> fetchSearchItemList(String obj, int page) =>
      pharmacyApiProvider.fetchSearchItemsList(obj, page);

  Future<ItemsAllModel> fetchItems(String id) =>
      pharmacyApiProvider.fetchItems(id);
}
