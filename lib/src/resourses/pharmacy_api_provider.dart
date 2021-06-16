import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/check_order_model_new.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/api/order_status_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view_model.dart';
import 'package:pharmacy/src/model/http_result.dart';
import 'package:pharmacy/src/model/payment_verfy.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/model/send/create_payment_model.dart';
import 'package:pharmacy/src/model/send/verfy_payment_model.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:pharmacy/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyApiProvider {
  HttpClient httpClient = new HttpClient();

  Duration duration = new Duration(seconds: 30);
  static Duration durationTimeout = new Duration(seconds: 30);

  static Future<HttpResult> postRequest(url, body) async {
    final dynamic headers = await _getReqHeader();
    print(url);
    print(headers);
    print(body);
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(durationTimeout);
      print(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }

  static Future<HttpResult> getRequest(url) async {
    final dynamic headers = await _getReqHeader();
    try {
      print(url);
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(durationTimeout);
      print(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }

  static HttpResult _result(response) {
    var result;
    int status = response.statusCode ?? 404;

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      result = json.decode(utf8.decode(response.bodyBytes));
      return HttpResult(
        isSuccess: true,
        status: status,
        result: result,
      );
    } else {
      return HttpResult(
        isSuccess: false,
        status: status,
        result: null,
      );
    }
  }

  static _getReqHeader() async {
    final prefs = await SharedPreferences.getInstance();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    if (prefs.getString('token') == null) {
      return {
        "Accept": "application/json",
        'content-type': 'application/json; charset=utf-8',
        'X-Device': encoded,
      };
    } else {
      return {
        "Accept": "application/json",
        'content-type': 'application/json; charset=utf-8',
        'X-Device': encoded,
        "Authorization": "Bearer " + prefs.getString('token')
      };
    }
  }

  ///Login
  Future<HttpResult> fetchLogin(String login) async {
    String url = Utils.baseUrl + '/api/v1/register';
    final data = {
      "login": login,
    };
    return await postRequest(url, json.encode(data));
  }

  ///verify
  Future<HttpResult> fetchVerify(
    String login,
    String code,
    String token,
  ) async {
    String url = Utils.baseUrl + '/api/v1/accept';

    final data = {
      "login": login,
      "smscode": code,
      "device_token": token,
    };
    return await postRequest(url, json.encode(data));
  }

  ///Register
  Future<HttpResult> fetchRegister(
    String name,
    String surname,
    String birthday,
    String gender,
    String token,
    String city,
    String ads,
    String fctoken,
  ) async {
    String url = Utils.baseUrl + '/api/v1/register-profil';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    final data = {
      "first_name": name,
      "last_name": surname,
      "gender": gender,
      "birth_date": birthday,
      "city": city,
      "ads": ads,
      "fctoken": fctoken,
      "region": regionId.toString(),
    };

    final dynamic headers = {
      "Accept": "application/json",
      'X-Device': encoded,
      "Authorization": "Bearer " + token
    };
    print(url);
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: data,
          )
          .timeout(durationTimeout);
      print(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }

  ///Banner
  Future<HttpResult> fetchBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/sales?region=$regionId';

    return await getRequest(url);
  }

  ///Blog
  Future<HttpResult> fetchBlog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String language = prefs.getString('language') ?? "ru";

    String url = Utils.baseUrl +
        '/api/v1/pages?choice=blog&region=$regionId&lan=$language';

    return await getRequest(url);
  }

  ///CashBack
  Future<HttpResult> fetchCashBackTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String language = prefs.getString('language') ?? "ru";

    String url = Utils.baseUrl +
        '/api/v1/pages?choice=cashback&region=$regionId&lan=$language';

    return await getRequest(url);
  }

  ///best items
  Future<HttpResult> fetchBestItemList(
    int page,
    int perPage,
    String ordering,
    String priceMax,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'is_home=1&'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            'ordering=$ordering&'
            'price_max=$priceMax';
    return await getRequest(url);
  }

  ///Top category
  Future<HttpResult> fetchTopCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String url =
        Utils.baseUrl + '/api/v1/categories?popular=true&region=$regionId';
    return await getRequest(url);
  }

  ///slimming
  Future<HttpResult> fetchSlimming() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String language = prefs.getString('language') ?? "ru";
    String url = Utils.baseUrl +
        '/api/v1/drugs/collections?region=$regionId&lan=$language';
    return await getRequest(url);
  }

  ///category
  Future<HttpResult> fetchCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/categories?region=$regionId';

    return await getRequest(url);
  }

  ///category's by item
  Future<HttpResult> fetchCategoryItemsList(
    String id,
    int page,
    int perPage,
    String ordering,
    String priceMax,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            'category=$id&'
            'ordering=$ordering&'
            'price_max=$priceMax';

    return await getRequest(url);
  }

  ///ids's by item
  Future<HttpResult> fetchIdsItemsList(
    String id,
    int page,
    int perPage,
    String ordering,
    String priceMax,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            'ids=$id&'
            'ordering=$ordering&'
            'price_max=$priceMax';

    return await getRequest(url);
  }

  ///search's by item
  Future<ItemModel> fetchSearchItemsList(
    String obj,
    int page,
    int perPage,
    String ordering,
    String priceMax,
    int barcode,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String search = barcode == 1 ? "barcode=$obj" : "search=$obj";

    String url = Utils.baseUrl +
        '/api/v1/drugs?'
            'page=$page&'
            'region=$regionId&'
            'per_page=$perPage&'
            '$search&'
            'ordering=$ordering&'
            'price_max=$priceMax';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return ItemModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      return null;
    } on SocketException catch (_) {
      return null;
    }
  }

  ///items
  Future<HttpResult> fetchItems(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/drugs/$id?region=$regionId';

    return await getRequest(url);
  }

  ///regions
  Future<List<RegionModel>> fetchRegions(String obj) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');
    if (lan == null) {
      lan = "ru";
    }

    String url = Utils.baseUrl + '/api/v1/regions?search=$obj&lan=$lan';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headers).timeout(duration);
      var responseJson = utf8.decode(response.bodyBytes);
      return regionModelFromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return null;
    }
  }

  ///History
  Future<HttpResult> fetchOrderHistory(int page, int perPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String lan = prefs.getString('language') ?? "ru";
    String url = Utils.baseUrl +
        '/api/v1/orders?'
            'page=$page&'
            'per_page=$perPage&'
            'lan=$lan&'
            'region=$regionId';
    return await getRequest(url);
  }

  ///Cancel order
  Future<HttpResult> fetchCancelOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId") ?? "";
    String lan = prefs.getString('language') ?? "ru";
    String url = Utils.baseUrl +
        '/api/v1/order-cancel?'
            'lan=$lan&'
            'region=$regionId';

    final data = {
      "order": orderId.toString(),
    };
    return await postRequest(url, json.encode(data));
  }

  /// Order options
  Future<HttpResult> fetchOrderOptions(String lan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url =
        Utils.baseUrl + '/api/v1/order-options?lan=$lan&region=$regionId';

    return await getRequest(url);
  }

  ///access store
  Future<HttpResult> fetchAccessStore(AccessStore accessStore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/exists-stores?region=$regionId';
    return await postRequest(url, json.encode(accessStore));
  }

  ///Min sum
  Future<HttpResult> fetchMinSum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/order-minimum?region=$regionId';

    return await getRequest(url);
  }

  ///Check error pickup
  Future<HttpResult> fetchCheckErrorPickup(
    AccessStore accessStore,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String lan = prefs.getString("language") ?? "ru";

    String url =
        Utils.baseUrl + '/api/v1/check-error?lan=$lan&region=$regionId';

    return await postRequest(url, json.encode(accessStore));
  }

  ///Check error delivery
  Future<CheckErrorModel> fetchCheckErrorDelivery(
      AccessStore accessStore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");
    String lan = prefs.getString("language") ?? "ru";

    String url = Utils.baseUrl +
        '/api/v1/check-shipping-error?lan=$lan&region=$regionId';
    String token = prefs.getString("token");

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url),
              headers: headers, body: json.encode(accessStore))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return CheckErrorModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      return CheckErrorModel(error: 1, msg: translate("internet_error"));
    }
  }

  ///payment verify token
  Future<PaymentVerfy> fetchVerfyPaymentModel(VerdyPaymentModel verfy) async {
    String url = Utils.baseUrl + '/api/v1/verify-token';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };
    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(verfy))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return PaymentVerfy.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return PaymentVerfy(
          errorCode: -1, errorNote: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return PaymentVerfy(
          errorCode: -1, errorNote: translate("internet_error"));
    }
  }

  ///check version
  Future<HttpResult> fetchCheckVersion(String version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = {
      "version": version,
      "device": Platform.isIOS ? "ios" : "android"
    };
    String lan = prefs.getString('language') ?? "ru";
    String url = Utils.baseUrl + '/api/v1/check-version?lan=$lan';

    return await postRequest(url, json.encode(data));
  }

  ///send rating
  Future<HttpResult> fetchSendRating(String comment, int rating) async {
    String url = Utils.baseUrl + '/api/v1/send-review';
    final data = {
      "comment": comment,
      "rating": rating.toString(),
    };
    return await postRequest(url, json.encode(data));
  }

  ///get-no-reviews
  Future<HttpResult> fetchGetNoReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/get-no-reviews?region=$regionId';
    return await getRequest(url);
  }

  ///order item review
  Future<HttpResult> fetchOrderItemReview(
    String comment,
    int rating,
    int orderId,
  ) async {
    String url = Utils.baseUrl + '/api/v1/send-order-reviews';

    final data = {
      "review": comment,
      "rating": rating.toString(),
      "order_id": orderId.toString(),
    };

    return await postRequest(url, json.encode(data));
  }

  /// Cash back
  Future<HttpResult> fetchCashBack() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/user-cashback?region=$regionId';

    return await getRequest(url);
  }

  /// FAQ
  Future<HttpResult> fetchFAQ() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language') ?? "ru";
    int regionId = prefs.getInt("cityId");

    String url = Utils.baseUrl + '/api/v1/faq?lan=$lan&region=$regionId';
    return await getRequest(url);
  }

  ///create order
  Future<HttpResult> fetchCreateOrder(CreateOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language') ?? "ru";
    int regionId = prefs.getInt("cityId");

    String url =
        Utils.baseUrl + '/api/v1/create-order?lan=$lan&region=$regionId';

    return await postRequest(url, json.encode(order));
  }

  ///check order
  Future<CheckOrderModelNew> fetchCheckOrder(CreateOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');
    int regionId = prefs.getInt("cityId");
    if (lan == null) {
      lan = "ru";
    }

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    String url =
        Utils.baseUrl + '/api/v1/check-order?lan=$lan&region=$regionId';

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(order))
          .timeout(duration);

      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return CheckOrderModelNew.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckOrderModelNew(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return CheckOrderModelNew(status: -1, msg: translate("internet_error"));
    }
  }

  ///Payment
  Future<OrderStatusModel> fetchPayment(PaymentOrderModel order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String lan = prefs.getString('language');
    int regionId = prefs.getInt("cityId");
    if (lan == null) {
      lan = "ru";
    }

    String url =
        Utils.baseUrl + '/api/v1/activate-order?lan=$lan&region=$regionId';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'content-type': 'application/json',
      'X-Device': encoded,
    };

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(order))
          .timeout(duration);

      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

      return OrderStatusModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///set location to region
  Future<OrderStatusModel> fetchGetRegion(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');
    if (lan == null) {
      lan = "ru";
    }

    final data = {
      "location": location,
    };

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    Map<String, String> headers = {
      'content-type': 'application/json; charset=utf-8',
      'X-Device': encoded,
    };

    String url = Utils.baseUrl + '/api/v1/check-region-polygon?lan=$lan';

    try {
      http.Response response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(data))
          .timeout(duration);
      final Map responseJson = json.decode(utf8.decode(response.bodyBytes));
      return OrderStatusModel.fromJson(responseJson);
    } on TimeoutException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    } on SocketException catch (_) {
      RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    }
  }

  ///add region
  Future<OrderStatusModel> fetchAddRegion(int regionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString('language');
    String token = prefs.getString("token");
    if (lan == null) {
      lan = "ru";
    }

    final data = {
      "region": regionId.toString(),
    };
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = prefs.getString("deviceData") != null
        ? stringToBase64.encode(prefs.getString("deviceData"))
        : "";

    String url = Utils.baseUrl + '/api/v1/add-region?lan=$lan';
    if (token != null) {
      try {
        Map<String, String> headers = {
          'content-type': 'application/json; charset=utf-8',
          HttpHeaders.authorizationHeader: "Bearer $token",
          'X-Device': encoded,
        };
        http.Response response = await http
            .post(Uri.parse(url), headers: headers, body: json.encode(data))
            .timeout(duration);
        final Map responseJson = json.decode(utf8.decode(response.bodyBytes));

        return OrderStatusModel.fromJson(responseJson);
      } on TimeoutException catch (_) {
        RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
        return OrderStatusModel(status: -1, msg: translate("internet_error"));
      } on SocketException catch (_) {
        RxBus.post(BottomViewModel(1), tag: "EVENT_BOTTOM_VIEW_ERROR");
        return OrderStatusModel(status: -1, msg: translate("internet_error"));
      }
    } else {
      return OrderStatusModel(status: -1, msg: translate("internet_error"));
    }
  }
}
