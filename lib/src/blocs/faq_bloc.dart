import 'package:flutter_translate/flutter_translate.dart';
import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/faq_model.dart';
import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/model/api/order_options_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class FaqBloc {
  final _repository = Repository();
  final _faqFetcher = PublishSubject<List<FaqModel>>();

  Observable<List<FaqModel>> get allFaq => _faqFetcher.stream;

  fetchAllFaq() async {
    List<FaqModel> result = await _repository.fetchFAQ();
    _faqFetcher.sink.add(result);
  }

  dispose() {
    _faqFetcher.close();
  }
}

final blocFaq = FaqBloc();
