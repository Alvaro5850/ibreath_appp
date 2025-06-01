// lib/db/padres_db.dart

import 'package:ibreath_appp/db_helper.dart';
import 'package:sqflite/sqflite.dart';


class PadresDB {
  PadresDB._privateConstructor();
  static final PadresDB instance = PadresDB._privateConstructor();

  Future<Database> get _db async => await AppDatabase.instance.database;

  /// Inserta un nuevo padre (email + password) en la tabla 'padres'
  /// Parámetros nombrados: email y password.
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
      // Si se intenta insertar un email ya existente, lanzará excepción
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Devuelve el padre (campos id, email, password) si existe la combinación email+password
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

  /// Devuelve el padre (campos id, email, password) si existe el email (sin validar contraseña)
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

  /// Actualiza la contraseña del padre identificado por email
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
