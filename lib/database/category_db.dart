import 'package:note_app/model/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const tableName = 'notecategory';

class CategoryDataBase {
  CategoryDataBase._();

  static final CategoryDataBase categoryDataBaseInstance = CategoryDataBase._();

  static Database? _database;

  Future<Database> get database async {
    return _database ?? await init('categ.db');
  }

  Future<Database> init(String databaseName) async {
    final databaseFolder = await getDatabasesPath();
    final databaseFullPath = join(databaseFolder, databaseName);
    return openDatabase(databaseFullPath, version: 1, onCreate: ((db, version) {
      db.execute("""
    CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
    )
""");
    }));
  }

  Future<int> createCategory(MyCategory category) async {
    final db = await database;
    final theId = await db.insert(tableName, category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return theId;
  }

  Future<List<MyCategory>> readCategory() async {
    final db = await database;
    List<Map<String, Object?>> theCategory = await db.query(tableName);

    List<MyCategory> convertedCategory =
        theCategory.map((e) => MyCategory.fromMysqlMap(e)).toList();
    return convertedCategory;
  }

  updateCategory(MyCategory category) async {
    final db = await database;
    await db.update(tableName, category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  deleteCategory(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
