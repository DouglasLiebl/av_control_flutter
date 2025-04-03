import 'package:demo_project/dto/feed_dto.dart';

class Feed {
  String id;
  String allotmentId;
  String accessKey;
  String nfeNumber;
  String emittedAt;
  double weight;
  String type;
  String createdAt;

  Feed({
    required this.id,
    required this.allotmentId,
    required this.accessKey,
    required this.nfeNumber,
    required this.emittedAt,
    required this.weight,
    required this.type,
    required this.createdAt
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'],
      allotmentId: json['allotmentId'] ?? "",
      accessKey: json['accessKey'] ?? "",
      nfeNumber: json['nfeNumber'] ?? "",
      emittedAt: json['emittedAt'] ?? "",
      weight: (json['weight'] as num).toDouble(),
      type: json["type"],
      createdAt: json['createdAt'] ?? ""
    );
  }

  factory Feed.fromDTO(FeedDto source) {
    return Feed(
      id: source.id,
      allotmentId: source.allotmentId,
      accessKey: source.accessKey,
      nfeNumber: source.nfeNumber,
      emittedAt: source.emittedAt,
      weight: source.weight,
      type: source.type,
      createdAt: source.createdAt
    );
  }

  static Map<String, dynamic> toJson(Feed source) {
    return {
      'id': source.id,
      'allotmentId': source.allotmentId,
      'accessKey': source.accessKey,
      'nfeNumber': source.nfeNumber,
      'emittedAt': source.emittedAt,
      'weight': source.weight,
      'type': source.type,
      'createdAt': source.createdAt
    };
  }
}