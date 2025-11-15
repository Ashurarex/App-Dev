import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Calculation {
  final int? id;
  final String expression;
  final String result;

  Calculation({this.id, required this.expression, required this.result});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
    };
  }

  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'],
      expression: map['expression'],
      result: map['result'],
    );
  }
}

class DBHelper {
  static Database? _database;
  static final DBHelper db = DBHelper._();

  DBHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT,
            result TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertCalculation(Calculation calculation) async {
    final db = await database;
    return await db.insert('history', calculation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Calculation>> getAllCalculations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('history', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => Calculation.fromMap(maps[i]));
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
