import 'package:pharmacy/src/model/api/cash_back_model.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class MenuBloc {
  final _repository = Repository();
  final _cashBackFetcher = PublishSubject<CashBackModel>();

  Observable<CashBackModel> get cashBackOptions => _cashBackFetcher.stream;

  fetchCashBack() async {
    CashBackModel cashBackOptions = await _repository.fetchCashBack();
    _cashBackFetcher.sink.add(cashBackOptions);
  }

  dispose() {
    _cashBackFetcher.close();
  }
}

final menuBack = MenuBloc();
