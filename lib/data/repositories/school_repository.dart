import 'package:sqflite/sqflite.dart';
import '../models/school.dart';
import '../../core/database/database_helper.dart';
import '../../core/constants/app_constants.dart';

class SchoolRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<School>> getAllSchools() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.schoolsTable,
      orderBy: 'name_arabic ASC',
    );

    return List.generate(maps.length, (i) {
      return School.fromMap(maps[i]);
    });
  }

  Future<School?> getSchoolById(int id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.schoolsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return School.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertSchool(School school) async {
    final db = await _databaseHelper.database;
    final now = DateTime.now();

    final schoolData = school.copyWith(createdAt: now, updatedAt: now).toMap();

    // Remove id field for insertion
    schoolData.remove('id');

    return await db.insert(AppConstants.schoolsTable, schoolData);
  }

  Future<int> updateSchool(School school) async {
    final db = await _databaseHelper.database;
    final schoolData = school.copyWith(updatedAt: DateTime.now()).toMap();

    return await db.update(
      AppConstants.schoolsTable,
      schoolData,
      where: 'id = ?',
      whereArgs: [school.id],
    );
  }

  Future<int> deleteSchool(int id) async {
    final db = await _databaseHelper.database;

    // Check if school has students
    final studentCount = await getStudentCountBySchool(id);
    if (studentCount > 0) {
      throw Exception('Cannot delete school with existing students');
    }

    return await db.delete(
      AppConstants.schoolsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getStudentCountBySchool(int schoolId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.studentsTable} WHERE school_id = ?',
      [schoolId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<School>> searchSchools(String query) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      AppConstants.schoolsTable,
      where: 'name_arabic LIKE ? OR name_english LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name_arabic ASC',
    );

    return List.generate(maps.length, (i) {
      return School.fromMap(maps[i]);
    });
  }
}
