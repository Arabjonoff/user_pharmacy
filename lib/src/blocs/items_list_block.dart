import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:rxdart/rxdart.dart';

List<ItemResult> usersCategory;
ItemModel itemCategoryData;
int itemCategoryCount;
dynamic itemCategoryNext;
dynamic itemCategoryPrevious;

List<ItemResult> usersSearch;
ItemModel itemSearchData;
int itemModelSearchCount;
dynamic itemModelSearchNext;
dynamic itemModelSearchPrevious;

List<ItemResult> usersBest;
ItemModel itemBestData;
int itemModelBestCount;
dynamic itemModelBestNext;
dynamic itemModelBestPrevious;

class ItemListBloc {
  final _repository = Repository();
  final _categoryItemsFetcher = PublishSubject<ItemModel>();
  final _bestItemFetcher = PublishSubject<ItemModel>();
  final _itemSearchFetcher = PublishSubject<ItemModel>();

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

    if (page == 1) {
      usersCategory = new List();
      usersCategory = itemCategory.results;
    } else {
      usersCategory.addAll(itemCategory.results);
    }

    itemCategoryCount = itemCategory.count;
    itemCategoryNext = itemCategory.next;
    itemCategoryPrevious = itemCategory.previous;

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

    if (page == 1) {
      usersBest = new List();
      usersBest = itemModelBest.results;
    } else {
      usersBest.addAll(itemModelBest.results);
    }

    itemModelBestCount = itemModelBest.count;
    itemModelBestNext = itemModelBest.next;
    itemModelBestPrevious = itemModelBest.previous;

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

    if (page == 1) {
      usersSearch = new List();
      usersSearch = itemModelSearch.results;
    } else {
      usersSearch.addAll(itemModelSearch.results);
    }

    itemModelSearchCount = itemModelSearch.count;
    itemModelSearchNext = itemModelSearch.next;
    itemModelSearchPrevious = itemModelSearch.previous;

    itemSearchData = new ItemModel(
      count: itemModelSearch.count,
      next: itemModelSearch.next,
      previous: itemModelSearch.previous,
      results: usersSearch,
    );

    _itemSearchFetcher.sink.add(itemSearchData);
  }

  updateBest() async {
    List<ItemResult> database = await _repository.databaseItem();

    ///best
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < usersBest.length; i++) {
        if (usersBest[i].id == database[j].id) {
          usersBest[i].cardCount = database[j].cardCount;
          usersBest[i].favourite = database[j].favourite;
        }
      }
    }

    _bestItemFetcher.sink.add(
      ItemModel(
        count: itemModelBestCount,
        next: itemModelBestNext,
        previous: itemModelBestPrevious,
        results: usersBest,
      ),
    );
  }

  updateSearch() async {
    List<ItemResult> database = await _repository.databaseItem();

    ///search
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < usersSearch.length; i++) {
        if (usersSearch[i].id == database[j].id) {
          usersSearch[i].cardCount = database[j].cardCount;
          usersSearch[i].favourite = database[j].favourite;
        }
      }
    }
    itemSearchData = new ItemModel(
      count: itemModelSearchCount,
      next: itemModelSearchNext,
      previous: itemModelSearchPrevious,
      results: usersSearch,
    );
    _itemSearchFetcher.sink.add(itemSearchData);
  }

  updateCategory() async {
    List<ItemResult> database = await _repository.databaseItem();

    ///category
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < usersCategory.length; i++) {
        if (usersCategory[i].id == database[j].id) {
          usersCategory[i].cardCount = database[j].cardCount;
          usersCategory[i].favourite = database[j].favourite;
        }
      }
    }

    itemCategoryData = new ItemModel(
      count: itemCategoryCount,
      next: itemCategoryNext,
      previous: itemCategoryPrevious,
      results: usersCategory,
    );
    _categoryItemsFetcher.sink.add(itemCategoryData);
  }

  dispose() {
    _categoryItemsFetcher.close();
    _bestItemFetcher.close();
    _itemSearchFetcher.close();
  }
}

final blocItemsList = ItemListBloc();
