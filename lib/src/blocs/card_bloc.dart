import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class CardBloc {
  final _repository = Repository();
  final _cardFetcher = PublishSubject<List<ItemResult>>();

  Observable<List<ItemResult>> get allCard => _cardFetcher.stream;

  fetchAllCard() async {
    List<ItemResult> result = await _repository.databaseCardItem(true);
    _cardFetcher.sink.add(result);
  }

//
//  fetchPaymentType(String lan) async {
//    OrderOptionsModel orderOptions = await _repository.fetchOrderOptions(lan);
//    orderOptions.paymentTypes
//        .add(PaymentTypes(id: -1, name: translate("orders.add_new_card")));
//    _paymentTypeFetcher.sink.add(orderOptions);
//  }

  dispose() {
    _cardFetcher.close();
  }
}

final blocCard = CardBloc();
