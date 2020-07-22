import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class ItemListBloc {
  final _repository = Repository();
  final _categoryItemsFetcher = PublishSubject<ItemModel>();
  final _bestItemFetcher = PublishSubject<ItemModel>();
  final _itemSearchFetcher = PublishSubject<ItemModel>();

  List<ItemResult> usersCategory = new List();
  ItemModel itemCategoryData;

  List<ItemResult> usersSearch = new List();
  ItemModel itemSearchData;

  List<ItemResult> usersBest = new List();
  ItemModel itemBestData;

  Observable<ItemModel> get allItemsCategoty => _categoryItemsFetcher.stream;

  Observable<ItemModel> get getBestItem => _bestItemFetcher.stream;

  Observable<ItemModel> get getItemSearch => _itemSearchFetcher.stream;

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

    itemCategoryData = new ItemModel(
      count: itemCategory.count,
      next: itemCategory.next,
      previous: itemCategory.previous,
      results: usersCategory,
    );
    _categoryItemsFetcher.sink.add(itemCategoryData);
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

    ItemModel itemModelBest = await _repository.fetchBestItem(
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
      for (var i = 0; i < itemModelBest.results.length; i++) {
        if (itemModelBest.results[i].id == database[j].id) {
          itemModelBest.results[i].cardCount = database[j].cardCount;
          itemModelBest.results[i].favourite = database[j].favourite;
        }
      }
    }

    usersBest.addAll(itemModelBest.results);

    itemBestData = new ItemModel(
      count: itemModelBest.count,
      next: itemModelBest.next,
      previous: itemModelBest.previous,
      results: usersBest,
    );
    _bestItemFetcher.sink.add(itemBestData);
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
      usersSearch = new List();
    }
    ItemModel itemModelSearch = await _repository.fetchSearchItemList(
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
      for (var i = 0; i < itemModelSearch.results.length; i++) {
        if (itemModelSearch.results[i].id == database[j].id) {
          itemModelSearch.results[i].cardCount = database[j].cardCount;
          itemModelSearch.results[i].favourite = database[j].favourite;
        }
      }
    }

    usersSearch.addAll(itemModelSearch.results);

    itemSearchData = new ItemModel(
      count: itemModelSearch.count,
      next: itemModelSearch.next,
      previous: itemModelSearch.previous,
      results: usersSearch,
    );

    _itemSearchFetcher.sink.add(itemSearchData);
  }

  dispose() {
    _categoryItemsFetcher.close();
    _bestItemFetcher.close();
    _itemSearchFetcher.close();
  }
}

final blocItemsList = ItemListBloc();
