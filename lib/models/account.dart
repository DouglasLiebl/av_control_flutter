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
}