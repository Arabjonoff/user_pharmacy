class LocationAddressModel {
  Response response;

  LocationAddressModel({
    this.response,
  });

  LocationAddressModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  GeoObjectCollection geoObjectCollection;

  Response({this.geoObjectCollection});

  Response.fromJson(Map<String, dynamic> json) {
    geoObjectCollection = json['GeoObjectCollection'] != null
        ? new GeoObjectCollection.fromJson(json['GeoObjectCollection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoObjectCollection != null) {
      data['GeoObjectCollection'] = this.geoObjectCollection.toJson();
    }
    return data;
  }
}

class GeoObjectCollection {
  List<FeatureMember> featureMember;

  GeoObjectCollection({this.featureMember});

  GeoObjectCollection.fromJson(Map<String, dynamic> json) {
    if (json['featureMember'] != null) {
      featureMember = <FeatureMember>[];
      json['featureMember'].forEach((v) {
        featureMember.add(new FeatureMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.featureMember != null) {
      data['featureMember'] =
          this.featureMember.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeatureMember {
  GeoObject geoObject;

  FeatureMember({this.geoObject});

  FeatureMember.fromJson(Map<String, dynamic> json) {
    geoObject = json['GeoObject'] != null
        ? new GeoObject.fromJson(json['GeoObject'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoObject != null) {
      data['GeoObject'] = this.geoObject.toJson();
    }
    return data;
  }
}

class GeoObject {
  String name;

  GeoObject({
    this.name,
  });

  GeoObject.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    return data;
  }
}
