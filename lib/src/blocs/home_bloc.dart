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
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    SaleModel saleModel = await _repository.fetchAllSales();
    if (saleModel.results != null) _saleFetcher.sink.add(saleModel);

    ItemModel itemModelResponse = await _repository.fetchBestItem(
      page,
      internationalNameIds,
      manufacturerIds,
      ordering,
      priceMax,
      priceMin,
      unitIds,
    );
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
    _saleFetcher.close();
    _cityNameFetcher.close();
    _bestItemFetcher.close();
  }
}

final blocHome = HomeBloc();
