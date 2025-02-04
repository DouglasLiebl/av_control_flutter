import 'package:demo_project/models/account.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'counter.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tb_account(
        id VARCHAR(300) PRIMARY KEY,
        first_name VARCHAR(300),
        last_name VARCHAR(300),
        email VARCHAR(300)
      );
    ''');

    // Create auth data table
    await db.execute('''
      CREATE TABLE tb_auth_data(
        account_id VARCHAR(300) PRIMARY KEY,
        access_token TEXT,
        token_type VARCHAR(40),
        refresh_token TEXT,
        expires_at VARCHAR(255),
        FOREIGN KEY (account_id) REFERENCES tb_account(id) ON DELETE CASCADE
      );
    ''');

    // Create aviaries table
    await db.execute('''
      CREATE TABLE tb_aviaries(
        id VARCHAR(300) PRIMARY KEY,
        name VARCHAR(300),
        alias VARCHAR(255),
        account_id VARCHAR(300),
        active_allotment_id VARCHAR(300),
        FOREIGN KEY (account_id) REFERENCES tb_account(id) ON DELETE CASCADE
      );
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_account_email ON tb_account(email);');
    await db.execute('CREATE INDEX idx_auth_token ON tb_auth_data(access_token);');
    await db.execute('CREATE INDEX idx_account_id ON tb_aviaries(account_id);');
  }

  Future<void> registerAccountData(Account request) async { 
    final db = await database;
    await db.insert(
      "tb_account", 
      {
        'id': request.id,
        'first_name': request.firstName,
        'last_name': request.lastName,
        'email': request.email
      }
    );

    await db.insert(
      "tb_auth_data", 
      {
        'account_id': request.id,
        'access_token': request.authData.accessToken,
        'token_type': request.authData.tokenType,
        'refresh_token': request.authData.refreshToken,
        'expires_at': request.authData.accessTokenExpiration
      }
    );

    for (Aviary a in request.aviaries) {
      await db.insert(
        "tb_aviaries",
        {
          'id': a.id,
          'name': a.name,
          'alias': a.alias,
          'account_id': request.id,
          'active_allotment_id': a.activeAllotmentId
        }
      ); 
    }
  }

  Future<void> registerAviaryData(Aviary request) async {
    final db = await database;
    await db.insert(
      "tb_aviaries",
      {
        'id': request.id,
        'name': request.name,
        'alias': request.alias,
        'account_id': request.accountId,
        'active_allotment_id': null
      }
    );

  }

  Future<Account> getContext() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
      SELECT 
        a.*,
        auth.access_token,
        auth.token_type,
        auth.refresh_token,
        auth.expires_at
      FROM tb_account a
      LEFT JOIN tb_auth_data auth ON auth.account_id = a.id
      ''');

    if (results.isEmpty) {
      throw Exception("No account found");
    }
    final accountData = results.first;

    final List<Map<String, dynamic>> registeredAviaries = await db.rawQuery(
      '''
      SELECT * FROM tb_aviaries
      WHERE account_id = ?
      ''',
      [accountData['id']]
    );

    print(registeredAviaries);
    
    final account = Account(
      id: accountData['id'] ?? '',
      firstName: accountData['first_name'] ?? '', 
      lastName: accountData['last_name'] ?? '',
      email: accountData['email'] ?? '',
      authData: Auth(
        accountId: accountData['id'] ?? '',
        accessToken: accountData['access_token'] ?? '',
        tokenType: accountData['token_type'] ?? '',
        refreshToken: accountData['refresh_token'] ?? '',
        accessTokenExpiration: accountData['expires_at'] ?? '',
      ),
      aviaries: registeredAviaries
        .map((a) => Aviary(
          id: a['id'],
          name: a['name'],
          alias: a['alias'],
          accountId: a['account_id'],
          activeAllotmentId: a['active_allotment_id']
        ))
        .toList(),
    );

    return account;
  }

  Future<bool> hasLocalData() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
        SELECT id FROM tb_account;
      ''');

    return results.first.isEmpty ? false : true;
  }

  Future<void> cleanDatabase(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM tb_aviaries');
      await txn.rawDelete('DELETE FROM tb_auth_data');
      await txn.rawDelete('DELETE FROM tb_account');
    });
  }
}