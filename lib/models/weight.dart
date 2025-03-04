import 'package:demo_project/models/weight_box.dart';

class Weight {
  String id;
  String allotmentId;
  int age;
  double weight;
  double tare;
  int totalUnits;
  List<WeightBox> boxesWeights;

  Weight({
    required this.id,
    required this.allotmentId,
    required this.age,
    required this.weight,
    required this.tare,
    required this.totalUnits,
    required this.boxesWeights
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      id: json["id"],
      allotmentId: json["allotmentId"],
      age: json["age"],
      weight: json["weight"],
      tare: json["tare"],
      totalUnits: json["totalUnits"],
      boxesWeights: (json["boxesWeights"] as List)
        .map((box) => WeightBox.fromJson(box))
        .toList()
    );
  }
}