import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'emociones.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE emociones (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            emocion TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  static Future<void> guardarEmocion(String emocion) async {
    final db = await _initDB();
    await db.insert(
      'emociones',
      {
        'emocion': emocion,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<List<Map<String, dynamic>>> obtenerEmociones() async {
    final db = await _initDB();
    return db.query('emociones', orderBy: 'timestamp DESC');
  }
}
