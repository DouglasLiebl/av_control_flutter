import 'dart:convert';

import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';

class Account {

  String id;
  String firstName;
  String lastName;
  String email;
  List<Aviary> aviaries;
  Auth authData;

  Account({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.aviaries,
    required this.authData
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      aviaries: (json['aviaries'] as List)
          .map((aviary) => Aviary.fromJson(aviary))
          .toList(),
      authData: Auth.fromJson(json['auth']),
    );
  }

  factory Account.fromSQLite(Map<String, dynamic> json) {
    final authData = json['auth'] is String 
      ? jsonDecode(json['auth']) as Map<String, dynamic>
      : json['auth'] as Map<String, dynamic>;
    return Account(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      aviaries: [],
      authData: Auth.fromJson(authData),
    );
  }
}