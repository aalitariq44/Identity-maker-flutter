import 'package:flutter/foundation.dart';
import 'database_provider.dart';
import 'web_database_provider.dart';

class PlatformDatabaseProvider {
  static final PlatformDatabaseProvider _instance =
      PlatformDatabaseProvider._internal();
  factory PlatformDatabaseProvider() => _instance;
  PlatformDatabaseProvider._internal() {
    if (kIsWeb) {
      _provider = WebDatabaseProvider();
    } else {
      _provider = DatabaseProvider();
    }
  }

  late final dynamic _provider;

  // Schools operations
  Future<int> insertSchool(Map<String, dynamic> school) =>
      _provider.insertSchool(school);
  Future<List<Map<String, dynamic>>> getSchools() => _provider.getSchools();
  Future<Map<String, dynamic>?> getSchool(int id) => _provider.getSchool(id);
  Future<int> updateSchool(int id, Map<String, dynamic> school) =>
      _provider.updateSchool(id, school);
  Future<int> deleteSchool(int id) => _provider.deleteSchool(id);

  // Students operations
  Future<int> insertStudent(Map<String, dynamic> student) =>
      _provider.insertStudent(student);
  Future<List<Map<String, dynamic>>> getStudents() => _provider.getStudents();
  Future<Map<String, dynamic>?> getStudent(int id) async {
    final students = await getStudents();
    try {
      return students.firstWhere((student) => student['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsWithSchoolInfo() =>
      _provider.getStudentsWithSchoolInfo();
  Future<List<Map<String, dynamic>>> getStudentsBySchool(int schoolId) =>
      _provider.getStudentsBySchool(schoolId);
  Future<int> updateStudent(int id, Map<String, dynamic> student) =>
      _provider.updateStudent(id, student);
  Future<int> deleteStudent(int id) => _provider.deleteStudent(id);

  // Settings operations
  Future<void> saveSetting(String key, String value) =>
      _provider.saveSetting(key, value);
  Future<String?> getSetting(String key) => _provider.getSetting(key);
  Future<void> deleteSetting(String key) => _provider.deleteSetting(key);
}
