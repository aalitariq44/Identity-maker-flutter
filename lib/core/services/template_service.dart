import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/template.dart';

class TemplateService {
  static const String _templatesFileName = 'templates.json';
  static const String _defaultTemplatesPath = 'assets/templates/';

  // Get templates directory
  Future<Directory?> _getTemplatesDirectory() async {
    if (kIsWeb) {
      // في الويب، لا يوجد دليل محلي، أعد null
      return null;
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      final templatesDir = Directory('${appDir.path}/templates');
      if (!await templatesDir.exists()) {
        await templatesDir.create(recursive: true);
      }
      return templatesDir;
    }
  }

  // Load templates from file
  Future<List<Template>> loadTemplates() async {
    try {
      final templatesDir = await _getTemplatesDirectory();
      if (templatesDir != null) {
        final templatesFile = File('${templatesDir.path}/$_templatesFileName');

        if (await templatesFile.exists()) {
          // Load from user templates file
          final content = await templatesFile.readAsString();
          final List<dynamic> jsonList = json.decode(content);
          return jsonList.map((json) => Template.fromJson(json)).toList();
        }
      }
      // Load default templates
      return await _loadDefaultTemplates();
    } catch (e) {
      print('Error loading templates: $e');
      return await _loadDefaultTemplates();
    }
  }

  // Load default templates from assets
  Future<List<Template>> _loadDefaultTemplates() async {
    try {
      final templates = <Template>[];

      // Load horizontal template
      try {
        final horizontalContent = await rootBundle.loadString(
          '${_defaultTemplatesPath}default_horizontal.json',
        );
        final horizontalJson = json.decode(horizontalContent);
        templates.add(Template.fromJson(horizontalJson));
      } catch (e) {
        print('Error loading horizontal template: $e');
      }

      // Load vertical template
      try {
        final verticalContent = await rootBundle.loadString(
          '${_defaultTemplatesPath}default_vertical.json',
        );
        final verticalJson = json.decode(verticalContent);
        templates.add(Template.fromJson(verticalJson));
      } catch (e) {
        print('Error loading vertical template: $e');
      }

      // If no templates loaded, create a basic one
      if (templates.isEmpty) {
        templates.add(_createBasicTemplate());
      }

      return templates;
    } catch (e) {
      print('Error loading default templates: $e');
      return [_createBasicTemplate()];
    }
  }

