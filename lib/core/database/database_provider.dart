import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Database> get database => _databaseHelper.database;

  // Schools CRUD operations
  Future<int> insertSchool(Map<String, dynamic> school) async {
    final db = await database;
    return await db.insert('schools', school);
  }

  Future<List<Map<String, dynamic>>> getSchools() async {
    final db = await database;
    return await db.query('schools', orderBy: 'name_arabic ASC');
  }

  Future<Map<String, dynamic>?> getSchool(int id) async {
    final db = await database;
    final results = await db.query(
      'schools',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateSchool(int id, Map<String, dynamic> school) async {
    final db = await database;
    return await db.update('schools', school, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSchool(int id) async {
    final db = await database;
    return await db.delete('schools', where: 'id = ?', whereArgs: [id]);
  }

  // Students CRUD operations
  Future<int> insertStudent(Map<String, dynamic> student) async {
    final db = await database;
    return await db.insert('students', student);
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await database;
    return await db.query('students', orderBy: 'name ASC');
  }

  Future<List<Map<String, dynamic>>> getStudentsBySchool(int schoolId) async {
    final db = await database;
    return await db.query(
      'students',
      where: 'school_id = ?',
      whereArgs: [schoolId],
      orderBy: 'name ASC',
    );
  }

  Future<Map<String, dynamic>?> getStudent(int id) async {
    final db = await database;
    final results = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateStudent(int id, Map<String, dynamic> student) async {
    final db = await database;
    return await db.update(
      'students',
      student,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  // Export Records CRUD operations
  Future<int> insertExportRecord(Map<String, dynamic> exportRecord) async {
    final db = await database;
    return await db.insert('export_records', exportRecord);
  }

  Future<List<Map<String, dynamic>>> getExportRecords() async {
    final db = await database;
    return await db.query('export_records', orderBy: 'exported_at DESC');
  }

  Future<Map<String, dynamic>?> getExportRecord(int id) async {
    final db = await database;
    final results = await db.query(
      'export_records',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> deleteExportRecord(int id) async {
    final db = await database;
    return await db.delete('export_records', where: 'id = ?', whereArgs: [id]);
  }

  // Templates CRUD operations
  Future<int> insertTemplate(Map<String, dynamic> template) async {
    final db = await database;
    return await db.insert('templates', template);
  }

  Future<List<Map<String, dynamic>>> getTemplates() async {
    final db = await database;
    return await db.query('templates', orderBy: 'name ASC');
  }

  Future<Map<String, dynamic>?> getTemplate(int id) async {
    final db = await database;
    final results = await db.query(
      'templates',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateTemplate(int id, Map<String, dynamic> template) async {
    final db = await database;
    return await db.update(
      'templates',
      template,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTemplate(int id) async {
    final db = await database;
    return await db.delete('templates', where: 'id = ?', whereArgs: [id]);
  }

  // Advanced queries
  Future<List<Map<String, dynamic>>> getStudentsWithSchoolInfo() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        s.*,
        sc.name_arabic as school_name_arabic,
        sc.name_english as school_name_english,
        sc.logo_path as school_logo_path
      FROM students s
      LEFT JOIN schools sc ON s.school_id = sc.id
      ORDER BY s.name ASC
    ''');
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;

    final schoolCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM schools'),
        ) ??
        0;

    final studentCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM students'),
        ) ??
        0;

    final templateCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM templates'),
        ) ??
        0;

    final exportCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM export_records'),
        ) ??
        0;

    return {
      'schools': schoolCount,
      'students': studentCount,
      'templates': templateCount,
      'exports': exportCount,
    };
  }

  // Settings operations
  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
    await db.execute(
      'INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)',
      [key, value],
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final results = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return results.first['value'] as String?;
    }
    return null;
  }

  Future<void> deleteSetting(String key) async {
    final db = await database;
    await db.delete('settings', where: 'key = ?', whereArgs: [key]);
  }

  Future<void> close() async {
    await _databaseHelper.close();
  }
}
