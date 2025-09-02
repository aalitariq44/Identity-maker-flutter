import 'package:sqflite/sqflite.dart';
import '../models/student.dart';
import '../../core/database/database_helper.dart';
import '../../core/constants/app_constants.dart';

class StudentRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Student>> getAllStudents() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.studentsTable,
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<List<Student>> getStudentsBySchool(int schoolId) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.studentsTable,
      where: 'school_id = ?',
      whereArgs: [schoolId],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<Student?> getStudentById(int id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.studentsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Student.fromMap(maps.first);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getStudentWithSchool(int id) async {
    final db = await _databaseHelper.database;
    final maps = await db.rawQuery(
      '''
      SELECT s.*, 
             sc.name_arabic as school_name_arabic,
             sc.name_english as school_name_english
      FROM ${AppConstants.studentsTable} s
      JOIN ${AppConstants.schoolsTable} sc ON s.school_id = sc.id
      WHERE s.id = ?
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllStudentsWithSchools() async {
    final db = await _databaseHelper.database;
    return await db.rawQuery('''
      SELECT s.*, 
             sc.name_arabic as school_name_arabic,
             sc.name_english as school_name_english
      FROM ${AppConstants.studentsTable} s
      JOIN ${AppConstants.schoolsTable} sc ON s.school_id = sc.id
      ORDER BY s.name ASC
    ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await _databaseHelper.database;
    final now = DateTime.now();

    final studentData = student
        .copyWith(createdAt: now, updatedAt: now)
        .toMap();

    // Remove id field for insertion
    studentData.remove('id');

    return await db.insert(AppConstants.studentsTable, studentData);
  }

  Future<int> updateStudent(Student student) async {
    final db = await _databaseHelper.database;
    final studentData = student.copyWith(updatedAt: DateTime.now()).toMap();

    return await db.update(
      AppConstants.studentsTable,
      studentData,
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      AppConstants.studentsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Student>> searchStudents(String query) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.studentsTable,
      where: 'name LIKE ? OR grade LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> searchStudentsWithSchools(
    String query,
  ) async {
    final db = await _databaseHelper.database;
    return await db.rawQuery(
      '''
      SELECT s.*, 
             sc.name_arabic as school_name_arabic,
             sc.name_english as school_name_english
      FROM ${AppConstants.studentsTable} s
      JOIN ${AppConstants.schoolsTable} sc ON s.school_id = sc.id
      WHERE s.name LIKE ? OR s.grade LIKE ? OR sc.name_arabic LIKE ? OR sc.name_english LIKE ?
      ORDER BY s.name ASC
    ''',
      ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
  }

  Future<int> getStudentCount() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.studentsTable}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getStudentCountBySchool(int schoolId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.studentsTable} WHERE school_id = ?',
      [schoolId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
