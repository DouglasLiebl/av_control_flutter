class AviaryDto {
  
  String id;
  String name;
  String alias;
  String accountId;
  String? activeAllotmentId;

  AviaryDto({
    required this.id,
    required this.name,
    required this.alias,
    required this.accountId,
    required this.activeAllotmentId,
  });

  factory AviaryDto.fromJson(Map<String, dynamic> json) {
    return AviaryDto(
      id: json['id'],
      name: json['name'],
      alias: json['alias'],
      accountId: json['accountId'],
      activeAllotmentId: json['activeAllotmentId'],
    );
  }
}