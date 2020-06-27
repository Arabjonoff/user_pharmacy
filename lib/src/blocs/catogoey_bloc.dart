import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class CateforyBloc {
  final _repository = Repository();
  final _categoryFetcher = PublishSubject<CategoryModel>();

  Observable<CategoryModel> get allCategory => _categoryFetcher.stream;

  fetchAllCategory() async {
    CategoryModel saleModel = await _repository.fetchCategoryItem();
    _categoryFetcher.sink.add(saleModel);
  }

  dispose() {
    _categoryFetcher.close();
  }
}

final blocCategory = CateforyBloc();
