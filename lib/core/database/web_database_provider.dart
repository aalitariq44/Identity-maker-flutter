import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WebDatabaseProvider {
  static final WebDatabaseProvider _instance = WebDatabaseProvider._internal();
  factory WebDatabaseProvider() => _instance;
  WebDatabaseProvider._internal();

  // Schools CRUD operations
  Future<int> insertSchool(Map<String, dynamic> school) async {
    final prefs = await SharedPreferences.getInstance();
    final schools = await getSchools();
    
    // Generate new ID
    int newId = 1;
    if (schools.isNotEmpty) {
      newId = schools.map((s) => s['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
    }
    
    school['id'] = newId;
    schools.add(school);
    
    await prefs.setString('schools', jsonEncode(schools));
    return newId;
  }

  Future<List<Map<String, dynamic>>> getSchools() async {
    final prefs = await SharedPreferences.getInstance();
    final schoolsJson = prefs.getString('schools');
    if (schoolsJson == null) return [];
    
    final List<dynamic> schoolsList = jsonDecode(schoolsJson);
    return schoolsList.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getSchool(int id) async {
    final schools = await getSchools();
    try {
      return schools.firstWhere((school) => school['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateSchool(int id, Map<String, dynamic> school) async {
    final prefs = await SharedPreferences.getInstance();
    final schools = await getSchools();
    
    final index = schools.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      school['id'] = id;
      schools[index] = school;
      await prefs.setString('schools', jsonEncode(schools));
      return 1;
    }
    return 0;
  }

  Future<int> deleteSchool(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final schools = await getSchools();
    
    schools.removeWhere((school) => school['id'] == id);
    await prefs.setString('schools', jsonEncode(schools));
    return 1;
  }

  // Students CRUD operations
  Future<int> insertStudent(Map<String, dynamic> student) async {
    final prefs = await SharedPreferences.getInstance();
    final students = await getStudents();
    
    // Generate new ID
    int newId = 1;
    if (students.isNotEmpty) {
      newId = students.map((s) => s['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
    }
    
    student['id'] = newId;
    students.add(student);
    
    await prefs.setString('students', jsonEncode(students));
    return newId;
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final studentsJson = prefs.getString('students');
    if (studentsJson == null) return [];
    
    final List<dynamic> studentsList = jsonDecode(studentsJson);
    return studentsList.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getStudentsWithSchoolInfo() async {
    final students = await getStudents();
    final schools = await getSchools();
    
    return students.map((student) {
      final school = schools.firstWhere(
        (s) => s['id'] == student['school_id'],
        orElse: () => {'name_arabic': 'غير محدد', 'name_english': 'Unknown'},
      );
      return {
        ...student,
        'school_name_arabic': school['name_arabic'],
        'school_name_english': school['name_english'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getStudentsBySchool(int schoolId) async {
    final students = await getStudents();
    return students.where((student) => student['school_id'] == schoolId).toList();
  }

  Future<int> updateStudent(int id, Map<String, dynamic> student) async {
    final prefs = await SharedPreferences.getInstance();
    final students = await getStudents();
    
    final index = students.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      student['id'] = id;
      students[index] = student;
      await prefs.setString('students', jsonEncode(students));
      return 1;
    }
    return 0;
  }

  Future<int> deleteStudent(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final students = await getStudents();
    
    students.removeWhere((student) => student['id'] == id);
    await prefs.setString('students', jsonEncode(students));
    return 1;
  }

  // Settings operations
  Future<void> saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setting_$key', value);
  }

  Future<String?> getSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('setting_$key');
  }

  Future<void> deleteSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('setting_$key');
  }
}
