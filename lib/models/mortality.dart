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

}