import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class FavBloc {
  final _repository = Repository();
  final _favFetcher = PublishSubject<List<ItemResult>>();

  Observable<List<ItemResult>> get allFav => _favFetcher.stream;

  fetchAllFav() async {
    List<ItemResult> result = await _repository.databaseFavItem();
    _favFetcher.sink.add(result);
  }

  dispose() {
    _favFetcher.close();
  }
}

final blocFav = FavBloc();
