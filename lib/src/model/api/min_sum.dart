class MinSum {
  MinSum({
    this.min,
  });

  int min;

  factory MinSum.fromJson(Map<String, dynamic> json) => MinSum(
        min: json["min"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
      };
}
