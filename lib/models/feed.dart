class Feed {
  String id;
  String allotmentId;
  String accessKey;
  String nfeNumber;
  String emmitedAt;
  String weight;
  String createdAt;

  Feed({
    required this.id,
    required this.allotmentId,
    required this.accessKey,
    required this.nfeNumber,
    required this.emmitedAt,
    required this.weight,
    required this.createdAt
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'],
      allotmentId: json['allotmentId'],
      accessKey: json['accessKey'],
      nfeNumber: json['nfeNumber'],
      emmitedAt: json['emmitedAt'],
      weight: json['weight'],
      createdAt: json['createdAt']
    );
  }
}