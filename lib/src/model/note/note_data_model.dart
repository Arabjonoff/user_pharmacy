class NoteModel {
  int id;
  String name;
  String doza;
  String eda;
  String time;
  String groupsName;
  String dateItem;
  int mark;

  NoteModel({
    this.id,
    this.name,
    this.doza,
    this.eda,
    this.time,
    this.groupsName,
    this.dateItem,
    this.mark,
  });

  NoteModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.doza = map["doza"];
    this.eda = map["eda"];
    this.time = map["time"];
    this.groupsName = map["groupsName"];
    this.dateItem = map["dateItem"];
    this.mark = map["mark"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "doza": doza,
        "eda": eda,
        "time": time,
        "groupsName": groupsName,
        "dateItem": dateItem,
        "mark": mark,
      };
}
