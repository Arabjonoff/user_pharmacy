class PaymentVerfy {
  PaymentVerfy({
    this.errorCode,
    this.errorNote,
  });

  int errorCode;
  String errorNote;

  factory PaymentVerfy.fromJson(Map<String, dynamic> json) => PaymentVerfy(
        errorCode: json["error_code"],
        errorNote: json["error_note"],
      );

  Map<String, dynamic> toJson() => {
        "error_code": errorCode,
        "error_note": errorNote,
      };
}
