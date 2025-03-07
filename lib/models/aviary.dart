class Aviary {
  
  String id;
  String name;
  String alias;
  String accountId;
  String? activeAllotmentId;
  int? currentWaterMultiplier;

  Aviary({
    required this.id,
    required this.name,
    required this.alias,
    required this.accountId,
    required this.activeAllotmentId,
    this.currentWaterMultiplier
  });

  factory Aviary.fromJson(Map<String, dynamic> json) {
    return Aviary(
      id: json['id'],
      name: json['name'],
      alias: json['alias'],
      accountId: json['accountId'],
      activeAllotmentId: json['activeAllotmentId'],
      currentWaterMultiplier: json['currentWaterMultiplier']
    );
  }
}