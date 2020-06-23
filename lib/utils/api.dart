import 'dart:convert';
import 'dart:io';

import 'package:pharmacy/model/api/category_model.dart';
import 'package:pharmacy/model/api/item_model.dart';
import 'package:pharmacy/utils/utils.dart';

import 'file:///D:/Flutter/ishxona/user_pharmacy/lib/model/api/sale_model.dart';

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

  ///get Sale
  static Future<List<Result>> getSale() async {
    String url = Utils.BASE_URL + '/api/v1/sales';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    final Map parsed = json.decode(reply);
    final saleModel = SaleModel.fromJson(parsed);

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
    print(reply);
    final Map parsed = json.decode(reply);
    final saleModel = CategoryModel.fromJson(parsed);

    return saleModel.results;
  }
}
