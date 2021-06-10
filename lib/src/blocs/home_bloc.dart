import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc {
  final _repository = Repository();
  final _bannerFetcher = PublishSubject<BannerModel>();
  final _cityNameFetcher = PublishSubject<String>();
  final _bestItemFetcher = PublishSubject<ItemModel>();
  final _recentlyFetcher = PublishSubject<ItemModel>();
  final _categoryFetcher = PublishSubject<CategoryModel>();

  Stream<BannerModel> get banner => _bannerFetcher.stream;

  Stream<String> get allCityName => _cityNameFetcher.stream;

  Stream<ItemModel> get getBestItem => _bestItemFetcher.stream;

  Stream<ItemModel> get recentlyItem => _recentlyFetcher.stream;

  Stream<CategoryModel> get categoryItem => _categoryFetcher.stream;

  fetchBanner() async {
    var response = await _repository.fetchAllSales();
    if (response.isSuccess) {
      _bannerFetcher.sink.add(BannerModel.fromJson(response.result));
    } else {
      _bannerFetcher.sink.add(BannerModel(results: []));
    }
  }

  ///recently
  ItemModel recentlyItemData;

  fetchRecently() async {
    var response = await _repository.fetchBestItem(
      1,
      "",
      "",
      "",
      "",
      "",
      "",
    );
    if (response.isSuccess) {
      recentlyItemData = ItemModel.fromJson(response.result);
      List<ItemResult> database = await _repository.databaseItem();
      List<ItemResult> resultFav = await _repository.databaseFavItem();
      if (recentlyItemData.results.length > 0) {
        for (var i = 0; i < recentlyItemData.results.length; i++) {
          for (var j = 0; j < database.length; j++) {
            if (recentlyItemData.results[i].id == database[j].id) {
              recentlyItemData.results[i].cardCount = database[j].cardCount;
            }
          }
        }

        for (int i = 0; i < recentlyItemData.results.length; i++) {
          recentlyItemData.results[i].favourite = false;
          for (int j = 0; j < resultFav.length; j++) {
            if (recentlyItemData.results[i].id == resultFav[j].id) {
              recentlyItemData.results[i].favourite = resultFav[j].favourite;
              break;
            }
          }
        }
      }
      _recentlyFetcher.sink.add(recentlyItemData);
    } else {
      RxBus.post(BottomView(true), tag: "HOME_VIEW_ERROR_NETWORK");
    }
  }

  fetchRecentlyUpdate() async {
    if (recentlyItemData != null) {
      List<ItemResult> database = await _repository.databaseItem();
      List<ItemResult> resultFav = await _repository.databaseFavItem();
      if (recentlyItemData.results.length > 0) {
        for (var i = 0; i < recentlyItemData.results.length; i++) {
          recentlyItemData.results[i].cardCount = 0;
          for (var j = 0; j < database.length; j++) {
            if (recentlyItemData.results[i].id == database[j].id) {
              recentlyItemData.results[i].cardCount = database[j].cardCount;
            }
          }
        }

        for (int i = 0; i < recentlyItemData.results.length; i++) {
          recentlyItemData.results[i].favourite = false;
          for (int j = 0; j < resultFav.length; j++) {
            if (recentlyItemData.results[i].id == resultFav[j].id) {
              recentlyItemData.results[i].favourite = resultFav[j].favourite;
              break;
            }
          }
        }
      }
      _recentlyFetcher.sink.add(recentlyItemData);
    } else {
      fetchRecently();
    }
  }

  fetchCategory() async {
    var response = await _repository.fetchTopCategory();
    if (response.isSuccess) {
      _categoryFetcher.sink.add(CategoryModel.fromJson(response.result));
    } else {
      _categoryFetcher.sink.add(CategoryModel(results: []));
    }
  }

  fetchAllHome() async {
    ItemModel itemModelResponse =
        ItemModel.fromJson((await _repository.fetchBestItem(
      1,
      "",
      "",
      "",
      "",
      "",
      "",
    ))
            .result);
    List<ItemResult> database = await _repository.databaseItem();
    if (itemModelResponse.results != null) {
      for (var i = 0; i < itemModelResponse.results.length; i++) {
        for (var j = 0; j < database.length; j++) {
          if (itemModelResponse.results[i].id == database[j].id) {
            itemModelResponse.results[i].cardCount = database[j].cardCount;
          }
        }
      }
      _bestItemFetcher.sink.add(itemModelResponse);
    }
  }

  fetchCityName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("city") != null) {
      _cityNameFetcher.sink.add(prefs.getString("city"));
    }
  }

  dispose() {
    _bannerFetcher.close();
    _cityNameFetcher.close();
    _bestItemFetcher.close();
    _recentlyFetcher.close();
    _categoryFetcher.close();
  }
}

final blocHome = HomeBloc();
