import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/infra/dto/account_dto.dart';

class Account {

  String id;
  String firstName;
  String lastName;
  String email;
  List<Aviary> aviaries;

  Account({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.aviaries,
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
    );
  }

  factory Account.fromDTO(AccountDto source) {
    return Account(
      id: source.id,
      firstName: source.firstName,
      lastName: source.lastName,
      email: source.email,
      aviaries: source.aviaries
        .map((aviary) => Aviary.fromDTO(aviary))
        .toList()
    );
  }

  factory Account.fromSQLite(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      aviaries: [],
    );
  }
}