  // Create a basic template if none exist
  Template _createBasicTemplate() {
    return Template(
      id: 1,
      name: 'قالب أساسي',
      width: 8.56,
      height: 5.398,
      orientation: 'horizontal',
      elements: [
        TemplateElement(
          id: 'school_name',
          type: 'text',
          x: 1.0,
          y: 0.5,
          width: 6.0,
          height: 1.0,
          properties: {
            'text': '{school_name_arabic}',
            'fontSize': 16,
            'fontFamily': 'NotoSansArabic',
            'fontWeight': 'bold',
            'color': '#000000',
            'textAlign': 'center',
          },
          zIndex: 1,
        ),
        TemplateElement(
          id: 'student_name',
          type: 'text',
          x: 2.5,
          y: 2.0,
          width: 4.0,
          height: 0.8,
          properties: {
            'text': 'الاسم: {student_name}',
            'fontSize': 14,
            'fontFamily': 'NotoSansArabic',
            'fontWeight': 'bold',
            'color': '#000000',
            'textAlign': 'right',
          },
          zIndex: 2,
        ),
        TemplateElement(
          id: 'student_photo',
          type: 'image',
          x: 0.5,
          y: 2.0,
          width: 1.5,
          height: 2.0,
          properties: {
            'source': 'student_photo',
            'fit': 'cover',
            'borderRadius': 8,
          },
          zIndex: 1,
        ),
      ],
      backgroundProperties: {'color': '#FFFFFF'},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Save templates to file
  Future<bool> saveTemplates(List<Template> templates) async {
    try {
      final templatesDir = await _getTemplatesDirectory();
      if (templatesDir == null) {
        // في الويب، لا نحفظ محليًا
        return true;
      }
      final templatesFile = File('${templatesDir.path}/$_templatesFileName');

      final jsonList = templates.map((template) => template.toJson()).toList();
      final content = json.encode(jsonList);

      await templatesFile.writeAsString(content);
      return true;
    } catch (e) {
      print('Error saving templates: $e');
      return false;
    }
  }

  // Save single template
  Future<bool> saveTemplate(Template template) async {
    try {
      final templates = await loadTemplates();

      // Find existing template or add new one
      final index = templates.indexWhere((t) => t.id == template.id);
      if (index != -1) {
        templates[index] = template;
      } else {
        // Assign new ID if needed
        if (template.id == null) {
          final maxId = templates.isNotEmpty
              ? templates.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b)
              : 0;
          final newTemplate = template.copyWith(id: maxId + 1);
          templates.add(newTemplate);
        } else {
          templates.add(template);
        }
      }

      return await saveTemplates(templates);
    } catch (e) {
      print('Error saving template: $e');
      return false;
    }
  }

  // Delete template
  Future<bool> deleteTemplate(int templateId) async {
    try {
      final templates = await loadTemplates();
      templates.removeWhere((template) => template.id == templateId);
      return await saveTemplates(templates);
    } catch (e) {
      print('Error deleting template: $e');
      return false;
    }
  }

  // Export template to JSON file
  Future<bool> exportTemplate(Template template, String filePath) async {
    if (kIsWeb) {
      // في الويب، لا يمكن التصدير إلى ملف
      return false;
    }
    try {
      final file = File(filePath);
      final jsonContent = json.encode(template.toJson());
      await file.writeAsString(jsonContent);
      return true;
    } catch (e) {
      print('Error exporting template: $e');
      return false;
    }
  }

  // Import template from JSON file
  Future<Template?> importTemplate(String filePath) async {
    if (kIsWeb) {
      // في الويب، لا يمكن الاستيراد من ملف
      return null;
    }
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      final jsonData = json.decode(content);
      return Template.fromJson(jsonData);
    } catch (e) {
      print('Error importing template: $e');
      return null;
    }
  }

  // Get next available template ID
  Future<int> getNextTemplateId() async {
    try {
      final templates = await loadTemplates();
      if (templates.isEmpty) return 1;

      final maxId = templates
          .map((t) => t.id ?? 0)
          .reduce((a, b) => a > b ? a : b);
      return maxId + 1;
    } catch (e) {
      return 1;
    }
  }

  // Search templates
  List<Template> searchTemplates(List<Template> templates, String query) {
    if (query.isEmpty) return templates;

    final lowerQuery = query.toLowerCase();
    return templates.where((template) {
      return template.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter templates by orientation
  List<Template> filterByOrientation(
    List<Template> templates,
    String orientation,
  ) {
    if (orientation.isEmpty) return templates;
    return templates
        .where((template) => template.orientation == orientation)
        .toList();
  }

  // Validate template
  bool validateTemplate(Template template) {
    // Check required fields
    if (template.name.trim().isEmpty) return false;
    if (template.width <= 0 || template.height <= 0) return false;
    if (!['horizontal', 'vertical'].contains(template.orientation))
      return false;

    // Validate elements
    for (final element in template.elements) {
      if (element.id.trim().isEmpty) return false;
      if (!['text', 'image', 'shape'].contains(element.type)) return false;
      if (element.x < 0 || element.y < 0) return false;
      if (element.width <= 0 || element.height <= 0) return false;
      if (element.x + element.width > template.width) return false;
      if (element.y + element.height > template.height) return false;
    }

    return true;
  }

  // Create template from existing template (clone)
  Template cloneTemplate(Template original, {String? newName}) {
    return original.copyWith(
      id: null, // Will be assigned when saved
      name: newName ?? '${original.name} - نسخة',
      elements: original.elements.map((element) => element.copyWith()).toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
