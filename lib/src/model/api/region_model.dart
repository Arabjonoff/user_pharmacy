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
  });

  int id;
  String name;
  String parentName;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
        id: json["id"],
        name: json["name"] == null ? "" : json["name"],
        parentName: json["parent_name"] == null ? "" : json["parent_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parent_name": parentName,
      };
}
