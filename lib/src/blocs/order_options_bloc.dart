import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderOptionBloc {
  final _repository = Repository();
  final _orderOptionsFetcher = PublishSubject<OrderOptionsModel>();

  Stream<OrderOptionsModel> get orderOptions => _orderOptionsFetcher.stream;

  fetchOrderOptions(String lan) async {
    var response = await _repository.fetchOrderOptions(lan);
    if (response.isSuccess) {
      _orderOptionsFetcher.sink.add(
        OrderOptionsModel.fromJson(response.result),
      );
    }
  }

  dispose() {
    _orderOptionsFetcher.close();
  }
}

final blocOrderOptions = OrderOptionBloc();
