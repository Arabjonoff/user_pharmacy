import 'dart:async';

import 'package:pharmacy/src/database/database_helper.dart';
import 'package:pharmacy/src/database/database_helper_fav.dart';
import 'package:pharmacy/src/database/database_helper_note.dart';
import 'package:pharmacy/src/model/api/cancel_order.dart';
import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/api/auth/login_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/check_order_model_new.dart';
import 'package:pharmacy/src/model/api/check_version.dart';
import 'package:pharmacy/src/model/api/current_location_address_model.dart';
import 'package:pharmacy/src/model/api/faq_model.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/model/api/order_status_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/model/check_error_model.dart';
import 'package:pharmacy/src/model/create_order_status_model.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/model/http_result.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/model/payment_verfy.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/model/send/add_order_model.dart';
import 'package:pharmacy/src/model/send/create_order_model.dart';
import 'package:pharmacy/src/model/send/create_payment_model.dart';
import 'package:pharmacy/src/model/send/verfy_payment_model.dart';

import 'pharmacy_api_provider.dart';

class Repository {
  final pharmacyApiProvider = PharmacyApiProvider();

  DatabaseHelper databaseHelper = new DatabaseHelper();
  DatabaseHelperFav databaseHelperFav = new DatabaseHelperFav();
  DatabaseHelperNote databaseHelperNote = new DatabaseHelperNote();

  Future<HttpResult> fetchLogin(String login) =>
      pharmacyApiProvider.fetchLogin(login);

  Future<HttpResult> fetchVerify(String login, String code, String token) =>
      pharmacyApiProvider.fetchVerify(login, code, token);

  Future<HttpResult> fetchRegister(
    String name,
    String surname,
    String birthday,
    String gender,
    String token,
    String city,
    String ads,
    String fctoken,
  ) =>
      pharmacyApiProvider.fetchRegister(
        name,
        surname,
        birthday,
        gender,
        token,
        city,
        ads,
        fctoken,
      );

  Future<HttpResult> fetchAllSales() => pharmacyApiProvider.fetchBanner();

  Future<HttpResult> fetchBlog() => pharmacyApiProvider.fetchBlog();

  Future<HttpResult> fetchTopCategory() =>
      pharmacyApiProvider.fetchTopCategory();

  Future<HttpResult> fetchSlimming() => pharmacyApiProvider.fetchSlimming();

  Future<HttpResult> fetchCashBackTitle() =>
      pharmacyApiProvider.fetchCashBackTitle();

  Future<HttpResult> fetchBestItem(
    int page,
    String ordering,
    String priceMax,
  ) =>
      pharmacyApiProvider.fetchBestItemList(
        page,
        20,
        ordering,
        priceMax,
      );

  Future<CategoryModel> fetchCategoryItem() =>
      pharmacyApiProvider.fetchCategoryList();

  Future<List<ItemResult>> databaseItem() => databaseHelper.getProduct();

  Future<List<NoteModel>> databaseNote() => databaseHelperNote.getProduct();

  Future<List<ItemResult>> databaseCardItem(bool isCard) =>
      databaseHelper.getProdu(isCard);

  Future<List<ItemResult>> databaseFavItem() => databaseHelperFav.getProduct();

  Future<HttpResult> fetchCategoryItemList(
    String id,
    int page,
    String ordering,
    String priceMax,
  ) =>
      pharmacyApiProvider.fetchCategoryItemsList(
        id,
        page,
        20,
        ordering,
        priceMax,
      );

  Future<HttpResult> fetchIdsItemsList(
    String id,
    int page,
    String ordering,
    String priceMax,
  ) =>
      pharmacyApiProvider.fetchIdsItemsList(
        id,
        page,
        20,
        ordering,
        priceMax,
      );

  Future<ItemModel> fetchSearchItemList(
    String obj,
    int page,
    String ordering,
    String priceMax,
    int barcode,
  ) =>
      pharmacyApiProvider.fetchSearchItemsList(
        obj,
        page,
        20,
        ordering,
        priceMax,
        barcode,
      );

