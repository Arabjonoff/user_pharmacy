import 'dart:convert';

CurrentLocationAddressModel currentLocationAddressModelFromJson(String str) =>
    CurrentLocationAddressModel.fromJson(json.decode(str));

String currentLocationAddressModelToJson(CurrentLocationAddressModel data) =>
    json.encode(data.toJson());

class CurrentLocationAddressModel {
  CurrentLocationAddressModel({
    this.response,
  });

  Response response;

  factory CurrentLocationAddressModel.fromJson(Map<String, dynamic> json) =>
      CurrentLocationAddressModel(
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
      };
}

class Response {
  Response({
    this.geoObjectCollection,
  });

  GeoObjectCollection geoObjectCollection;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        geoObjectCollection:
            GeoObjectCollection.fromJson(json["GeoObjectCollection"]),
      );

  Map<String, dynamic> toJson() => {
        "GeoObjectCollection": geoObjectCollection.toJson(),
      };
}

class GeoObjectCollection {
  GeoObjectCollection({
    this.featureMember,
  });

  List<FeatureMember> featureMember;

  factory GeoObjectCollection.fromJson(Map<String, dynamic> json) =>
      GeoObjectCollection(
        featureMember: List<FeatureMember>.from(
            json["featureMember"].map((x) => FeatureMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "featureMember":
            List<dynamic>.from(featureMember.map((x) => x.toJson())),
      };
}

class FeatureMember {
  FeatureMember({
    this.geoObject,
  });

  GeoObject geoObject;

  factory FeatureMember.fromJson(Map<String, dynamic> json) => FeatureMember(
        geoObject: GeoObject.fromJson(json["GeoObject"]),
      );

  Map<String, dynamic> toJson() => {
        "GeoObject": geoObject.toJson(),
      };
}

class GeoObject {
  GeoObject({
    this.metaDataProperty,
  });

  GeoObjectMetaDataProperty metaDataProperty;

  factory GeoObject.fromJson(Map<String, dynamic> json) => GeoObject(
        metaDataProperty:
            GeoObjectMetaDataProperty.fromJson(json["metaDataProperty"]),
      );

  Map<String, dynamic> toJson() => {
        "metaDataProperty": metaDataProperty.toJson(),
      };
}

class GeoObjectMetaDataProperty {
  GeoObjectMetaDataProperty({
    this.geocoderMetaData,
  });

  GeocoderMetaData geocoderMetaData;

  factory GeoObjectMetaDataProperty.fromJson(Map<String, dynamic> json) =>
      GeoObjectMetaDataProperty(
        geocoderMetaData: GeocoderMetaData.fromJson(json["GeocoderMetaData"]),
      );

  Map<String, dynamic> toJson() => {
        "GeocoderMetaData": geocoderMetaData.toJson(),
      };
}

class GeocoderMetaData {
  GeocoderMetaData({
    this.text,
  });

  String text;

  factory GeocoderMetaData.fromJson(Map<String, dynamic> json) =>
      GeocoderMetaData(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}
