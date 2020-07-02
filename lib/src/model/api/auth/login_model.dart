class LoginModel {
  LoginModel({
    this.status,
    this.msg,
  });

  int status;
  String msg;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
      };
}
