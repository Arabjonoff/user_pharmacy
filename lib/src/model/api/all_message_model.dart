class AllMessageModel {
  String next;
  List<ChatResults> results;

  AllMessageModel({
    this.next,
    this.results,
  });

  AllMessageModel.fromJson(Map<String, dynamic> json) {
    next = json['next'] ?? "";
    if (json['results'] != null) {
      results = new List<ChatResults>();
      json['results'].forEach((v) {
        results.add(new ChatResults.fromJson(v));
      });
    }
  }
}

class ChatResults {
  int id;
  int userId;
  String body;
  DateTime createdAt;
  String year;

  ChatResults({
    this.id,
    this.userId,
    this.body,
    this.createdAt,
    this.year,
  });

  ChatResults.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    body = json['body'] ?? "";
    createdAt = json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']);
    year = json['created_at'] != null
        ? DateTime.parse(json["created_at"]).year.toString() +
            "." +
            DateTime.parse(json["created_at"]).month.toString() +
            "." +
            DateTime.parse(json["created_at"]).day.toString()
        : DateTime.now().year.toString() +
            "." +
            DateTime.now().month.toString() +
            "." +
            DateTime.now().day.toString();
  }
}
