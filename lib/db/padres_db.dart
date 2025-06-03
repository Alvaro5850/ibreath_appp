
import 'package:ibreath_appp/db_helper.dart';
import 'package:sqflite/sqflite.dart';


class PadresDB {
  PadresDB._privateConstructor();
  static final PadresDB instance = PadresDB._privateConstructor();

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<int> createPadre({
    required String email,
    required String password,
  }) async {
    final db = await _db;
    return await db.insert(
      AppDatabase.tablePadres,
      {
        'email': email,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> getPadreByEmailPassword(
      String email, String password) async {
    final db = await _db;
    final resultados = await db.query(
      AppDatabase.tablePadres,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (resultados.isNotEmpty) {
      return resultados.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPadreByEmail(String email) async {
    final db = await _db;
    final resultados = await db.query(
      AppDatabase.tablePadres,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (resultados.isNotEmpty) {
      return resultados.first;
    }
    return null;
  }

  Future<int> updatePassword(String email, String newPassword) async {
    final db = await _db;
    return await db.update(
      AppDatabase.tablePadres,
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
