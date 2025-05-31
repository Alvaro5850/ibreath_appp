// lib/db/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _databaseName = 'ibreath_app.db';
  static const _databaseVersion = 1;

  // Nombres de tablas
  static const String tableHijos = 'hijos';
  static const String tableEmociones = 'emociones';

  // Columnas comunes
  static const String columnId = 'id';

  // Columnas hijos
  static const String columnNombre = 'nombre';
  static const String columnEdad = 'edad';

  // Columnas emociones
  static const String columnHijoId = 'hijoId';
  static const String columnEmocion = 'emocion';
  static const String columnTimestamp = 'timestamp';

  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableHijos (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNombre TEXT NOT NULL,
        $columnEdad INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableEmociones (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnHijoId INTEGER NOT NULL,
        $columnEmocion TEXT NOT NULL,
        $columnTimestamp TEXT NOT NULL,
        FOREIGN KEY ($columnHijoId) REFERENCES $tableHijos($columnId) ON DELETE CASCADE
      )
    ''');
  }

  // ─────────────────────────────────────────────
  // MÉTODOS PARA HIJOS
  // ─────────────────────────────────────────────

  Future<int> createChild({
    required String nombre,
    required int edad,
  }) async {
    final db = await database;
    return await db.insert(
      tableHijos,
      {
        columnNombre: nombre,
        columnEdad: edad,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllChildren() async {
    final db = await database;
    return await db.query(
      tableHijos,
      orderBy: '$columnNombre ASC',
    );
  }

  // ─────────────────────────────────────────────
  // MÉTODOS PARA EMOCIONES
  // ─────────────────────────────────────────────

  Future<int> guardarEmocion({
    required int hijoId,
    required String emocion,
  }) async {
    final db = await database;
    return await db.insert(
      tableEmociones,
      {
        columnHijoId: hijoId,
        columnEmocion: emocion,
        columnTimestamp: DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> obtenerEmocionesPorHijo(int hijoId) async {
    final db = await database;
    return await db.query(
      tableEmociones,
      where: '$columnHijoId = ?',
      whereArgs: [hijoId],
      orderBy: '$columnTimestamp DESC',
    );
  }

  /// (Opcional) Devuelve sólo las filas de emoción = "Emergencia" de un hijo
  Future<List<Map<String, dynamic>>> obtenerEmergenciasPorHijo(int hijoId) async {
    final db = await database;
    return await db.query(
      tableEmociones,
      where: '$columnHijoId = ? AND $columnEmocion = ?',
      whereArgs: [hijoId, 'Emergencia'],
      orderBy: '$columnTimestamp DESC',
    );
  }
}
