import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel({
    this.id,
    this.name,
    this.image,
    this.address,
    this.phone,
    this.mode,
    this.location,
    this.distance,
  });

  int id;
  String name;
  String image;
  String address;
  String phone;
  String mode;
  Location location;
  double distance;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        address: json["address"],
        phone: json["phone"],
        mode: json["mode"],
        location: Location.fromJson(json["location"]),
        distance: json["distance"] == null ? 0.0 : json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "address": address,
        "phone": phone,
        "mode": mode,
        "location": location.toJson(),
        "distance": distance,
      };
}

class Location {
  Location({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}
