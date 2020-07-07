class AptekaModel {
  int id;
  String name;
  String address;
  String open;
  String number;
  double lat;
  double lon;
  bool fav = false;


  AptekaModel(this.id, this.name, this.address, this.open, this.number,
      this.lat, this.lon, this.fav);

//  AptekaModel(
//      this.id, this.name, this.open, this.number, this.lat, this.lon, this.fav);

  AptekaModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.address = map["address"];
    this.open = map["open"];
    this.number = map["number"];
    this.lat = map["lat"].toDouble();
    this.lon = map["lon"].toDouble();
    this.fav = false;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["address"] = address;
    map["open"] = open;
    map["number"] = number;
    map["lat"] = lat;
    map["lon"] = lon;
    return map;
  }
}
