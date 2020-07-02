class AptekaModel {
  int id;
  String name;
  String open;
  String number;
  double lat;
  double lon;
  bool fav = false;

  AptekaModel(this.id, this.name, this.open, this.number, this.lat, this.lon);

  AptekaModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.open = map["open"];
    this.number = map["number"];
    this.lat = map["lat"].toDouble();
    this.lon = map["lon"].toDouble();
    this.fav = true;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["open"] = open;
    map["number"] = number;
    map["lat"] = lat;
    map["lon"] = lon;
    return map;
  }
}
