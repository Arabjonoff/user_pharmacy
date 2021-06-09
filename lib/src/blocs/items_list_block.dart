import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/search/search_screen.dart';
import 'package:rxdart/rxdart.dart';

List<ItemResult> usersCategory;
ItemModel itemCategoryData;
int itemCategoryCount;
dynamic itemCategoryNext;
dynamic itemCategoryPrevious;

List<ItemResult> usersIds;
ItemModel itemIdsData;
int itemIdsCount;
dynamic itemIdsNext;
dynamic itemIdsPrevious;

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
  final _idsItemsFetcher = PublishSubject<ItemModel>();
  final _itemSearchFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get allItemsCategory => _categoryItemsFetcher.stream;

  Stream<ItemModel> get allIds => _idsItemsFetcher.stream;

  Stream<ItemModel> get getBestItem => _bestItemFetcher.stream;

  Stream<ItemModel> get getItemSearch => _itemSearchFetcher.stream;

  fetchAllItemCategory(
    String id,
    int page,
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    if (page == 1) {
      usersCategory = new List();
    }
    ItemModel itemCategory = await _repository.fetchCategoryItemList(
      id,
      page,
      internationalNameIds,
      manufacturerIds,
      ordering,
      priceMax,
      priceMin,
      unitIds,
    );
    if (itemCategory != null) {
      List<ItemResult> database = await _repository.databaseItem();
      for (var j = 0; j < database.length; j++) {
        for (var i = 0; i < itemCategory.results.length; i++) {
          if (itemCategory.results[i].id == database[j].id) {
            itemCategory.results[i].cardCount = database[j].cardCount;
          }
        }
      }
      List<ItemResult> databaseFav = await _repository.databaseFavItem();
      for (var j = 0; j < databaseFav.length; j++) {
        for (var i = 0; i < itemCategory.results.length; i++) {
          if (itemCategory.results[i].id == databaseFav[j].id) {
            itemCategory.results[i].favourite = true;
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
  }

  fetchIdsItemsList(
    String id,
    int page,
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    if (page == 1) {
      usersIds = new List();
    }
    ItemModel itemIds = await _repository.fetchIdsItemsList(
      id,
      page,
      internationalNameIds,
      manufacturerIds,
      ordering,
      priceMax,
      priceMin,
      unitIds,
    );

    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemIds.results.length; i++) {
        if (itemIds.results[i].id == database[j].id) {
          itemIds.results[i].cardCount = database[j].cardCount;
        }
      }
    }

    List<ItemResult> databaseFav = await _repository.databaseFavItem();
    for (var j = 0; j < databaseFav.length; j++) {
      for (var i = 0; i < itemIds.results.length; i++) {
        if (itemIds.results[i].id == databaseFav[j].id) {
          itemIds.results[i].favourite = true;
        }
      }
    }

    if (page == 1) {
      usersIds = new List();
      usersIds = itemIds.results;
    } else {
      usersIds.addAll(itemIds.results);
    }

    itemIdsCount = itemIds.count;
    itemIdsNext = itemIds.next;
    itemIdsPrevious = itemIds.previous;

    itemIdsData = new ItemModel(
      count: itemIds.count,
      next: itemIds.next,
      previous: itemIds.previous,
      results: usersIds,
    );
    _idsItemsFetcher.sink.add(itemIdsData);
  }

  fetchAllItemCategoryBest(
    int page,
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    if (page == 1) {
      usersBest = new List();
    }

    ItemModel itemModelBest =
        ItemModel.fromJson((await _repository.fetchBestItem(
      page,
      internationalNameIds,
      manufacturerIds,
      ordering,
      priceMax,
      priceMin,
      unitIds,
    ))
            .result);
    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      for (var i = 0; i < itemModelBest.results.length; i++) {
        if (itemModelBest.results[i].id == database[j].id) {
          itemModelBest.results[i].cardCount = database[j].cardCount;
        }
      }
    }

    List<ItemResult> databaseFav = await _repository.databaseFavItem();
    for (var j = 0; j < databaseFav.length; j++) {
      for (var i = 0; i < itemModelBest.results.length; i++) {
        if (itemModelBest.results[i].id == databaseFav[j].id) {
          itemModelBest.results[i].favourite = true;
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
    String internationalNameIds,
    String manufacturerIds,
    String ordering,
    String priceMax,
    String priceMin,
    String unitIds,
  ) async {
    if (page == 1) {
      usersSearch = new List();
    }
    ItemModel itemModelSearch = await _repository.fetchSearchItemList(
      obj,
      page,
      internationalNameIds,
      manufacturerIds,
      ordering,
      priceMax,
      priceMin,
      unitIds,
      barcode,
    );

    if (itemModelSearch != null) {
      List<ItemResult> database = await _repository.databaseItem();
      for (var j = 0; j < database.length; j++) {
        for (var i = 0; i < itemModelSearch.results.length; i++) {
          if (itemModelSearch.results[i].id == database[j].id) {
            itemModelSearch.results[i].cardCount = database[j].cardCount;
          }
        }
      }

      List<ItemResult> databaseFav = await _repository.databaseFavItem();
      for (var j = 0; j < databaseFav.length; j++) {
        for (var i = 0; i < itemModelSearch.results.length; i++) {
          if (itemModelSearch.results[i].id == databaseFav[j].id) {
            itemModelSearch.results[i].favourite = true;
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
  }

  updateBest() async {
    List<ItemResult> database = await _repository.databaseItem();

    if (usersBest != null) {
      for (var i = 0; i < usersBest.length; i++) {
        usersBest[i].cardCount = 0;
        usersBest[i].favourite = false;
      }

      ///card
      if (database.length != 0) {
        for (var j = 0; j < database.length; j++) {
          for (var i = 0; i < usersBest.length; i++) {
            if (usersBest[i].id == database[j].id) {
              usersBest[i].cardCount = database[j].cardCount;
            }
          }
        }
      }

      List<ItemResult> databaseFav = await _repository.databaseFavItem();

      ///favourite
      if (databaseFav.length != 0) {
        for (var j = 0; j < databaseFav.length; j++) {
          for (var i = 0; i < usersBest.length; i++) {
            if (usersBest[i].id == databaseFav[j].id) {
              usersBest[i].favourite = true;
            }
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
  }

  updateSearch() async {
    List<ItemResult> database = await _repository.databaseItem();

    if (usersSearch != null) {
      for (var i = 0; i < usersSearch.length; i++) {
        usersSearch[i].cardCount = 0;
        usersSearch[i].favourite = false;
      }

      ///search
      if (database.length != 0) {
        for (var j = 0; j < database.length; j++) {
          for (var i = 0; i < usersSearch.length; i++) {
            if (usersSearch[i].id == database[j].id) {
              usersSearch[i].cardCount = database[j].cardCount;
            }
          }
        }
      }

      List<ItemResult> databaseFav = await _repository.databaseFavItem();

      ///favourite
      if (databaseFav.length != 0) {
        for (var j = 0; j < databaseFav.length; j++) {
          for (var i = 0; i < usersSearch.length; i++) {
            if (usersSearch[i].id == databaseFav[j].id) {
              usersSearch[i].favourite = true;
            }
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
  }

  updateCategory() async {
    List<ItemResult> database = await _repository.databaseItem();

    if (usersCategory != null) {
      for (var i = 0; i < usersCategory.length; i++) {
        usersCategory[i].cardCount = 0;
        usersCategory[i].favourite = false;
      }

      ///category
      if (database.length != 0) {
        for (var j = 0; j < database.length; j++) {
          for (var i = 0; i < usersCategory.length; i++) {
            if (usersCategory[i].id == database[j].id) {
              usersCategory[i].cardCount = database[j].cardCount;
            }
          }
        }
      }

      List<ItemResult> databaseFav = await _repository.databaseFavItem();

      ///favourite
      if (databaseFav.length != 0) {
        for (var j = 0; j < databaseFav.length; j++) {
          for (var i = 0; i < usersCategory.length; i++) {
            if (usersCategory[i].id == databaseFav[j].id) {
              usersCategory[i].favourite = true;
            }
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
  }

  updateIds() async {
    List<ItemResult> database = await _repository.databaseItem();

    if (usersIds != null) {
      for (var i = 0; i < usersIds.length; i++) {
        usersIds[i].cardCount = 0;
        usersIds[i].favourite = false;
      }

      ///ids
      if (database.length != 0) {
        for (var j = 0; j < database.length; j++) {
          for (var i = 0; i < usersIds.length; i++) {
            if (usersIds[i].id == database[j].id) {
              usersIds[i].cardCount = database[j].cardCount;
            }
          }
        }
      }

      List<ItemResult> databaseFav = await _repository.databaseFavItem();

      ///favourite
      if (databaseFav.length != 0) {
        for (var j = 0; j < databaseFav.length; j++) {
          for (var i = 0; i < usersIds.length; i++) {
            if (usersIds[i].id == databaseFav[j].id) {
              usersIds[i].favourite = true;
            }
          }
        }
      }

      itemIdsData = new ItemModel(
        count: itemIdsCount,
        next: itemIdsNext,
        previous: itemIdsPrevious,
        results: usersIds,
      );
      _idsItemsFetcher.sink.add(itemIdsData);
    }
  }

  dispose() {
    _categoryItemsFetcher.close();
    _bestItemFetcher.close();
    _idsItemsFetcher.close();
    _itemSearchFetcher.close();
  }
}

final blocItemsList = ItemListBloc();
