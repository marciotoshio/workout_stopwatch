import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutDatabase {
  static final WorkoutDatabase instance = WorkoutDatabase.init();

  static Database? _database;

  WorkoutDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDb('workouts.db');
    return _database!;
  }

  Future<Database> initDb(String dbFileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbFileName);

    return await openDatabase(path, version: 1, onCreate: createDb);
  }

  Future createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE workouts ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "name TEXT,"
            "getReadyTime INTEGER NOT NULL,"
            "workoutTime INTEGER NOT NULL,"
            "restTime INTEGER NOT NULL)"
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
