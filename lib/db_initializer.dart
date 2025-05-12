import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initDatabaseForWindows() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
