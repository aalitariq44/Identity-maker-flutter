import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create schools table
    await db.execute('''
      CREATE TABLE ${AppConstants.schoolsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name_arabic TEXT NOT NULL,
        name_english TEXT NOT NULL,
        address TEXT NOT NULL,
        phone TEXT NOT NULL,
        principal TEXT NOT NULL,
        logo_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create students table
    await db.execute('''
      CREATE TABLE ${AppConstants.studentsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        grade TEXT NOT NULL,
        school_id INTEGER NOT NULL,
        photo_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (school_id) REFERENCES ${AppConstants.schoolsTable} (id)
      )
    ''');

    // Create export_records table
    await db.execute('''
      CREATE TABLE ${AppConstants.exportRecordsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_name TEXT NOT NULL,
        student_ids TEXT NOT NULL,
        template_id INTEGER NOT NULL,
        file_path TEXT NOT NULL,
        total_students INTEGER NOT NULL,
        exported_at TEXT NOT NULL,
        export_settings TEXT
      )
    ''');

    // Create templates table (for storing template metadata)
    await db.execute('''
      CREATE TABLE templates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        width REAL NOT NULL,
        height REAL NOT NULL,
        orientation TEXT NOT NULL,
        file_path TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Insert default data
    await _insertDefaultData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insert a default school for testing
    final now = DateTime.now().toIso8601String();
    await db.insert(AppConstants.schoolsTable, {
      'name_arabic': 'مدرسة الأمل الثانوية',
      'name_english': 'Al-Amal Secondary School',
      'address': 'شارع الجامعة، المدينة',
      'phone': '0123456789',
      'principal': 'أحمد محمد علي',
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // Helper methods for testing and debugging
  Future<List<Map<String, dynamic>>> getAllTables() async {
    final db = await database;
    return await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
  }

  Future<List<Map<String, dynamic>>> getTableInfo(String tableName) async {
    final db = await database;
    return await db.rawQuery("PRAGMA table_info('$tableName')");
  }
}
