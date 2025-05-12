// lib/db/padres_db.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PadresDB {
  static final PadresDB instance = PadresDB._init();
  static Database? _database;

  PadresDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('padres.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE padres (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> createPadre(String email, String password) async {
    final db = await instance.database;
    return await db.insert('padres', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>?> getPadre(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'padres',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPadreByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'padres',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updatePassword(String email, String newPassword) async {
    final db = await instance.database;
    return await db.update(
      'padres',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
