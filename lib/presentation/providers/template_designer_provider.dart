import 'package:fluent_ui/fluent_ui.dart';
import 'dart:math' as math;
import '../../data/models/template.dart';

class TemplateDesignerProvider extends ChangeNotifier {
  // Template properties
  late TextEditingController templateNameController;
  double _templateWidth = 8.56; // Default credit card size
  double _templateHeight = 5.398;
  String _templateOrientation = 'horizontal';
  Map<String, dynamic> _backgroundProperties = {
    'color': '#FFFFFF',
    'image': null,
    'opacity': 1.0,
  };

  // Elements
  List<TemplateElement> _elements = [];
  TemplateElement? _selectedElement;
  bool _isBackgroundSelected = false;

  // Canvas properties
  double _canvasZoom = 1.0;
  Offset _canvasOffset = Offset.zero;

  // History for undo/redo
  List<List<TemplateElement>> _history = [];
  int _historyIndex = -1;
  final int _maxHistorySize = 50;

  // Getters
  double get templateWidth => _templateWidth;
  double get templateHeight => _templateHeight;
  String get templateOrientation => _templateOrientation;
  Map<String, dynamic> get backgroundProperties => _backgroundProperties;
  List<TemplateElement> get elements => _elements;
  TemplateElement? get selectedElement => _selectedElement;
  bool get isBackgroundSelected => _isBackgroundSelected;
  double get canvasZoom => _canvasZoom;
  Offset get canvasOffset => _canvasOffset;
  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  TemplateDesignerProvider() {
    templateNameController = TextEditingController(text: 'قالب جديد');
    _saveToHistory();
  }

  @override
  void dispose() {
    templateNameController.dispose();
    super.dispose();
  }

  // Template methods
  void updateTemplateName(String name) {
    templateNameController.text = name;
    notifyListeners();
  }

  void updateTemplateDimensions({double? width, double? height}) {
    if (width != null && width > 0) _templateWidth = width;
    if (height != null && height > 0) _templateHeight = height;

    // Auto-update orientation based on dimensions
    _templateOrientation = _templateWidth > _templateHeight
        ? 'horizontal'
        : 'vertical';

    notifyListeners();
  }

  void updateTemplateOrientation(String orientation) {
    if (orientation != _templateOrientation) {
      _templateOrientation = orientation;

      // Swap dimensions if needed
      if ((orientation == 'horizontal' && _templateWidth < _templateHeight) ||
          (orientation == 'vertical' && _templateWidth > _templateHeight)) {
        final temp = _templateWidth;
        _templateWidth = _templateHeight;
        _templateHeight = temp;
      }

      notifyListeners();
    }
  }

  void updateBackgroundProperties(Map<String, dynamic> properties) {
    _backgroundProperties = Map.from(properties);
    notifyListeners();
  }

  // Element methods
  void addElement(TemplateElement element) {
    _elements.add(element);
    _selectedElement = element;
    _saveToHistory();
    notifyListeners();
  }

  void selectElement(TemplateElement? element) {
    _selectedElement = element;
    _isBackgroundSelected = false; // إلغاء تحديد الخلفية عند تحديد عنصر
    notifyListeners();
  }

  void selectBackground(bool selected) {
    _isBackgroundSelected = selected;
    if (selected) {
      _selectedElement = null; // إلغاء تحديد العنصر عند تحديد الخلفية
    }
    notifyListeners();
  }

  void updateSelectedElement(TemplateElement updatedElement) {
    if (_selectedElement != null) {
      final index = _elements.indexWhere((e) => e.id == _selectedElement!.id);
      if (index != -1) {
        _elements[index] = updatedElement;
        _selectedElement = updatedElement;
        _saveToHistory();
        notifyListeners();
      }
    }
  }

  void deleteSelectedElement() {
    if (_selectedElement != null) {
      _elements.removeWhere((e) => e.id == _selectedElement!.id);
      _selectedElement = null;
      _saveToHistory();
      notifyListeners();
    }
  }

  void deleteElement(String elementId) {
    _elements.removeWhere((e) => e.id == elementId);
    if (_selectedElement?.id == elementId) {
      _selectedElement = null;
    }
    _saveToHistory();
    notifyListeners();
  }

  void moveElement(String elementId, double deltaX, double deltaY) {
    final index = _elements.indexWhere((e) => e.id == elementId);
    if (index != -1) {
      final element = _elements[index];
      final newX = math.max(
        0.0,
        math.min(_templateWidth - element.width, element.x + deltaX),
      );
      final newY = math.max(
        0.0,
        math.min(_templateHeight - element.height, element.y + deltaY),
      );

      _elements[index] = element.copyWith(x: newX, y: newY);

      if (_selectedElement?.id == elementId) {
        _selectedElement = _elements[index];
      }

      notifyListeners();
    }
  }

  void resizeElement(String elementId, double newWidth, double newHeight) {
    final index = _elements.indexWhere((e) => e.id == elementId);
    if (index != -1) {
      final element = _elements[index];
      final clampedWidth = math.max(
        0.1,
        math.min(_templateWidth - element.x, newWidth),
      );
      final clampedHeight = math.max(
        0.1,
        math.min(_templateHeight - element.y, newHeight),
      );

      _elements[index] = element.copyWith(
        width: clampedWidth,
        height: clampedHeight,
      );

      if (_selectedElement?.id == elementId) {
        _selectedElement = _elements[index];
      }

      notifyListeners();
    }
  }

