import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/fliter_screen.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class FilterBloc {
  final _repository = Repository();
  final _filterFetcher = PublishSubject<FilterModel>();

  List<FilterResults> filterItems = new List();

  Observable<FilterModel> get filterItem => _filterFetcher.stream;

  fetchAllFilter(int type, int page, String obj) async {
    FilterModel itemModelResponse =
        await _repository.fetchFilterParametrs(page, type, obj);

    if (itemModelResponse != null) {
      if (page == 1) {
        filterItems = new List();
      }
      filterItems.addAll(itemModelResponse.results);

      if (type == 2) {
        for (int i = 0; i < filterItems.length; i++) {
          for (int j = 0; j < manufacturerExamp.length; j++) {
            if (filterItems[i].id == manufacturerExamp[j].id) {
              filterItems[i].isClick = true;
            }
          }
        }
      } else {
        for (int i = 0; i < filterItems.length; i++) {
          for (int j = 0; j < internationalNameExamp.length; j++) {
            if (filterItems[i].id == internationalNameExamp[j].id) {
              filterItems[i].isClick = true;
            }
          }
        }
      }

      _filterFetcher.sink.add(
        FilterModel(
          count: itemModelResponse.count,
          previous: itemModelResponse.previous,
          next: itemModelResponse.next,
          results: filterItems,
        ),
      );
    }
  }

  dispose() {
    _filterFetcher.close();
  }
}

final blocFilter = FilterBloc();
