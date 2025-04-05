import 'dart:convert';

import 'package:demo_project/domain/entity/account.dart';
import 'package:demo_project/infra/dto/account_dto.dart';
import 'package:demo_project/infra/dto/auth_dto.dart';
import 'package:demo_project/infra/dto/aviary_dto.dart';
import 'package:demo_project/infra/repository/auth_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';

class AuthService {
  final AuthRepository authRepository;
  final SecureStorage secureStorage;
  final SqliteStorage _sqliteStorage = SqliteStorage.instance;

  AuthService({required this.authRepository, required this.secureStorage});

  Future<bool> hasLoggedUser() async {
    return secureStorage.getAuth().then((auth) => auth != null);
  }

  Future<Account> login(String email, String password) async {
    final db = await _sqliteStorage.database;
    AccountDto response = await authRepository.login(email, password);

    secureStorage.setItem("Auth", jsonEncode(AuthDto.toJson(response.authData)));
   
    await db.transaction((tx) async {
      await tx.insert(
        "tb_account", 
        {
          'id': response.id,
          'firstName': response.firstName,
          'lastName': response.lastName,
          'email': response.email
        }
      );

      for (AviaryDto a in response.aviaries) {
        await tx.insert(
          "tb_aviaries",
          {
            'id': a.id,
            'name': a.name,
            'alias': a.alias,
            'accountId': response.id,
            'activeAllotmentId': a.activeAllotmentId,
            'currentWaterMultiplier': a.currentWaterMultiplier
          }
        ); 
        }
    });

    return Account.fromDTO(response);
  }

  Future<void> logout() async {
    secureStorage.deleteItem("Auth");
    final db = await _sqliteStorage.database;
    
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM tb_aviaries');
      await txn.rawDelete('DELETE FROM tb_account');
      await txn.rawDelete('DELETE FROM tb_allotments');
    });
  }
}