class PaymentVerfy {
  PaymentVerfy({
    this.error_code,
    this.errorNote,
  });

  int error_code;
  String errorNote;

  factory PaymentVerfy.fromJson(Map<String, dynamic> json) => PaymentVerfy(
        error_code: json["error_code"],
        errorNote: json["error_note"],
      );

  Map<String, dynamic> toJson() => {
        "error_code": error_code,
        "error_note": errorNote,
      };
}
