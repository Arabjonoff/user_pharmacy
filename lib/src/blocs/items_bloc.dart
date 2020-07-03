import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/items_all_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class ItemBloc {
  final _repository = Repository();
  final _itemFetcher = PublishSubject<ItemsAllModel>();

  Observable<ItemsAllModel> get allItems => _itemFetcher.stream;

  fetchAllCategory(String id) async {
    ItemsAllModel items = await _repository.fetchItems(id);

    List<ItemResult> database = await _repository.databaseItem();
    for (var j = 0; j < database.length; j++) {
      if (items.id == database[j].id) {
        items.cardCount = database[j].cardCount;
        items.favourite = database[j].favourite;
      }
    }

    _itemFetcher.sink.add(items);
  }

  dispose() {
    _itemFetcher.close();
  }
}

final blocItem = ItemBloc();