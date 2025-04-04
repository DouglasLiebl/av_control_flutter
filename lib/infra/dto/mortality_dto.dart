class MortalityDto {
  String id;
  String allotmentId;
  int age;
  int deaths;
  int eliminations;
  double newDeathPercentage;
  String createdAt;

  MortalityDto({
    required this.id,
    required this.allotmentId,
    required this.age,
    required this.deaths,
    required this.eliminations,
    required this.newDeathPercentage,
    required this.createdAt
  });

  factory MortalityDto.fromJson(Map<String, dynamic> json) {
    return MortalityDto(
      id: json["id"],
      allotmentId: json["allotmentId"],
      age: json["age"],
      deaths: json["deaths"],
      eliminations: json["eliminations"],
      newDeathPercentage: json["newDeathPercentage"],
      createdAt: json["createdAt"]
    );
  }

}