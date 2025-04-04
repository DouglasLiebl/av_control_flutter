import 'dart:convert';

import 'package:demo_project/infra/dto/auth_dto.dart';
import 'package:demo_project/infra/dto/aviary_dto.dart';

class AccountDto {

  String id;
  String firstName;
  String lastName;
  String email;
  List<AviaryDto> aviaries;
  AuthDto authData;

  AccountDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.aviaries,
    required this.authData
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    return AccountDto(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      aviaries: (json['aviaries'] as List)
          .map((aviary) => AviaryDto.fromJson(aviary))
          .toList(),
      authData: AuthDto.fromJson(json['auth']),
    );
  }

  factory AccountDto.fromSQLite(Map<String, dynamic> json) {
    final authData = json['auth'] is String 
      ? jsonDecode(json['auth']) as Map<String, dynamic>
      : json['auth'] as Map<String, dynamic>;
    return AccountDto(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      aviaries: [],
      authData: AuthDto.fromJson(authData),
    );
  }
}