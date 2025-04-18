class FeedDto {
  String id;
  String allotmentId;
  String accessKey;
  String nfeNumber;
  String emittedAt;
  double weight;
  String type;
  String createdAt;
  double currentTotalFeedReceived;

  FeedDto({
    required this.id,
    required this.allotmentId,
    required this.accessKey,
    required this.nfeNumber,
    required this.emittedAt,
    required this.weight,
    required this.type,
    required this.createdAt,
    required this.currentTotalFeedReceived
  });

  factory FeedDto.fromJson(Map<String, dynamic> json) {
    return FeedDto(
      id: json['id'],
      allotmentId: json['allotmentId'],
      accessKey: json['accessKey'],
      nfeNumber: json['nfeNumber'],
      emittedAt: json['emittedAt'],
      weight: (json['weight'] as num).toDouble(),
      type: json["type"],
      createdAt: json['createdAt'],
      currentTotalFeedReceived: (json["currentTotalFeedReceived"] as num).toDouble()
    );
  }
}