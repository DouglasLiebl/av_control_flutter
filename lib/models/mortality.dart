import 'package:demo_project/dto/mortality_dto.dart';

class Mortality {
  String id;
  String allotmentId;
  int age;
  int deaths;
  int eliminations;
  String createdAt;

  Mortality({
    required this.id,
    required this.allotmentId,
    required this.age,
    required this.deaths,
    required this.eliminations,
    required this.createdAt
  });

  factory Mortality.fromJson(Map<String, dynamic> json) {
    return Mortality(
      id: json["id"],
      allotmentId: json["allotmentId"],
      age: json["age"],
      deaths: json["deaths"],
      eliminations: json["eliminations"],
      createdAt: json["createdAt"]
    );
  }

  factory Mortality.fromDTO(MortalityDto source) {
    return Mortality(
      id: source.id,
      allotmentId: source.allotmentId,
      age: source.age,
      deaths: source.deaths,
      eliminations: source.eliminations,
      createdAt: source.createdAt
    );
  }

  static Map<String, dynamic> toJson(Mortality source) {
    return {
      'id': source.id,
      'allotmentId': source.allotmentId,
      'age': source.age,
      'deaths': source.deaths,
      'eliminations': source.eliminations,
      'createdAt': source.createdAt
    };    
  }

}