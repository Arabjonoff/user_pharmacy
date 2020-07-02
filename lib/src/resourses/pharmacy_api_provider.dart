import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class PharmacyApiProvider {
  HttpClient httpClient = new HttpClient();

  ///Login
  Future<LoginModel> fetchLogin(String login) async {
    String url = Utils.BASE_URL + '/api/v1/register';

    final data = {
      "login": login,
    };

    http.Response response =
        await http.post(url, body: data).timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return LoginModel.fromJson(parsed);
  }

  ///Sale
  Future<SaleModel> fetchSaleList() async {
    String url = Utils.BASE_URL + '/api/v1/sales';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);
    return SaleModel.fromJson(parsed);
  }

  ///best items
  Future<ItemModel> fetchBestItemList(int page, int per_page) async {
    String url = Utils.BASE_URL +
        '/api/v1/drugs?is_home=1&page=$page&per_page=$per_page';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }

  ///category
  Future<CategoryModel> fetchCategoryList() async {
    String url = Utils.BASE_URL + '/api/v1/categories';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return CategoryModel.fromJson(parsed);
  }

  ///search
  Future<ItemModel> fetchSearchList(String obj) async {
    String url = Utils.BASE_URL + '/api/v1/drugs?search=' + obj;

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }

  ///category's by item
  Future<ItemModel> fetchCategoryItemsList(
      String id, int page, int per_page) async {
    String url = Utils.BASE_URL +
        '/api/v1/drugs?page=$page&per_page=$per_page&category=' +
        id;

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }

  ///search's by item
  Future<ItemModel> fetchSearchItemsList(
      String obj, int page, int per_page) async {
    String url = Utils.BASE_URL +
        '/api/v1/drugs?page=$page&per_page=$per_page&search=' +
        obj;

    print(url);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);

    return ItemModel.fromJson(parsed);
  }

  ///items
  Future<ItemsAllModel> fetchItems(String id) async {
    String url = Utils.BASE_URL + '/api/v1/drugs/' + id.toString();

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemsAllModel.fromJson(parsed);
  }
}
