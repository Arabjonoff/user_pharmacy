class ChatApiModel {
  int count;
  String next;
  String previous;
  List<ChatResults> results;

  ChatApiModel({this.count, this.next, this.previous, this.results});

  ChatApiModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<ChatResults>();
      json['results'].forEach((v) {
        results.add(new ChatResults.fromJson(v));
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

class ChatResults {
  int id;
  int userId;
  String body;
  String year;
  int month;
  int day;
  String time;

  ChatResults({
    this.id,
    this.userId,
    this.body,
    this.year,
    this.month,
    this.day,
    this.time,
  });

  ChatResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    body = json['body'];
    month =
        int.parse(json['created_at'].toString().split("T")[0].split("-")[1]);
    day = int.parse(json['created_at'].toString().split("T")[0].split("-")[2]);
    time = json['created_at'].toString().split("T")[1];
    year = int.parse(json['created_at'].toString().split("T")[0].split("-")[0])
            .toString() +
        "-" +
        int.parse(json['created_at'].toString().split("T")[0].split("-")[1])
            .toString() +
        "-" +
        int.parse(json['created_at'].toString().split("T")[0].split("-")[2])
            .toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['body'] = this.body;
    data['created_at'] = this.year + "T" + this.time;
    return data;
  }
}
