import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class ItemsBloc {
  final _repository = Repository();
  final _categoryItemsFetcher = PublishSubject<ItemModel>();
  final _bestItemFetcher = PublishSubject<ItemModel>();
  final _itemSearchFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allItemsCategoty => _categoryItemsFetcher.stream;

  Observable<ItemModel> get getBestItem => _bestItemFetcher.stream;

  Observable<ItemModel> get getItemSearch => _itemSearchFetcher.stream;

  fetchAllItemCategory(String id) async {
    ItemModel itemCategory = await _repository.fetchCategryItemList(id);

    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemCategory.results.length; i++) {
        if (itemCategory.results[i].id == database[j].id) {
          itemCategory.results[i].cardCount = database[j].cardCount;
          itemCategory.results[i].favourite = database[j].favourite;
        }
      }
    }
    _categoryItemsFetcher.sink.add(itemCategory);
  }

  fetchAllItemCategoryBest() async {
    ItemModel itemModelResponse = await _repository.fetchBestItem();
    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemModelResponse.results.length; i++) {
        if (itemModelResponse.results[i].id == database[j].id) {
          itemModelResponse.results[i].cardCount = database[j].cardCount;
          itemModelResponse.results[i].favourite = database[j].favourite;
        }
      }
    }
    _bestItemFetcher.sink.add(itemModelResponse);
  }

  fetchAllItemSearch(String obj) async {
    ItemModel itemModelResponse = await _repository.fetchSearchItemList(obj);
    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemModelResponse.results.length; i++) {
        if (itemModelResponse.results[i].id == database[j].id) {
          itemModelResponse.results[i].cardCount = database[j].cardCount;
          itemModelResponse.results[i].favourite = database[j].favourite;
        }
      }
    }
    _itemSearchFetcher.sink.add(itemModelResponse);
  }

  dispose() {
    _categoryItemsFetcher.close();
    _bestItemFetcher.close();
    _itemSearchFetcher.close();
  }
}

final blocItems = ItemsBloc();
