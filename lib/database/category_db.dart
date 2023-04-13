import 'package:note_app/model/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const categoryname = 'category';

class CategoryDatabase {
  CategoryDatabase._();

  static final CategoryDatabase instance = CategoryDatabase._();

  static Database? _database;

  Future<Database> get database async {
    return _database ?? await init("category1.db");
  }

  Future<Database> init(String databaseName) async {
    final databaseFolder = await getDatabasesPath();
    final databaseFullpath = join(databaseFolder, databaseName);

    return openDatabase(
      databaseFullpath,
      version: 1,
      onCreate: (db, version) {
        db.execute("""
      CREATE TABLE $categoryname (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      );
""");
      },
    );
  }

  Future<int> createCategory(CategoryModel category) async {
    final db = await database;
    int theId = await db.insert(categoryname, category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return theId;
  }

  Future<List<CategoryModel>> readCategory() async {
    final db = await database;
    List<Map<String, Object?>> theCategory = await db.query(categoryname);
    List<CategoryModel> ourConvertedData =
        theCategory.map((e) => CategoryModel.fromMysqlMap(e)).toList();
    return ourConvertedData;
  }

  updateCategory(
    CategoryModel category,
  ) async {
    final db = await database;
    await db.update(categoryname, category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  removeCategory(int id) async {
    final db = await database;
    await db.delete(categoryname, where: 'id = ?', whereArgs: [id]);
  }
}
