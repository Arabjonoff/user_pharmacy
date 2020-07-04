import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/history_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class HistoryBloc {
  final _repository = Repository();
  final _historyFetcher = PublishSubject<HistoryModel>();

  Observable<HistoryModel> get allHistory => _historyFetcher.stream;

  fetchAllHistory() async {
    HistoryModel historyModel = await _repository.fetchHistory();
    _historyFetcher.sink.add(historyModel);
  }

  dispose() {
    _historyFetcher.close();
  }
}

final blocHistory = HistoryBloc();
