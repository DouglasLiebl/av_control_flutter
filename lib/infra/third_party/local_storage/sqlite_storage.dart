import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteStorage {
  static final SqliteStorage _instance = SqliteStorage._internal();
  static Database? _database;
  
  SqliteStorage._internal();

  static SqliteStorage get instance => _instance;

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

    await db.execute('''
      CREATE TABLE tb_aviaries(
        id VARCHAR(300) PRIMARY KEY,
        name VARCHAR(300),
        alias VARCHAR(255),
        accountId VARCHAR(300),
        activeAllotmentId VARCHAR(300),
        FOREIGN KEY (accountId) REFERENCES tb_account(id) ON DELETE CASCADE
      );
    ''');

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
        currentWaterMultiplier INTEGER,
        currentDeathPercentage DECIMAL(10, 3),
        currentWeight DECIMAL(10, 3),
        currentTotalWaterConsume INTEGER,
        currentTotalFeedReceived DECIMAL(12, 4)
      );
    ''');

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

    await db.execute('CREATE INDEX idx_account_email ON tb_account(email);');
    await db.execute('CREATE INDEX idx_account_id ON tb_aviaries(accountId);');
    await db.execute('CREATE INDEX idx_id ON tb_allotments(id);');
  }

}