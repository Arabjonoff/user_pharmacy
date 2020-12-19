import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class AptekaBloc {
  final _repository = Repository();

  final _aptekaFetcher = PublishSubject<List<AptekaModel>>();
  final _existStoreFetcher = PublishSubject<List<AptekaModel>>();

  Observable<List<AptekaModel>> get allApteka => _aptekaFetcher.stream;

  Observable<List<AptekaModel>> get allExistStorea => _existStoreFetcher.stream;

  fetchAllApteka(double lat, double lng) async {
    List<LocationModel> orderModel = await _repository.fetchApteka(lat, lng);
    List<AptekaModel> aptekadatabase = await _repository.dbAptekaItems();
    List<AptekaModel> aptekadata = new List();

    if (orderModel != null) {
      for (int i = 0; i < orderModel.length; i++) {
        aptekadata.add(AptekaModel(
          orderModel[i].id,
          orderModel[i].name,
          orderModel[i].address,
          orderModel[i].mode,
          orderModel[i].phone,
          orderModel[i].location.coordinates[1],
          orderModel[i].location.coordinates[0],
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
  }

  fetchAccessApteka(AccessStore accessStore) async {
    List<LocationModel> saleModel =
        await _repository.fetchAccessApteka(accessStore);

    if (saleModel != null) {
      List<AptekaModel> aptekadatabase = await _repository.dbAptekaItems();
      List<AptekaModel> aptekadata = new List();

      for (int i = 0; i < saleModel.length; i++) {
        aptekadata.add(AptekaModel(
          saleModel[i].id,
          saleModel[i].name,
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
      _existStoreFetcher.sink.add(aptekadata);
    }
  }

  dispose() {
    _aptekaFetcher.close();
    _existStoreFetcher.close();
  }
}

final blocApteka = AptekaBloc();
