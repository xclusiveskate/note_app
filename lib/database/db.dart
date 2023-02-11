import 'package:note_app/model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const tableName = 'mynoteapp';

class NoteDatabase {
  NoteDatabase._();

  static final NoteDatabase noteDatabaseInstance = NoteDatabase._();

  static Database? _database;

  Future<Database> get database async {
    return _database ?? await init('noteapp.db');
  }

  Future<Database> init(String databaseName) async {
    final databaseFolder = await getDatabasesPath();
    final databaseFullPath = join(databaseFolder, databaseName);

    return await openDatabase(
      databaseFullPath,
      version: 1,
      onCreate: (db, version) {
        db.execute("""
    CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT,
      date TEXT,
      category TEXT,
      isCompleted BOOLEAN
    )
""");
      },
    );
  }

//Create
  Future<int> createNote(MyNote note) async {
    final db = await database;
    int theId = await db.insert(tableName, note.toMap());
    return theId;
  }

  //read
  readNote() async {
    final db = await database;
  }

  //update
  updateNote() async {
    final db = await database;
  }

  //delete
  deleteNote() async {
    final db = await database;
  }
}
