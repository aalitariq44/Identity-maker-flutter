import 'package:fluent_ui/fluent_ui.dart';
import '../../data/models/template.dart';
import '../../core/services/template_service.dart';

class TemplateProvider extends ChangeNotifier {
  final TemplateService _templateService = TemplateService();

  List<Template> _templates = [];
  Template? _selectedTemplate;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Template> get templates => _templates;
  Template? get selectedTemplate => _selectedTemplate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load templates using service
  Future<void> loadTemplates() async {
    try {
      _setLoading(true);
      _templates = await _templateService.loadTemplates();
      _clearError();
    } catch (e) {
      _setError('خطأ في تحميل القوالب: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
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
      final success = await _templateService.saveTemplate(template);

      if (success) {
        // Reload templates to get the updated list with IDs
        await loadTemplates();
        _clearError();
        return true;
      } else {
        _setError('فشل في حفظ القالب');
        return false;
      }
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
      final success = await _templateService.saveTemplate(updatedTemplate);

      if (success) {
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
      } else {
        _setError('فشل في تحديث القالب');
        return false;
      }
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
      final success = await _templateService.deleteTemplate(templateId);

      if (success) {
        _templates.removeWhere((template) => template.id == templateId);

        if (_selectedTemplate?.id == templateId) {
          _selectedTemplate = null;
        }

        _clearError();
        notifyListeners();
        return true;
      } else {
        _setError('فشل في حذف القالب');
        return false;
      }
    } catch (e) {
      _setError('خطأ في حذف القالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search templates
  List<Template> searchTemplates(String query) {
    return _templateService.searchTemplates(_templates, query);
  }

  // Filter by orientation
  List<Template> filterByOrientation(String orientation) {
    return _templateService.filterByOrientation(_templates, orientation);
  }

  // Export template
  Future<bool> exportTemplate(Template template, String filePath) async {
    try {
      return await _templateService.exportTemplate(template, filePath);
    } catch (e) {
      _setError('خطأ في تصدير القالب: ${e.toString()}');
      return false;
    }
  }

  // Import template
  Future<bool> importTemplate(String filePath) async {
    try {
      _setLoading(true);
      final template = await _templateService.importTemplate(filePath);

      if (template != null) {
        final success = await _templateService.saveTemplate(template);
        if (success) {
          await loadTemplates();
          _clearError();
          return true;
        }
      }

      _setError('فشل في استيراد القالب');
      return false;
    } catch (e) {
      _setError('خطأ في استيراد القالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clone template
  Future<bool> cloneTemplate(Template template, {String? newName}) async {
    try {
      _setLoading(true);
      final clonedTemplate = _templateService.cloneTemplate(
        template,
        newName: newName,
      );
      return await addTemplate(clonedTemplate);
    } catch (e) {
      _setError('خطأ في نسخ القالب: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Validate template
  bool validateTemplate(Template template) {
    return _templateService.validateTemplate(template);
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
