import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/api/region_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class RegionBloc {
  final _repository = Repository();
  final _regionFetcher = PublishSubject<List<RegionModel>>();

  Observable<List<RegionModel>> get allRegion => _regionFetcher.stream;

  fetchAllRegion() async {
    List<RegionModel> regionModel = await _repository.fetchRegions("");
    if (regionModel != null) _regionFetcher.sink.add(regionModel);
  }

  dispose() {
    _regionFetcher.close();
  }
}

final blocRegion = RegionBloc();
