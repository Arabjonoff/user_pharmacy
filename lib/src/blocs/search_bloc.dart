import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/eventBus/bottom_view.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/utils/rx_bus.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final _repository = Repository();
  final _searchFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get searchOptions => _searchFetcher.stream;

  List<ItemResult> allResult;

  fetchSearch(int page, String obj) async {
    if (obj.length > 2) {
      _searchFetcher.sink.add(null);
      var response = await _repository.fetchSearchItemList(
        obj,
        page,
        "",
        "",
      );
      if (response.isSuccess) {
        ItemModel itemModel = ItemModel.fromJson(response.result);
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
      } else if (response.status == -1) {
        RxBus.post(BottomView(true), tag: "SEARCH_VIEW_ERROR_NETWORK");
      }
    }
  }

  dispose() {
    _searchFetcher.close();
  }
}

final blocSearch = SearchBloc();
