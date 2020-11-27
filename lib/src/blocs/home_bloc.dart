import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc {
  final _repository = Repository();
  final _saleFetcher = PublishSubject<SaleModel>();
  final _cityNameFetcher = PublishSubject<String>();
  final _bestItemFetcher = PublishSubject<ItemModel>();

  Observable<SaleModel> get allSale => _saleFetcher.stream;

  Observable<String> get allCityName => _cityNameFetcher.stream;

  Observable<ItemModel> get getBestItem => _bestItemFetcher.stream;

  fetchAllHome(
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    SaleModel saleModel = await _repository.fetchAllSales();
    if (saleModel.results != null) _saleFetcher.sink.add(saleModel);

    ItemModel itemModelResponse = await _repository.fetchBestItem(
      page,
      international_name_ids,
      manufacturer_ids,
      ordering,
      price_max,
      price_min,
      unit_ids,
    );
    List<ItemResult> database = await _repository.databaseItem();
    if (itemModelResponse.results != null) {
      for (var i = 0; i < itemModelResponse.results.length; i++) {
        for (var j = 0; j < database.length; j++) {
          if (itemModelResponse.results[i].id == database[j].id) {
            itemModelResponse.results[i].cardCount = database[j].cardCount;
            itemModelResponse.results[i].favourite = database[j].favourite;
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
    _saleFetcher.close();
    _cityNameFetcher.close();
    _bestItemFetcher.close();
  }
}

final blocHome = HomeBloc();
