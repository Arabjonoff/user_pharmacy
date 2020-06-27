import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/utils/utils.dart';

class PharmacyApiProvider {
  HttpClient httpClient = new HttpClient();

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
  Future<ItemModel> fetchBestItemList() async {
    String url = Utils.BASE_URL + '/api/v1/drugs?is_home=1';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }
}
