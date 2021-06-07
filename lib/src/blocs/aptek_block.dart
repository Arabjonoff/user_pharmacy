import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/database/apteka_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class AptekaBloc {
  final _repository = Repository();

  final _aptekaFetcher = PublishSubject<List<AptekaModel>>();
  final _existStoreFetcher = PublishSubject<List<LocationModel>>();

  Stream<List<AptekaModel>> get allApteka => _aptekaFetcher.stream;

  Stream<List<LocationModel>> get allExistStorea =>
      _existStoreFetcher.stream;

  fetchAllApteka(double lat, double lng) async {
    List<LocationModel> orderModel = await _repository.fetchStore(lat, lng);

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

      _aptekaFetcher.sink.add(aptekadata);
    }
  }

  fetchAccessApteka(AccessStore accessStore) async {
    List<LocationModel> saleModel =
        await _repository.fetchAccessStore(accessStore);

    if (saleModel != null) {
      _existStoreFetcher.sink.add(saleModel);
    }
  }

  dispose() {
    _aptekaFetcher.close();
    _existStoreFetcher.close();
  }
}

final blocApteka = AptekaBloc();
