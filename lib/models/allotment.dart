import 'package:demo_project/models/feed.dart';
import 'package:demo_project/models/mortality.dart';
import 'package:demo_project/models/water.dart';
import 'package:demo_project/models/weight.dart';

class Allotment {

  String id;
  String aviaryId;
  bool isActive;
  int number;
  int totalAmount;
  int currentAge;
  String startedAt;
  String endedAt;
  double currentDeathPercentage;
  double currentWeight;
  int currentTotalWaterConsume;
  double currentTotalFeedReceived;
  List<Water> waterHistory;
  List<Mortality> mortalityHistory;
  List<Weight> weightHistory;
  List<Feed> feedHistory;


  Allotment({
    required this.id,
    required this.aviaryId,
    required this.isActive,
    required this.number,
    required this.totalAmount,
    required this.currentAge,
    required this.startedAt,
    required this.endedAt,
    required this.currentDeathPercentage,
    required this.currentWeight,
    required this.currentTotalWaterConsume,
    required this.currentTotalFeedReceived,
    required this.waterHistory,
    required this.mortalityHistory,
    required this.weightHistory,
    required this.feedHistory
  });

  factory Allotment.fromJson(Map<String, dynamic> json) {
    return Allotment(
      id: json["id"],
      aviaryId: json["aviaryId"],
      isActive: json["isActive"],
      number: json["number"].toInt(),
      totalAmount: json["totalAmount"].toInt(),
      currentAge: json["currentAge"].toInt(),
      startedAt: json["startedAt"],
      endedAt: json["endedAt"] ?? '',
      currentDeathPercentage: (json["currentDeathPercentage"] as num).toDouble(),
      currentWeight: (json["currentWeight"] as num).toDouble(),
      currentTotalWaterConsume: json["currentTotalWaterConsume"].toInt(),
      currentTotalFeedReceived: (json["currentTotalFeedReceived"] as num).toDouble(),
      waterHistory: (json["waterHistory"] as List)
        .map((history) => Water.fromJson(history))
        .toList(),
      mortalityHistory: (json["mortalityHistory"] as List)
        .map((history) => Mortality.fromJson(history))
        .toList(),
      weightHistory: (json["weightHistory"] as List)
        .map((history) => Weight.fromJson(history))
        .toList(),
      feedHistory: (json["feedHistory"] as List)
        .map((history) => Feed.fromJson(history))
        .toList()
    );
  }
}
