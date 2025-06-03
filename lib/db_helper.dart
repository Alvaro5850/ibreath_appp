
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _databaseName = 'ibreath_app.db';
  static const _databaseVersion = 2;


  static const String tablePadres    = 'padres';
  static const String columnId       = 'id';
  static const String columnEmail    = 'email';
  static const String columnPassword = 'password';

  static const String tableHijos      = 'hijos';
  static const String columnNombre    = 'nombre';
  static const String columnEdad      = 'edad';
  static const String columnParentId  = 'parentId';

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


  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePadres (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPassword TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableHijos (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNombre TEXT NOT NULL,
        $columnEdad INTEGER NOT NULL,
        $columnParentId INTEGER NOT NULL,
        FOREIGN KEY($columnParentId) REFERENCES $tablePadres($columnId) ON DELETE CASCADE
      )
    ''');

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


  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 && newVersion >= 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tablePadres (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnEmail TEXT NOT NULL UNIQUE,
          $columnPassword TEXT NOT NULL
        )
      ''');



      await db.execute('DROP TABLE IF EXISTS $tableHijos');

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


  Future<int> createChild({
    required String nombre,
    required int edad,
    required int parentId,
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
