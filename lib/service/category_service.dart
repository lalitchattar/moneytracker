import 'package:moneytracker/model/category.dart';
import 'package:sqflite/sqflite.dart';

import '../util/database_helper.dart';

class CategoryService {
  final String _tableName = "CATEGORY";

  Future<List<Category>> getAllCategories(bool fetchSuspended) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        "SELECT C.*, (SELECT COUNT(*) FROM CATEGORY C2 WHERE C2.PARENT_CATEGORY = C.ID AND C2.IS_DELETED = ?) AS CHILD_COUNT FROM CATEGORY C WHERE C.IS_DELETED = ? AND C.IS_SUSPENDED <= ? ORDER BY IS_SUSPENDED ASC",
        [0, 0, fetchSuspended ? 1: 0]);
    return result.map((account) => Category.fromMapObject(account)).toList();
  }

  Future<List<Category>> getCategoriesByType(String type) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        "SELECT C.*, (SELECT COUNT(*) FROM CATEGORY C2 WHERE C2.PARENT_CATEGORY = C.ID AND C2.IS_DELETED = ?) AS CHILD_COUNT FROM CATEGORY C WHERE IS_DELETED = ? AND CATEGORY_TYPE = ?",
        [0, 0, type]);
    return result.map((account) => Category.fromMapObject(account)).toList();
  }

  Future<int> createCategory(Map<String, dynamic>? category) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.insert(_tableName, category!);
    return result;
  }

  Future<List<Category>> getCategoryByName(String name) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        'SELECT * FROM CATEGORY WHERE CATEGORY_NAME = ? AND IS_DELETED = ? COLLATE NOCASE',
        [name.trim(), 0]);
    return result.map((category) => Category.fromMapObject(category)).toList();
  }

  Future<List<Category>> getCategoryById(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        'SELECT C.*, (SELECT COUNT(*) FROM CATEGORY C2 WHERE C2.PARENT_CATEGORY = ?) AS CHILD_COUNT FROM CATEGORY C WHERE C.ID = ?',
        [id, id]);
    return result.map((category) => Category.fromMapObject(category)).toList();
  }

  Future<List<Category>> getCategoryByIdWithParent(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        'SELECT C.* , (SELECT C2.CATEGORY_NAME FROM CATEGORY C2 WHERE C2.ID = C.PARENT_CATEGORY AND C2.IS_DELETED = ?) AS PARENT_CATEGORY_NAME FROM CATEGORY C WHERE C.ID = ?',
        [0, id]);
    return result.map((category) => Category.fromMapObject(category)).toList();
  }

  Future<List<Category>> getCategoryByParentId(int id) async {
    if (id == 0) {
      return [];
    }
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery(
        'SELECT C.*, (SELECT COUNT(*) FROM CATEGORY C2 WHERE C2.PARENT_CATEGORY = ? AND C2.IS_DELETED = ?) AS CHILD_COUNT FROM CATEGORY C WHERE C.PARENT_CATEGORY = ? AND C.IS_DELETED = ?',
        [0, id, id, 0]);
    return result.map((category) => Category.fromMapObject(category)).toList();
  }

  Future<void> updateCategory(Map<String, dynamic>? category, int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;

    String updateQuery = """
      UPDATE CATEGORY SET CATEGORY_NAME = ?, CATEGORY_TYPE = ?, PARENT_CATEGORY = ?, DESCRIPTION = ? WHERE ID = ?
      """;
    List<dynamic> params = [category!["CATEGORY_NAME"],category!["CATEGORY_TYPE"], category!["PARENT_CATEGORY"], category!["DESCRIPTION"], id];

    await database.rawQuery(updateQuery, params);
  }

  void deleteCategory(int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database
        .rawQuery('UPDATE CATEGORY SET IS_DELETED = ? WHERE ID = ?', [1, id]);
  }

  Future<bool> isHavingChildCategory(int id) async{
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database.rawQuery("SELECT * FROM CATEGORY WHERE PARENT_CATEGORY = ?", [id]);
    return result.map((category) => Category.fromMapObject(category)).toList().isNotEmpty;
  }

  Future<void> updateCategoryForInTransaction(Map<String, dynamic>? category, int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
      String updateQuery = """
      UPDATE CATEGORY SET CREDITED_AMOUNT = ?, 
      IN_TRANSACTION = ? WHERE ID = ?
      """;
      List<dynamic> params = [category!["CREDITED_AMOUNT"], category!["IN_TRANSACTION"], id];
      await database.rawQuery(updateQuery, params);
  }

  Future<void> updateCategoryForOutTransaction(Map<String, dynamic>? category, int id) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    String updateQuery = """
      UPDATE CATEGORY SET DEBITED_AMOUNT = ?, 
      OUT_TRANSACTION = ? WHERE ID = ?
      """;
    List<dynamic> params = [category!["DEBITED_AMOUNT"], category!["OUT_TRANSACTION"], id];
    await database.rawQuery(updateQuery, params);
  }

  void toggleSuspendCategory(int id, int flag) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database database = await databaseHelper.database;
    var result = await database
        .rawQuery('UPDATE CATEGORY SET IS_SUSPENDED = ? WHERE ID = ?', [flag, id]);
  }
}
