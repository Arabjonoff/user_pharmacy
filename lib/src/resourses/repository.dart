import 'dart:async';

import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_apteka.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/auth/verfy_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/api/order_status_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';

import 'pharmacy_api_provider.dart';

class Repository {
  final pharmacyApiProvider = PharmacyApiProvider();

  DatabaseHelper databaseHelper = new DatabaseHelper();
  DatabaseHelperApteka dbApteka = new DatabaseHelperApteka();

  Future<LoginModel> fetchLogin(String login) =>
      pharmacyApiProvider.fetchLogin(login);

  Future<VerfyModel> fetchVetfy(String login, String code) =>
      pharmacyApiProvider.fetchVerfy(login, code);

  Future<LoginModel> fetchRegister(String name, String surname, String birthday,
          String gender, String token) =>
      pharmacyApiProvider.fetchRegister(name, surname, birthday, gender, token);

  Future<SaleModel> fetchAllSales() => pharmacyApiProvider.fetchSaleList();

  Future<ItemModel> fetchBestItem(int page) =>
      pharmacyApiProvider.fetchBestItemList(page, 12);

  Future<CategoryModel> fetchCategoryItem() =>
      pharmacyApiProvider.fetchCategoryList();

  Future<CategoryModel> fetchSearchItem() =>
      pharmacyApiProvider.fetchCategoryList();

  Future<List<ItemResult>> databaseItem() => databaseHelper.getProduct();

  Future<List<AptekaModel>> dbAptekaItems() => dbApteka.getProduct();

  Future<List<ItemResult>> databaseCardItem(bool isCard) =>
      databaseHelper.getProdu(isCard);

  Future<ItemModel> fetchCategryItemList(String id, int page) =>
      pharmacyApiProvider.fetchCategoryItemsList(id, page, 12);

  Future<ItemModel> fetchSearchItemList(String obj, int page) =>
      pharmacyApiProvider.fetchSearchItemsList(obj, page, 12);

  Future<ItemsAllModel> fetchItems(String id) =>
      pharmacyApiProvider.fetchItems(id);

  Future<List<LocationModel>> fetchApteka() =>
      pharmacyApiProvider.fetchApteka();

  Future<List<RegionModel>> fetchRegions(String obj) =>
      pharmacyApiProvider.fetchRegions(obj);

  Future<OrderStatusModel> fetchRAddOrder(AddOrderModel order) =>
      pharmacyApiProvider.fetchAddOrder(order);

  Future<HistoryModel> fetchHistory() =>
      pharmacyApiProvider.fetchOrderHistory();
}
