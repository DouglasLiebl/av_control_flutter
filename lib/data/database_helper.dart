
import 'package:demo_project/infra/dto/feed_dto.dart';
import 'package:demo_project/infra/dto/mortality_dto.dart';
import 'package:demo_project/infra/dto/water_dto.dart';
import 'package:demo_project/domain/entity/account.dart';
import 'package:demo_project/domain/entity/allotment.dart';
import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/domain/entity/feed.dart';
import 'package:demo_project/domain/entity/mortality.dart';
import 'package:demo_project/domain/entity/sync_data.dart';
import 'package:demo_project/domain/entity/water.dart';
import 'package:demo_project/domain/entity/weight.dart';
import 'package:demo_project/domain/entity/weight_box.dart';
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
        firstName VARCHAR(300),
        lastName VARCHAR(300),
        email VARCHAR(300)
      );
    ''');

    // Create auth data table
    await db.execute('''
      CREATE TABLE tb_auth_data(
        accountId VARCHAR(300) PRIMARY KEY,
        accessToken TEXT,
        tokenType VARCHAR(40),
        refreshToken TEXT,
        expiresAt VARCHAR(255),
        FOREIGN KEY (accountId) REFERENCES tb_account(id) ON DELETE CASCADE
      );
    ''');

    // Create aviaries table
    await db.execute('''
      CREATE TABLE tb_aviaries(
        id VARCHAR(300) PRIMARY KEY,
        name VARCHAR(300),
        alias VARCHAR(255),
        accountId VARCHAR(300),
        activeAllotmentId VARCHAR(300),
        currentWaterMultiplier INTEGER,
        FOREIGN KEY (accountId) REFERENCES tb_account(id) ON DELETE CASCADE
      );
    ''');

    // Create allotments table
    await db.execute('''
      CREATE TABLE tb_allotments(
        id VARCHAR(300) PRIMARY KEY,
        aviaryId VARCHAR(300),
        isActive BOOLEAN,
        number INTEGER,
        totalAmount INTEGER,
        currentAge INTEGER,
        startedAt VARCHAR(100),
        endedAt VARCHAR(100),
        currentDeathPercentage DECIMAL(10, 3),
        currentWeight DECIMAL(10, 3),
        currentTotalWaterConsume INTEGER,
        currentTotalFeedReceived DECIMAL(12, 4)
      );
    ''');

    // Create water history table
    await db.execute('''
      CREATE TABLE tb_water_history (
        id VARCHAR(300) PRIMARY KEY,
        allotmentId VARCHAR(300),
        age INTEGER,
        previousMeasure INTEGER,
        currentMeasure INTEGER,
        consumedLiters INTEGER,
        createdAt VARCHAR(100),
        FOREIGN KEY (allotmentId) REFERENCES tb_allotments(id) ON DELETE CASCADE
      );
    ''');

    // Create mortality history table
    await db.execute('''
      CREATE TABLE tb_mortality_history (
        id VARCHAR(300) PRIMARY KEY,
        allotmentId VARCHAR(300),
        age INTEGER,
        deaths INTEGER,
        eliminations INTEGER,
        createdAt VARCHAR(100),
        FOREIGN KEY (allotmentId) REFERENCES tb_allotments(id) ON DELETE CASCADE
      );
    ''');

    // Create weight history table
    await db.execute('''
      CREATE TABLE tb_weight_history (
        id VARCHAR(300) PRIMARY KEY,
        allotmentId VARCHAR(300),
        age INTEGER,
        weight DECIMAL(10, 3),
        tare DECIMAL(10, 3),
        totalUnits INTEGER,
        createdAt VARCHAR(100),
        FOREIGN KEY (allotmentId) REFERENCES tb_allotments(id) ON DELETE CASCADE
      );
    ''');


    // Create box weight history table
    await db.execute('''
      CREATE TABLE tb_box_weight_history (
        id VARCHAR(300) PRIMARY KEY,
        weightId VARCHAR(300),
        number INTEGER,
        weight DECIMAL(10, 3),
        units INTEGER,
        FOREIGN KEY (weightId) REFERENCES tb_weight_history(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE tb_feed_history (
        id VARCHAR(300) PRIMARY KEY,
        allotmentId VARCHAR(300),
        accessKey TEXT,
        nfeNumber VARCHAR(300),
        emittedAt VARCHAR(100),
        weight DECIMAL(12, 4),
        type VARCHAR(10),
        createdAt VARCHAR(100),
        FOREIGN KEY (allotmentId) REFERENCES tb_allotments(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE tb_offline_sync (
        id INTEGER PRIMARY KEY,
        operationType VARCHAR(40),
        data TEXT
      );
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_account_email ON tb_account(email);');
    await db.execute('CREATE INDEX idx_auth_token ON tb_auth_data(accessToken);');
    await db.execute('CREATE INDEX idx_account_id ON tb_aviaries(accountId);');
    await db.execute('CREATE INDEX idx_id ON tb_allotments(id);');
  }

  Future<void> registerAccountData(Account request) async { 
   
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
          'accountId': request.accountId,
          'activeAllotmentId': null,
          'currentWaterMultiplier': null
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
          'aviaryId': request.aviaryId,
          'isActive': request.isActive ? 1 : 0,
          'number': request.number,
          'totalAmount': request.totalAmount,
          'currentAge': request.currentAge,
          'startedAt': request.startedAt,
          'endedAt': request.endedAt,
          'currentDeathPercentage': request.currentDeathPercentage,
          'currentWeight': request.currentWeight,
          'currentTotalWaterConsume': request.currentTotalWaterConsume,
          'currentTotalFeedReceived': request.currentTotalFeedReceived
        },
      );

      await txn.update(
        "tb_aviaries", 
        {
          'activeAllotmentId': request.id
        },
        where: 'id = ?',
        whereArgs: [request.aviaryId]
      );
    });
  }

  Future<void> updateAllotmentData(Allotment request) async {
    

  }

  Future<void> registerMortality(MortalityDto request) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        "tb_mortality_history",
        {
          'id': request.id,
          'allotmentId': request.allotmentId,
          'age': request.age,
          'deaths': request.deaths,
          'eliminations': request.eliminations,
          'createdAt': request.createdAt
        }
      );

      await txn.update(
        "tb_allotments",
        {
          "currentDeathPercentage": request.newDeathPercentage
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
          "allotmentId": request.allotmentId,
          "age": request.age,
          "previousMeasure": request.previousMeasure,
          "currentMeasure": request.currentMeasure,
          "consumedLiters": request.consumedLiters,
          "createdAt": request.createdAt
        }
      );

      await txn.update(
        "tb_aviaries", 
        {
          "currentWaterMultiplier": request.multiplier
        },
        where: "id = ?",
        whereArgs: [aviaryId]
      );

      await txn.update(
        "tb_allotments",
        {
          "currentTotalWaterConsume": request.newTotalConsumed
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
          "allotmentId": request.allotmentId,
          "age": request.age,
          "weight": request.weight,
          "tare": request.tare,
          "totalUnits": request.totalUnits,
          "createdAt": request.createdAt
        }
      );

      for (WeightBox w in request.boxesWeights) {
        tx.insert(
          "tb_box_weight_history",
          {
            "id": w.id,
            "weightId": w.weightId,
            "number": w.number,
            "weight": w.weight,
            "units": w.units
          }
        );
      }

      await tx.update(
        "tb_allotments",
        {
          "currentWeight": request.weight
        },
        where: "id = ?",
        whereArgs: [request.allotmentId]
      );

    });
  }

  Future<void> registerFeed(FeedDto request) async {
    final db = await database;

    await db.transaction((tx) async {
      tx.insert(
        "tb_feed_history", 
        {
          "id": request.id,
          "allotmentId": request.allotmentId,
          "accessKey": request.accessKey,
          "nfeNumber": request.nfeNumber,
          "emittedAt": request.emittedAt,
          "weight": request.weight,
          "type": request.type,
          "createdAt": request.createdAt
        }
      );

      tx.update(
        "tb_allotments", 
        {
          "currentTotalFeedReceived": request.currentTotalFeedReceived
        },
        where: "id = ?",
        whereArgs: [request.allotmentId]
      );

    });
  }


  Future<List<SyncData>> getPendingOperations() async {
    final db = await database;

    List<Map<String, dynamic>> data = await db.rawQuery(
      '''
      SELECT * FROM tb_offline_sync
      '''
    );

    return data.map((d) => SyncData.fromJson(d)).toList();
  }

  Future<void> cleanPendingOperations() async {
    final db = await database;

    await db.transaction((tx) async {
      await tx.rawDelete("DELETE FROM tb_offline_sync");
    });
  }

  Future<bool> hasLocalData() async {
    try {
      final db = await database;
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tb_account'));
      return count != null && count > 0;
    } catch (e) { 
      return false;
    }
  }

  Future<void> cleanOfflineSync() async {
    final db = await database;

    await db.transaction((tx) async {
      await tx.rawQuery("DELETE FROM tb_offline_sync");
    });
  }


}