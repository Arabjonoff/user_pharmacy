import 'package:pharmacy/src/model/api/item_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class CardBloc {
  final _repository = Repository();
  final _cardFetcher = PublishSubject<List<ItemResult>>();

  Stream<List<ItemResult>> get allCard => _cardFetcher.stream;

  fetchAllCard() async {
    List<ItemResult> result = await _repository.databaseCardItem(true);
    List<ItemResult> resultFav = await _repository.databaseFavItem();
    for (int i = 0; i < result.length; i++) {

      for (int j = 0; j < resultFav.length; j++) {
        if (result[i].id == resultFav[j].id) {
          result[i].favourite = true;
          break;
        }
      }
    }
    _cardFetcher.sink.add(result);
  }

  dispose() {
    _cardFetcher.close();
  }
}

final blocCard = CardBloc();
