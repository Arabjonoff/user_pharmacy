import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pharmacy/src/model/api/chech_error.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/auth/verfy_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/check_order_responce.dart';
import 'package:pharmacy/src/model/api/check_version.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/api/min_sum.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/api/order_status_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/model/payment_verfy.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';
import 'package:pharmacy/src/model/send/check_order.dart';
import 'package:pharmacy/src/model/send/verfy_payment_model.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyApiProvider {
  HttpClient httpClient = new HttpClient();

  ///Login
  Future<LoginModel> fetchLogin(String login) async {
    String url = Utils.BASE_URL + '/api/v1/register';

    final data = {
      "login": login,
    };

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.write(json.encode(data));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

//    http.Response response =
//        await http.post(url, body: data).timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(reply);

    return LoginModel.fromJson(parsed);
  }

  ///verfy
  Future<VerfyModel> fetchVerfy(String login, String code, String token) async {
    String url = Utils.BASE_URL + '/api/v1/accept';

    final data = {
      "login": login,
      "smscode": code,
      "device_token": token,
    };

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.write(json.encode(data));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);

    return VerfyModel.fromJson(parsed);
  }

  ///Register
  Future<LoginModel> fetchRegister(String name, String surname, String birthday,
      String gender, String token) async {
    String url = Utils.BASE_URL + '/api/v1/register-profil';

    final data = {
      "first_name": name,
      "last_name": surname,
      "gender": gender,
      "birth_date": birthday,
    };

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    http.Response response = await http
        .post(url, headers: headers, body: data)
        .timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return LoginModel.fromJson(parsed);
  }

  ///Sale
  Future<SaleModel> fetchSaleList() async {
    String url = Utils.BASE_URL + '/api/v1/sales';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return SaleModel.fromJson(parsed);
  }

  ///best items
  Future<ItemModel> fetchBestItemList(
    int page,
    int per_page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    String url = Utils.BASE_URL +
        '/api/v1/drugs?'
            'is_home=1&'
            'page=$page&'
            'per_page=$per_page&'
            'international_name_ids=$international_name_ids&'
            'manufacturer_ids=$manufacturer_ids&'
            'ordering=$ordering&'
            'price_max=$price_max&'
            'price_min=$price_min&'
            'unit_ids=$unit_ids';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
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
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
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
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }

  ///category's by item
  Future<ItemModel> fetchCategoryItemsList(
    String id,
    int page,
    int per_page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    String url = Utils.BASE_URL +
        '/api/v1/drugs?'
            'page=$page&'
            'per_page=$per_page&'
            'category=$id&'
            'international_name_ids=$international_name_ids&'
            'manufacturer_ids=$manufacturer_ids&'
            'ordering=$ordering&'
            'price_max=$price_max&'
            'price_min=$price_min&'
            'unit_ids=$unit_ids';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemModel.fromJson(parsed);
  }

  ///search's by item
  Future<ItemModel> fetchSearchItemsList(
    String obj,
    int page,
    int per_page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    String url = Utils.BASE_URL +
        '/api/v1/drugs?'
            'page=$page&'
            'per_page=$per_page&'
            'search=$obj&'
            'international_name_ids=$international_name_ids&'
            'manufacturer_ids=$manufacturer_ids&'
            'ordering=$ordering&'
            'price_max=$price_max&'
            'price_min=$price_min&'
            'unit_ids=$unit_ids';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
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
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);
    return ItemsAllModel.fromJson(parsed);
  }

  ///items
  Future<List<LocationModel>> fetchApteka(double lat, double lng) async {
    String url = Utils.BASE_URL + '/api/v1/stores?lat=$lat&lng=$lng';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    return locationModelFromJson(reply);
  }

  ///regions
  Future<List<RegionModel>> fetchRegions(String obj) async {
    String url = Utils.BASE_URL + '/api/v1/regions?search=' + obj;

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    return regionModelFromJson(reply);
  }

  ///add order
  Future<OrderStatusModel> fetchAddOrder(AddOrderModel order) async {
    String url = Utils.BASE_URL + '/api/v1/add-order';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json'
    };

    http.Response response = await http
        .post(url, headers: headers, body: json.encode(order))
        .timeout(const Duration(seconds: 120));

    final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

    return OrderStatusModel.fromJson(responseJson);
  }

  ///add order
  Future<HistoryModel> fetchOrderHistory() async {
    String url = Utils.BASE_URL + '/api/v1/orders';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);

    return HistoryModel.fromJson(parsed);
  }

  /// Filter parametrs
  Future<FilterModel> fetchFilterParametrs(
      int page, int per_page, int type) async {
    String url = type == 1
        ? Utils.BASE_URL + '/api/v1/units?page=$page&per_page=$per_page'
        : type == 2
            ? Utils.BASE_URL +
                '/api/v1/manufacturers?page=$page&per_page=$per_page'
            : Utils.BASE_URL +
                '/api/v1/international-names?page=$page&per_page=$per_page';

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);

    return FilterModel.fromJson(parsed);
  }

  /// Filter parametrs
  Future<OrderOptionsModel> fetchOrderOptions(String lan) async {
    String url = Utils.BASE_URL + '/api/v1/order-options?lan=$lan';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);

    return OrderOptionsModel.fromJson(parsed);
  }

  /// Check order
  Future<CheckOrderResponceModel> fetchCheckOrder(CheckOrderModel order) async {
    String url = Utils.BASE_URL + '/api/v1/check-order';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    request.write(json.encode(order));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    final Map parsed = json.decode(reply);

    return CheckOrderResponceModel.fromJson(parsed);
  }

  ///items
  Future<List<LocationModel>> fetchAccessApteka(AccessStore accessStore) async {
    String url = Utils.BASE_URL + '/api/v1/exists-stores';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.write(json.encode(accessStore));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    return locationModelFromJson(reply);
  }

  ///reload payment
  Future<OrderStatusModel> fetchOrderPayment(String id) async {
    String url = Utils.BASE_URL + '/api/v1/order-payment';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    final data = {"order_id": id};

    http.Response response = await http
        .post(url, headers: headers, body: data)
        .timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return OrderStatusModel.fromJson(parsed);
  }

  ///get all message
  Future<ChatApiModel> fetchGetAppMessage(int page, int per_page) async {
    String url =
        Utils.BASE_URL + '/api/v1/chat/messages?page=$page&per_page=$per_page';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);

    return ChatApiModel.fromJson(parsed);
  }

  ///sent message
  Future<LoginModel> fetchSentMessage(String message) async {
    String url = Utils.BASE_URL + '/api/v1/chat/send-message';

    final data = {"message": message};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    http.Response response = await http
        .post(url, headers: headers, body: data)
        .timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return LoginModel.fromJson(parsed);
  }

  ///Min sum
  Future<int> fetchMinSum() async {
    String url = Utils.BASE_URL + '/api/v1/order-minimum';

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);

    return MinSum.fromJson(parsed).min;
  }

  ///items
  Future<CheckError> fetchCheckError(
      AccessStore accessStore, String language) async {
    String url = Utils.BASE_URL + '/api/v1/check-error?lang=$language';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    request.write(json.encode(accessStore));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);

    return CheckError.fromJson(parsed);
  }

  ///items
  Future<PaymentVerfy> fetchVerfyPaymentModel(VerdyPaymentModel verfy) async {
    String url = Utils.BASE_URL + '/api/v1/verify-token';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    HttpClient httpClient = new HttpClient();
    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.headers.set(HttpHeaders.authorizationHeader, "Bearer $token");
    request.write(json.encode(verfy));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    final Map parsed = json.decode(reply);
    return PaymentVerfy.fromJson(parsed);
  }

  ///items
  Future<CheckVersion> fetchCheckVersion(String version) async {
    String url = Utils.BASE_URL + '/api/v1/check-version';

    final data = {"version": version};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
    };

    http.Response response = await http
        .post(url, headers: headers, body: data)
        .timeout(const Duration(seconds: 120));

    final Map parsed = json.decode(response.body);

    return CheckVersion.fromJson(parsed);
  }
}
