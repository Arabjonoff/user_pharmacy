import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderOptionBloc {
  final _repository = Repository();
  final _orderOptionsFetcher = PublishSubject<OrderOptionsModel>();

  Observable<OrderOptionsModel> get orderOptions => _orderOptionsFetcher.stream;

  fetchOrderOptions(String lan) async {
    OrderOptionsModel orderOptions = await _repository.fetchOrderOptions(lan);
    if (orderOptions != null) _orderOptionsFetcher.sink.add(orderOptions);
  }

  dispose() {
    _orderOptionsFetcher.close();
  }
}

final blocOrderOptions = OrderOptionBloc();
