import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class HistoryBloc {
  final _repository = Repository();
  final _historyFetcher = PublishSubject<HistoryModel>();
  List<HistoryResults> results = new List();
  HistoryModel model = new HistoryModel();

  Observable<HistoryModel> get allHistory => _historyFetcher.stream;

  fetchAllHistory(int page) async {
    if (page == 1) {
      results = new List();
    }
    HistoryModel historyModel = await _repository.fetchHistory(page);
    if (historyModel != null) {
      if (historyModel.results != null) results.addAll(historyModel.results);
      model = new HistoryModel(
        count: historyModel.count,
        next: historyModel.next,
        previous: historyModel.previous,
        results: results,
      );
      _historyFetcher.sink.add(model);
    }
  }

  dispose() {
    _historyFetcher.close();
  }
}

final blocHistory = HistoryBloc();
