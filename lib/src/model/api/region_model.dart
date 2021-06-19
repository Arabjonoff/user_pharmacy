import 'dart:convert';

List<RegionModel> regionModelFromJson(String str) => List<RegionModel>.from(
    json.decode(str).map((x) => RegionModel.fromJson(x)));

String regionModelToJson(List<RegionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegionModel {
  RegionModel({
    this.id,
    this.name,
    this.parentName,
    this.childs,
    this.coords,
  });

  int id;
  String name;
  String parentName;
  List<RegionModel> childs;
  bool isOpen = false;
  bool isChoose;
  List<double> coords;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
        id: json["id"],
        name: json["name"] == null ? "" : json["name"],
        parentName: json["parent_name"] == null ? "" : json["parent_name"],
        childs: List<RegionModel>.from(
            json["childs"].map((x) => RegionModel.fromJson(x))),
        coords: json["coords"] == null
            ? null
            : List<double>.from(json["coords"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parent_name": parentName,
        "childs": List<dynamic>.from(childs.map((x) => x.toJson())),
        "coords":
            coords == null ? null : List<dynamic>.from(coords.map((x) => x)),
      };
}
