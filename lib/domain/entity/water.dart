import 'package:demo_project/infra/dto/water_dto.dart';

class Water {
  String id;
  String allotmentId;
  int age;
  int previousMeasure;
  int currentMeasure;
  int consumedLiters;
  String createdAt;

  Water({
    required this.id,
    required this.allotmentId,
    required this.age,
    required this.previousMeasure,
    required this.currentMeasure,
    required this.consumedLiters,
    required this.createdAt
  });

  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      id: json["id"],
      allotmentId: json["allotmentId"],
      age: json["age"],
      previousMeasure: json["previousMeasure"],
      currentMeasure: json["currentMeasure"],
      consumedLiters: json["consumedLiters"],
      createdAt: json["createdAt"]
    );
  }

  factory Water.fromDTO(WaterDto source) {
    return Water(
      id: source.id,
      allotmentId: source.allotmentId,
      age: source.age,
      previousMeasure: source.previousMeasure,
      currentMeasure: source.currentMeasure,
      consumedLiters: source.consumedLiters,
      createdAt: source.createdAt
    );
  }

  static Map<String, dynamic> toJson(Water source) {
    return {
      'id': source.id,
      'allotmentId': source.allotmentId,
      'age': source.age,
      'previousMeasure': source.previousMeasure,
      'currentMeasure': source.currentMeasure,
      'consumedLiters': source.consumedLiters,
      'createdAt': source.createdAt
    };
  }
  
}