import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final _repository = Repository();
  final _searchFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get searchOptions => _searchFetcher.stream;

  List<ItemResult> allResult;

  fetchSearch(int page, String obj) async {
    if (obj.length > 2) {
      ItemModel itemModel = await _repository.fetchSearchItemList(
        obj,
        page,
        "",
        "",
        "",
        "",
        "",
        "",
      );
      if (page == 1) {
        allResult = new List();
      }
      allResult.addAll(itemModel.results);
      _searchFetcher.sink.add(
        ItemModel(
          count: itemModel.count,
          next: itemModel.next,
          previous: itemModel.previous,
          results: allResult,
        ),
      );
    }
  }

  dispose() {
    _searchFetcher.close();
  }
}

final blocSearch = SearchBloc();
