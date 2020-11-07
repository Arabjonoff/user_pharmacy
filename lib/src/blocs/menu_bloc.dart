import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class MenuBloc {
  final _repository = Repository();
  final _cashBackFetcher = PublishSubject<CashBackModel>();
  final _visibleFetcher = PublishSubject<bool>();

  Observable<CashBackModel> get cashBackOptions => _cashBackFetcher.stream;

  Observable<bool> get visibleOptions => _visibleFetcher.stream;

  fetchCashBack() async {
    CashBackModel cashBackOptions = await _repository.fetchCashBack();
    _cashBackFetcher.sink.add(cashBackOptions);
  }

  fetchVisible(int star, String text) {
    if (star > 0 || text.length > 0) {
      _visibleFetcher.sink.add(true);
    } else {
      _visibleFetcher.sink.add(false);
    }
  }

  dispose() {
    _cashBackFetcher.close();
    _visibleFetcher.close();
  }
}

final menuBack = MenuBloc();
