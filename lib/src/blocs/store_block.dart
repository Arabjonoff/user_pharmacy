import 'package:pharmacy/src/model/api/location_model.dart';
import 'package:pharmacy/src/model/database/address_model.dart';
import 'package:pharmacy/src/model/send/access_store.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class StoreBloc {
  final _repository = Repository();

  final _existStoreFetcher = PublishSubject<List<LocationModel>>();
  final _addressFetcher = PublishSubject<List<AddressModel>>();
  final _addressHomeFetcher = PublishSubject<AddressModel>();
  final _addressWorkFetcher = PublishSubject<AddressModel>();

  Stream<List<LocationModel>> get allExistStore => _existStoreFetcher.stream;

  Stream<List<AddressModel>> get allAddress => _addressFetcher.stream;

  Stream<AddressModel> get allAddressHome => _addressHomeFetcher.stream;

  Stream<AddressModel> get allAddressWork => _addressWorkFetcher.stream;

  fetchAddress() async {
    _addressFetcher.sink.add(await _repository.databaseAddress());
  }

  fetchAddressHome() async {
    _addressHomeFetcher.sink.add(await _repository.databaseAddressType(1));
  }

  fetchAddressWork() async {
    _addressWorkFetcher.sink.add(await _repository.databaseAddressType(2));
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
    _addressHomeFetcher.close();
    _addressWorkFetcher.close();
  }
}

final blocStore = StoreBloc();
