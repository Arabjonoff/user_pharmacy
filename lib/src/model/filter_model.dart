class FilterModel {
  int count;
  String next;
  String previous;
  List<FilterResults> results;

  FilterModel({this.count, this.next, this.previous, this.results});

  FilterModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'] == null ? "" : json['next'];
    previous = json['previous'] == null ? "" : json['previous'];
    if (json['results'] != null) {
      results = new List<FilterResults>();
      json['results'].forEach((v) {
        results.add(new FilterResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterResults {
  int id;
  String name;
  bool isClick = false;

  FilterResults({this.id, this.name});

  FilterResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null ? "" : json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
