import 'package:demo_project/infra/dto/account_dto.dart';

abstract class AuthRepository {

  Future<AccountDto> login(String email, String password);
  
}