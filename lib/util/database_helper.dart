import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  static const String _account = """ CREATE TABLE ACCOUNT (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        ACCOUNT_NAME TEXT NOT NULL,
        AVAILABLE_BALANCE REAL DEFAULT 0,
        DESCRIPTION TEXT,
        IS_CREDIT_CARD INTEGER DEFAULT 0,
        CREDIT_LIMIT REAL DEFAULT 0,
        OUTSTANDING_BALANCE REAL DEFAULT 0,
        BILLING_DAY TEXT,
        GRACE_PERIOD TEXT,
        CREDITED_AMOUNT REAL DEFAULT 0,
        DEBITED_AMOUNT REAL DEFAULT 0,
        IN_TRANSACTION INTEGER DEFAULT 0,
        OUT_TRANSACTION INTEGER DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SUSPENDED INTEGER DEFAULT 0,
        EXCLUDED_FROM_SUMMARY INTEGER DEFAULT 0
      )
      """;

  static const String _defaultAccount = """INSERT INTO ACCOUNT(ACCOUNT_NAME, DESCRIPTION) VALUES("Cash", "Cash")""";

  static const String _category = """ CREATE TABLE CATEGORY (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        CATEGORY_NAME TEXT UNIQUE NOT NULL,
        CATEGORY_TYPE TEXT,
        DESCRIPTION TEXT,
        PARENT_CATEGORY INTEGER DEFAULT 0,
        CREDITED_AMOUNT REAL DEFAULT 0,
        DEBITED_AMOUNT REAL DEFAULT 0,
        IN_TRANSACTION INTEGER DEFAULT 0,
        OUT_TRANSACTION INTEGER DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SUSPENDED INTEGER DEFAULT 0,
        EXCLUDED_FROM_SUMMARY INTEGER DEFAULT 0
      )""";

  static const _categoryInsert = """ INSERT INTO CATEGORY(
      CATEGORY_NAME, CATEGORY_TYPE, DESCRIPTION, PARENT_CATEGORY
      ) SELECT 'Beauty', 'E', 'Beauty', 0 UNION ALL
      SELECT 'Bills', 'E', 'Bills', 0 UNION ALL
      SELECT 'Cable', 'E', 'Cable', 2 UNION ALL
      SELECT 'Electricity', 'E', 'Electricity', 2 UNION ALL
      SELECT 'Water', 'E', 'Water', 2 UNION ALL
      SELECT 'Books', 'E', 'Books', 0 UNION ALL
      SELECT 'Dining', 'E', 'Dining', 0 UNION ALL
      SELECT 'Discount', 'I', 'Discount', 0 UNION ALL
      SELECT 'Cashback', 'I', 'Cashback', 0 UNION ALL
      SELECT 'Donation', 'E', 'Donation', 0 UNION ALL
      SELECT 'Education', 'E', 'Education', 0 UNION ALL
      SELECT 'Entertainment', 'E', 'Entertainment', 0 UNION ALL
      SELECT 'Movies', 'E', 'Movies', 12 UNION ALL
      SELECT 'Food & Drinks', 'E', 'Food & Drinks', 0 UNION ALL
      SELECT 'Fuel', 'E', 'Fuel', 0 UNION ALL
      SELECT 'Gas', 'E', 'Gas', 0 UNION ALL
      SELECT 'Grocery', 'E', 'Grocery', 0 UNION ALL
      SELECT 'Health', 'E', 'Health', 0 UNION ALL
      SELECT 'Medicines', 'E', 'Medicines', 18 UNION ALL
      SELECT 'Household', 'E', 'Household', 0 UNION ALL
      SELECT 'Interest', 'I', 'Interest', 0 UNION ALL
      SELECT 'Kids', 'E', 'Kids', 0 UNION ALL
      SELECT 'Maintenance', 'E', 'Maintenance', 0 UNION ALL
      SELECT 'Others', 'B', 'Others', 0 UNION ALL
      SELECT 'Recharge', 'E', 'Recharge', 0 UNION ALL
      SELECT 'Salary', 'I', 'Salary', 0 UNION ALL
      SELECT 'Bonus', 'I', 'Bonus', 0 UNION ALL
      SELECT 'Shopping', 'E', 'Shopping', 0 UNION ALL
      SELECT 'Clothes', 'E', 'Clothes', 28 UNION ALL
      SELECT 'Electronics', 'E', 'Electronics', 28 UNION ALL
      SELECT 'Jewellery', 'E', 'Jewellery', 28 UNION ALL
      SELECT 'Stationery', 'E', 'Stationery', 0 UNION ALL
      SELECT 'Tax', 'E', 'Tax', 0 UNION ALL
      SELECT 'Transport', 'E', 'Transport', 0 UNION ALL
      SELECT 'Travel', 'E', 'Travel', 0 UNION ALL
      SELECT 'Utilities', 'E', 'Utilities', 0 UNION ALL
      SELECT 'Vacation', 'E', 'Vacation', 0 """;

  static const String _transaction = """ CREATE TABLE TRANSACTIONS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        TRANSACTION_DATE TEXT NOT NULL,
        TRANSACTION_TYPE TEXT NOT NULL,
        FROM_ACCOUNT INTEGER,
        TO_ACCOUNT INTEGER,
        CATEGORY INTEGER NOT NULL,
        FINAL_AMOUNT REAL NOT NULL,
        DESCRIPTION TEXT,
        IS_DELETED INTEGER DEFAULT 0,
        IS_SUSPENDED INTEGER DEFAULT 0,
        EXCLUDED_FROM_SUMMARY INTEGER DEFAULT 0
      )""";

  static const String _budget = """ CREATE TABLE BUDGET (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        BUDGET_AMOUNT REAL NOT NULL,
        FOR_YEAR INTEGER NOT NULL DEFAULT 0,
        ALERT_ENABLED INTEGER NOT NULL DEFAULT 0,
        IS_DELETED INTEGER DEFAULT 0
      )""";



  DatabaseHelper._createInstance();

  Future<Database> get database async {
    return _database ??= await initializeDatabase();
  }

  factory DatabaseHelper() {
    return _databaseHelper ??= DatabaseHelper._createInstance();
  }

  void _createDB(Database database, int version) async {
    await database.execute(_account);
    await database.execute(_defaultAccount);
    await database.execute(_category);
    await database.execute(_categoryInsert);
    await database.execute(_transaction);
    await database.execute(_budget);
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/moneytracker.db";
    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }
}
