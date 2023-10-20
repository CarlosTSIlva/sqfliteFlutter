import 'package:sqflite/sqflite.dart';
import 'package:sql/todo.dart';

class Dbhelper {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDb();
    return _database;
  }

  Future<Database> _initDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/notes.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE IF NOT EXISTS "notes" (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "title" TEXT,
          "done" INTEGER
        )''');
      },
      version: 1,
    );
    return db;
  }

  Future<void> deleteAllNotes() async {
    var dbClient = await database;
    await dbClient!.delete('notes');
  }

  Future<void> insertNotes(String title, int done) async {
    var dbClient = await database;

    await dbClient!.insert('notes', {
      'title': title,
      'done': done,
    });
  }

  Future<List<Todo>> selectNotes() async {
    var dbClient = await database;
    final response = await dbClient!.query('notes');
    return response.map((e) => Todo.fromMap(e)).toList();
  }

  Future<void> updateNotes(int id, int done) async {
    var dbClient = await database;
    await dbClient!
        .update('notes', {'done': done}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNotes(int id) async {
    var dbClient = await database;
    await dbClient!.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    var dbClient = await database;
    dbClient!.close();
  }
}
