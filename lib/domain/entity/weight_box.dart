class WeightBox {
  String? id;
  String? weightId;
  int number;
  double weight;
  int units;

  WeightBox({
    required this.id,
    required this.weightId,
    required this.number,
    required this.weight,
    required this.units
  });

  factory WeightBox.fromJson(Map<String, dynamic> json) {
    return WeightBox(
      id: json["id"],
      weightId: json["weightId"],
      number: json["number"],
      weight: (json["weight"] as num).toDouble(),
      units: json["units"]
    );
  }

  static Map<String, dynamic> toJson(WeightBox source) {
    return {
      "id": source.id,
      "weightId": source.id,
      "number": source.number,
      "weight": source.weight,
      "units": source.units
    };
  }
}