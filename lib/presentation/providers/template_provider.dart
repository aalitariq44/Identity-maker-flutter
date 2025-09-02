import 'package:fluent_ui/fluent_ui.dart';
import '../../data/models/template.dart';

class TemplateProvider extends ChangeNotifier {
  List<Template> _templates = [];
  Template? _selectedTemplate;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Template> get templates => _templates;
  Template? get selectedTemplate => _selectedTemplate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load templates (placeholder - will implement JSON loading later)
  Future<void> loadTemplates() async {
    try {
      _setLoading(true);
      // TODO: Implement template loading from JSON files
      _templates = _createDefaultTemplates();
      _clearError();
    } catch (e) {
      _setError('خطأ في تحميل القوالب: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Create default templates
  List<Template> _createDefaultTemplates() {
    final now = DateTime.now();
    return [
      Template(
        id: 1,
        name: 'قالب أفقي كلاسيكي',
        width: 8.5,
        height: 5.4,
        orientation: 'horizontal',
        elements: [],
        backgroundProperties: {'color': '#FFFFFF'},
        createdAt: now,
        updatedAt: now,
      ),
      Template(
        id: 2,
        name: 'قالب عمودي حديث',
        width: 5.4,
        height: 8.5,
        orientation: 'vertical',
        elements: [],
        backgroundProperties: {'color': '#F8F9FA'},
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  // Select template
  void selectTemplate(Template? template) {
    _selectedTemplate = template;
    notifyListeners();
  }

  // Add new template
  Future<bool> addTemplate(Template template) async {
    try {
      _setLoading(true);
      final now = DateTime.now();
      final templateToAdd = template.copyWith(
        id: _getNextId(),
        createdAt: now,
        updatedAt: now,
      );

      _templates.add(templateToAdd);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في إضافة القالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update template
  Future<bool> updateTemplate(Template template) async {
    try {
      _setLoading(true);
      final updatedTemplate = template.copyWith(updatedAt: DateTime.now());

      final index = _templates.indexWhere((t) => t.id == template.id);
      if (index != -1) {
        _templates[index] = updatedTemplate;
      }

      if (_selectedTemplate?.id == template.id) {
        _selectedTemplate = updatedTemplate;
      }

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في تحديث القالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete template
  Future<bool> deleteTemplate(int templateId) async {
    try {
      _setLoading(true);
      _templates.removeWhere((template) => template.id == templateId);

      if (_selectedTemplate?.id == templateId) {
        _selectedTemplate = null;
      }

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في حذف القالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search templates
  List<Template> searchTemplates(String query) {
    if (query.isEmpty) return _templates;

    return _templates.where((template) {
      return template.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter by orientation
  List<Template> filterByOrientation(String orientation) {
    return _templates.where((t) => t.orientation == orientation).toList();
  }

  // Get next available ID
  int _getNextId() {
    if (_templates.isEmpty) return 1;
    return _templates.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
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
    _templates.clear();
    _selectedTemplate = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
