class LoginModel {
  LoginModel({
    this.status,
    this.msg,
    this.konkurs,
  });

  int status;
  String msg;
  bool konkurs;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        msg: json["msg"],
        konkurs: json["konkurs"] == null ? false : json["konkurs"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "konkurs": konkurs,
      };
}
