import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/body_fat_log.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tableName = "bf_log";
  final String _idColName = "id";
  final String _fatPercentageColName = "fat_percentage";
  final String _dateColName = "date";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "bf_log_db4.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tableName (
          $_idColName INTEGER PRIMARY KEY,
          $_fatPercentageColName REAL NOT NULL,
          $_dateColName TEXT NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  void addLog(double fatPercentage) async {
    final db = await database;
    await db.insert(_tableName, {
      _fatPercentageColName: fatPercentage,
      _dateColName: DateTime.now().toIso8601String(),
    });
  }

  Future<List<BodyFatLog>> getLogs() async {
    final db = await database;
    final data = await db.query(_tableName);
    List<BodyFatLog> logs = data
        .map(
          (e) => BodyFatLog(
            id: e[_idColName] as int,
            fatPercentage: e[_fatPercentageColName] as double,
            date: DateTime.tryParse(e[_dateColName] as String) as DateTime,
          ),
        )
        .toList();
    return logs;
  }

  void deleteLog(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
