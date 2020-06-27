import 'package:pharmacy/model/api/item_model.dart';
import 'package:pharmacy/model/api/sale_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _repository = Repository();
  final _saleFetcher = PublishSubject<SaleModel>();
  final _bestItemFetcher = PublishSubject<ItemModel>();

  Observable<SaleModel> get allSale => _saleFetcher.stream;

  Observable<ItemModel> get getBestItem => _bestItemFetcher.stream;

  fetchAllHome() async {
    SaleModel saleModel = await _repository.fetchAllSales();
    _saleFetcher.sink.add(saleModel);

    ItemModel itemModelResponse = await _repository.fetchBestItem();
    List<ItemResult> database = await _repository.databaseItem();

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

  dispose() {
    _saleFetcher.close();
    _bestItemFetcher.close();
  }
}

final blocHome = HomeBloc();
