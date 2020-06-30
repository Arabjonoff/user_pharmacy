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
  SearchResult({
    this.id,
    this.name,

  });

  int id;
  String name;


  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        id: json["id"],
        name: json["name"],

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