  void updateElementZIndex(String elementId, int newZIndex) {
    final index = _elements.indexWhere((e) => e.id == elementId);
    if (index != -1) {
      _elements[index] = _elements[index].copyWith(zIndex: newZIndex);

      if (_selectedElement?.id == elementId) {
        _selectedElement = _elements[index];
      }

      // Sort elements by zIndex
      _elements.sort((a, b) => a.zIndex.compareTo(b.zIndex));
      _saveToHistory();
      notifyListeners();
    }
  }

  void bringToFront(String elementId) {
    final maxZ = _elements.isNotEmpty
        ? _elements.map((e) => e.zIndex).reduce(math.max)
        : 0;
    updateElementZIndex(elementId, maxZ + 1);
  }

  void sendToBack(String elementId) {
    final minZ = _elements.isNotEmpty
        ? _elements.map((e) => e.zIndex).reduce(math.min)
        : 0;
    updateElementZIndex(elementId, minZ - 1);
  }

  void duplicateElement(String elementId) {
    final element = _elements.firstWhere((e) => e.id == elementId);
    final duplicatedElement = element.copyWith(
      id: '${element.id}_copy_${DateTime.now().millisecondsSinceEpoch}',
      x: element.x + 0.5,
      y: element.y + 0.5,
    );
    addElement(duplicatedElement);
  }

  // Canvas methods
  void setCanvasZoom(double zoom) {
    _canvasZoom = math.max(0.1, math.min(5.0, zoom));
    notifyListeners();
  }

  void setCanvasOffset(Offset offset) {
    _canvasOffset = offset;
    notifyListeners();
  }

  void resetCanvasView() {
    _canvasZoom = 1.0;
    _canvasOffset = Offset.zero;
    notifyListeners();
  }

  // History methods
  void _saveToHistory() {
    // Remove any history after current index
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    // Add current state
    _history.add(_elements.map((e) => e.copyWith()).toList());
    _historyIndex++;

    // Limit history size
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
      _historyIndex--;
    }
  }

  void undo() {
    if (canUndo) {
      _historyIndex--;
      _elements = _history[_historyIndex].map((e) => e.copyWith()).toList();
      _selectedElement = null;
      notifyListeners();
    }
  }

  void redo() {
    if (canRedo) {
      _historyIndex++;
      _elements = _history[_historyIndex].map((e) => e.copyWith()).toList();
      _selectedElement = null;
      notifyListeners();
    }
  }

  // Template loading and building
  void loadTemplate(Template? template) {
    if (template != null) {
      templateNameController.text = template.name;
      _templateWidth = template.width;
      _templateHeight = template.height;
      _templateOrientation = template.orientation;
      _backgroundProperties = Map.from(template.backgroundProperties);
      _elements = template.elements.map((e) => e.copyWith()).toList();
      _selectedElement = null;
      _saveToHistory();
      notifyListeners();
    }
  }

  Template buildTemplate() {
    return Template(
      name: templateNameController.text.trim().isEmpty
          ? 'قالب جديد'
          : templateNameController.text.trim(),
      width: _templateWidth,
      height: _templateHeight,
      orientation: _templateOrientation,
      elements: _elements.map((e) => e.copyWith()).toList(),
      backgroundProperties: Map.from(_backgroundProperties),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Quick element creation helpers
  void addTextElement({
    required String text,
    double? x,
    double? y,
    double? width,
    double? height,
    Map<String, dynamic>? properties,
  }) {
    final element = TemplateElement(
      id: 'text_${DateTime.now().millisecondsSinceEpoch}',
      type: 'text',
      x: x ?? 1.0,
      y: y ?? 1.0,
      width: width ?? 3.0,
      height: height ?? 0.8,
      properties: {
        'text': text,
        'fontSize': 14,
        'fontFamily': 'NotoSansArabic',
        'fontWeight': 'normal',
        'color': '#000000',
        'textAlign': 'right',
        ...?properties,
      },
      zIndex: _getNextZIndex(),
    );
    addElement(element);
  }

  void addImageElement({
    required String source,
    double? x,
    double? y,
    double? width,
    double? height,
    Map<String, dynamic>? properties,
  }) {
    final element = TemplateElement(
      id: 'image_${DateTime.now().millisecondsSinceEpoch}',
      type: 'image',
      x: x ?? 1.0,
      y: y ?? 1.0,
      width: width ?? 2.0,
      height: height ?? 2.0,
      properties: {
        'source': source,
        'fit': 'contain',
        'borderRadius': 0,
        ...?properties,
      },
      zIndex: _getNextZIndex(),
    );
    addElement(element);
  }

  void addShapeElement({
    required String shapeType,
    double? x,
    double? y,
    double? width,
    double? height,
    Map<String, dynamic>? properties,
  }) {
    final element = TemplateElement(
      id: 'shape_${DateTime.now().millisecondsSinceEpoch}',
      type: 'shape',
      x: x ?? 1.0,
      y: y ?? 1.0,
      width: width ?? 2.0,
      height: height ?? 1.0,
      properties: {
        'shapeType': shapeType,
        'fillColor': '#CCCCCC',
        'strokeColor': '#000000',
        'strokeWidth': 1.0,
        ...?properties,
      },
      zIndex: _getNextZIndex(),
    );
    addElement(element);
  }

  int _getNextZIndex() {
    return _elements.isNotEmpty
        ? _elements.map((e) => e.zIndex).reduce(math.max) + 1
        : 1;
  }

  // Clear all
  void clearAll() {
    _elements.clear();
    _selectedElement = null;
    _saveToHistory();
    notifyListeners();
  }
}
