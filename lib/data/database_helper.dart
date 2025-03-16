import 'package:demo_project/dto/mortality_dto.dart';
import 'package:demo_project/dto/water_dto.dart';
import 'package:demo_project/models/account.dart';
import 'package:demo_project/models/allotment.dart';
import 'package:demo_project/models/auth.dart';
import 'package:demo_project/models/aviary.dart';
import 'package:demo_project/models/mortality.dart';
import 'package:demo_project/models/water.dart';
import 'package:demo_project/models/weight.dart';
import 'package:demo_project/models/weight_box.dart';
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
        current_water_multiplier INTEGER,
        FOREIGN KEY (account_id) REFERENCES tb_account(id) ON DELETE CASCADE
      );
    ''');

    // Create allotments table
    await db.execute('''
      CREATE TABLE tb_allotments(
        id VARCHAR(300) PRIMARY KEY,
        aviary_id VARCHAR(300),
        is_active BOOLEAN,
        number INTEGER,
        total_amount INTEGER,
        current_age INTEGER,
        started_at VARCHAR(100),
        ended_at VARCHAR(100),
        current_death_percentage DECIMAL(10, 3),
        current_weight DECIMAL(10, 3),
        current_total_water_consume INTEGER
      );
    ''');

    // Create water history table
    await db.execute('''
      CREATE TABLE tb_water_history (
        id VARCHAR(300) PRIMARY KEY,
        allotment_id VARCHAR(300),
        age INTEGER,
        previous_measure INTEGER,
        current_measure INTEGER,
        consumed_liters INTEGER,
        created_at VARCHAR(100),
        FOREIGN KEY (allotment_id) REFERENCES tb_allotments(id) ON DELETE CASCADE
      );
    ''');

    // Create mortality history table
    await db.execute('''
      CREATE TABLE tb_mortality_history (
        id VARCHAR(300) PRIMARY KEY,
        allotment_id VARCHAR(300),
        age INTEGER,
        deaths INTEGER,
        eliminations INTEGER,
        created_at VARCHAR(100),
        FOREIGN KEY (allotment_id) REFERENCES tb_allotments(id) ON DELETE CASCADE
      );
    ''');

    // Create weight history table
    await db.execute('''
      CREATE TABLE tb_weight_history (
        id VARCHAR(300) PRIMARY KEY,
        allotment_id VARCHAR(300),
        age INTEGER,
        weight DECIMAL(10, 3),
        tare DECIMAL(10, 3),
        total_units INTEGER,
        created_at VARCHAR(100),
        FOREIGN KEY (allotment_id) REFERENCES tb_allotments(id) ON DELETE CASCADE
      );
    ''');


    // Create box weight history table
    await db.execute('''
      CREATE TABLE tb_box_weight_history (
        id VARCHAR(300) PRIMARY KEY,
        weight_id VARCHAR(300),
        number INTEGER,
        weight DECIMAL(10, 3),
        units INTEGER,
        FOREIGN KEY (weight_id) REFERENCES tb_weight_history(id) ON DELETE CASCADE
      );
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_account_email ON tb_account(email);');
    await db.execute('CREATE INDEX idx_auth_token ON tb_auth_data(access_token);');
    await db.execute('CREATE INDEX idx_account_id ON tb_aviaries(account_id);');
    await db.execute('CREATE INDEX idx_id ON tb_allotments(id);');
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
          'active_allotment_id': a.activeAllotmentId,
          'current_water_multiplier': a.currentWaterMultiplier
        }
      ); 
    }
  }

  Future<void> registerAviaryData(Aviary request) async {
    final db = await database;
    await db.transaction((txn) async {
       await txn.insert(
        "tb_aviaries",
        {
          'id': request.id,
          'name': request.name,
          'alias': request.alias,
          'account_id': request.accountId,
          'active_allotment_id': null,
          'current_water_multiplier': null
        },
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    });

  }

  Future<void> registerNewAllotment(Allotment request) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        "tb_allotments", 
        {
          'id': request.id,
          'aviary_id': request.aviaryId,
          'is_active': request.isActive ? 1 : 0,
          'number': request.number,
          'total_amount': request.totalAmount,
          'current_age': request.currentAge,
          'started_at': request.startedAt,
          'ended_at': request.endedAt,
          'current_death_percentage': request.currentDeathPercentage,
          'current_weight': request.currentWeight,
          'current_total_water_consume': request.currentTotalWaterConsume
        },
      );

      await txn.update(
        "tb_aviaries", 
        {
          'active_allotment_id': request.id
        },
        where: 'id = ?',
        whereArgs: [request.aviaryId]
      );
    });
  }

  Future<void> updateAllotmentData(Allotment request) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        "tb_allotments", 
        {
          'id': request.id,
          'aviary_id': request.aviaryId,
          'is_active': request.isActive ? 1 : 0,
          'number': request.number,
          'total_amount': request.totalAmount,
          'current_age': request.currentAge,
          'started_at': request.startedAt,
          'ended_at': request.endedAt,
          'current_death_percentage': request.currentDeathPercentage,
          'current_weight': request.currentWeight,
          'current_total_water_consume': request.currentTotalWaterConsume
        },
        conflictAlgorithm: ConflictAlgorithm.replace
      );

      for (Water h in request.waterHistory) {
        await txn.insert(
          "tb_water_history",
          {
            'id': h.id,
            'allotment_id': h.allotmentId,
            'age': h.age,
            'previous_measure': h.previousMeasure,
            'current_measure': h.currentMeasure,
            'consumed_liters': h.consumedLiters,
            'created_at': h.createdAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      }

      for (Mortality h in request.mortalityHistory) {
        await txn.insert(
          "tb_mortality_history",
          {
            'id': h.id,
            'allotment_id': h.allotmentId,
            'age': h.age,
            'deaths': h.deaths,
            'eliminations': h.eliminations,
            'created_at': h.createdAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      }

      for (Weight h in request.weightHistory) {
        await txn.insert(
          "tb_weight_history",
          {
            'id': h.id,
            'allotment_id': h.allotmentId,
            'age': h.age,
            'weight': h.weight,
            'tare': h.tare,
            'total_units': h.totalUnits,
            'created_at': h.createdAt
          },
          conflictAlgorithm: ConflictAlgorithm.replace
        );

        for (WeightBox hb in h.boxesWeights) {
          await txn.insert(
            "tb_box_weight_history",
            {
              'id': hb.id,
              'weight_id': hb.weightId,
              'number': hb.number,
              'weight': hb.weight,
              'units': hb.units
            },
            conflictAlgorithm: ConflictAlgorithm.replace
          );
        }

      }

    });

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
          activeAllotmentId: a['active_allotment_id'],
          currentWaterMultiplier: a['current_water_multiplier']
        ))
        .toList(),
    );

    return account;
  }

  Future<Allotment> getAllotmentContext(String allotmentId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
    '''
      SELECT 
        *
      FROM tb_allotments 
      WHERE id = ?
    ''', [allotmentId]);

    if (results.isEmpty) {
      throw Exception("No account found");
    }

    final allotmentData = results.first;

    final List<Map<String, dynamic>> waterHistory = await db.rawQuery(
      '''
      SELECT * FROM tb_water_history
      WHERE allotment_id = ?
      ''',
      [allotmentData['id']]
    );

    final List<Map<String, dynamic>> mortalityHistory = await db.rawQuery(
      '''
      SELECT * FROM tb_mortality_history
      WHERE allotment_id = ?
      ''',
      [allotmentData['id']]
    );

    final List<Mortality> mortalities = mortalityHistory.map((m) => Mortality(
      id: m['id'],
      allotmentId: m['allotment_id'],
      age: m['age'],
      deaths: m['deaths'].toInt(),
      eliminations: m['eliminations'].toInt(),
      createdAt: m['created_at']
    )).toList();
    
    final List<Map<String, dynamic>> weightHistory = await db.rawQuery(
      '''
      SELECT * FROM tb_weight_history
      WHERE allotment_id = ?
      ''',
      [allotmentData['id']]
    );

    List<Weight> weights = await Future.wait(weightHistory.map((weight) async {
      List<Map<String, dynamic>> boxes = await db.rawQuery(
        '''
        SELECT * FROM tb_box_weight_history
        WHERE weight_id = ?
        ''',
        [weight['id']]
      );

      return Weight(
        id: weight['id'],
        allotmentId: weight['allotment_id'],
        age: weight['age'],
        weight: weight['weight'],
        tare: weight['tare'],
        totalUnits: weight['total_units'],
        createdAt: weight['created_at'],
        boxesWeights: boxes.map((b) => WeightBox.fromJson(b)).toList()
      );
    }).toList());


    final allotment = Allotment(
      id: allotmentData['id'] ?? '',
      aviaryId: allotmentData['aviary_id'] ?? '',
      isActive: (allotmentData['is_active'] as int) == 1,
      number: allotmentData['number'] ?? 0,
      totalAmount: allotmentData['total_amount'] ?? 0,
      currentAge: allotmentData['current_age'] ?? 0,
      startedAt: allotmentData['started_at'] ?? '',
      endedAt: allotmentData['ended_at'] ?? '',
      currentDeathPercentage: allotmentData['current_death_percentage'] ?? 0.0,
      currentWeight: (allotmentData['current_weight'] ?? 0.0).toDouble(),
      currentTotalWaterConsume: (allotmentData['current_total_water_consume'] ?? 0).toInt(),
      waterHistory: waterHistory
        .map((w) => Water.fromJson(w))
        .toList(),
      mortalityHistory: mortalities,
      weightHistory: weights
    );

    return allotment;
  }

  Future<void> registerMortality(MortalityDto request) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        "tb_mortality_history",
        {
          'id': request.id,
          'allotment_id': request.allotmentId,
          'age': request.age,
          'deaths': request.deaths,
          'eliminations': request.eliminations,
          'created_at': request.createdAt
        }
      );

      await txn.update(
        "tb_allotments",
        {
          "current_death_percentage": request.newDeathPercentage
        },
        where: "id = ?",
        whereArgs: [request.allotmentId]
      );
      
    });
  }

  Future<void> registerWaterHistory(WaterDto request, String aviaryId) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        "tb_water_history",
        {
          "id": request.id,
          "allotment_id": request.allotmentId,
          "age": request.age,
          "previous_measure": request.previousMeasure,
          "current_measure": request.currentMeasure,
          "consumed_liters": request.consumedLiters,
          "created_at": request.createdAt
        }
      );

      await txn.update(
        "tb_aviaries", 
        {
          "current_water_multiplier": request.multiplier
        },
        where: "id = ?",
        whereArgs: [aviaryId]
      );

      await txn.update(
        "tb_allotments",
        {
          "current_total_water_consume": request.newTotalConsumed
        },
        where: "id = ?",
        whereArgs: [request.allotmentId]
      );

    });
  }

  Future<void> registerWeight(Weight request) async {
    final db = await database;

    await db.transaction((tx) async {
      tx.insert(
        "tb_weight_history", 
        {
          "id": request.id,
          "allotment_id": request.allotmentId,
          "age": request.age,
          "weight": request.weight,
          "tare": request.tare,
          "total_units": request.totalUnits,
          "created_at": request.createdAt
        }
      );

      for (WeightBox w in request.boxesWeights) {
        tx.insert(
          "tb_box_weight_history",
          {
            "id": w.id,
            "weight_id": w.weightId,
            "number": w.number,
            "weight": w.weight,
            "units": w.units
          }
        );
      }

      await tx.update(
        "tb_allotments",
        {
          "current_weight": request.weight
        },
        where: "id = ?",
        whereArgs: [request.allotmentId]
      );

    });
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
      await txn.rawDelete('DELETE FROM tb_allotments');
    });
  }
}