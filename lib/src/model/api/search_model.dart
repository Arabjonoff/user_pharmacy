class SearchModel {
  SearchModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  String next;
  dynamic previous;
  List<SearchResult> results;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<SearchResult>.from(
          json["results"].map((x) => SearchResult.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class SearchResult {
  int id;
  String name;
  Unit manufacturer;

  SearchResult({
    this.id,
    this.name,
    this.manufacturer,
  });

  SearchResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    manufacturer = json['manufacturer'] != null
        ? Unit.fromJson(json['manufacturer'])
        : Unit(id: 0, name: "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer.toJson();
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
