import 'dart:convert';
import 'dart:io';

import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/utils/utils.dart';

class API {
  ///get Home
  static Future<List<ItemResult>> getHome() async {
    String url = Utils.BASE_URL + '/api/v1/drugs?is_home=1';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    final Map parsed = json.decode(reply);
    final saleModel = ItemModel.fromJson(parsed);

    return saleModel.results;
  }

  ///get Category
  static Future<List<CategoryResult>> getCategory() async {
    String url = Utils.BASE_URL + '/api/v1/categories';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();

    final Map parsed = json.decode(reply);
    final saleModel = CategoryModel.fromJson(parsed);

    return saleModel.results;
  }

  ///get Items
  static Future<List<ItemResult>> getItems(int id) async {
    String url = Utils.BASE_URL + '/api/v1/drugs?category=' + id.toString();

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    final Map parsed = json.decode(reply);
    final saleModel = ItemModel.fromJson(parsed);

    return saleModel.results;
  }

  ///get search
  static Future<List<ItemResult>> getSearchItems(String obj) async {
    String url = Utils.BASE_URL + '/api/v1/drugs?search=' + obj;

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    httpClient.close();
    final Map parsed = json.decode(reply);
    final saleModel = ItemModel.fromJson(parsed);

    return saleModel.results;
  }

  ///get search
  static Future<ItemsAllModel> getItemsAllInfo(int id) async {
    String url = Utils.BASE_URL + '/api/v1/drugs/' + id.toString();

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    httpClient.close();
    final Map parsed = json.decode(reply);
    final saleModel = ItemsAllModel.fromJson(parsed);

    return saleModel;
  }
}
