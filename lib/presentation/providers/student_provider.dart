import 'package:fluent_ui/fluent_ui.dart';
import '../../data/models/student.dart';
import '../../data/models/school.dart';
import '../../core/database/database_provider.dart';

class StudentProvider extends ChangeNotifier {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  List<Student> _students = [];
  List<Student> _selectedStudents = [];
  Student? _selectedStudent;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Student> get students => _students;
  List<Student> get selectedStudents => _selectedStudents;
  Student? get selectedStudent => _selectedStudent;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasSelectedStudents => _selectedStudents.isNotEmpty;

  // Load all students
  Future<void> loadStudents() async {
    try {
      _setLoading(true);
      final studentMaps = await _databaseProvider.getStudents();
      _students = studentMaps.map((map) => Student.fromMap(map)).toList();
      _clearError();
    } catch (e) {
      _setError('خطأ في تحميل الطلاب: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load students with school info
  Future<void> loadStudentsWithSchoolInfo() async {
    try {
      _setLoading(true);
      final studentMaps = await _databaseProvider.getStudentsWithSchoolInfo();
      _students = studentMaps.map((map) => Student.fromMap(map)).toList();
      _clearError();
    } catch (e) {
      _setError('خطأ في تحميل الطلاب: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load students by school
  Future<void> loadStudentsBySchool(int schoolId) async {
    try {
      _setLoading(true);
      final studentMaps = await _databaseProvider.getStudentsBySchool(schoolId);
      _students = studentMaps.map((map) => Student.fromMap(map)).toList();
      _clearError();
    } catch (e) {
      _setError('خطأ في تحميل طلاب المدرسة: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Add new student
  Future<bool> addStudent(Student student) async {
    try {
      _setLoading(true);
      final now = DateTime.now();
      final studentToAdd = student.copyWith(createdAt: now, updatedAt: now);

      final id = await _databaseProvider.insertStudent(studentToAdd.toMap());
      final newStudent = studentToAdd.copyWith(id: id);

      _students.add(newStudent);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في إضافة الطالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update student
  Future<bool> updateStudent(Student student) async {
    try {
      _setLoading(true);
      final updatedStudent = student.copyWith(updatedAt: DateTime.now());

      await _databaseProvider.updateStudent(
        student.id!,
        updatedStudent.toMap(),
      );

      final index = _students.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        _students[index] = updatedStudent;
      }

      if (_selectedStudent?.id == student.id) {
        _selectedStudent = updatedStudent;
      }

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في تحديث الطالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete student
  Future<bool> deleteStudent(int studentId) async {
    try {
      _setLoading(true);
      await _databaseProvider.deleteStudent(studentId);

      _students.removeWhere((student) => student.id == studentId);
      _selectedStudents.removeWhere((student) => student.id == studentId);

      if (_selectedStudent?.id == studentId) {
        _selectedStudent = null;
      }

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في حذف الطالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get student by id
  Future<Student?> getStudentById(int id) async {
    try {
      final studentMap = await _databaseProvider.getStudent(id);
      if (studentMap != null) {
        return Student.fromMap(studentMap);
      }
      return null;
    } catch (e) {
      _setError('خطأ في تحميل الطالب: ${e.toString()}');
      return null;
    }
  }

  // Select single student
  void selectStudent(Student? student) {
    _selectedStudent = student;
    notifyListeners();
  }

  // Multi-selection methods
  void toggleStudentSelection(Student student) {
    if (_selectedStudents.any((s) => s.id == student.id)) {
      _selectedStudents.removeWhere((s) => s.id == student.id);
    } else {
      _selectedStudents.add(student);
    }
    notifyListeners();
  }

  void selectAllStudents() {
    _selectedStudents = List.from(_students);
    notifyListeners();
  }

  void clearSelection() {
    _selectedStudents.clear();
    notifyListeners();
  }

  bool isStudentSelected(Student student) {
    return _selectedStudents.any((s) => s.id == student.id);
  }

  // Search students
  List<Student> searchStudents(String query) {
    if (query.isEmpty) return _students;

    return _students.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase()) ||
          student.grade.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter students by school
  List<Student> filterBySchool(int schoolId) {
    return _students.where((student) => student.schoolId == schoolId).toList();
  }

  // Filter students by grade
  List<Student> filterByGrade(String grade) {
    return _students.where((student) => student.grade == grade).toList();
  }

  // Get unique grades
  List<String> getUniqueGrades() {
    final grades = _students.map((student) => student.grade).toSet().toList();
    grades.sort();
    return grades;
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data
  void clear() {
    _students.clear();
    _selectedStudents.clear();
    _selectedStudent = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
