import 'package:note_app/model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const notename = 'notename';

class NoteDatabase {
  NoteDatabase._();
  static final NoteDatabase instance = NoteDatabase._();
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await init('note1.db');
  }

  Future<Database> init(String databaseName) async {
    final databaseFolder = await getDatabasesPath();
    final databaseFullpath = join(databaseFolder, databaseName);
    return openDatabase(
      databaseFullpath,
      version: 1,
      onCreate: (db, version) {
        db.execute("""
  CREATE TABLE $notename(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            category TEXT
  );
        """);
      },
    );
  }

  Future<int> createNote(MyNote note) async {
    final db = await database;
    final theId = await db.insert(notename, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return theId;
  }

  Future<List<MyNote>> readNote() async {
    final db = await database;
    List<Map<String, dynamic>> notes = await db.query(notename);
    List<MyNote> convertedData =
        notes.map((e) => MyNote.fromMysqlMap(e)).toList();
    return convertedData;
  }

  updateNote(MyNote note) async {
    final db = await database;
    await db
        .update(notename, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<List<MyNote>> readNoteByCategory(String byCategory) async {
    final db = await database;
    List<Map<String, Object?>> noteByCateg = await db
        .query(notename, where: 'category = ?', whereArgs: [byCategory]);

    List<MyNote> theNotes =
        noteByCateg.map((e) => MyNote.fromMysqlMap(e)).toList();
    return theNotes;
  }

  deleteNote(int id) async {
    final db = await database;
    await db.delete(notename, where: 'id = ?', whereArgs: [id]);
  }
}
