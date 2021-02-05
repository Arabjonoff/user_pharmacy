import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class ItemBloc {
  final _repository = Repository();
  final _itemFetcher = PublishSubject<ItemsAllModel>();

  Observable<ItemsAllModel> get allItems => _itemFetcher.stream;
  ItemsAllModel items;

  fetchAllCategory(String id) async {
    items = await _repository.fetchItems(id);

    if (items != null) {
      List<ItemResult> database = await _repository.databaseItem();
      for (var j = 0; j < database.length; j++) {
        if (items.id == database[j].id) {
          items.cardCount = database[j].cardCount;
        }
      }
      for (var i = 0; i < items.analog.length; i++) {
        for (var j = 0; j < database.length; j++) {
          if (items.analog[i].id == database[j].id) {
            items.analog[i].cardCount = database[j].cardCount;
          }
        }
      }
      for (var i = 0; i < items.recommendations.length; i++) {
        for (var j = 0; j < database.length; j++) {
          if (items.recommendations[i].id == database[j].id) {
            items.recommendations[i].cardCount = database[j].cardCount;
          }
        }
      }
      _itemFetcher.sink.add(items);
    }
  }

  fetchAllUpdate(int id) async {
    if (id == items.id) {
      List<ItemResult> database = await _repository.databaseItem();
      if (database.length > 0) {
        for (var j = 0; j < database.length; j++) {
          if (items.id == database[j].id) {
            items.cardCount = database[j].cardCount;
          }
        }
      } else {
        items.cardCount = 0;
        items.favourite = false;
      }
      for (var i = 0; i < items.analog.length; i++) {
        for (var j = 0; j < database.length; j++) {
          if (items.analog[i].id == database[j].id) {
            items.analog[i].cardCount = database[j].cardCount;
          }
        }
      }
      for (var i = 0; i < items.recommendations.length; i++) {
        for (var j = 0; j < database.length; j++) {
          if (items.recommendations[i].id == database[j].id) {
            items.recommendations[i].cardCount = database[j].cardCount;
          }
        }
      }
      _itemFetcher.sink.add(items);
    }
  }

  dispose() {
    _itemFetcher.close();
  }
}

final blocItem = ItemBloc();
