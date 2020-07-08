import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/sale_model.dart';
import 'package:pharmacy/src/model/filter_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:pharmacy/src/ui/item_list/item_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class FilterBloc {
  final _repository = Repository();
  final _filterFetcher = PublishSubject<List<FilterResults>>();

  List<FilterResults> filterItems = new List();

  Observable<List<FilterResults>> get filterItem => _filterFetcher.stream;

  fetchAllFilter(int type, int page) async {
    if (page == 1) {
      filterItems = new List();
    }
    FilterModel itemModelResponse =
        await _repository.fetchFilterParametrs(page, type);

    filterItems.addAll(itemModelResponse.results);
    _filterFetcher.sink.add(filterItems);
  }

  dispose() {
    filterItems = new List();
    _filterFetcher.close();
  }
}

final blocFilter = FilterBloc();
