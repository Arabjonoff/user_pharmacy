class CategoryModel {
  CategoryModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<CategoryResult> results;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<CategoryResult>.from(json["results"].map((x) => CategoryResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class CategoryResult {
  CategoryResult({
    this.id,
    this.name,
    this.childs,
  });

  int id;
  String name;
  List<Child> childs;

  factory CategoryResult.fromJson(Map<String, dynamic> json) => CategoryResult(
        id: json["id"],
        name: json["name"],
        childs: List<Child>.from(json["childs"].map((x) => Child.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "childs": List<dynamic>.from(childs.map((x) => x.toJson())),
      };
}

class Child {
  Child({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
