import 'package:demo_project/domain/entity/account.dart';
import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/infra/dto/aviary_dto.dart';
import 'package:demo_project/infra/repository/account_repository.dart';
import 'package:demo_project/infra/third_party/local_storage/secure_storage.dart';
import 'package:demo_project/infra/third_party/local_storage/sqlite_storage.dart';
import 'package:sqflite/sqflite.dart';

class AccountService {
  final AccountRepository accountRepository;
  final SecureStorage secureStorage;
  final SqliteStorage _sqliteStorage = SqliteStorage.instance;

  AccountService({required this.accountRepository, required this.secureStorage});

  Future<Aviary> registerNewAviary(String accountId, String name, String alias) async {
    final db = await _sqliteStorage.database;
    AviaryDto response = await accountRepository.registerNewAviary(accountId, name, alias);
    
    await db.transaction((tx) async {
      await tx.insert(
        "tb_aviaries",
        {
          'id': response.id,
          'name': response.name,
          'alias': response.alias,
          'accountId': response.accountId,
          'activeAllotmentId': null,
        },
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    });

    return Aviary.fromDTO(response);
  }

  Future<Account> getAccountData() async {
    final db = await _sqliteStorage.database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
      SELECT * FROM tb_account
      ''');

    if (results.isEmpty) {
      throw Exception("No account found");
    }
    Account account = Account.fromSQLite(results.first);

    final List<Map<String, dynamic>> registeredAviaries = await db.rawQuery(
      '''
      SELECT * FROM tb_aviaries
      WHERE accountId = ?
      ''',
      [account.id]
    );
    
    account.aviaries = registeredAviaries.map((a) => Aviary.fromJson(a)).toList();

    return account;
  }

}