  Future<HttpResult> fetchItems(String id) =>
      pharmacyApiProvider.fetchItems(id);

  Future<List<LocationModel>> fetchStore(double lat, double lng) =>
      pharmacyApiProvider.fetchApteka(lat, lng);

  Future<List<LocationModel>> fetchAccessStore(AccessStore accessStore) =>
      pharmacyApiProvider.fetchAccessApteka(accessStore);

  Future<List<RegionModel>> fetchRegions(String obj) =>
      pharmacyApiProvider.fetchRegions(obj);

  Future<OrderStatusModel> fetchAddOrder(AddOrderModel order) =>
      pharmacyApiProvider.fetchAddOrder(order);

  Future<OrderStatusModel> fetchPayment(PaymentOrderModel order) =>
      pharmacyApiProvider.fetchPayment(order);

  Future<CreateOrderStatusModel> fetchCreateOrder(CreateOrderModel order) =>
      pharmacyApiProvider.fetchCreateOrder(order);

  Future<CheckOrderModelNew> fetchCheckOrder(CreateOrderModel order) =>
      pharmacyApiProvider.fetchCheckOrder(order);

  Future<HistoryModel> fetchHistory(int page) =>
      pharmacyApiProvider.fetchOrderHistory(page, 20);

  Future<CancelOrder> fetchCancelOrder(int orderId) =>
      pharmacyApiProvider.fetchCancelOrder(orderId);

  Future<FilterModel> fetchFilterParameters(
    int page,
    int filterType,
    String search,
    int type,
    String id,
  ) =>
      pharmacyApiProvider.fetchFilterParameters(
        page,
        50,
        filterType,
        search,
        type,
        id,
      );

  Future<OrderOptionsModel> fetchOrderOptions(String lan) =>
      pharmacyApiProvider.fetchOrderOptions(lan);

  Future<ChatApiModel> fetchGetAppMessage(int page) =>
      pharmacyApiProvider.fetchGetAppMessage(page, 20);

  Future<LoginModel> fetchSentMessage(String message) =>
      pharmacyApiProvider.fetchSentMessage(message);

  Future<HttpResult> fetchCheckErrorPickup(
    AccessStore accessStore,
  ) =>
      pharmacyApiProvider.fetchCheckErrorPickup(
        accessStore,
      );

  Future<CheckErrorModel> fetchCheckErrorDelivery(
          AccessStore accessStore, String language) =>
      pharmacyApiProvider.fetchCheckErrorDelivery(accessStore, language);

  Future<PaymentVerfy> fetchVerifyPaymentModel(VerdyPaymentModel verify) =>
      pharmacyApiProvider.fetchVerfyPaymentModel(verify);

  Future<int> fetchMinSum() => pharmacyApiProvider.fetchMinSum();

  Future<HttpResult> fetchCheckVersion(String version) =>
      pharmacyApiProvider.fetchCheckVersion(version);

  Future<CheckVersion> fetchSendRating(String comment, int rating) =>
      pharmacyApiProvider.fetchSendRating(comment, rating);

  Future<HttpResult> fetchOrderItemReview(
          String comment, int rating, int orderId) =>
      pharmacyApiProvider.fetchOrderItemReview(comment, rating, orderId);

  Future<HttpResult> fetchGetNoReview() =>
      pharmacyApiProvider.fetchGetNoReviews();

  Future<CashBackModel> fetchCashBack() => pharmacyApiProvider.fetchCashBack();

  Future<List<FaqModel>> fetchFAQ() => pharmacyApiProvider.fetchFAQ();

  Future<OrderStatusModel> fetchGetRegion(String location) =>
      pharmacyApiProvider.fetchGetRegion(location);

  Future<OrderStatusModel> fetchAddRegion(int regionId) =>
      pharmacyApiProvider.fetchAddRegion(regionId);

  Future<CurrentLocationAddressModel> fetchLocationAddress(
          double lat, double lng) =>
      pharmacyApiProvider.fetchLocationAddress(lat, lng);
}
