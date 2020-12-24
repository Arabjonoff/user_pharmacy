import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/fliter_screen.dart';
import 'package:rxdart/rxdart.dart';

class FilterBloc {
  final _repository = Repository();
  final _filterFetcher = PublishSubject<FilterModel>();
  final _filterInterNameFetcher = PublishSubject<String>();
  final _filterManFetcher = PublishSubject<String>();

  List<FilterResults> filterItems = new List();

  Observable<FilterModel> get filterItem => _filterFetcher.stream;

  Observable<String> get filterInterNameItem => _filterInterNameFetcher.stream;

  Observable<String> get filterManItem => _filterManFetcher.stream;

  fetchAllFilter(
    int filterType,
    int page,
    String obj,
    int type,
    String id,
  ) async {
    FilterModel itemModelResponse = await _repository.fetchFilterParameters(
      page,
      filterType,
      obj,
      type,
      id,
    );

    if (itemModelResponse != null) {
      if (page == 1) {
        filterItems = new List();
      }
      filterItems.addAll(itemModelResponse.results);

      if (filterType == 2) {
        for (int i = 0; i < filterItems.length; i++) {
          for (int j = 0; j < manufacturerFilter.length; j++) {
            if (filterItems[i].id == manufacturerFilter[j].id) {
              filterItems[i].isClick = manufacturerFilter[j].isClick;
            }
          }
        }
      } else {
        for (int i = 0; i < filterItems.length; i++) {
          for (int j = 0; j < internationalNameFilter.length; j++) {
            if (filterItems[i].id == internationalNameFilter[j].id) {
              filterItems[i].isClick = internationalNameFilter[j].isClick;
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

  fitchInterName() {
    String interName = "";
    for (int i = 0; i < internationalNameFilter.length; i++) {
      if (i < internationalNameFilter.length - 1) {
        interName += internationalNameFilter[i].name + ", ";
      } else {
        interName += internationalNameFilter[i].name;
      }
    }
    _filterInterNameFetcher.sink.add(interName);
  }

  fitchMan() {
    String manufacName = "";
    for (int i = 0; i < manufacturerFilter.length; i++) {
      if (i < manufacturerFilter.length - 1) {
        manufacName += manufacturerFilter[i].name + ", ";
      } else {
        manufacName += manufacturerFilter[i].name;
      }
    }
    _filterManFetcher.sink.add(manufacName);
  }

  dispose() {
    _filterFetcher.close();
    _filterInterNameFetcher.close();
    _filterManFetcher.close();
  }
}

final blocFilter = FilterBloc();
