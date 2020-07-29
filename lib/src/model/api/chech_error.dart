class CheckError {
  CheckError({
    this.error,
    this.msg,
  });

  int error;
  String msg;

  factory CheckError.fromJson(Map<String, dynamic> json) => CheckError(
        error: json["error"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
      };
}
