import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class ItemListBloc {
  final _repository = Repository();
  final _categoryItemsFetcher = PublishSubject<List<ItemResult>>();
  final _bestItemFetcher = PublishSubject<List<ItemResult>>();
  final _itemSearchFetcher = PublishSubject<List<ItemResult>>();

  List<ItemResult> users = new List();
  List<ItemResult> usersCategory = new List();
  List<ItemResult> usersBest = new List();

  Observable<List<ItemResult>> get allItemsCategoty =>
      _categoryItemsFetcher.stream;

  Observable<List<ItemResult>> get getBestItem => _bestItemFetcher.stream;

  Observable<List<ItemResult>> get getItemSearch => _itemSearchFetcher.stream;

  fetchAllItemCategory(
    String id,
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    if (page == 1) {
      usersCategory = new List();
    }
    ItemModel itemCategory = await _repository.fetchCategryItemList(
      id,
      page,
      international_name_ids,
      manufacturer_ids,
      ordering,
      price_max,
      price_min,
      unit_ids,
    );

    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemCategory.results.length; i++) {
        if (itemCategory.results[i].id == database[j].id) {
          itemCategory.results[i].cardCount = database[j].cardCount;
          itemCategory.results[i].favourite = database[j].favourite;
        }
      }
    }

    usersCategory.addAll(itemCategory.results);
    _categoryItemsFetcher.sink.add(usersCategory);
  }

  fetchAllItemCategoryBest(
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    if (page == 1) {
      usersBest = new List();
    }

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
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemModelResponse.results.length; i++) {
        if (itemModelResponse.results[i].id == database[j].id) {
          itemModelResponse.results[i].cardCount = database[j].cardCount;
          itemModelResponse.results[i].favourite = database[j].favourite;
        }
      }
    }

    usersBest.addAll(itemModelResponse.results);
    _bestItemFetcher.sink.add(usersBest);
  }

  fetchAllItemSearch(
    String obj,
    int page,
    String international_name_ids,
    String manufacturer_ids,
    String ordering,
    String price_max,
    String price_min,
    String unit_ids,
  ) async {
    if (page == 1) {
      users = new List();
    }
    ItemModel itemModelResponse = await _repository.fetchSearchItemList(
      obj,
      page,
      international_name_ids,
      manufacturer_ids,
      ordering,
      price_max,
      price_min,
      unit_ids,
    );
    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemModelResponse.results.length; i++) {
        if (itemModelResponse.results[i].id == database[j].id) {
          itemModelResponse.results[i].cardCount = database[j].cardCount;
          itemModelResponse.results[i].favourite = database[j].favourite;
        }
      }
    }
    users.addAll(itemModelResponse.results);
    _itemSearchFetcher.sink.add(users);
  }

  dispose() {
    users = new List();
    usersCategory = new List();
    usersBest = new List();
    _categoryItemsFetcher.close();
    _bestItemFetcher.close();
    _itemSearchFetcher.close();
  }
}

final blocItemsList = ItemListBloc();
