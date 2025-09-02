import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/template_designer_provider.dart';

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateDesignerProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'خصائص العنصر',
                style: FluentTheme.of(context).typography.subtitle,
              ),
              const SizedBox(height: 16),

              // Content
              Expanded(
                child: provider.selectedElement != null
                    ? _buildElementProperties(
                        provider,
                        provider.selectedElement!,
                      )
                    : _buildNoSelection(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FluentIcons.settings, size: 48, color: Colors.grey[120]),
          const SizedBox(height: 16),
          Text(
            'لا يوجد عنصر محدد',
            style: TextStyle(color: Colors.grey[120], fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر عنصراً لتعديل خصائصه',
            style: TextStyle(color: Colors.grey[100], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildElementProperties(TemplateDesignerProvider provider, element) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Element Info
          _buildElementInfo(element),
          const SizedBox(height: 16),

          // Position & Size
          _buildPositionAndSize(provider, element),
          const SizedBox(height: 16),

          // Type-specific properties
          if (element.type == 'text') ...[
            _buildTextProperties(provider, element),
          ] else if (element.type == 'image') ...[
            _buildImageProperties(provider, element),
          ] else if (element.type == 'shape') ...[
            _buildShapeProperties(provider, element),
          ],

          const SizedBox(height: 16),

          // Layer Properties
          _buildLayerProperties(provider, element),
        ],
      ),
    );
  }

  Widget _buildElementInfo(element) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات العنصر',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('النوع: ', style: TextStyle(fontSize: 12)),
                Text(
                  _getElementTypeDisplayName(element.type),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('المعرف: ', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Text(
                    element.id,
                    style: TextStyle(fontSize: 12, color: Colors.grey[120]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionAndSize(TemplateDesignerProvider provider, element) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الموضع والحجم',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Position
            Row(
              children: [
                Expanded(
                  child: InfoLabel(
                    label: 'X (سم)',
                    child: NumberBox<double>(
                      value: element.x,
                      onChanged: (value) {
                        if (value != null) {
                          provider.moveElement(
                            element.id,
                            value - element.x,
                            0,
                          );
                        }
                      },
                      min: 0.0,
                      max: provider.templateWidth - element.width,
                      smallChange: 0.1,
                      largeChange: 1.0,
                      mode: SpinButtonPlacementMode.inline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InfoLabel(
                    label: 'Y (سم)',
                    child: NumberBox<double>(
                      value: element.y,
                      onChanged: (value) {
                        if (value != null) {
                          provider.moveElement(
                            element.id,
                            0,
                            value - element.y,
                          );
                        }
                      },
                      min: 0.0,
                      max: provider.templateHeight - element.height,
                      smallChange: 0.1,
                      largeChange: 1.0,
                      mode: SpinButtonPlacementMode.inline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Size
            Row(
              children: [
                Expanded(
                  child: InfoLabel(
                    label: 'العرض (سم)',
                    child: NumberBox<double>(
                      value: element.width,
                      onChanged: (value) {
                        if (value != null && value > 0) {
                          provider.resizeElement(
                            element.id,
                            value,
                            element.height,
                          );
                        }
                      },
                      min: 0.1,
                      max: provider.templateWidth - element.x,
                      smallChange: 0.1,
                      largeChange: 1.0,
                      mode: SpinButtonPlacementMode.inline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InfoLabel(
                    label: 'الارتفاع (سم)',
                    child: NumberBox<double>(
                      value: element.height,
                      onChanged: (value) {
                        if (value != null && value > 0) {
                          provider.resizeElement(
                            element.id,
                            element.width,
                            value,
                          );
                        }
                      },
                      min: 0.1,
                      max: provider.templateHeight - element.y,
                      smallChange: 0.1,
                      largeChange: 1.0,
                      mode: SpinButtonPlacementMode.inline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextProperties(TemplateDesignerProvider provider, element) {
    final properties = element.properties;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خصائص النص',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Text Content
            InfoLabel(
              label: 'النص',
              child: TextBox(
                controller: TextEditingController(
                  text: properties['text'] as String? ?? '',
                ),
                onChanged: (value) =>
                    _updateElementProperty(provider, element, 'text', value),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 12),

            // Font Size
            InfoLabel(
              label: 'حجم الخط',
              child: NumberBox<double>(
                value: (properties['fontSize'] as num?)?.toDouble() ?? 14.0,
                onChanged: (value) {
                  if (value != null && value > 0) {
                    _updateElementProperty(
                      provider,
                      element,
                      'fontSize',
                      value,
                    );
                  }
                },
                min: 6.0,
                max: 72.0,
                smallChange: 1.0,
                largeChange: 2.0,
                mode: SpinButtonPlacementMode.inline,
              ),
            ),
            const SizedBox(height: 12),

            // Font Family
            InfoLabel(
              label: 'نوع الخط',
              child: ComboBox<String>(
                value: properties['fontFamily'] as String? ?? 'NotoSansArabic',
                items: const [
                  ComboBoxItem(
                    value: 'NotoSansArabic',
                    child: Text('Arabic (Noto Sans)'),
                  ),
                  ComboBoxItem(
                    value: 'Roboto',
                    child: Text('English (Roboto)'),
                  ),
                  ComboBoxItem(value: 'Arial', child: Text('Arial')),
                  ComboBoxItem(
                    value: 'Times New Roman',
                    child: Text('Times New Roman'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updateElementProperty(
                      provider,
                      element,
                      'fontFamily',
                      value,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Font Weight
            InfoLabel(
              label: 'وزن الخط',
              child: ComboBox<String>(
                value: properties['fontWeight'] as String? ?? 'normal',
                items: const [
                  ComboBoxItem(value: 'normal', child: Text('عادي')),
                  ComboBoxItem(value: 'bold', child: Text('عريض')),
                  ComboBoxItem(value: 'w300', child: Text('خفيف')),
                  ComboBoxItem(value: 'w500', child: Text('متوسط')),
                  ComboBoxItem(value: 'w600', child: Text('شبه عريض')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updateElementProperty(
                      provider,
                      element,
                      'fontWeight',
                      value,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Text Align
            InfoLabel(
              label: 'محاذاة النص',
              child: ComboBox<String>(
                value: properties['textAlign'] as String? ?? 'right',
                items: const [
                  ComboBoxItem(value: 'right', child: Text('يمين')),
                  ComboBoxItem(value: 'left', child: Text('يسار')),
                  ComboBoxItem(value: 'center', child: Text('وسط')),
                  ComboBoxItem(value: 'justify', child: Text('ضبط')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updateElementProperty(
                      provider,
                      element,
                      'textAlign',
                      value,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Text Color
            InfoLabel(
              label: 'لون النص',
              child: _buildColorPicker(
                properties['color'] as String? ?? '#000000',
                (color) =>
                    _updateElementProperty(provider, element, 'color', color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageProperties(TemplateDesignerProvider provider, element) {
    final properties = element.properties;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خصائص الصورة',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Image Source
            InfoLabel(
              label: 'مصدر الصورة',
              child: ComboBox<String>(
                value: properties['source'] as String? ?? 'custom_image',
                items: const [
                  ComboBoxItem(
                    value: 'student_photo',
                    child: Text('صورة الطالب'),
                  ),
                  ComboBoxItem(
                    value: 'school_logo',
                    child: Text('شعار المدرسة'),
                  ),
                  ComboBoxItem(
                    value: 'custom_image',
                    child: Text('صورة مخصصة'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updateElementProperty(provider, element, 'source', value);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Border Radius
            InfoLabel(
              label: 'زاوية الحدود',
              child: NumberBox<double>(
                value: (properties['borderRadius'] as num?)?.toDouble() ?? 0.0,
                onChanged: (value) {
                  if (value != null && value >= 0) {
                    _updateElementProperty(
                      provider,
                      element,
                      'borderRadius',
                      value,
                    );
                  }
                },
                min: 0.0,
                max: 50.0,
                smallChange: 1.0,
                largeChange: 5.0,
                mode: SpinButtonPlacementMode.inline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShapeProperties(TemplateDesignerProvider provider, element) {
    final properties = element.properties;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خصائص الشكل',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Shape Type
            InfoLabel(
              label: 'نوع الشكل',
              child: ComboBox<String>(
                value: properties['shapeType'] as String? ?? 'rectangle',
                items: const [
                  ComboBoxItem(value: 'rectangle', child: Text('مستطيل')),
                  ComboBoxItem(value: 'circle', child: Text('دائرة')),
                  ComboBoxItem(value: 'line', child: Text('خط')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _updateElementProperty(
                      provider,
                      element,
                      'shapeType',
                      value,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Fill Color
            InfoLabel(
              label: 'لون التعبئة',
              child: _buildColorPicker(
                properties['fillColor'] as String? ?? '#CCCCCC',
                (color) => _updateElementProperty(
                  provider,
                  element,
                  'fillColor',
                  color,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Stroke Color
            InfoLabel(
              label: 'لون الحدود',
              child: _buildColorPicker(
                properties['strokeColor'] as String? ?? '#000000',
                (color) => _updateElementProperty(
                  provider,
                  element,
                  'strokeColor',
                  color,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Stroke Width
            InfoLabel(
              label: 'سمك الحدود',
              child: NumberBox<double>(
                value: (properties['strokeWidth'] as num?)?.toDouble() ?? 1.0,
                onChanged: (value) {
                  if (value != null && value >= 0) {
                    _updateElementProperty(
                      provider,
                      element,
                      'strokeWidth',
                      value,
                    );
                  }
                },
                min: 0.0,
                max: 10.0,
                smallChange: 0.5,
                largeChange: 1.0,
                mode: SpinButtonPlacementMode.inline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerProperties(TemplateDesignerProvider provider, element) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خصائص الطبقة',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Z-Index
            InfoLabel(
              label: 'ترتيب الطبقة',
              child: NumberBox<int>(
                value: element.zIndex,
                onChanged: (value) {
                  if (value != null) {
                    provider.updateElementZIndex(element.id, value);
                  }
                },
                min: -100,
                max: 100,
                smallChange: 1,
                largeChange: 5,
                mode: SpinButtonPlacementMode.inline,
              ),
            ),
            const SizedBox(height: 12),

            // Quick Layer Actions
            Row(
              children: [
                Expanded(
                  child: Button(
                    onPressed: () => provider.bringToFront(element.id),
                    child: Text('للمقدمة', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Button(
                    onPressed: () => provider.sendToBack(element.id),
                    child: Text('للخلف', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(
    String currentColor,
    Function(String) onColorChanged,
  ) {
    return Row(
      children: [
        // Color Preview
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _parseColor(currentColor),
            border: Border.all(color: Colors.grey[100]),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),

        // Color Input
        Expanded(
          child: TextBox(
            controller: TextEditingController(text: currentColor),
            onChanged: onColorChanged,
            placeholder: '#000000',
          ),
        ),
        const SizedBox(width: 8),

        // Quick Color Buttons
        Row(
          children: [
            _buildQuickColorButton('#000000', onColorChanged),
            _buildQuickColorButton('#FFFFFF', onColorChanged),
            _buildQuickColorButton('#FF0000', onColorChanged),
            _buildQuickColorButton('#0000FF', onColorChanged),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickColorButton(String color, Function(String) onColorChanged) {
    return GestureDetector(
      onTap: () => onColorChanged(color),
      child: Container(
        width: 20,
        height: 20,
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: _parseColor(color),
          border: Border.all(color: Colors.grey[100]),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  void _updateElementProperty(
    TemplateDesignerProvider provider,
    element,
    String property,
    dynamic value,
  ) {
    final updatedProperties = Map<String, dynamic>.from(element.properties);
    updatedProperties[property] = value;

    final updatedElement = element.copyWith(properties: updatedProperties);
    provider.updateSelectedElement(updatedElement);
  }

  String _getElementTypeDisplayName(String type) {
    switch (type) {
      case 'text':
        return 'نص';
      case 'image':
        return 'صورة';
      case 'shape':
        return 'شكل';
      default:
        return 'غير معروف';
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.black;
    }
  }
}
