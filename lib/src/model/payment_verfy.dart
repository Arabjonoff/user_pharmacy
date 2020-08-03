
class PaymentVerfy {
  PaymentVerfy({
    this.error,
    this.errorNote,
  });

  int error;
  String errorNote;

  factory PaymentVerfy.fromJson(Map<String, dynamic> json) => PaymentVerfy(
    error: json["error"],
    errorNote: json["error_note"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "error_note": errorNote,
  };
}