class WaterDto {
  String id;
  String allotmentId;
  String aviaryId;
  int age;
  int previousMeasure;
  int currentMeasure;
  int consumedLiters;
  String createdAt;
  int multiplier;
  int newTotalConsumed;

  WaterDto({
    required this.id,
    required this.allotmentId,
    required this.aviaryId,
    required this.age,
    required this.previousMeasure,
    required this.currentMeasure,
    required this.consumedLiters,
    required this.multiplier,
    required this.newTotalConsumed,
    required this.createdAt
  });

  factory WaterDto.fromJson(Map<String, dynamic> json) {
    return WaterDto(
      id: json["id"],
      allotmentId: json["allotmentId"],
      aviaryId: json["aviaryId"],
      age: json["age"],
      previousMeasure: json["previousMeasure"],
      currentMeasure: json["currentMeasure"],
      consumedLiters: json["consumedLiters"],
      multiplier: json["multiplier"],
      newTotalConsumed: json["newTotalConsumed"],
      createdAt: json["createdAt"]
    );
  }
  
}