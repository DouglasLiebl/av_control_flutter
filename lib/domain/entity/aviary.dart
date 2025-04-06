import 'package:demo_project/infra/dto/aviary_dto.dart';

class Aviary {
  
  String id;
  String name;
  String alias;
  String accountId;
  String? activeAllotmentId;

  Aviary({
    required this.id,
    required this.name,
    required this.alias,
    required this.accountId,
    required this.activeAllotmentId,
  });

  factory Aviary.fromJson(Map<String, dynamic> json) {
    return Aviary(
      id: json['id'],
      name: json['name'],
      alias: json['alias'],
      accountId: json['accountId'],
      activeAllotmentId: json['activeAllotmentId'],
    );
  }

  factory Aviary.fromDTO(AviaryDto source) {
    return Aviary(
      id: source.id,
      name: source.name,
      alias: source.alias,
      accountId: source.accountId,
      activeAllotmentId: source.activeAllotmentId,
    );
  }
}