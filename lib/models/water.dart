class Water {
  String id;
  String allotmentId;
  int age;
  int previousMeasure;
  int currentMeasure;
  int consumedLiters;

  Water({
    required this.id,
    required this.allotmentId,
    required this.age,
    required this.previousMeasure,
    required this.currentMeasure,
    required this.consumedLiters
  });

  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      id: json["id"],
      allotmentId: json["allotmentId"],
      age: json["age"],
      previousMeasure: json["previousMeasure"],
      currentMeasure: json["currentMeasure"],
      consumedLiters: json["consumedLiters"]
    );
  }
  
}