import 'package:fluent_ui/fluent_ui.dart';
import '../../data/models/school.dart';
import '../../core/database/database_provider.dart';

class SchoolProvider extends ChangeNotifier {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  List<School> _schools = [];
  School? _selectedSchool;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<School> get schools => _schools;
  School? get selectedSchool => _selectedSchool;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all schools
  Future<void> loadSchools() async {
    try {
      _setLoading(true);
      final schoolMaps = await _databaseProvider.getSchools();
      _schools = schoolMaps.map((map) => School.fromMap(map)).toList();
      _clearError();
    } catch (e) {
      _setError('خطأ في تحميل المدارس: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Add new school
  Future<bool> addSchool(School school) async {
    try {
      _setLoading(true);
      final now = DateTime.now();
      final schoolToAdd = school.copyWith(createdAt: now, updatedAt: now);

      final id = await _databaseProvider.insertSchool(schoolToAdd.toMap());
      final newSchool = schoolToAdd.copyWith(id: id);

      _schools.add(newSchool);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في إضافة المدرسة: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update school
  Future<bool> updateSchool(School school) async {
    try {
      _setLoading(true);
      final updatedSchool = school.copyWith(updatedAt: DateTime.now());

      await _databaseProvider.updateSchool(school.id!, updatedSchool.toMap());

      final index = _schools.indexWhere((s) => s.id == school.id);
      if (index != -1) {
        _schools[index] = updatedSchool;
      }

      if (_selectedSchool?.id == school.id) {
        _selectedSchool = updatedSchool;
      }

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في تحديث المدرسة: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete school
  Future<bool> deleteSchool(int schoolId) async {
    try {
      _setLoading(true);
      await _databaseProvider.deleteSchool(schoolId);

      _schools.removeWhere((school) => school.id == schoolId);

      if (_selectedSchool?.id == schoolId) {
        _selectedSchool = null;
      }

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في حذف المدرسة: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get school by id
  Future<School?> getSchoolById(int id) async {
    try {
      final schoolMap = await _databaseProvider.getSchool(id);
      if (schoolMap != null) {
        return School.fromMap(schoolMap);
      }
      return null;
    } catch (e) {
      _setError('خطأ في تحميل المدرسة: ${e.toString()}');
      return null;
    }
  }

  // Select school
  void selectSchool(School? school) {
    _selectedSchool = school;
    notifyListeners();
  }

  // Search schools
  List<School> searchSchools(String query) {
    if (query.isEmpty) return _schools;

    return _schools.where((school) {
      return school.nameArabic.toLowerCase().contains(query.toLowerCase()) ||
          school.nameEnglish.toLowerCase().contains(query.toLowerCase()) ||
          school.address.toLowerCase().contains(query.toLowerCase());
    }).toList();
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

  // Clear all data (for logout or reset)
  void clear() {
    _schools.clear();
    _selectedSchool = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
