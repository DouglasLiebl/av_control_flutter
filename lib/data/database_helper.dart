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
      CREATE TABLE counter(
        id INTEGER PRIMARY KEY,
        value INTEGER
      )
    ''');
    // Insert initial value
    await db.insert('counter', {'id': 1, 'value': 0});
  }

  Future<int> getCount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('counter');
    return maps.first['value'];
  }

  Future<void> updateCount(int value) async {
    final db = await database;
    await db.update(
      'counter',
      {'value': value},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}