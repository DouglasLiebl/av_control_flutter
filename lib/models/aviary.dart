class Aviary {
  
  String id;
  String name;
  String alias;
  String accountId;
  String activeAllotmentId;

  Aviary({
    required this.id,
    required this.name,
    required this.alias,
    required this.accountId,
    required this.activeAllotmentId
  });

  factory Aviary.fromJson(Map<String, dynamic> json) {
    return Aviary(
      id: json['id'],
      name: json['name'],
      alias: json['alias'],
      accountId: json['alias'],
      activeAllotmentId: json['activeAllotmentId']
    );
  }
}