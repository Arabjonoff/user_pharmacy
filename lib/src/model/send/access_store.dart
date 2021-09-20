class AccessStore {
  double lat;
  double lng;
  List<ProductsStore> products;

  AccessStore({this.lat, this.lng, this.products});

  AccessStore.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    if (json['products'] != null) {
      products = <ProductsStore>[];
      json['products'].forEach((v) {
        products.add(new ProductsStore.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsStore {
  int drugId;
  int qty;

  ProductsStore({this.drugId, this.qty});

  ProductsStore.fromJson(Map<String, dynamic> json) {
    drugId = json['drug_id'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drug_id'] = this.drugId;
    data['qty'] = this.qty;
    return data;
  }
}
