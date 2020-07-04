class ItemsAllModel {
  int id;
  String name;
  String barcode;
  String image;
  String imageThumbnail;
  String piece;
  String dose;
  bool status;
  int price;
  String expirationDate;
  bool isRecept;
  Unit unit;
  InternationalName internationalName;
  Unit manufacturer;
  Unit pharmGroup;
  Unit category;
  List<Analog> analog;
  List<Analog> recommendations;

  ItemsAllModel(
      {this.id,
      this.name,
      this.barcode,
      this.image,
      this.imageThumbnail,
      this.piece,
      this.dose,
      this.status,
      this.price,
      this.expirationDate,
      this.isRecept,
      this.unit,
      this.internationalName,
      this.manufacturer,
      this.pharmGroup,
      this.category,
      this.analog,
      this.recommendations});

  ItemsAllModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    image = json['image'];
    imageThumbnail = json['image_thumbnail'];
    piece = json['piece'];
    dose = json['dose'];
    status = json['status'];
    price = json['price'];
    expirationDate = json['expiration_date'];
    isRecept = json['is_recept'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    internationalName = json['international_name'] != null
        ? new InternationalName.fromJson(json['international_name'])
        : null;
    manufacturer = json['manufacturer'] != null
        ? new Unit.fromJson(json['manufacturer'])
        : null;
    pharmGroup = json['pharm_group'] != null
        ? new Unit.fromJson(json['pharm_group'])
        : null;
    category =
        json['category'] != null ? new Unit.fromJson(json['category']) : null;
    if (json['analog'] != null) {
      analog = new List<Analog>();
      json['analog'].forEach((v) {
        analog.add(new Analog.fromJson(v));
      });
    }
    if (json['recommendations'] != null) {
      recommendations = new List<Analog>();
      json['recommendations'].forEach((v) {
        recommendations.add(new Analog.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['image'] = this.image;
    data['image_thumbnail'] = this.imageThumbnail;
    data['piece'] = this.piece;
    data['dose'] = this.dose;
    data['status'] = this.status;
    data['price'] = this.price;
    data['expiration_date'] = this.expirationDate;
    data['is_recept'] = this.isRecept;
    if (this.unit != null) {
      data['unit'] = this.unit.toJson();
    }
    if (this.internationalName != null) {
      data['international_name'] = this.internationalName.toJson();
    }
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer.toJson();
    }
    if (this.pharmGroup != null) {
      data['pharm_group'] = this.pharmGroup.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.analog != null) {
      data['analog'] = this.analog.map((v) => v.toJson()).toList();
    }
    if (this.recommendations != null) {
      data['recommendations'] =
          this.recommendations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Unit {
  int id;
  String name;

  Unit({this.id, this.name});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class InternationalName {
  int id;
  String name;
  String nameRu;

  InternationalName({this.id, this.name, this.nameRu});

  InternationalName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameRu = json['name_ru'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ru'] = this.nameRu;
    return data;
  }
}

class Analog {
  int id;
  String name;
  String barcode;
  String image;
  String imageThumbnail;
  String piece;
  String dose;
  bool status;
  int price;
  String expirationDate;
  bool isRecept;
  Unit unit;
  InternationalName internationalName;
  Unit manufacturer;
  Unit pharmGroup;
  Unit category;

  Analog(
      {this.id,
      this.name,
      this.barcode,
      this.image,
      this.imageThumbnail,
      this.piece,
      this.dose,
      this.status,
      this.price,
      this.expirationDate,
      this.isRecept,
      this.unit,
      this.internationalName,
      this.manufacturer,
      this.pharmGroup,
      this.category});

  Analog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    image = json['image'];
    imageThumbnail = json['image_thumbnail'];
    piece = json['piece'];
    dose = json['dose'];
    status = json['status'];
    price = json['price'];
    expirationDate = json['expiration_date'];
    isRecept = json['is_recept'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    internationalName = json['international_name'] != null
        ? new InternationalName.fromJson(json['international_name'])
        : null;
    manufacturer = json['manufacturer'] != null
        ? new Unit.fromJson(json['manufacturer'])
        : null;
    pharmGroup = json['pharm_group'] != null
        ? new Unit.fromJson(json['pharm_group'])
        : null;
    category =
        json['category'] != null ? new Unit.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['image'] = this.image;
    data['image_thumbnail'] = this.imageThumbnail;
    data['piece'] = this.piece;
    data['dose'] = this.dose;
    data['status'] = this.status;
    data['price'] = this.price;
    data['expiration_date'] = this.expirationDate;
    data['is_recept'] = this.isRecept;
    if (this.unit != null) {
      data['unit'] = this.unit.toJson();
    }
    if (this.internationalName != null) {
      data['international_name'] = this.internationalName.toJson();
    }
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer.toJson();
    }
    if (this.pharmGroup != null) {
      data['pharm_group'] = this.pharmGroup.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}
