import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';

class Account {

  String id;
  String firstName;
  String lastName;
  String email;
  List<Aviary>? aviaries;
  Auth? authData;

  Account({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}