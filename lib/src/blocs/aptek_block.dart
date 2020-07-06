import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class AptekaBloc {
  final _repository = Repository();
  final _aptekaFetcher = PublishSubject<List<AptekaModel>>();

  Observable<List<AptekaModel>> get allApteka => _aptekaFetcher.stream;

  fetchAllApteka() async {
    List<LocationModel> saleModel = await _repository.fetchApteka();
    List<AptekaModel> aptekadatabase = await _repository.dbAptekaItems();
    List<AptekaModel> aptekadata = new List();

    for (int i = 0; i < saleModel.length; i++) {
      aptekadata.add(AptekaModel(
        saleModel[i].id,
        saleModel[i].address,
        saleModel[i].mode,
        saleModel[i].phone,
        saleModel[i].location.coordinates[1],
        saleModel[i].location.coordinates[0],
        false,
      ));
    }

    for (int i = 0; i < aptekadata.length; i++) {
      for (int j = 0; j < aptekadatabase.length; j++) {
        if (aptekadata[i].id == aptekadatabase[j].id) {
          aptekadata[i].fav = true;
        }
      }
    }

    _aptekaFetcher.sink.add(aptekadata);
  }

  dispose() {
    _aptekaFetcher.close();
  }
}

final blocApteka = AptekaBloc();
