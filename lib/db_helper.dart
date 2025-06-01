// lib/db/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _databaseName = 'ibreath_app.db';
  static const _databaseVersion = 2;

  // ───────────────────────────── tablas y columnas ─────────────────────────────

  // TABLA PADRES (suponemos que ésta ya existía o se creó sin problemas)
  static const String tablePadres    = 'padres';
  static const String columnId       = 'id';
  static const String columnEmail    = 'email';
  static const String columnPassword = 'password';

  // TABLA HIJOS (usamos `parentId` para coincidir con el esquema que ya tienes)
  static const String tableHijos      = 'hijos';
  static const String columnNombre    = 'nombre';
  static const String columnEdad      = 'edad';
  static const String columnParentId  = 'parentId'; // <<-- columna antigua

  // TABLA EMOCIONES
  static const String tableEmociones  = 'emociones';
  static const String columnHijoId    = 'hijoId';
  static const String columnEmocion   = 'emocion';
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
      onUpgrade: _onUpgrade,
    );
  }

  /// Se ejecuta la primera vez que no existe la BD (versión 2).
  /// Creamos tablas completas: padres, hijos (con parentId) y emociones.
  Future _onCreate(Database db, int version) async {
    // 1) Tabla PADRES
    await db.execute('''
      CREATE TABLE $tablePadres (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPassword TEXT NOT NULL
      )
    ''');

    // 2) Tabla HIJOS (con parentId NOT NULL)
    await db.execute('''
      CREATE TABLE $tableHijos (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNombre TEXT NOT NULL,
        $columnEdad INTEGER NOT NULL,
        $columnParentId INTEGER NOT NULL,
        FOREIGN KEY($columnParentId) REFERENCES $tablePadres($columnId) ON DELETE CASCADE
      )
    ''');

    // 3) Tabla EMOCIONES
    await db.execute('''
      CREATE TABLE $tableEmociones (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnHijoId INTEGER NOT NULL,
        $columnEmocion TEXT NOT NULL,
        $columnTimestamp TEXT NOT NULL,
        FOREIGN KEY($columnHijoId) REFERENCES $tableHijos($columnId) ON DELETE CASCADE
      )
    ''');
  }

  /// Si la BD existente era versión 1 (no tenía parentId en hijos),
  /// al pasar a versión 2 hacemos el upgrade: 
  /// - Añadimos la tabla `padres` (si no existía)
  /// - Creamos o ajustamos la tabla `hijos` para que tenga `parentId`
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 && newVersion >= 2) {
      // 1) Crear tabla PADRES si no existía
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tablePadres (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnEmail TEXT NOT NULL UNIQUE,
          $columnPassword TEXT NOT NULL
        )
      ''');

      // 2) Comprobamos si la columna parentId ya existe
      //    Si no existe, la añadimos. Para simplificar, borramos y volvemos a crear `hijos`.
      //    Esto eliminará datos antiguos de hijos, pero es la forma más directa
      //    si no quieres borrar manualmente la base. 
      //    Si prefieres migrar datos, tendrías que:
      //      a) Renombrar la tabla antigua, b) Crear nueva con parentId, c) INSERT SELECT, d) Borrar tabla antigua.
      //    Aquí optamos por soltar y crear de nuevo:

      await db.execute('DROP TABLE IF EXISTS $tableHijos');

      // 3) Crear tabla HIJOS (con parentId)
      await db.execute('''
        CREATE TABLE $tableHijos (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnNombre TEXT NOT NULL,
          $columnEdad INTEGER NOT NULL,
          $columnParentId INTEGER NOT NULL,
          FOREIGN KEY($columnParentId) REFERENCES $tablePadres($columnId) ON DELETE CASCADE
        )
      ''');
    }
  }

  // ─────────────────────────────────────────────
  // MÉTODOS PARA PADRES
  // ─────────────────────────────────────────────

  Future<int> createPadre({
    required String email,
    required String password,
  }) async {
    final db = await database;
    return await db.insert(
      tablePadres,
      {
        columnEmail: email,
        columnPassword: password,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> getPadreByEmailPassword(
      String email, String password) async {
    final db = await database;
    final result = await db.query(
      tablePadres,
      where: '$columnEmail = ? AND $columnPassword = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<Map<String, dynamic>?> getPadreByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      tablePadres,
      where: '$columnEmail = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> updatePassword(String email, String newPassword) async {
    final db = await database;
    return await db.update(
      tablePadres,
      { columnPassword: newPassword },
      where: '$columnEmail = ?',
      whereArgs: [ email ],
    );
  }

  // ─────────────────────────────────────────────
  // MÉTODOS PARA HIJOS (ahora con parentId)
  // ─────────────────────────────────────────────

  Future<int> createChild({
    required String nombre,
    required int edad,
    required int parentId,       // <<–– usamos parentId aquí
  }) async {
    final db = await database;
    return await db.insert(
      tableHijos,
      {
        columnNombre: nombre,
        columnEdad: edad,
        columnParentId: parentId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getChildrenByParent(int parentId) async {
    final db = await database;
    return await db.query(
      tableHijos,
      where: '$columnParentId = ?',
      whereArgs: [parentId],
      orderBy: '$columnNombre ASC',
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

  Future<List<Map<String, dynamic>>> obtenerEmergenciasPorHijo(
      int hijoId) async {
    final db = await database;
    return await db.query(
      tableEmociones,
      where: '$columnHijoId = ? AND $columnEmocion = ?',
      whereArgs: [hijoId, 'Emergencia'],
      orderBy: '$columnTimestamp DESC',
    );
  }
}
