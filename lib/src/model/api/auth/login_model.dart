class AuthModel {
  AuthModel({
    this.status,
    this.msg,
  });

  int status;
  String msg;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        status: json["status"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
      };
}
