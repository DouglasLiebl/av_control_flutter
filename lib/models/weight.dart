import 'package:demo_project/models/weight_box.dart';

class Weight {
  String id;
  String allotmentId;
  int age;
  double weight;
  double tare;
  int totalUnits;
  String createdAt;
  List<WeightBox> boxesWeights;

  Weight({
    required this.id,
    required this.allotmentId,
    required this.age,
    required this.weight,
    required this.tare,
    required this.totalUnits,
    required this.createdAt,
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
      createdAt: json["createdAt"],
      boxesWeights: (json["weights"] as List)
        .map((box) => WeightBox.fromJson(box))
        .toList()
    );
  }

  factory Weight.fromSQLite(Map<String, dynamic> json) {
    return Weight(
      id: json["id"],
      allotmentId: json["allotmentId"],
      age: json["age"],
      weight: json["weight"],
      tare: json["tare"],
      totalUnits: json["totalUnits"],
      createdAt: json["createdAt"],
      boxesWeights: []
    );
  }

  static Map<String, dynamic> toJson(Weight source) {
    return {
      'id': source.id,
      'allotmentId': source.allotmentId,
      'age': source.age,
      'weight': source.weight,
      'tare': source.tare,
      'totalUnits': source.totalUnits,
      'createdAt': source.createdAt,
      'weights': source.boxesWeights.map((box) => WeightBox.toJson(box)).toList()
    };
  }
}