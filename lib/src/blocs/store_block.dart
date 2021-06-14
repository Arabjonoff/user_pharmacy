import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class StoreBloc {
  final _repository = Repository();

  final _existStoreFetcher = PublishSubject<List<LocationModel>>();
  final _addressFetcher = PublishSubject<List<AddressModel>>();

  Stream<List<LocationModel>> get allExistStore => _existStoreFetcher.stream;

  Stream<List<AddressModel>> get allAddress => _addressFetcher.stream;

  fetchAddress() async {
    _addressFetcher.sink.add(await _repository.databaseAddress());
  }

  fetchAccessStore(AccessStore accessStore) async {
    List<LocationModel> saleModel =
        await _repository.fetchAccessStore(accessStore);

    if (saleModel != null) {
      _existStoreFetcher.sink.add(saleModel);
    }
  }

  dispose() {
    _existStoreFetcher.close();
    _addressFetcher.close();
  }
}

final blocStore = StoreBloc();
